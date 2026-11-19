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

-- =============================================================================
-- BỘ MOCK DATA TEST TOÀN DIỆN CÁC TRƯỜNG HỢP CHO HỆ THỐNG
-- =============================================================================
USE `restaurant_db`;

-- 1. BÀN ĂN (Đủ các trạng thái: Trống, Có khách, Đặt trước, Bảo trì, Mang về)
INSERT INTO `TABLES` (`table_id`, `table_number`, `qr_token`, `status`) VALUES
(1, 'Bàn 01 (Tầng 1)', 'token_qr_b01_active', 'Đang có khách'),
(2, 'Bàn 02 (Tầng 1)', 'token_qr_b02_empty', 'Trống'),
(3, 'Bàn 03 (Tầng 1)', 'token_qr_b03_empty', 'Trống'),
(4, 'Bàn VIP 01 (Tầng 2)', 'token_qr_vip1_reserved', 'Đã đặt trước'),
(5, 'Bàn 05 (Ngoài trời)', 'token_qr_b05_broken', 'Đang bảo trì'),
(6, 'Quầy Mang Về (Takeaway)', NULL, 'Khả dụng');

-- 2. PHƯƠNG THỨC THANH TOÁN (Có hoạt động, có tạm ngưng bảo trì)
INSERT INTO `PAYMENT_METHODS` (`PAYMENT_ID`, `Name`, `Status`) VALUES
(1, 'Tiền mặt', 'Hoạt động'),
(2, 'Chuyển khoản VietQR', 'Hoạt động'),
(3, 'Ví điện tử MoMo', 'Hoạt động'),
(4, 'Thẻ Visa / Mastercard', 'Hoạt động'),
(5, 'Ví ZaloPay', 'Tạm bảo trì');

-- 3. NHÂN VIÊN (Đủ các vai trò + Có người đang làm, có người đã nghỉ việc)
INSERT INTO `STAFF` (`staff_id`, `full_name`, `email`, `password_hash`, `role`, `status`) VALUES
(1, 'Nguyễn Văn Quản Lý', 'admin@restaurant.com', '$2y$10$wT8Kz...hash1', 'Quản lý', 'Đang làm việc'),
(2, 'Trần Thị Thu Ngân', 'thungan@restaurant.com', '$2y$10$kL9Qx...hash2', 'Thu ngân', 'Đang làm việc'),
(3, 'Lê Hoàng Phục Vụ', 'phucvu1@restaurant.com', '$2y$10$mN3Za...hash3', 'Phục vụ', 'Đang làm việc'),
(4, 'Phạm Barista Bếp', 'kitchen@restaurant.com', '$2y$10$zP4Bx...hash4', 'Pha chế', 'Đang làm việc'),
(5, 'Đỗ Văn Cũ (Nghỉ việc)', 'nhanviencu@restaurant.com', '$2y$10$qR1Yw...hash5', 'Phục vụ', 'Đã nghỉ việc');

-- 4. VOUCHER (Đủ case: Đang dùng được, Hết hạn, Đơn tối thiểu cao)
INSERT INTO `VOUCHER` (`voucher_id`, `code`, `discount_percent`, `expiry_date`, `max_discount_amout`, `min_order_amount`, `status`, `voucher_sp_id`) VALUES
(1, 'CHAOBANMOI', 10.00, '2026-12-31 23:59:59', 30000.00, 80000.00, 'Khả dụng', NULL),     -- Giảm 10%, max 30k, min 80k
(2, 'GIAM50K', 20.00, '2026-12-31 23:59:59', 50000.00, 200000.00, 'Khả dụng', NULL),       -- Giảm 20%, chặn trần max 50k
(3, 'HETHAN2023', 50.00, '2023-01-01 00:00:00', 100000.00, 50000.00, 'Hết hạn', NULL),      -- Case: Voucher hết hạn
(4, 'VIPTIEC1TRIEU', 15.00, '2026-12-31 23:59:59', 200000.00, 1000000.00, 'Khả dụng', NULL); -- Case: Đơn phải trên 1 triệu mới được dùng

-- 5. DANH MỤC MÓN (Có danh mục hiển thị, có danh mục ẩn/hết mùa)
INSERT INTO `CATEGORY` (`category_id`, `category_name`, `description`, `status`) VALUES
(1, 'Cà Phê Truyền Thống', 'Cà phê phin Robusta và Arabica nguyên chất', 'Hiển thị'),
(2, 'Trà Trái Cây & Trà Sữa', 'Đồ uống tươi giải nhiệt', 'Hiển thị'),
(3, 'Món Ăn Vặt & Khai Vị', 'Đồ ăn nhanh nóng hổi', 'Hiển thị'),
(4, 'Món Đặc Biệt Mùa Hè', 'Menu theo mùa', 'Tạm ẩn');

