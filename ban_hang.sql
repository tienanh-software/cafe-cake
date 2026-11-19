-- =============================================================================
-- 1. TẠO CƠ SỞ DỮ LIỆU
-- =============================================================================
CREATE DATABASE IF NOT EXISTS `restaurant_db` 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE `restaurant_db`;

-- Xóa bảng cũ nếu tồn tại (để chạy lại không bị lỗi khóa ngoại)
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS `ORDER_ITEMS`;
DROP TABLE IF EXISTS `ORDER`;
DROP TABLE IF EXISTS `PROMOTIONS`;
DROP TABLE IF EXISTS `PROMOTIONS_COMBO`;
DROP TABLE IF EXISTS `MENU_VARIANT`;
DROP TABLE IF EXISTS `MENU_ITEM`;
DROP TABLE IF EXISTS `CATEGORY`;
DROP TABLE IF EXISTS `VOUCHER`;
DROP TABLE IF EXISTS `STAFF`;
DROP TABLE IF EXISTS `PAYMENT_METHODS`;
DROP TABLE IF EXISTS `TABLES`;
SET FOREIGN_KEY_CHECKS = 1;

-- =============================================================================
-- 2. TẠO CÁC BẢNG (GIỮ NGUYÊN TÊN NHƯ SƠ ĐỒ)
-- =============================================================================

