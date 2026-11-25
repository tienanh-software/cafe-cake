-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Máy chủ: localhost:3306
-- Thời gian đã tạo: Th10 24, 2026 lúc 02:32 PM
-- Phiên bản máy phục vụ: 8.0.30
-- Phiên bản PHP: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `restaurant_db`
--

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `category`
--

CREATE TABLE `category` (
  `category_id` int NOT NULL,
  `category_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `status` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT 'Hiển thị'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `category`
--

INSERT INTO `category` (`category_id`, `category_name`, `description`, `status`) VALUES
(1, 'Cà Phê Truyền Thống', 'Cà phê phin Robusta và Arabica nguyên chất', 'Hiển thị'),
(2, 'Trà Trái Cây & Trà Sữa', 'Đồ uống tươi giải nhiệt', 'Hiển thị'),
(3, 'Món Ăn Vặt & Khai Vị', 'Đồ ăn nhanh nóng hổi', 'Hiển thị'),
(4, 'Món Đặc Biệt Mùa Hè', 'Menu theo mùa', 'Tạm ẩn');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `menu_item`
--

CREATE TABLE `menu_item` (
  `item_id` int NOT NULL,
  `item_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `status` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT 'Còn món',
  `image_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `options` text COLLATE utf8mb4_unicode_ci,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `category_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `menu_item`
--

INSERT INTO `menu_item` (`item_id`, `item_name`, `description`, `status`, `image_url`, `options`, `created_at`, `category_id`) VALUES
(1, 'Cà phê sữa đá', 'Cà phê rang đậm phối trộn Robusta & Arabica pha phin truyền thống, hòa quyện sữa đặc béo ngậy.', 'Còn món', 'assets/images/prod_ca_phe_sua_da_1795150828661.jpg', '{\"kind\":\"beverage\",\"badge\":\"BÁN CHẠY\",\"is_featured\":true}', '2026-11-23 21:16:45', 1),
(2, 'Bạc xỉu', 'Ba tầng sữa tươi thanh mát, sữa đặc dịu ngọt và lớp bọt cà phê thơm lừng nhẹ nhàng.', 'Còn món', 'assets/images/prod_bac_xiu_1795150829243.jpg', '{\"kind\":\"beverage\",\"badge\":\"\",\"is_featured\":true}', '2026-11-23 21:16:45', 1),
(3, 'Americano', 'Hai shot Espresso chiết xuất chuẩn mực hòa cùng nước tinh khiết, vị thanh sạch hậu ngọt.', 'Còn món', 'assets/images/prod_americano_1795150829082.jpg', '{\"kind\":\"beverage\",\"badge\":\"\",\"is_featured\":false}', '2026-11-23 21:16:45', 1),
(4, 'Cappuccino', 'Espresso, sữa nóng và lớp bọt sữa mịn màng rắc nhẹ bột cacao nguyên chất.', 'Còn món', 'assets/images/prod_cappuccino_1795150828785.jpg', '{\"kind\":\"beverage\",\"badge\":\"\",\"is_featured\":true}', '2026-11-23 21:16:45', 1),
(5, 'Latte', 'Sữa tươi đánh hơi lụa mịn kết hợp cùng Espresso rang vừa, êm ái và cân bằng.', 'Còn món', 'assets/images/prod_latte_1795150828600.jpg', '{\"kind\":\"beverage\",\"badge\":\"\",\"is_featured\":false}', '2026-11-23 21:16:45', 1),
(6, 'Espresso', 'Chiết xuất áp suất cao 9 bar giữ trọn lớp crema vàng óng cùng hương sô-cô-la đen.', 'Còn món', 'assets/images/prod_espresso_1795150828441.jpg', '{\"kind\":\"beverage\",\"badge\":\"\",\"is_featured\":false}', '2026-11-23 21:16:45', 1),
(7, 'Matcha Latte', 'Matcha Uji thanh dịu đánh tay bằng chổi chasen cùng sữa tươi tiệt trùng mát lạnh.', 'Còn món', 'assets/images/prod_matcha_latte_1795150828588.jpg', '{\"kind\":\"beverage\",\"badge\":\"MỚI\",\"is_featured\":true}', '2026-11-23 21:49:33', 2),
(8, 'Trà đào cam sả', 'Trà đen ủ lạnh thanh mát quyện hương sả tươi, cam vàng mọng và miếng đào giòn ngọt.', 'Còn món', 'assets/images/prod_tra_dao_cam_sa_1795150828656.jpg', '{\"kind\":\"beverage\",\"badge\":\"BÁN CHẠY\",\"is_featured\":true}', '2026-11-23 21:49:33', 2),
(9, 'Trà vải', 'Trà lài hương hoa dịu nhẹ kết hợp quả vải ngâm ngọt thanh và lá bạc hà tươi.', 'Còn món', 'assets/images/prod_tra_vai_1795150828954.jpg', '{\"kind\":\"beverage\",\"badge\":\"\",\"is_featured\":false}', '2026-11-23 21:49:33', 2),
(10, 'Matcha Đá Xay', 'Matcha Nhật Bản xay nhuyễn mịn cùng đá và sữa tươi, phủ kem whipping bông nhẹ.', 'Còn món', 'assets/images/prod_matcha_da_xay_1795150828427.jpg', '{\"kind\":\"beverage\",\"badge\":\"MỚI\",\"is_featured\":false}', '2026-11-23 21:49:33', 3),
(11, 'Chocolate Đá Xay', 'Sô-cô-la đen 70% xay cùng sữa béo, phủ kem tươi và vụn sô-cô-la Bỉ thơm ngậy.', 'Còn món', 'assets/images/prod_choco_da_xay_1795150828433.jpg', '{\"kind\":\"beverage\",\"badge\":\"\",\"is_featured\":false}', '2026-11-23 21:49:33', 3),
(12, 'Tiramisu', 'Bánh sâm-panh thấm đẫm Espresso cùng kem phô mai Mascarpone mềm tan và bột cacao.', 'Còn món', 'assets/images/prod_tiramisu_1795150828226.jpg', '{\"kind\":\"bakery\",\"badge\":\"BÁN CHẠY\",\"is_featured\":true}', '2026-11-23 21:49:33', 4),
(13, 'Croissant bơ', 'Nướng mới mỗi sáng từ bơ nguyên chất, vỏ giòn rụm nhiều tầng ruột mềm xốp.', 'Còn món', 'assets/images/prod_croissant_bo_1795150828586.jpg', '{\"kind\":\"bakery\",\"badge\":\"\",\"is_featured\":true}', '2026-11-23 21:49:33', 4),
(14, 'Cheesecake', 'Basque Burnt Cheesecake nướng cháy cạnh kiểu Tây Ban Nha, lõi kem phô mai tan chảy.', 'Còn món', 'assets/images/prod_cheesecake_1795150828506.jpg', '{\"kind\":\"bakery\",\"badge\":\"ĐẶC BIỆT\",\"is_featured\":false}', '2026-11-23 21:49:33', 4),
(15, 'Red Velvet', 'Cốt bánh nhung đỏ mềm ẩm vị cacao nhẹ, xen kẽ lớp kem cream cheese chua dịu.', 'Còn món', 'assets/images/prod_red_velvet_1795150829136.jpg', '{\"kind\":\"bakery\",\"badge\":\"\",\"is_featured\":false}', '2026-11-23 21:49:33', 4),
(16, 'Chocolate Muffin', 'Muffin sô-cô-la nướng ấm thơm lừng với những mảnh sô-cô-la tan chảy bên trong.', 'Còn món', 'assets/images/prod_choco_muffin_1795150828511.jpg', '{\"kind\":\"bakery\",\"badge\":\"\",\"is_featured\":false}', '2026-11-23 21:49:33', 4),
(17, 'Croissant Trứng Muối', 'Bánh sừng bò giòn rụm phủ mè đen cùng nhân sốt trứng muối tan chảy béo mặn hài hòa.', 'Còn món', 'assets/images/prod_salted_egg_croissant_1795150828408.jpg', '{\"kind\":\"bakery\",\"badge\":\"BÁN CHẠY\",\"is_featured\":true}', '2026-11-23 21:49:33', 3),
(18, 'Baguette Jambon Phô Mai', 'Bánh mì Baguette vỏ giòn kẹp jambon hun khói, phô mai Emmental, xà lách và sốt Dijon.', 'Còn món', 'assets/images/prod_savory_baguette_1795150828853.jpg', '{\"kind\":\"bakery\",\"badge\":\"\",\"is_featured\":false}', '2026-11-23 21:49:33', 3);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `menu_variant`
--

CREATE TABLE `menu_variant` (
  `variant_id` int NOT NULL,
  `variant_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `discount` decimal(10,2) DEFAULT '0.00',
  `price` decimal(12,2) NOT NULL,
  `status` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT 'Đang bán',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `item_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `menu_variant`
--

INSERT INTO `menu_variant` (`variant_id`, `variant_name`, `discount`, `price`, `status`, `created_at`, `item_id`) VALUES
(1, 'Size Vừa (M)', 0.00, 32000.00, 'Đang bán', '2026-11-23 21:16:45', 1),
(2, 'Size Lớn (L)', 0.00, 39000.00, 'Đang bán', '2026-11-23 21:16:45', 1),
(3, 'Size Vừa (M)', 0.00, 25000.00, 'Đang bán', '2026-11-23 21:16:45', 2),
(4, 'Size Vừa (M)', 0.00, 45000.00, 'Đang bán', '2026-11-23 21:16:45', 3),
(5, 'Size Lớn (L)', 5000.00, 52000.00, 'Đang bán', '2026-11-23 21:16:45', 3),
(6, 'Size Vừa (M)', 0.00, 40000.00, 'Đang bán', '2026-11-23 21:16:45', 4),
(7, 'Size Lớn (L)', 0.00, 48000.00, 'Đang bán', '2026-11-23 21:16:45', 4),
(8, 'Phần Tiêu Chuẩn', 0.00, 35000.00, 'Đang bán', '2026-11-23 21:16:45', 5),
(9, 'Phần Siêu To (Khổng Lồ)', 0.00, 55000.00, 'Đang bán', '2026-11-23 21:16:45', 5),
(10, 'Phần Tiêu Chuẩn', 0.00, 45000.00, 'Hết hàng', '2026-11-23 21:16:45', 6),
(11, 'Size Vừa (M)', 0.00, 29000.00, 'Đang bán', '2026-11-24 12:09:20', 7),
(12, 'Size Lớn (L)', 0.00, 35000.00, 'Đang bán', '2026-11-24 12:09:20', 7),
(13, 'Size Vừa (M)', 0.00, 32000.00, 'Đang bán', '2026-11-24 12:09:20', 8),
(14, 'Size Vừa (M)', 0.00, 39000.00, 'Đang bán', '2026-11-24 12:09:20', 9),
(15, 'Size Vừa (M)', 0.00, 38000.00, 'Đang bán', '2026-11-24 12:09:20', 10),
(16, 'Size Lớn (L)', 0.00, 45000.00, 'Đang bán', '2026-11-24 12:09:20', 10),
(17, 'Size Vừa (M)', 0.00, 30000.00, 'Đang bán', '2026-11-24 12:09:20', 11),
(18, 'Size Vừa (M)', 0.00, 42000.00, 'Đang bán', '2026-11-24 12:09:20', 12),
(19, 'Size Lớn (L)', 0.00, 49000.00, 'Đang bán', '2026-11-24 12:09:20', 12),
(20, 'Size Vừa (M)', 0.00, 39000.00, 'Đang bán', '2026-11-24 12:09:20', 13),
(21, 'Size Vừa (M)', 0.00, 45000.00, 'Đang bán', '2026-11-24 12:09:20', 14),
(22, 'Size Vừa (M)', 0.00, 45000.00, 'Đang bán', '2026-11-24 12:09:20', 15),
(23, 'Phần Tiêu Chuẩn', 0.00, 42000.00, 'Đang bán', '2026-11-24 12:09:20', 16),
(24, 'Phần Tiêu Chuẩn', 0.00, 35000.00, 'Đang bán', '2026-11-24 12:09:20', 17),
(25, 'Phần Tiêu Chuẩn', 0.00, 48000.00, 'Đang bán', '2026-11-24 12:09:20', 18);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `order`
--

CREATE TABLE `order` (
  `order_id` int NOT NULL,
  `order_code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `table_id` int DEFAULT NULL,
  `order_type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `discount_amount` decimal(12,2) DEFAULT '0.00',
  `payment_method` int DEFAULT NULL,
  `payment_status` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT 'Chưa thanh toán',
  `total_amount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `cancel_reason` text COLLATE utf8mb4_unicode_ci,
  `voucher_id` int DEFAULT NULL,
  `status` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT 'Chờ xử lý',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `staff_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `order`
--

INSERT INTO `order` (`order_id`, `order_code`, `table_id`, `order_type`, `discount_amount`, `payment_method`, `payment_status`, `total_amount`, `cancel_reason`, `voucher_id`, `status`, `created_at`, `updated_at`, `staff_id`) VALUES
(1, 'ORD-20261025-001', 1, 'Tại bàn', 12600.00, 2, 'Đã thanh toán', 113400.00, NULL, 1, 'Hoàn thành', '2026-10-25 08:30:00', '2026-11-23 21:16:45', 2),
(2, 'ORD-20261025-002', NULL, 'Mang về', 0.00, 1, 'Đã thanh toán', 50000.00, NULL, NULL, 'Hoàn thành', '2026-10-25 09:15:00', '2026-11-23 21:16:45', 3),
(3, 'ORD-20261025-003', 2, 'Tại bàn', 0.00, NULL, 'Chưa thanh toán', 127000.00, NULL, NULL, 'Đang chuẩn bị', '2026-10-25 10:00:00', '2026-11-23 21:16:45', 3),
(4, 'ORD-20261025-004', 3, 'Tại bàn', 0.00, NULL, 'Đã hủy', 0.00, 'Khách có việc gấp về sớm, chưa ra món', NULL, 'Đã hủy', '2026-10-25 10:20:00', '2026-11-23 21:16:45', 2),
(5, 'ORD-20261025-005', 4, 'Tại bàn', 50000.00, 4, 'Đã thanh toán', 386000.00, NULL, 2, 'Hoàn thành', '2026-10-25 11:45:00', '2026-11-23 21:16:45', 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `order_items`
--

CREATE TABLE `order_items` (
  `order_item_id` int NOT NULL,
  `order_id` int NOT NULL,
  `variant_id` int NOT NULL,
  `quantity` int NOT NULL DEFAULT '1',
  `unit_price` decimal(12,2) NOT NULL,
  `discount_amount` decimal(12,2) DEFAULT '0.00',
  `note` text COLLATE utf8mb4_unicode_ci,
  `subtotal` decimal(12,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `order_items`
--

INSERT INTO `order_items` (`order_item_id`, `order_id`, `variant_id`, `quantity`, `unit_price`, `discount_amount`, `note`, `subtotal`) VALUES
(1, 1, 5, 1, 52000.00, 0.00, 'Ít ngọt 50%', 52000.00),
(2, 1, 2, 1, 39000.00, 0.00, 'Nhiều đá riêng', 39000.00),
(3, 1, 8, 1, 35000.00, 0.00, 'Lắc nhiều bột phô mai', 35000.00),
(4, 2, 3, 2, 25000.00, 0.00, 'Đóng túi mang đi, để đá riêng', 50000.00),
(5, 3, 7, 1, 48000.00, 0.00, 'Thêm trân châu đen', 48000.00),
(6, 3, 9, 1, 55000.00, 0.00, 'Chiên giòn rụm', 55000.00),
(7, 3, 1, 1, 32000.00, 0.00, 'Bình thường', 32000.00),
(8, 4, 4, 1, 45000.00, 0.00, 'Khách hủy trước khi làm', 45000.00),
(9, 5, 5, 2, 52000.00, 0.00, 'Bàn VIP - không lấy sả', 104000.00),
(10, 5, 2, 2, 39000.00, 0.00, 'Đậm vị phin', 78000.00),
(11, 5, 7, 2, 48000.00, 0.00, 'Nhiều trân châu', 96000.00),
(12, 5, 9, 2, 55000.00, 0.00, 'Lắc phô mai đậm đà', 11000.00),
(13, 5, 6, 1, 40000.00, 0.00, 'Ít đường', 40000.00);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `payment_methods`
--

CREATE TABLE `payment_methods` (
  `PAYMENT_ID` int NOT NULL,
  `Name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Status` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT 'Hoạt động',
  `Time` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `payment_methods`
--

INSERT INTO `payment_methods` (`PAYMENT_ID`, `Name`, `Status`, `Time`) VALUES
(1, 'Tiền mặt', 'Hoạt động', '2026-11-23 21:16:45'),
(2, 'Chuyển khoản VietQR', 'Hoạt động', '2026-11-23 21:16:45'),
(3, 'Ví điện tử MoMo', 'Hoạt động', '2026-11-23 21:16:45'),
(4, 'Thẻ Visa / Mastercard', 'Hoạt động', '2026-11-23 21:16:45'),
(5, 'Ví ZaloPay', 'Tạm bảo trì', '2026-11-23 21:16:45');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `promotions`
--

CREATE TABLE `promotions` (
  `promo_id` int NOT NULL,
  `promo_type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `promo_value` decimal(12,2) NOT NULL,
  `combo_id` int NOT NULL,
  `variant_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `promotions`
--

INSERT INTO `promotions` (`promo_id`, `promo_type`, `promo_value`, `combo_id`, `variant_id`) VALUES
(1, 'Giảm giá trực tiếp', 10000.00, 1, 4),
(2, 'Phần trăm', 15.00, 1, 8),
(101, 'DIEU_KIEN', 1.00, 10, 3),
(102, 'GIAM_PHAN_TRAM', 50.00, 10, 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `promotions_combo`
--

CREATE TABLE `promotions_combo` (
  `combo_id` int NOT NULL,
  `combo_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date_start` date DEFAULT (curdate()),
  `date_end` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `promotions_combo`
--

INSERT INTO `promotions_combo` (`combo_id`, `combo_name`, `image_url`, `date_start`, `date_end`) VALUES
(1, 'Combo Trà Chiều Thảnh Thơi', 'assets/images/prod_tra_dao_cam_sa_1795150828656.jpg', '2026-01-01', '2026-12-31'),
(2, 'Croissant Bơ Pháp & Pain au Chocolat', 'assets/images/prod_salted_egg_croissant_1795150828408.jpg', '2026-11-24', '2026-12-01'),
(3, 'Combo Mùa Giáng Sinh (Sắp tới)', NULL, '2026-12-01', '2026-12-25'),
(10, 'Mua Trà Đào Giảm 50% Cà Phê Muối', 'assets/images/prod_ca_phe_sua_da_1795150828661.jpg', '2026-01-01', '2026-12-31');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `staff`
--

CREATE TABLE `staff` (
  `staff_id` int NOT NULL,
  `full_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT 'Đang làm việc',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `staff`
--

INSERT INTO `staff` (`staff_id`, `full_name`, `email`, `password_hash`, `role`, `status`, `created_at`) VALUES
(1, 'Nguyễn Văn Quản Lý', 'admin@restaurant.com', '$2y$10$wT8Kz...hash1', 'Quản lý', 'Đang làm việc', '2026-11-23 21:16:45'),
(2, 'Trần Thị Thu Ngân', 'thungan@restaurant.com', '$2y$10$kL9Qx...hash2', 'Thu ngân', 'Đang làm việc', '2026-11-23 21:16:45'),
(3, 'Lê Hoàng Phục Vụ', 'phucvu1@restaurant.com', '$2y$10$mN3Za...hash3', 'Phục vụ', 'Đang làm việc', '2026-11-23 21:16:45'),
(4, 'Phạm Barista Bếp', 'kitchen@restaurant.com', '$2y$10$zP4Bx...hash4', 'Pha chế', 'Đang làm việc', '2026-11-23 21:16:45'),
(5, 'Đỗ Văn Cũ (Nghỉ việc)', 'nhanviencu@restaurant.com', '$2y$10$qR1Yw...hash5', 'Phục vụ', 'Đã nghỉ việc', '2026-11-23 21:16:45');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tables`
--

CREATE TABLE `tables` (
  `table_id` int NOT NULL,
  `table_number` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `qr_token` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT 'Trống',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `tables`
--

INSERT INTO `tables` (`table_id`, `table_number`, `qr_token`, `status`, `created_at`) VALUES
(1, 'Bàn 01 (Tầng 1)', 'token_qr_b01_active', 'Đang có khách', '2026-11-23 21:16:45'),
(2, 'Bàn 02 (Tầng 1)', 'token_qr_b02_empty', 'Trống', '2026-11-23 21:16:45'),
(3, 'Bàn 03 (Tầng 1)', 'token_qr_b03_empty', 'Trống', '2026-11-23 21:16:45'),
(4, 'Bàn VIP 01 (Tầng 2)', 'token_qr_vip1_reserved', 'Đã đặt trước', '2026-11-23 21:16:45'),
(5, 'Bàn 05 (Ngoài trời)', 'token_qr_b05_broken', 'Đang bảo trì', '2026-11-23 21:16:45'),
(6, 'Quầy Mang Về (Takeaway)', NULL, 'Khả dụng', '2026-11-23 21:16:45');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `voucher`
--

CREATE TABLE `voucher` (
  `voucher_id` int NOT NULL,
  `code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `discount_percent` decimal(5,2) DEFAULT '0.00',
  `expiry_date` datetime NOT NULL,
  `max_discount_amout` decimal(12,2) DEFAULT '0.00',
  `min_order_amount` decimal(12,2) DEFAULT '0.00',
  `status` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT 'Khả dụng',
  `voucher_sp_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `voucher`
--

INSERT INTO `voucher` (`voucher_id`, `code`, `discount_percent`, `expiry_date`, `max_discount_amout`, `min_order_amount`, `status`, `voucher_sp_id`) VALUES
(1, 'CHAOBANMOI', 10.00, '2026-12-31 23:59:59', 30000.00, 80000.00, 'Khả dụng', NULL),
(2, 'GIAM50K', 20.00, '2026-12-31 23:59:59', 50000.00, 200000.00, 'Khả dụng', NULL),
(3, 'HETHAN2023', 50.00, '2023-01-01 00:00:00', 100000.00, 50000.00, 'Hết hạn', NULL),
(4, 'VIPTIEC1TRIEU', 15.00, '2026-12-31 23:59:59', 200000.00, 1000000.00, 'Khả dụng', NULL);

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`category_id`);

--
-- Chỉ mục cho bảng `menu_item`
--
ALTER TABLE `menu_item`
  ADD PRIMARY KEY (`item_id`),
  ADD KEY `fk_item_category` (`category_id`);

--
-- Chỉ mục cho bảng `menu_variant`
--
ALTER TABLE `menu_variant`
  ADD PRIMARY KEY (`variant_id`),
  ADD KEY `fk_variant_item` (`item_id`);

--
-- Chỉ mục cho bảng `order`
--
ALTER TABLE `order`
  ADD PRIMARY KEY (`order_id`),
  ADD UNIQUE KEY `order_code` (`order_code`),
  ADD KEY `fk_order_table` (`table_id`),
  ADD KEY `fk_order_payment` (`payment_method`),
  ADD KEY `fk_order_voucher` (`voucher_id`),
  ADD KEY `fk_order_staff` (`staff_id`);

--
-- Chỉ mục cho bảng `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`order_item_id`),
  ADD KEY `fk_order_items_order` (`order_id`),
  ADD KEY `fk_order_items_variant` (`variant_id`);

--
-- Chỉ mục cho bảng `payment_methods`
--
ALTER TABLE `payment_methods`
  ADD PRIMARY KEY (`PAYMENT_ID`);

--
-- Chỉ mục cho bảng `promotions`
--
ALTER TABLE `promotions`
  ADD PRIMARY KEY (`promo_id`),
  ADD KEY `fk_promo_combo` (`combo_id`),
  ADD KEY `fk_promo_variant` (`variant_id`);

--
-- Chỉ mục cho bảng `promotions_combo`
--
ALTER TABLE `promotions_combo`
  ADD PRIMARY KEY (`combo_id`);

--
-- Chỉ mục cho bảng `staff`
--
ALTER TABLE `staff`
  ADD PRIMARY KEY (`staff_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Chỉ mục cho bảng `tables`
--
ALTER TABLE `tables`
  ADD PRIMARY KEY (`table_id`);

--
-- Chỉ mục cho bảng `voucher`
--
ALTER TABLE `voucher`
  ADD PRIMARY KEY (`voucher_id`),
  ADD UNIQUE KEY `code` (`code`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `category`
--
ALTER TABLE `category`
  MODIFY `category_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT cho bảng `menu_item`
--
ALTER TABLE `menu_item`
  MODIFY `item_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT cho bảng `menu_variant`
--
ALTER TABLE `menu_variant`
  MODIFY `variant_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT cho bảng `order`
--
ALTER TABLE `order`
  MODIFY `order_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT cho bảng `order_items`
--
ALTER TABLE `order_items`
  MODIFY `order_item_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT cho bảng `payment_methods`
--
ALTER TABLE `payment_methods`
  MODIFY `PAYMENT_ID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT cho bảng `promotions`
--
ALTER TABLE `promotions`
  MODIFY `promo_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=103;

--
-- AUTO_INCREMENT cho bảng `promotions_combo`
--
ALTER TABLE `promotions_combo`
  MODIFY `combo_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT cho bảng `staff`
--
ALTER TABLE `staff`
  MODIFY `staff_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT cho bảng `tables`
--
ALTER TABLE `tables`
  MODIFY `table_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT cho bảng `voucher`
--
ALTER TABLE `voucher`
  MODIFY `voucher_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Ràng buộc đối với các bảng kết xuất
--

--
-- Ràng buộc cho bảng `menu_item`
--
ALTER TABLE `menu_item`
  ADD CONSTRAINT `fk_item_category` FOREIGN KEY (`category_id`) REFERENCES `category` (`category_id`) ON DELETE CASCADE;

--
-- Ràng buộc cho bảng `menu_variant`
--
ALTER TABLE `menu_variant`
  ADD CONSTRAINT `fk_variant_item` FOREIGN KEY (`item_id`) REFERENCES `menu_item` (`item_id`) ON DELETE CASCADE;

--
-- Ràng buộc cho bảng `order`
--
ALTER TABLE `order`
  ADD CONSTRAINT `fk_order_payment` FOREIGN KEY (`payment_method`) REFERENCES `payment_methods` (`PAYMENT_ID`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_order_staff` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`staff_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_order_table` FOREIGN KEY (`table_id`) REFERENCES `tables` (`table_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_order_voucher` FOREIGN KEY (`voucher_id`) REFERENCES `voucher` (`voucher_id`) ON DELETE SET NULL;

--
-- Ràng buộc cho bảng `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `fk_order_items_order` FOREIGN KEY (`order_id`) REFERENCES `order` (`order_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_order_items_variant` FOREIGN KEY (`variant_id`) REFERENCES `menu_variant` (`variant_id`) ON DELETE RESTRICT;

--
-- Ràng buộc cho bảng `promotions`
--
ALTER TABLE `promotions`
  ADD CONSTRAINT `fk_promo_combo` FOREIGN KEY (`combo_id`) REFERENCES `promotions_combo` (`combo_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_promo_variant` FOREIGN KEY (`variant_id`) REFERENCES `menu_variant` (`variant_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