-- 6. MÓN ĂN (Có món bình thường, có món hết nguyên liệu, có options JSON/text)
INSERT INTO `MENU_ITEM` (`item_id`, `item_name`, `description`, `status`, `image_url`, `options`, `category_id`) VALUES
(1, 'Cà Phê Muối Xứ Huế', 'Cà phê phin kết hợp lớp kem mặn béo ngậy', 'Còn món', 'https://img.vn/cf-muoi.jpg', '50% đường, 100% đường, Ít đá, Nhiều đá', 1),
(2, 'Cà Phê Đen Đá', 'Đậm đà truyền thống', 'Còn món', 'https://img.vn/cf-den.jpg', 'Không đường, Có đường', 1),
(3, 'Trà Đào Cam Sả', 'Trà thanh mát với miếng đào giòn', 'Còn món', 'https://img.vn/tra-dao.jpg', 'Đá chung, Đá riêng, 70% ngọt', 2),
(4, 'Trà Sữa Trân Châu Hoàng Gia', 'Trà đen đậm vị sữa cùng trân châu đen dẻo', 'Còn món', 'https://img.vn/tra-sua.jpg', '30% đá, 50% đá, 70% đường', 2),
(5, 'Khoai Tây Chiên Lắc Phô Mai', 'Khoai giòn lắc bột phô mai béo ngọt', 'Còn món', 'https://img.vn/khoai-tay.jpg', 'Có cay, Không cay', 3),
(6, 'Gà Popcorn Lắc Rong Biển', 'Thịt gà tươi viên chiên giòn rụm', 'Hết món', 'https://img.vn/ga-popcorn.jpg', 'Có sốt chấm riêng', 3);

-- 7. BIẾN THỂ MÓN ĂN (Có size S/M/L, Có món đang giảm giá trực tiếp `discount`)
INSERT INTO `MENU_VARIANT` (`variant_id`, `variant_name`, `discount`, `price`, `status`, `item_id`) VALUES
(1, 'Size Vừa (M)', 0.00, 32000.00, 'Đang bán', 1),
(2, 'Size Lớn (L)', 0.00, 39000.00, 'Đang bán', 1),
(3, 'Size Vừa (M)', 0.00, 25000.00, 'Đang bán', 2),
(4, 'Size Vừa (M)', 0.00, 45000.00, 'Đang bán', 3),
(5, 'Size Lớn (L)', 5000.00, 52000.00, 'Đang bán', 3), -- Giảm giá trực tiếp 5.000đ trên menu
(6, 'Size Vừa (M)', 0.00, 40000.00, 'Đang bán', 4),
(7, 'Size Lớn (L)', 0.00, 48000.00, 'Đang bán', 4),
(8, 'Phần Tiêu Chuẩn', 0.00, 35000.00, 'Đang bán', 5),
(9, 'Phần Siêu To (Khổng Lồ)', 0.00, 55000.00, 'Đang bán', 5),
(10, 'Phần Tiêu Chuẩn', 0.00, 45000.00, 'Hết hàng', 6);

-- 8. COMBO KHUYẾN MÃI (Đang chạy, Đã hết hạn, Sắp chạy)
INSERT INTO `PROMOTIONS_COMBO` (`combo_id`, `combo_name`, `date_start`, `date_end`) VALUES
(1, 'Combo Trà Chiều Thảnh Thơi', '2026-01-01', '2026-12-31'),
(2, 'Combo Ăn Vặt Xuyên Đêm (Đã hết hạn)', '2023-01-01', '2023-06-30'),
(3, 'Combo Mùa Giáng Sinh (Sắp tới)', '2026-12-01', '2026-12-25');

-- 9. CHI TIẾT KHUYẾN MÃI (Giảm tiền mặt vs Giảm theo %)
INSERT INTO `PROMOTIONS` (`promo_id`, `combo_id`, `variant_id`, `promo_type`, `promo_value`) VALUES
(1, 1, 4, 'Giảm giá trực tiếp', 10000.00), -- Trà đào M trong combo giảm 10k
(2, 1, 8, 'Phần trăm', 15.00);             -- Khoai tây trong combo giảm 15%

-- =============================================================================
-- 10. ĐƠN HÀNG (ORDER) - ĐỦ 5 TÌNH HUỐNG THỰC TẾ
-- =============================================================================
INSERT INTO `ORDER` (`order_id`, `order_code`, `table_id`, `order_type`, `discount_amount`, `payment_method`, `payment_status`, `total_amount`, `cancel_reason`, `voucher_id`, `status`, `staff_id`, `created_at`) VALUES
-- TRƯỜNG HỢP 1: Khách ăn tại Bàn 1, hóa đơn chuẩn, áp Voucher 10% (giảm 12.6k), trả qua VietQR
(1, 'ORD-20261025-001', 1, 'Tại bàn', 12600.00, 2, 'Đã thanh toán', 113400.00, NULL, 1, 'Hoàn thành', 2, '2026-10-25 08:30:00'),

