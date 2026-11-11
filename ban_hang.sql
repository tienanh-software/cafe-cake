-- Tạo Database (nếu chưa có)
CREATE DATABASE IF NOT EXISTS `cafe_qr_ordering` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `cafe_qr_ordering`;

-- Tắt kiểm tra khóa ngoại tạm thời để tránh lỗi thứ tự tạo bảng
SET FOREIGN_KEY_CHECKS = 0;

-- 1. BẢNG NHÂN VIÊN / QUẢN TRỊ (STAFF)
DROP TABLE IF EXISTS `staff`;
CREATE TABLE `staff` (
    `staff_id` INT AUTO_INCREMENT PRIMARY KEY,
    `full_name` VARCHAR(100) NOT NULL,
    `email` VARCHAR(100) NOT NULL UNIQUE,
    `password_hash` VARCHAR(255) NOT NULL,
    `role` ENUM('admin', 'staff') NOT NULL DEFAULT 'staff',
    `status` ENUM('active', 'inactive') NOT NULL DEFAULT 'active',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 2. BẢNG QUẢN LÝ BÀN (TABLES) - Hỗ trợ QR Code Token
DROP TABLE IF EXISTS `tables`;
CREATE TABLE `tables` (
    `table_id` INT AUTO_INCREMENT PRIMARY KEY,
    `table_number` VARCHAR(20) NOT NULL UNIQUE, -- VD: Bàn 01, Bàn 02, Quầy Mang Đi
    `qr_token` VARCHAR(64) NOT NULL UNIQUE,    -- Chuỗi ngẫu nhiên trong link QR chống fake
    `status` ENUM('available', 'occupied', 'disabled') NOT NULL DEFAULT 'available',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 3. BẢNG DANH MỤC (CATEGORY)
DROP TABLE IF EXISTS `categories`;
CREATE TABLE `categories` (
    `category_id` INT AUTO_INCREMENT PRIMARY KEY,
    `category_name` VARCHAR(100) NOT NULL,
    `description` TEXT NULL,
    `status` ENUM('active', 'inactive') NOT NULL DEFAULT 'active'
) ENGINE=InnoDB;

-- 4. BẢNG MÓN ĂN / ĐỒ UỐNG CHÍNH (MENU_ITEM)
DROP TABLE IF EXISTS `menu_items`;
CREATE TABLE `menu_items` (
    `item_id` INT AUTO_INCREMENT PRIMARY KEY,
    `category_id` INT NOT NULL,
    `item_name` VARCHAR(150) NOT NULL,
    `description` TEXT NULL,
    `image_url` VARCHAR(255) NULL,
    `status` ENUM('active', 'inactive', 'out_of_stock') NOT NULL DEFAULT 'active',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_items_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 5. BẢNG BIẾN THỂ CỦA MÓN (MENU_VARIANT: Size S, M, L, Bánh miếng...)
DROP TABLE IF EXISTS `menu_variants`;
CREATE TABLE `menu_variants` (
    `variant_id` INT AUTO_INCREMENT PRIMARY KEY,
    `item_id` INT NOT NULL,
    `variant_name` VARCHAR(50) NOT NULL DEFAULT 'Tiêu chuẩn', -- Size S, Size M, Size L
    `price` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    `discount` DECIMAL(10,2) NOT NULL DEFAULT 0.00,          -- Số tiền giảm trực tiếp nếu có
    `status` ENUM('active', 'inactive') NOT NULL DEFAULT 'active',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_variants_item` FOREIGN KEY (`item_id`) REFERENCES `menu_items` (`item_id`) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 6. BẢNG TOPPING
DROP TABLE IF EXISTS `toppings`;
CREATE TABLE `toppings` (
    `topping_id` INT AUTO_INCREMENT PRIMARY KEY,
    `topping_name` VARCHAR(100) NOT NULL,
    `price` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    `status` ENUM('active', 'inactive', 'out_of_stock') NOT NULL DEFAULT 'active',
    `image_url` VARCHAR(255) NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 7. BẢNG QUAN HỆ MÓN CÓ THỂ ĐI KÈM VỚI TOPPING NÀO (MENU_ITEM_TOPPING)
DROP TABLE IF EXISTS `menu_item_toppings`;
CREATE TABLE `menu_item_toppings` (
    `item_id` INT NOT NULL,
    `topping_id` INT NOT NULL,
    PRIMARY KEY (`item_id`, `topping_id`),
    CONSTRAINT `fk_mit_item` FOREIGN KEY (`item_id`) REFERENCES `menu_items` (`item_id`) ON DELETE CASCADE,
    CONSTRAINT `fk_mit_topping` FOREIGN KEY (`topping_id`) REFERENCES `toppings` (`topping_id`) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 8. BẢNG MÃ GIẢM GIÁ (VOUCHER)
DROP TABLE IF EXISTS `vouchers`;
CREATE TABLE `vouchers` (
    `voucher_id` INT AUTO_INCREMENT PRIMARY KEY,
    `code` VARCHAR(50) NOT NULL UNIQUE,
    `discount_percent` INT NOT NULL DEFAULT 0, -- Số % giảm (ví dụ: 10, 20)
    `max_discount_amount` DECIMAL(10,2) NULL,  -- Giảm tối đa bao nhiêu
    `min_order_amount` DECIMAL(10,2) DEFAULT 0.00,
    `expiry_date` DATE NOT NULL,
    `status` ENUM('active', 'expired', 'disabled') NOT NULL DEFAULT 'active'
) ENGINE=InnoDB;

-- 9. BẢNG ĐƠN HÀNG (ORDERS)
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders` (
    `order_id` INT AUTO_INCREMENT PRIMARY KEY,
    `order_code` VARCHAR(20) NOT NULL UNIQUE,       -- Mã đơn khách nhìn thấy, vd: #DH001
    `table_id` INT NULL,                            -- NULL nếu là đơn mang đi
    `staff_id` INT NULL,                            -- NULL nếu khách tự quét QR đặt món
    `voucher_id` INT NULL,
    `order_type` ENUM('dine_in', 'takeaway') NOT NULL DEFAULT 'dine_in',
    `customer_name` VARCHAR(100) NULL,
    `customer_phone` VARCHAR(15) NULL,
    `discount_amount` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    `total_amount` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    `status` ENUM('pending', 'confirmed', 'preparing', 'ready', 'completed', 'cancelled') NOT NULL DEFAULT 'pending',
    `payment_method` ENUM('cash', 'banking') NOT NULL DEFAULT 'cash',
    `payment_status` ENUM('unpaid', 'paid') NOT NULL DEFAULT 'unpaid',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT `fk_orders_table` FOREIGN KEY (`table_id`) REFERENCES `tables` (`table_id`) ON DELETE SET NULL,
    CONSTRAINT `fk_orders_staff` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`staff_id`) ON DELETE SET NULL,
    CONSTRAINT `fk_orders_voucher` FOREIGN KEY (`voucher_id`) REFERENCES `vouchers` (`voucher_id`) ON DELETE SET NULL
) ENGINE=InnoDB;

-- 10. BẢNG CHI TIẾT ĐƠN HÀNG (ORDER_ITEMS)
DROP TABLE IF EXISTS `order_items`;
CREATE TABLE `order_items` (
    `order_item_id` INT AUTO_INCREMENT PRIMARY KEY,
    `order_id` INT NOT NULL,
    `variant_id` INT NOT NULL,
    `quantity` INT NOT NULL DEFAULT 1,
    `unit_price` DECIMAL(10,2) NOT NULL,            -- Lưu giá tại thời điểm khách mua
    `sugar_level` VARCHAR(20) DEFAULT '100%',       -- Tùy chọn ngọt: 0%, 30%, 50%, 100%
    `ice_level` VARCHAR(20) DEFAULT '100%',         -- Tùy chọn đá: 0%, 50%, 100%, Nóng
    `note` VARCHAR(255) NULL,                       -- Ghi chú cho từng ly
    `subtotal` DECIMAL(10,2) NOT NULL,              -- (unit_price * quantity) + tiền toppings
    CONSTRAINT `fk_order_items_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE,
    CONSTRAINT `fk_order_items_variant` FOREIGN KEY (`variant_id`) REFERENCES `menu_variants` (`variant_id`) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- 11. BẢNG LƯU TOPPING THEO TỪNG LY ĐÃ ĐẶT (ORDER_ITEM_TOPPINGS)
DROP TABLE IF EXISTS `order_item_toppings`;
CREATE TABLE `order_item_toppings` (
    `order_item_id` INT NOT NULL,
    `topping_id` INT NOT NULL,
    `topping_price` DECIMAL(10,2) NOT NULL,         -- Giá topping lúc khách chọn
    PRIMARY KEY (`order_item_id`, `topping_id`),
    CONSTRAINT `fk_oit_order_item` FOREIGN KEY (`order_item_id`) REFERENCES `order_items` (`order_item_id`) ON DELETE CASCADE,
    CONSTRAINT `fk_oit_topping` FOREIGN KEY (`topping_id`) REFERENCES `toppings` (`topping_id`) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- 12. BẢNG GỌI NHÂN VIÊN TẠI BÀN (Nâng cao: hỗ trợ tính năng nút 'Gọi nhân viên')
DROP TABLE IF EXISTS `service_calls`;
CREATE TABLE `service_calls` (
    `call_id` INT AUTO_INCREMENT PRIMARY KEY,
    `table_id` INT NOT NULL,
    `message` VARCHAR(100) DEFAULT 'Khách gọi phục vụ',
    `status` ENUM('pending', 'completed') DEFAULT 'pending',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_calls_table` FOREIGN KEY (`table_id`) REFERENCES `tables` (`table_id`) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Bật lại kiểm tra khóa ngoại
SET FOREIGN_KEY_CHECKS = 1;

-- ========================================================
-- DỮ LIỆU MẪU ĐỂ CHÂU CHẠY THỬ NGHIỆM ĐƯỢC NGAY
-- ========================================================

-- Mật khẩu mặc định là: 123456 (được băm bằng password_hash BCRYPT chuẩn PHP)
INSERT INTO `staff` (`full_name`, `email`, `password_hash`, `role`) VALUES
('Quản trị viên', 'admin@cafe.com', '$2y$10$e0MYzXyjpJS7Pd0RVvHwHe4g1I5J3k9sC17dZ5t0O.oY1e0zO5UqC', 'admin'),
('Nhân viên quầy', 'staff@cafe.com', '$2y$10$e0MYzXyjpJS7Pd0RVvHwHe4g1I5J3k9sC17dZ5t0O.oY1e0zO5UqC', 'staff');

-- Danh mục
INSERT INTO `categories` (`category_name`, `description`) VALUES
('Cà phê', 'Các loại cà phê pha phin và máy'),
('Trà trái cây', 'Trà thanh nhiệt và trà sữa thơm ngon'),
('Bánh ngọt', 'Bánh nướng thủ công trong ngày');

-- Bàn mẫu kèm token QR (Khi làm trang QR, link quét sẽ dạng: website.com/menu?token=token_ban_1)
INSERT INTO `tables` (`table_number`, `qr_token`) VALUES
('Bàn 01', 'token_ban_1_a83fd9'),
('Bàn 02', 'token_ban_2_c12b77'),
('Bàn 03', 'token_ban_3_f99a12'),
('Quầy Mang Đi', 'token_quay_takeaway');

-- Món mẫu
INSERT INTO `menu_items` (`category_id`, `item_name`, `description`, `image_url`) VALUES
(1, 'Cà Phê Muối', 'Cà phê truyền thống kết hợp lớp kem mặn béo ngậy', 'ca-phe-muoi.jpg'),
(2, 'Trà Đào Cam Sả', 'Trà đào thơm mát kết hợp vị chua nhẹ của cam', 'tra-dao.jpg'),
(3, 'Bánh Tiramisu', 'Bánh kem phô mai hương vị cà phê và cacao', 'tiramisu.jpg');

-- Biến thể (Variants)
INSERT INTO `menu_variants` (`item_id`, `variant_name`, `price`) VALUES
(1, 'Size Vừa (M)', 30000.00),
(1, 'Size Lớn (L)', 35000.00),
(2, 'Size Vừa (M)', 35000.00),
(2, 'Size Lớn (L)', 42000.00),
(3, '1 Miếng', 45000.00);

-- Toppings
INSERT INTO `toppings` (`topping_name`, `price`) VALUES
('Trân châu trắng', 5000.00),
('Thạch đào', 7000.00),
('Kem Cheese', 10000.00);

-- Liên kết món với Topping có thể chọn
INSERT INTO `menu_item_toppings` (`item_id`, `topping_id`) VALUES
(2, 1), -- Trà đào có thể thêm trân châu trắng
(2, 2), -- Trà đào có thể thêm thạch đào
(1, 3); -- Cà phê muối có thể thêm kem cheese

-- Voucher mẫu
INSERT INTO `vouchers` (`code`, `discount_percent`, `max_discount_amount`, `min_order_amount`, `expiry_date`) VALUES
('CHAOBANMOI', 10, 20000.00, 50000.00, '2026-12-31');