-- Bảng TABLES
CREATE TABLE `TABLES` (
    `table_id` INT AUTO_INCREMENT PRIMARY KEY,
    `table_number` VARCHAR(50) NOT NULL,
    `qr_token` VARCHAR(255) NULL,
    `status` VARCHAR(50) DEFAULT 'Trống',
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Bảng PAYMENT METHODS
CREATE TABLE `PAYMENT_METHODS` (
    `PAYMENT_ID` INT AUTO_INCREMENT PRIMARY KEY,
    `Name` VARCHAR(100) NOT NULL,
    `Status` VARCHAR(50) DEFAULT 'Hoạt động',
    `Time` DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Bảng STAFF
CREATE TABLE `STAFF` (
    `staff_id` INT AUTO_INCREMENT PRIMARY KEY,
    `full_name` VARCHAR(100) NOT NULL,
    `email` VARCHAR(100) NOT NULL UNIQUE,
    `password_hash` VARCHAR(255) NOT NULL,
    `role` VARCHAR(50) NOT NULL,
    `status` VARCHAR(50) DEFAULT 'Đang làm việc',
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Bảng VOUCHER
CREATE TABLE `VOUCHER` (
    `voucher_id` INT AUTO_INCREMENT PRIMARY KEY,
    `code` VARCHAR(50) NOT NULL UNIQUE,
    `discount_percent` DECIMAL(5,2) DEFAULT 0.00,
    `expiry_date` DATETIME NOT NULL,
    `max_discount_amout` DECIMAL(12,2) DEFAULT 0.00,
    `min_order_amount` DECIMAL(12,2) DEFAULT 0.00,
    `status` VARCHAR(50) DEFAULT 'Khả dụng',
    `voucher_sp_id` INT NULL
);

-- Bảng CATEGORY
CREATE TABLE `CATEGORY` (
    `category_id` INT AUTO_INCREMENT PRIMARY KEY,
    `category_name` VARCHAR(100) NOT NULL,
    `description` TEXT NULL,
    `status` VARCHAR(50) DEFAULT 'Hiển thị'
);

-- Bảng MENU_ITEM
CREATE TABLE `MENU_ITEM` (
    `item_id` INT AUTO_INCREMENT PRIMARY KEY,
    `category_id` INT NOT NULL,
    `item_name` VARCHAR(150) NOT NULL,
    `description` TEXT NULL,
    `status` VARCHAR(50) DEFAULT 'Còn món',
    `image_url` VARCHAR(255) NULL,
    `options` TEXT NULL,
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_item_category` FOREIGN KEY (`category_id`) REFERENCES `CATEGORY` (`category_id`) ON DELETE CASCADE
);

-- Bảng MENU_VARIANT
CREATE TABLE `MENU_VARIANT` (
    `variant_id` INT AUTO_INCREMENT PRIMARY KEY,
    `item_id` INT NOT NULL,
    `variant_name` VARCHAR(100) NOT NULL,
    `discount` DECIMAL(10,2) DEFAULT 0.00,
    `price` DECIMAL(12,2) NOT NULL,
    `status` VARCHAR(50) DEFAULT 'Đang bán',
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_variant_item` FOREIGN KEY (`item_id`) REFERENCES `MENU_ITEM` (`item_id`) ON DELETE CASCADE
);

-- Bảng PROMOTIONS_COMBO
CREATE TABLE `PROMOTIONS_COMBO` (
    `combo_id` INT AUTO_INCREMENT PRIMARY KEY,
    `combo_name` VARCHAR(150) NOT NULL,
    `combo_status` VARCHAR(50) DEFAULT 'Đang áp dụng'
);

-- Bảng PROMOTIONS
CREATE TABLE `PROMOTIONS` (
    `promo_id` INT AUTO_INCREMENT PRIMARY KEY,
    `combo_id` INT NOT NULL,
    `variant_id` INT NOT NULL,
    `promo_type` VARCHAR(50) NOT NULL,
    `promo_value` DECIMAL(12,2) NOT NULL,
    CONSTRAINT `fk_promo_combo` FOREIGN KEY (`combo_id`) REFERENCES `PROMOTIONS_COMBO` (`combo_id`) ON DELETE CASCADE,
    CONSTRAINT `fk_promo_variant` FOREIGN KEY (`variant_id`) REFERENCES `MENU_VARIANT` (`variant_id`) ON DELETE CASCADE
);

-- Bảng ORDER
CREATE TABLE `ORDER` (
    `order_id` INT AUTO_INCREMENT PRIMARY KEY,
    `order_code` VARCHAR(50) NOT NULL UNIQUE,
    `table_id` INT NULL,
    `order_type` VARCHAR(50) NOT NULL,
    `customer_name` VARCHAR(100) NULL,
    `customer_phone` VARCHAR(20) NULL,
    `discount_amount` DECIMAL(12,2) DEFAULT 0.00,
    `payment_method` INT NULL,
    `payment_status` VARCHAR(50) DEFAULT 'Chưa thanh toán',
    `total_amount` DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    `cancel_reason` TEXT NULL,
    `voucher_id` INT NULL,
    `staff_id` INT NULL,
    `status` VARCHAR(50) DEFAULT 'Chờ xử lý',
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT `fk_order_table` FOREIGN KEY (`table_id`) REFERENCES `TABLES` (`table_id`) ON DELETE SET NULL,
    CONSTRAINT `fk_order_payment` FOREIGN KEY (`payment_method`) REFERENCES `PAYMENT_METHODS` (`PAYMENT_ID`) ON DELETE SET NULL,
    CONSTRAINT `fk_order_voucher` FOREIGN KEY (`voucher_id`) REFERENCES `VOUCHER` (`voucher_id`) ON DELETE SET NULL,
    CONSTRAINT `fk_order_staff` FOREIGN KEY (`staff_id`) REFERENCES `STAFF` (`staff_id`) ON DELETE SET NULL
);

-- Bảng ORDER_ITEMS
CREATE TABLE `ORDER_ITEMS` (
    `order_item_id` INT AUTO_INCREMENT PRIMARY KEY,
    `order_id` INT NOT NULL,
    `parent_order_item_id` INT NULL,
    `quantity` INT NOT NULL DEFAULT 1,
    `unit_price` DECIMAL(12,2) NOT NULL,
    `discount_amount` DECIMAL(12,2) DEFAULT 0.00,
    `note` TEXT NULL,
    `subtotal` DECIMAL(12,2) NOT NULL,
    CONSTRAINT `fk_items_order` FOREIGN KEY (`order_id`) REFERENCES `ORDER` (`order_id`) ON DELETE CASCADE,
    CONSTRAINT `fk_items_parent` FOREIGN KEY (`parent_order_item_id`) REFERENCES `ORDER_ITEMS` (`order_item_id`) ON DELETE CASCADE
);

-- =============================================================================
-- 3. THÊM DỮ LIỆU MẪU (MOCK DATA GIỐNG THỰC TẾ)
-- =============================================================================

-- Dữ liệu bàn ăn
INSERT INTO `TABLES` (`table_id`, `table_number`, `qr_token`, `status`) VALUES
(1, 'Bàn 01 - Tầng 1', 'qr_token_b01_t1_sec9823', 'Đang có khách'),
(2, 'Bàn 02 - Tầng 1', 'qr_token_b02_t1_sec8712', 'Trống'),
(3, 'Bàn 03 - Tầng 1', 'qr_token_b03_t1_sec2341', 'Trống'),
(4, 'Bàn VIP 01 - Tầng 2', 'qr_token_vip1_sec9912', 'Đã đặt trước'),
(5, 'Bàn Mang Về (Takeaway)', NULL, 'Khả dụng');

-- Phương thức thanh toán
INSERT INTO `PAYMENT_METHODS` (`PAYMENT_ID`, `Name`, `Status`) VALUES
(1, 'Tiền mặt', 'Hoạt động'),
(2, 'Chuyển khoản VietQR', 'Hoạt động'),
(3, 'Ví điện tử MoMo', 'Hoạt động'),
(4, 'Thẻ Visa / Mastercard', 'Hoạt động');

-- Nhân viên
INSERT INTO `STAFF` (`staff_id`, `full_name`, `email`, `password_hash`, `role`, `status`) VALUES
(1, 'Nguyễn Văn Quản Lý', 'quanly@restaurant.com', '$2y$10$e8wE...hash1', 'Quản lý', 'Đang làm việc'),
(2, 'Trần Thị Thu Ngân', 'thungan@restaurant.com', '$2y$10$e8wE...hash2', 'Thu ngân', 'Đang làm việc'),
(3, 'Lê Hoàng Phục Vụ', 'phucvu@restaurant.com', '$2y$10$e8wE...hash3', 'Phục vụ', 'Đang làm việc');

-- Voucher khuyến mãi
INSERT INTO `VOUCHER` (`voucher_id`, `code`, `discount_percent`, `expiry_date`, `max_discount_amout`, `min_order_amount`, `status`, `voucher_sp_id`) VALUES
(1, 'CHAOBANMOI', 10.00, '2026-12-31 23:59:59', 30000.00, 100000.00, 'Khả dụng', NULL),
(2, 'GIAM50K', 20.00, '2026-12-31 23:59:59', 50000.00, 200000.00, 'Khả dụng', NULL),
(3, 'TRIANVIP', 15.00, '2026-06-30 23:59:59', 100000.00, 300000.00, 'Hết hạn', NULL);

-- Danh mục món
INSERT INTO `CATEGORY` (`category_id`, `category_name`, `description`, `status`) VALUES
(1, 'Cà Phê Truyền Thống', 'Các loại cà phê pha phin và pha máy', 'Hiển thị'),
(2, 'Trà Trái Cây & Trà Sữa', 'Đồ uống thanh nhiệt, hoa quả tươi', 'Hiển thị'),
(3, 'Món Ăn Vặt', 'Đồ ăn kèm nhẹ nhàng nhâm nhi', 'Hiển thị');

-- Món ăn
INSERT INTO `MENU_ITEM` (`item_id`, `category_id`, `item_name`, `description`, `status`, `image_url`, `options`) VALUES
(1, 1, 'Cà Phê Muối Xứ Huế', 'Cà phê phin đậm đà kết hợp lớp kem muối béo ngậy', 'Còn món', 'https://images.unsplash.com/cafe-muoi.jpg', 'Ít đá, Nhiều đá, Ít ngọt'),
(2, 2, 'Trà Đào Cam Sả', 'Trà đào thanh mát với cam vàng tươi và sả thơm lừng', 'Còn món', 'https://images.unsplash.com/tra-dao.jpg', '50% đường, 100% đường'),
(3, 3, 'Khoai Tây Chiên Lắc Phô Mai', 'Khoai tây cọng giòn rụm lắc bột phô mai hảo hạng', 'Còn món', 'https://images.unsplash.com/khoai-tay.jpg', 'Có cay, Không cay');

-- Biến thể món ăn (Size, loại...)
INSERT INTO `MENU_VARIANT` (`variant_id`, `item_id`, `variant_name`, `discount`, `price`, `status`) VALUES
(1, 1, 'Size Vừa (M)', 0.00, 32000.00, 'Đang bán'),
(2, 1, 'Size Lớn (L)', 0.00, 39000.00, 'Đang bán'),
(3, 2, 'Size Vừa (M)', 0.00, 45000.00, 'Đang bán'),
(4, 2, 'Size Lớn (L)', 0.00, 52000.00, 'Đang bán'),
(5, 3, 'Phần Tiêu Chuẩn', 0.00, 35000.00, 'Đang bán');

-- Combo khuyến mãi
INSERT INTO `PROMOTIONS_COMBO` (`combo_id`, `combo_name`, `combo_status`) VALUES
(1, 'Combo Trà Bánh Buổi Chiều', 'Đang áp dụng'),
(2, 'Combo Khai Vị', 'Tạm ngưng');

-- Chi tiết khuyến mãi
INSERT INTO `PROMOTIONS` (`promo_id`, `combo_id`, `variant_id`, `promo_type`, `promo_value`) VALUES
(1, 1, 3, 'Giảm giá trực tiếp', 10000.00),
(2, 1, 5, 'Phần trăm', 15.00);

-- Đơn hàng
INSERT INTO `ORDER` (`order_id`, `order_code`, `table_id`, `order_type`, `customer_name`, `customer_phone`, `discount_amount`, `payment_method`, `payment_status`, `total_amount`, `cancel_reason`, `voucher_id`, `staff_id`, `status`) VALUES
(1, 'ORD-20261025-001', 1, 'Tại bàn', 'Anh Hoàng Nam', '0912345678', 11600.00, 2, 'Đã thanh toán', 104400.00, NULL, 1, 2, 'Hoàn thành'),
(2, 'ORD-20261025-002', 5, 'Mang về', 'Chị Mai Linh', '0987654321', 0.00, 1, 'Chưa thanh toán', 45000.00, NULL, NULL, 3, 'Đang pha chế');

-- Chi tiết món trong đơn hàng
INSERT INTO `ORDER_ITEMS` (`order_item_id`, `order_id`, `parent_order_item_id`, `quantity`, `unit_price`, `discount_amount`, `note`, `subtotal`) VALUES
-- Đơn hàng 1: Khách gọi 1 Trà Đào (L), 1 Cà Phê Muối (L), 1 Khoai tây chiên
(1, 1, NULL, 1, 52000.00, 0.00, 'Ít đường 50%', 52000.00),
(2, 1, NULL, 1, 39000.00, 0.00, 'Nhiều đá riêng', 39000.00),
(3, 1, NULL, 1, 35000.00, 0.00, 'Lắc nhiều phô mai', 35000.00),

-- Đơn hàng 2: 1 Trà Đào (M) mang về
(4, 2, NULL, 1, 45000.00, 0.00, 'Mang đi để đá riêng', 45000.00);