-- TRƯỜNG HỢP 2: Khách mang về (Take-away, table_id = NULL), không áp voucher, trả Tiền mặt
(2, 'ORD-20261025-002', NULL, 'Mang về', 0.00, 1, 'Đã thanh toán', 50000.00, NULL, NULL, 'Hoàn thành', 3, '2026-10-25 09:15:00'),

-- TRƯỜNG HỢP 3: Khách đang ngồi ăn tại Bàn 2, bếp đang làm món -> CHƯA THANH TOÁN
(3, 'ORD-20261025-003', 2, 'Tại bàn', 0.00, NULL, 'Chưa thanh toán', 127000.00, NULL, NULL, 'Đang chuẩn bị', 3, '2026-10-25 10:00:00'),

-- TRƯỜNG HỢP 4: Khách đặt tại bàn nhưng bận việc gấp -> ĐƠN BỊ HỦY (Có lý do hủy đơn)
(4, 'ORD-20261025-004', 3, 'Tại bàn', 0.00, NULL, 'Đã hủy', 0.00, 'Khách có việc gấp về sớm, chưa ra món', NULL, 'Đã hủy', 2, '2026-10-25 10:20:00'),

-- TRƯỜNG HỢP 5: Tiệc lớn Bàn VIP (Tổng 436k), Áp voucher GIAM50K (20% của 436k = 87.2k, nhưng bị chặn trần max 50k), Quẹt thẻ Visa
(5, 'ORD-20261025-005', 4, 'Tại bàn', 50000.00, 4, 'Đã thanh toán', 386000.00, NULL, 2, 'Hoàn thành', 1, '2026-10-25 11:45:00');

-- =============================================================================
-- 11. CHI TIẾT MÓN TRONG ĐƠN (ORDER_ITEMS) - KHỚP TỪNG ĐỒNG TOÁN HỌC
-- =============================================================================
INSERT INTO `ORDER_ITEMS` (`order_item_id`, `order_id`, `variant_id`, `quantity`, `unit_price`, `discount_amount`, `note`, `subtotal`) VALUES

-- --- CÁC MÓN CỦA ĐƠN HÀNG 1 (Tổng trước giảm: 52k + 39k + 35k = 126.000đ) ---
(1, 1, 5, 1, 52000.00, 0.00, 'Ít ngọt 50%', 52000.00),         -- 1x Trà đào Size L
(2, 1, 2, 1, 39000.00, 0.00, 'Nhiều đá riêng', 39000.00),       -- 1x Cà phê muối Size L
(3, 1, 8, 1, 35000.00, 0.00, 'Lắc nhiều bột phô mai', 35000.00),-- 1x Khoai tây chiên thường

-- --- CÁC MÓN CỦA ĐƠN HÀNG 2 (Mang về, 2 ly cà phê đen = 50.000đ) ---
(4, 2, 3, 2, 25000.00, 0.00, 'Đóng túi mang đi, để đá riêng', 50000.00), -- 2x Cà phê đen M

-- --- CÁC MÓN CỦA ĐƠN HÀNG 3 (Đang ăn dở: 1 Trà sữa + 1 Khoai khổng lồ + 1 Cà phê M = 127.000đ) ---
(5, 3, 7, 1, 48000.00, 0.00, 'Thêm trân châu đen', 48000.00),   -- 1x Trà sữa Size L
(6, 3, 9, 1, 55000.00, 0.00, 'Chiên giòn rụm', 55000.00),       -- 1x Khoai tây khổng lồ
(7, 3, 1, 1, 32000.00, 0.00, 'Bình thường', 32000.00),          -- 1x Cà phê muối M

-- --- CÁC MÓN CỦA ĐƠN HÀNG 4 (Đơn hủy - vẫn lưu vết item để kiểm toán lịch sử bếp) ---
(8, 4, 4, 1, 45000.00, 0.00, 'Khách hủy trước khi làm', 45000.00),

-- --- CÁC MÓN CỦA ĐƠN HÀNG 5 (Tiệc VIP 4 người: 4 món nước + 3 món ăn = 436.000đ) ---
(9, 5, 5, 2, 52000.00, 0.00, 'Bàn VIP - không lấy sả', 104000.00), -- 2x Trà đào L (104k)
(10, 5, 2, 2, 39000.00, 0.00, 'Đậm vị phin', 78000.00),            -- 2x Cà phê muối L (78k)
(11, 5, 7, 2, 48000.00, 0.00, 'Nhiều trân châu', 96000.00),        -- 2x Trà sữa L (96k)
(12, 5, 9, 2, 55000.00, 0.00, 'Lắc phô mai đậm đà', 11000.00),    -- 2x Khoai khổng lồ (110k)
(13, 5, 6, 1, 40000.00, 0.00, 'Ít đường', 40000.00);               -- 1x Trà sữa M (40k)
-- Tổng = 104 + 78 + 96 + 110 + 48 (trừ voucher 50k) = 386.000đ
