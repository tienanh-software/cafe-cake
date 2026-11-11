<?php
require_once "config/database.php";

class Products extends DB {
    public function __construct() {
        if (method_exists('DB', '__construct')) {
            parent::__construct();
        }
    }

    // 1. Lấy tất cả món (Dùng cho trang chủ index)
    public function getAll() {
        $sql = "SELECT m.*, c.category_name, 
                       MIN(v.price) AS min_price, 
                       MAX(v.price) AS max_price
                FROM menu_items m
                JOIN categories c ON m.category_id = c.category_id
                LEFT JOIN menu_variants v ON m.item_id = v.item_id AND v.status = 'active'
                GROUP BY m.item_id
                ORDER BY m.item_id DESC";
        $stmt = $this->conn->prepare($sql);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    // 2. Lấy chi tiết 1 món theo ID (Dùng cho hàm detail)
    public function getById($itemId) {
        $sql = "SELECT m.*, c.category_name, 
                       MIN(v.price) AS min_price
                FROM menu_items m
                JOIN categories c ON m.category_id = c.category_id
                LEFT JOIN menu_variants v ON m.item_id = v.item_id AND v.status = 'active'
                WHERE m.item_id = :item_id
                GROUP BY m.item_id
                LIMIT 1";
        $stmt = $this->conn->prepare($sql);
        $stmt->execute([':item_id' => $itemId]);
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }

    // 3. Lấy danh sách Size (Variants: S, M, L) của món
    public function getVariantsByItemId($itemId) {
        $sql = "SELECT * FROM menu_variants 
                WHERE item_id = :item_id AND status = 'active'
                ORDER BY price ASC";
        $stmt = $this->conn->prepare($sql);
        $stmt->execute([':item_id' => $itemId]);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    // 4. Lấy danh sách Topping (Thạch, trân châu, kem cheese...)
    public function getToppingsByItemId($itemId) {
        // Kiểm tra xem bảng toppings có tồn tại không để tránh lỗi SQL
        $sql = "SELECT * FROM toppings WHERE status = 'active'";
        try {
            $stmt = $this->conn->prepare($sql);
            $stmt->execute();
            return $stmt->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            // Nếu chưa tạo bảng toppings thì trả về mảng rỗng, web không bị văng lỗi
            return [];
        }
    }

    // 5. Lọc món theo danh mục (Dùng cho hàm filterByCategory)
    public function getByCategory($categoryId) {
        $sql = "SELECT m.*, c.category_name, 
                       MIN(v.price) AS min_price, 
                       MAX(v.price) AS max_price
                FROM menu_items m
                JOIN categories c ON m.category_id = c.category_id
                LEFT JOIN menu_variants v ON m.item_id = v.item_id AND v.status = 'active'
                WHERE m.category_id = :category_id
                GROUP BY m.item_id
                ORDER BY m.item_id DESC";
        $stmt = $this->conn->prepare($sql);
        $stmt->execute([':category_id' => $categoryId]);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    // 6. Tìm kiếm món theo từ khóa (Dùng cho hàm search)
    public function search($keyword) {
        $sql = "SELECT m.*, c.category_name, 
                       MIN(v.price) AS min_price, 
                       MAX(v.price) AS max_price
                FROM menu_items m
                JOIN categories c ON m.category_id = c.category_id
                LEFT JOIN menu_variants v ON m.item_id = v.item_id AND v.status = 'active'
                WHERE m.item_name LIKE :keyword OR m.description LIKE :keyword
                GROUP BY m.item_id
                ORDER BY m.item_id DESC";
        $stmt = $this->conn->prepare($sql);
        $stmt->execute([':keyword' => '%' . $keyword . '%']);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }
}