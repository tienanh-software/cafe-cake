-- =============================================================================
-- HỆ THỐNG QUẢN LÝ NHÀ HÀNG / CAFE
-- Bản chuẩn chỉnh thứ tự quan hệ & nạp Mock Data thực tế
-- =============================================================================

CREATE DATABASE IF NOT EXISTS `restaurant_db` 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE `restaurant_db`;

-- Xóa các bảng cũ theo đúng thứ tự an toàn
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
-- 1. TẠO CÁC BẢNG (CHUẨN THỨ TỰ KHÓA NGOẠI)
-- =============================================================================

-- 1. Bảng Bàn ăn
CREATE TABLE `TABLES` (
    `table_id` INT AUTO_INCREMENT PRIMARY KEY,
    `table_number` VARCHAR(50) NOT NULL,
    `qr_token` VARCHAR(255) NULL,
    `status` VARCHAR(50) DEFAULT 'Trống',
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 2. Bảng Phương thức thanh toán
CREATE TABLE `PAYMENT_METHODS` (
    `PAYMENT_ID` INT AUTO_INCREMENT PRIMARY KEY,
    `Name` VARCHAR(100) NOT NULL,
    `Status` VARCHAR(50) DEFAULT 'Hoạt động',
    `Time` DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 3. Bảng Nhân viên
CREATE TABLE `STAFF` (
    `staff_id` INT AUTO_INCREMENT PRIMARY KEY,
    `full_name` VARCHAR(100) NOT NULL,
    `email` VARCHAR(100) NOT NULL UNIQUE,
    `password_hash` VARCHAR(255) NOT NULL,
    `role` VARCHAR(50) NOT NULL,
    `status` VARCHAR(50) DEFAULT 'Đang làm việc',
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 4. Bảng Phiếu giảm giá (VOUCHER)
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

-- 5. Bảng Danh mục món
CREATE TABLE `CATEGORY` (
    `category_id` INT AUTO_INCREMENT PRIMARY KEY,
    `category_name` VARCHAR(100) NOT NULL,
    `description` TEXT NULL,
    `status` VARCHAR(50) DEFAULT 'Hiển thị'
);

-- 6. Bảng Món ăn
CREATE TABLE `MENU_ITEM` (
    `item_id` INT AUTO_INCREMENT PRIMARY KEY,
    `item_name` VARCHAR(150) NOT NULL,
    `description` TEXT NULL,
    `status` VARCHAR(50) DEFAULT 'Còn món',
    `image_url` VARCHAR(255) NULL,
    `options` TEXT NULL,
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `category_id` INT NOT NULL,
    CONSTRAINT `fk_item_category` FOREIGN KEY (`category_id`) REFERENCES `CATEGORY` (`category_id`) ON DELETE CASCADE
);

-- 7. Bảng Biến thể món ăn (Size, loại...)
CREATE TABLE `MENU_VARIANT` (
    `variant_id` INT AUTO_INCREMENT PRIMARY KEY,
    `variant_name` VARCHAR(100) NOT NULL,
    `discount` DECIMAL(10,2) DEFAULT 0.00,
    `price` DECIMAL(12,2) NOT NULL,
    `status` VARCHAR(50) DEFAULT 'Đang bán',
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `item_id` INT NOT NULL,
    CONSTRAINT `fk_variant_item` FOREIGN KEY (`item_id`) REFERENCES `MENU_ITEM` (`item_id`) ON DELETE CASCADE
);

-- 8. Bảng Nhóm combo khuyến mãi (PHẢI TẠO TRƯỚC BẢNG PROMOTIONS)
CREATE TABLE `PROMOTIONS_COMBO` (
    `combo_id` INT AUTO_INCREMENT PRIMARY KEY,
    `combo_name` VARCHAR(150) NOT NULL,
    `date_start` DATE DEFAULT (CURRENT_DATE),
    `date_end` DATE NULL
);

-- 9. Bảng Chi tiết khuyến mãi
CREATE TABLE `PROMOTIONS` (
    `promo_id` INT AUTO_INCREMENT PRIMARY KEY,
    `promo_type` VARCHAR(50) NOT NULL,
    `promo_value` DECIMAL(12,2) NOT NULL,
    `combo_id` INT NOT NULL,
    `variant_id` INT NOT NULL,
    CONSTRAINT `fk_promo_combo` FOREIGN KEY (`combo_id`) REFERENCES `PROMOTIONS_COMBO` (`combo_id`) ON DELETE CASCADE,
    CONSTRAINT `fk_promo_variant` FOREIGN KEY (`variant_id`) REFERENCES `MENU_VARIANT` (`variant_id`) ON DELETE CASCADE
);

-- 10. Bảng Đơn hàng
CREATE TABLE `ORDER` (
    `order_id` INT AUTO_INCREMENT PRIMARY KEY,
    `order_code` VARCHAR(50) NOT NULL UNIQUE,
    `table_id` INT NULL,
    `order_type` VARCHAR(50) NOT NULL,
	`discount_amount` DECIMAL(12,2) DEFAULT 0.00,
    `payment_method` INT NULL,
    `payment_status` VARCHAR(50) DEFAULT 'Chưa thanh toán',
    `total_amount` DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    `cancel_reason` TEXT NULL,
    `voucher_id` INT NULL,
    `status` VARCHAR(50) DEFAULT 'Chờ xử lý',
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `staff_id` INT NULL,
    CONSTRAINT `fk_order_table` FOREIGN KEY (`table_id`) REFERENCES `TABLES` (`table_id`) ON DELETE SET NULL,
    CONSTRAINT `fk_order_payment` FOREIGN KEY (`payment_method`) REFERENCES `PAYMENT_METHODS` (`PAYMENT_ID`) ON DELETE SET NULL,
    CONSTRAINT `fk_order_voucher` FOREIGN KEY (`voucher_id`) REFERENCES `VOUCHER` (`voucher_id`) ON DELETE SET NULL,
    CONSTRAINT `fk_order_staff` FOREIGN KEY (`staff_id`) REFERENCES `STAFF` (`staff_id`) ON DELETE SET NULL
);

-- 11. Bảng Chi tiết đơn hàng (ORDER_ITEMS)
CREATE TABLE `ORDER_ITEMS` (
    `order_item_id` INT AUTO_INCREMENT PRIMARY KEY,
    `order_id` INT NOT NULL,
    `variant_id` INT NOT NULL,
    `quantity` INT NOT NULL DEFAULT 1,
    `unit_price` DECIMAL(12,2) NOT NULL,
    `discount_amount` DECIMAL(12,2) DEFAULT 0.00,
    `note` TEXT NULL,
    `subtotal` DECIMAL(12,2) NOT NULL,
    CONSTRAINT `fk_order_items_order` FOREIGN KEY (`order_id`) REFERENCES `ORDER` (`order_id`) ON DELETE CASCADE,
    CONSTRAINT `fk_order_items_variant` FOREIGN KEY (`variant_id`) REFERENCES `MENU_VARIANT` (`variant_id`) ON DELETE RESTRICT
);

