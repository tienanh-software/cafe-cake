-- =============================================================================
-- HỆ THỐNG QUẢN LÝ NHÀ HÀNG / CAFE
-- Bản cập nhật chuẩn xác theo ERD mới nhất cho Châu
-- =============================================================================

CREATE DATABASE IF NOT EXISTS `restaurant_db` 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE `restaurant_db`;

-- Xóa các bảng cũ nếu đã tồn tại để tránh lỗi trùng lặp/khóa ngoại
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
-- 1. TẠO CÁC BẢNG (ĐÚNG TÊN CỘT & QUAN HỆ THEO ẢNH MỚI)
-- =============================================================================

-- 1. Bảng TABLES (Bàn ăn)
CREATE TABLE `TABLES` (
    `table_id` INT AUTO_INCREMENT PRIMARY KEY,
    `table_number` VARCHAR(50) NOT NULL,
    `qr_token` VARCHAR(255) NULL,
    `status` VARCHAR(50) DEFAULT 'Trống',
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 2. Bảng PAYMENT METHODS (Phương thức thanh toán)
CREATE TABLE `PAYMENT_METHODS` (
    `PAYMENT_ID` INT AUTO_INCREMENT PRIMARY KEY,
    `Name` VARCHAR(100) NOT NULL,
    `Status` VARCHAR(50) DEFAULT 'Hoạt động',
    `Time` DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 3. Bảng STAFF (Nhân viên)
CREATE TABLE `STAFF` (
    `staff_id` INT AUTO_INCREMENT PRIMARY KEY,
    `full_name` VARCHAR(100) NOT NULL,
    `email` VARCHAR(100) NOT NULL UNIQUE,
    `password_hash` VARCHAR(255) NOT NULL,
    `role` VARCHAR(50) NOT NULL,
    `status` VARCHAR(50) DEFAULT 'Đang làm việc',
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 4. Bảng VOUCHER (Phiếu giảm giá)
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

-- 5. Bảng CATEGORY (Danh mục món)
CREATE TABLE `CATEGORY` (
    `category_id` INT AUTO_INCREMENT PRIMARY KEY,
    `category_name` VARCHAR(100) NOT NULL,
    `description` TEXT NULL,
    `status` VARCHAR(50) DEFAULT 'Hiển thị'
);

-- 6. Bảng MENU_ITEM (Món ăn)
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

-- 7. Bảng MENU_VARIANT (Biến thể món: Size, loại...)
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

-- 8. Bảng PROMOTIONS_COMBO (Nhóm combo khuyến mãi)
CREATE TABLE `PROMOTIONS_COMBO` (
    `combo_id` INT AUTO_INCREMENT PRIMARY KEY,
    `combo_name` VARCHAR(150) NOT NULL,
    `combo_status` VARCHAR(50) DEFAULT 'Đang áp dụng'
);

-- 9. Bảng PROMOTIONS (Chi tiết khuyến mãi)
CREATE TABLE `PROMOTIONS` (
    `promo_id` INT AUTO_INCREMENT PRIMARY KEY,
    `promo_type` VARCHAR(50) NOT NULL,
    `promo_value` DECIMAL(12,2) NOT NULL,
    `combo_id` INT NOT NULL,
    `variant_id` INT NOT NULL,
    CONSTRAINT `fk_promo_combo` FOREIGN KEY (`combo_id`) REFERENCES `PROMOTIONS_COMBO` (`combo_id`) ON DELETE CASCADE,
    CONSTRAINT `fk_promo_variant` FOREIGN KEY (`variant_id`) REFERENCES `MENU_VARIANT` (`variant_id`) ON DELETE CASCADE
);

-- 10. Bảng ORDER (Đơn hàng)
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
    `status` VARCHAR(50) DEFAULT 'Chờ xử lý',
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `staff_id` INT NULL,
    CONSTRAINT `fk_order_table` FOREIGN KEY (`table_id`) REFERENCES `TABLES` (`table_id`) ON DELETE SET NULL,
    CONSTRAINT `fk_order_payment` FOREIGN KEY (`payment_method`) REFERENCES `PAYMENT_METHODS` (`PAYMENT_ID`) ON DELETE SET NULL,
    CONSTRAINT `fk_order_voucher` FOREIGN KEY (`voucher_id`) REFERENCES `VOUCHER` (`voucher_id`) ON DELETE SET NULL,
    CONSTRAINT `fk_order_staff` FOREIGN KEY (`staff_id`) REFERENCES `STAFF` (`staff_id`) ON DELETE SET NULL
);

-- 11. Bảng ORDER_ITEMS (Chi tiết món theo đúng ERD mới: FK order_id và FK variant_id)
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

-- =============================================================================
-- 2. DỮ LIỆU MẪU THỰC TẾ (MOCK DATA)
-- =============================================================================

-- 1. Bàn ăn
INSERT INTO `TABLES` (`table_id`, `table_number`, `qr_token`, `status`) VALUES
(1, 'Bàn 01 (Tầng 1)', 'qr_token_b01_t1_sec9823', 'Đang có khách'),
(2, 'Bàn 02 (Tầng 1)', 'qr_token_b02_t1_sec8712', 'Trống'),
(3, 'Bàn VIP 01 (Tầng 2)', 'qr_token_vip1_sec9912', 'Đã đặt trước'),
(4, 'Quầy Mang Về', NULL, 'Khả dụng');

-- 2. Phương thức thanh toán
INSERT INTO `PAYMENT_METHODS` (`PAYMENT_ID`, `Name`, `Status`) VALUES
(1, 'Tiền mặt', 'Hoạt động'),
(2, 'Chuyển khoản VietQR', 'Hoạt động'),
(3, 'Ví điện tử MoMo', 'Hoạt động');

-- 3. Nhân viên
INSERT INTO `STAFF` (`staff_id`, `full_name`, `email`, `password_hash`, `role`, `status`) VALUES
(1, 'Nguyễn Văn Quản Lý', 'manager@restaurant.com', '$2y$10$wT8Kz.hashManager99', 'Quản lý', 'Đang làm việc'),
(2, 'Trần Thị Thu Ngân', 'cashier@restaurant.com', '$2y$10$kL9Qx.hashCashier88', 'Thu ngân', 'Đang làm việc'),
(3, 'Lê Hoàng Phục Vụ', 'waiter@restaurant.com', '$2y$10$mN3Za.hashWaiter77', 'Phục vụ', 'Đang làm việc');

-- 4. Voucher khuyến mãi
INSERT INTO `VOUCHER` (`voucher_id`, `code`, `discount_percent`, `expiry_date`, `max_discount_amout`, `min_order_amount`, `status`, `voucher_sp_id`) VALUES
(1, 'CHAOBANMOI', 10.00, '2026-12-31 23:59:59', 30000.00, 100000.00, 'Khả dụng', NULL),
(2, 'GIAM50K', 20.00, '2026-12-31 23:59:59', 50000.00, 200000.00, 'Khả dụng', NULL);

-- 5. Danh mục món
INSERT INTO `CATEGORY` (`category_id`, `category_name`, `description`, `status`) VALUES
(1, 'Cà Phê Truyền Thống', 'Các dòng cà phê phin đậm đà Việt Nam', 'Hiển thị'),
(2, 'Trà Trái Cây & Trà Sữa', 'Các loại trà giải nhiệt hoa quả tươi', 'Hiển thị'),
(3, 'Món Ăn Vặt', 'Đồ ăn kèm nóng giòn', 'Hiển thị');

-- 6. Món ăn
INSERT INTO `MENU_ITEM` (`item_id`, `item_name`, `description`, `status`, `image_url`, `options`, `category_id`) VALUES
(1, 'Cà Phê Muối Xứ Huế', 'Cà phê phin thơm lừng kết hợp kem mặn béo', 'Còn món', 'https://img.food.vn/cf-muoi.jpg', 'Ít ngọt, Ít đá, Nhiều đá', 1),
(2, 'Trà Đào Cam Sả', 'Trà đào thanh mát với miếng đào giòn và sả tươi', 'Còn món', 'https://img.food.vn/tra-dao.jpg', '50% đường, 100% đường', 2),
(3, 'Khoai Tây Chiên Lắc Phô Mai', 'Khoai tây cọng giòn rụm phủ lớp bột phô mai hảo hạng', 'Còn món', 'https://img.food.vn/khoai-tay.jpg', 'Có cay, Không cay', 3);

-- 7. Biến thể món ăn (Size/loại)
INSERT INTO `MENU_VARIANT` (`variant_id`, `variant_name`, `discount`, `price`, `status`, `item_id`) VALUES
(1, 'Size Vừa (M)', 0.00, 32000.00, 'Đang bán', 1),
(2, 'Size Lớn (L)', 0.00, 39000.00, 'Đang bán', 1),
(3, 'Size Vừa (M)', 0.00, 45000.00, 'Đang bán', 2),
(4, 'Size Lớn (L)', 0.00, 52000.00, 'Đang bán', 2),
(5, 'Phần Tiêu Chuẩn', 0.00, 35000.00, 'Đang bán', 3);

-- 8. Combo khuyến mãi
INSERT INTO `PROMOTIONS_COMBO` (`combo_id`, `combo_name`, `combo_status`) VALUES
(1, 'Combo Trà Chiều Thư Giãn', 'Đang áp dụng');

-- 9. Chi tiết khuyến mãi
INSERT INTO `PROMOTIONS` (`promo_id`, `promo_type`, `promo_value`, `combo_id`, `variant_id`) VALUES
(1, 'Giảm giá trực tiếp', 10000.00, 1, 3); -- Giảm 10k cho Trà đào size M

-- 10. Đơn hàng (ORDER)
INSERT INTO `ORDER` (`order_id`, `order_code`, `table_id`, `order_type`, `customer_name`, `customer_phone`, `discount_amount`, `payment_method`, `payment_status`, `total_amount`, `cancel_reason`, `voucher_id`, `status`, `staff_id`) VALUES
-- Đơn số 1: Bàn 1 gọi 3 món (Tổng 126k, áp voucher giảm 10% = 12.6k, còn 113.4k)
(1, 'ORD-20261025-001', 1, 'Tại bàn', 'Anh Hoàng Nam', '0912345678', 12600.00, 2, 'Đã thanh toán', 113400.00, NULL, 1, 'Hoàn thành', 2),

-- Đơn số 2: Khách mang về mua 1 ly Trà đào (45k)
(2, 'ORD-20261025-002', 4, 'Mang về', 'Chị Mai Linh', '0987654321', 0.00, 1, 'Chưa thanh toán', 45000.00, NULL, NULL, 'Đang pha chế', 3);

-- 11. Chi tiết đơn hàng (ORDER_ITEMS - Khớp chính xác FK order_id và FK variant_id)
INSERT INTO `ORDER_ITEMS` (`order_item_id`, `order_id`, `variant_id`, `quantity`, `unit_price`, `discount_amount`, `note`, `subtotal`) VALUES
-- Chi tiết đơn 1:
(1, 1, 4, 1, 52000.00, 0.00, 'Ít đường 50%', 52000.00), -- 1x Trà đào Size L
(2, 1, 2, 1, 39000.00, 0.00, 'Nhiều đá để riêng', 39000.00), -- 1x Cà phê muối Size L
(3, 1, 5, 1, 35000.00, 0.00, 'Lắc nhiều bột phô mai', 35000.00), -- 1x Khoai tây chiên

-- Chi tiết đơn 2:
(4, 2, 3, 1, 45000.00, 0.00, 'Mang đi để đá riêng', 45000.00); -- 1x Trà đào Size M
