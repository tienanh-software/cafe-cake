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

-- 2. BẢNG QUẢN LÝ BÀN (TABLES)
DROP TABLE IF EXISTS `tables`;
CREATE TABLE `tables` (
    `table_id` INT AUTO_INCREMENT PRIMARY KEY,
    `table_number` VARCHAR(20) NOT NULL UNIQUE,
    `qr_token` VARCHAR(64) NOT NULL UNIQUE,
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
    `variant_name` VARCHAR(50) NOT NULL DEFAULT 'Tiêu chuẩn',
    `price` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    `discount` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
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

-- 7. BẢNG QUAN HỆ MÓN - TOPPING (MENU_ITEM_TOPPING)
DROP TABLE IF EXISTS `menu_item_toppings`;
CREATE TABLE `menu_item_toppings` (
    `item_id` INT NOT NULL,
    `topping_id` INT NOT NULL,
    PRIMARY KEY (`item_id`, `topping_id`),
    CONSTRAINT `fk_mit_item` FOREIGN KEY (`item_id`) REFERENCES `menu_items` (`item_id`) ON DELETE CASCADE,
    CONSTRAINT `fk_mit_topping` FOREIGN KEY (`topping_id`) REFERENCES `toppings` (`topping_id`) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 8. BẢNG MÃ GIẢM GIÁ TỔNG BILL (VOUCHER)
DROP TABLE IF EXISTS `vouchers`;
CREATE TABLE `vouchers` (
    `voucher_id` INT AUTO_INCREMENT PRIMARY KEY,
    `code` VARCHAR(50) NOT NULL UNIQUE,
    `discount_percent` INT NOT NULL DEFAULT 0,
    `max_discount_amount` DECIMAL(10,2) NULL,
    `min_order_amount` DECIMAL(10,2) DEFAULT 0.00,
    `expiry_date` DATE NOT NULL,
    `status` ENUM('active', 'expired', 'disabled') NOT NULL DEFAULT 'active'
) ENGINE=InnoDB;

-- ========================================================
-- [MỚI] 9. BẢNG CHƯƠNG TRÌNH KHUYẾN MÃI & COMBO (PROMOTIONS)
-- ========================================================
DROP TABLE IF EXISTS `promotions`;
CREATE TABLE `promotions` (
    `promo_id` INT AUTO_INCREMENT PRIMARY KEY,
    `promo_name` VARCHAR(150) NOT NULL,
    `promo_type` ENUM('buy_x_get_y', 'combo_fixed') NOT NULL,
    `combo_price` DECIMAL(10,2) NULL,                -- Điền giá nếu là Combo trọn gói (VD: 99.000đ). Để NULL nếu là Mua 1 tặng 1
    `start_date` DATETIME NOT NULL,
    `end_date` DATETIME NOT NULL,
    `status` ENUM('active', 'inactive') NOT NULL DEFAULT 'active',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ========================================================
-- [MỚI] 10. BẢNG CHI TIẾT MÓN TRONG KM / COMBO (PROMOTION_ITEMS)
-- Chấp hết mọi loại combo 2, 3, 4, 5 món tùy ý
-- ========================================================
DROP TABLE IF EXISTS `promotion_items`;
CREATE TABLE `promotion_items` (
    `promo_item_id` INT AUTO_INCREMENT PRIMARY KEY,
    `promo_id` INT NOT NULL,
    `variant_id` INT NOT NULL,
    `quantity` INT NOT NULL DEFAULT 1,
    `item_role` ENUM('buy', 'get', 'combo') NOT NULL, -- 'buy': ly điều kiện; 'get': ly được tặng/giảm; 'combo': món thuộc combo trọn gói
    `discount_type` ENUM('percent', 'amount', 'free', 'none') NOT NULL DEFAULT 'none',
    `discount_value` DECIMAL(10,2) NOT NULL DEFAULT 0.00, -- VD: 100 nếu Free, 50 nếu giảm 50%
    CONSTRAINT `fk_pi_promo` FOREIGN KEY (`promo_id`) REFERENCES `promotions` (`promo_id`) ON DELETE CASCADE,
    CONSTRAINT `fk_pi_variant` FOREIGN KEY (`variant_id`) REFERENCES `menu_variants` (`variant_id`) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 11. BẢNG ĐƠN HÀNG (ORDERS)
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders` (
    `order_id` INT AUTO_INCREMENT PRIMARY KEY,
    `order_code` VARCHAR(20) NOT NULL UNIQUE,
    `table_id` INT NULL,
    `staff_id` INT NULL,
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

-- ========================================================
-- [CẬP NHẬT] 12. BẢNG CHI TIẾT ĐƠN HÀNG (ORDER_ITEMS)
-- Thêm liên kết Khuyến mãi và Liên kết Cha-Con
-- ========================================================
DROP TABLE IF EXISTS `order_items`;
CREATE TABLE `order_items` (
    `order_item_id` INT AUTO_INCREMENT PRIMARY KEY,
    `order_id` INT NOT NULL,
    `variant_id` INT NOT NULL,
    `promo_id` INT NULL,                            -- NULL nếu là món gọi thường, có số nếu thuộc KM/Combo
    `parent_order_item_id` INT NULL,                -- Tự trỏ về ly chính nếu đây là ly được tặng/giảm mua kèm
    `quantity` INT NOT NULL DEFAULT 1,
    `unit_price` DECIMAL(10,2) NOT NULL,            -- Giá niêm yết
    `discount_amount` DECIMAL(10,2) NOT NULL DEFAULT 0.00, -- Số tiền được giảm trên món này
    `sugar_level` VARCHAR(20) DEFAULT '100%',
    `ice_level` VARCHAR(20) DEFAULT '100%',
    `note` VARCHAR(255) NULL,
    `subtotal` DECIMAL(10,2) NOT NULL,              -- [(unit_price - discount_amount) * quantity] + tiền toppings
    CONSTRAINT `fk_order_items_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE,
    CONSTRAINT `fk_order_items_variant` FOREIGN KEY (`variant_id`) REFERENCES `menu_variants` (`variant_id`) ON DELETE RESTRICT,
    CONSTRAINT `fk_order_items_promo` FOREIGN KEY (`promo_id`) REFERENCES `promotions` (`promo_id`) ON DELETE SET NULL,
    CONSTRAINT `fk_order_items_parent` FOREIGN KEY (`parent_order_item_id`) REFERENCES `order_items` (`order_item_id`) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 13. BẢNG LƯU TOPPING THEO TỪNG LY ĐÃ ĐẶT (ORDER_ITEM_TOPPINGS)
DROP TABLE IF EXISTS `order_item_toppings`;
CREATE TABLE `order_item_toppings` (
    `order_item_id` INT NOT NULL,
    `topping_id` INT NOT NULL,
    `topping_price` DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (`order_item_id`, `topping_id`),
    CONSTRAINT `fk_oit_order_item` FOREIGN KEY (`order_item_id`) REFERENCES `order_items` (`order_item_id`) ON DELETE CASCADE,
    CONSTRAINT `fk_oit_topping` FOREIGN KEY (`topping_id`) REFERENCES `toppings` (`topping_id`) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- 14. BẢNG GỌI PHỤC VỤ (SERVICE_CALLS)
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
-- DỮ LIỆU MẪU ĐẦY ĐỦ ĐỂ CHÂU CHẠY DEMO ĐƯỢC NGAY
-- ========================================================

-- 1. Nhân viên (Pass: 123456)
INSERT INTO `staff` (`full_name`, `email`, `password_hash`, `role`) VALUES
('Quản trị viên', 'admin@cafe.com', '$2y$10$e0MYzXyjpJS7Pd0RVvHwHe4g1I5J3k9sC17dZ5t0O.oY1e0zO5UqC', 'admin'),
('Nhân viên quầy', 'staff@cafe.com', '$2y$10$e0MYzXyjpJS7Pd0RVvHwHe4g1I5J3k9sC17dZ5t0O.oY1e0zO5UqC', 'staff');

-- 2. Danh mục
INSERT INTO `categories` (`category_name`, `description`) VALUES
('Cà phê', 'Các loại cà phê pha phin và máy'),
('Trà trái cây', 'Trà thanh nhiệt và trà sữa thơm ngon'),
('Bánh ngọt', 'Bánh nướng thủ công trong ngày');

-- 3. Bàn
INSERT INTO `tables` (`table_number`, `qr_token`) VALUES
('Bàn 01', 'token_ban_1_a83fd9'),
('Bàn 02', 'token_ban_2_c12b77'),
('Quầy Mang Đi', 'token_quay_takeaway');

-- 4. Món
INSERT INTO `menu_items` (`item_id`, `category_id`, `item_name`, `description`, `image_url`) VALUES
(1, 1, 'Cà Phê Muối', 'Cà phê truyền thống kết hợp lớp kem mặn', 'ca-phe-muoi.jpg'),
(2, 2, 'Trà Đào Cam Sả', 'Trà đào thơm mát chua nhẹ', 'tra-dao.jpg'),
(3, 3, 'Bánh Tiramisu', 'Bánh kem phô mai hương vị cacao', 'tiramisu.jpg');

-- 5. Biến thể (Variants)
INSERT INTO `menu_variants` (`variant_id`, `item_id`, `variant_name`, `price`) VALUES
(1, 1, 'Size Vừa (M)', 30000.00),  -- ID 1: Cafe Muối M
(2, 1, 'Size Lớn (L)', 35000.00),  -- ID 2: Cafe Muối L
(3, 2, 'Size Vừa (M)', 35000.00),  -- ID 3: Trà Đào M
(4, 2, 'Size Lớn (L)', 42000.00),  -- ID 4: Trà Đào L
(5, 3, '1 Miếng', 45000.00);       -- ID 5: Bánh Tiramisu

-- 6. Topping
INSERT INTO `toppings` (`topping_id`, `topping_name`, `price`) VALUES
('1', 'Trân châu trắng', 5000.00),
('2', 'Thạch đào', 7000.00),
('3', 'Kem Cheese', 10000.00);

-- ========================================================
-- DEMO: CẤU HÌNH ĐẦY ĐỦ 3 LOẠI KHUYẾN MÃI / COMBO CỦA THẦY
-- ========================================================

INSERT INTO `promotions` (`promo_id`, `promo_name`, `promo_type`, `combo_price`, `start_date`, `end_date`) VALUES
(1, 'Mua 1 Tặng 1: Mua Cafe Muối L tặng Cafe Muối M', 'buy_x_get_y', NULL, '2025-01-01', '2026-12-31'),
(2, 'Highlands Style: Mua Trà Đào L - Ly thứ 2 Cafe Muối M giảm 50%', 'buy_x_get_y', NULL, '2025-01-01', '2026-12-31'),
(3, 'Combo Họp Nhóm 3 Món (2 Nước + 1 Bánh) trọn gói 99k', 'combo_fixed', 99000.00, '2025-01-01', '2026-12-31');

-- Chi tiết của 3 chương trình trên:
INSERT INTO `promotion_items` (`promo_id`, `variant_id`, `quantity`, `item_role`, `discount_type`, `discount_value`) VALUES
-- CT 1: Mua Cafe Muối L (Variant 2) -> Tặng Cafe Muối M (Variant 1) 100%
(1, 2, 1, 'buy', 'none', 0.00),
(1, 1, 1, 'get', 'free', 100.00),

-- CT 2: Mua Trà Đào L (Variant 4) -> Mua Cafe Muối M (Variant 1) GIẢM 50%
(2, 4, 1, 'buy', 'none', 0.00),
(2, 1, 1, 'get', 'percent', 50.00),

-- CT 3: Combo 3 Món trọn gói (Gồm 1 Trà Đào M + 1 Cafe Muối M + 1 Bánh Tiramisu = 99k)
(3, 3, 1, 'combo', 'none', 0.00),
(3, 1, 1, 'combo', 'none', 0.00),
(3, 5, 1, 'combo', 'none', 0.00);
