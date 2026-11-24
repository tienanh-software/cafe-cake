<?php
declare(strict_types=1);

require_once "config/database.php";

class Products extends DB {

    public function __construct() {
        if (method_exists('DB', '__construct')) {
            parent::__construct();
        }
    }

    public function getAll(bool $onlyActive = true): array {
        $statusCondition = $onlyActive 
            ? "WHERE mi.status = 'Còn món' AND c.status = 'Hiển thị'" 
            : "";

        $sql = "SELECT 
                    mi.item_id,
                    mi.item_name,
                    mi.description,
                    mi.image_url,
                    mi.options,
                    mi.status AS item_status,
                    c.category_id,
                    c.category_name,
                    MIN(mv.price - mv.discount) AS min_price,
                    MAX(mv.price - mv.discount) AS max_price,
                    JSON_ARRAYAGG(
                        JSON_OBJECT(
                            'variant_id', mv.variant_id,
                            'variant_name', mv.variant_name,
                            'original_price', CAST(mv.price AS DOUBLE),
                            'discount', CAST(mv.discount AS DOUBLE),
                            'final_price', CAST(mv.price - mv.discount AS DOUBLE),
                            'status', mv.status
                        )
                    ) AS variants_json
                FROM `MENU_ITEM` mi
                INNER JOIN `CATEGORY` c ON mi.category_id = c.category_id
                INNER JOIN `MENU_VARIANT` mv ON mi.item_id = mv.item_id
                {$statusCondition}
                GROUP BY 
                    mi.item_id, mi.item_name, mi.description, 
                    mi.image_url, mi.options, mi.status, 
                    c.category_id, c.category_name
                ORDER BY mi.item_id DESC";

        $stmt = $this->conn->prepare($sql);
        $stmt->execute();
        $items = $stmt->fetchAll(PDO::FETCH_ASSOC);

        return array_map([$this, 'formatItemResponse'], $items);
    }
/**
     * Xác thực QR Token và lấy thông tin bàn ăn
     */
    public function getTableByToken(string $token): ?array {
        $sql = "SELECT table_id, table_number, status 
                FROM `TABLES` 
                WHERE qr_token = :token 
                LIMIT 1";
        $stmt = $this->conn->prepare($sql);
        $stmt->execute([':token' => $token]);
        $table = $stmt->fetch(PDO::FETCH_ASSOC);
        return $table ?: null;
    }

    /**
     * Lấy danh sách toàn bộ danh mục đang hoạt động
     */
    public function getCategories(bool $onlyActive = true): array {
        $statusCondition = $onlyActive ? "WHERE status = 'Hiển thị'" : "";
        $sql = "SELECT category_id, category_name, description, status 
                FROM `CATEGORY` 
                {$statusCondition}
                ORDER BY category_id ASC";
        $stmt = $this->conn->prepare($sql);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    /**
     * 2. Lấy thông tin chi tiết của 1 món theo ID
     */
    public function getById(int $itemId): ?array {
        $sql = "SELECT 
                    mi.item_id,
                    mi.item_name,
                    mi.description,
                    mi.image_url,
                    mi.options,
                    mi.status AS item_status,
                    c.category_id,
                    c.category_name,
                    MIN(mv.price - mv.discount) AS min_price,
                    MAX(mv.price - mv.discount) AS max_price
                FROM `MENU_ITEM` mi
                INNER JOIN `CATEGORY` c ON mi.category_id = c.category_id
                LEFT JOIN `MENU_VARIANT` mv ON mi.item_id = mv.item_id AND mv.status = 'Đang bán'
                WHERE mi.item_id = :item_id
                GROUP BY 
                    mi.item_id, mi.item_name, mi.description, 
                    mi.image_url, mi.options, mi.status, 
                    c.category_id, c.category_name
                LIMIT 1";

        $stmt = $this->conn->prepare($sql);
        $stmt->execute([':item_id' => $itemId]);
        $result = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$result) {
            return null;
        }

        // Tự động load luôn biến thể và các combo đang áp dụng cho món này
        $result['variants'] = $this->getVariantsByItemId($itemId);
        $result['active_combos'] = $this->getActiveCombosByItemId($itemId);

        return $result;
    }

    /**
     * 3. Lấy danh sách các biến thể (Size/Loại) của 1 món
     */
    public function getVariantsByItemId(int $itemId, bool $onlyAvailable = true): array {
        $statusClause = $onlyAvailable ? "AND status = 'Đang bán'" : "";

        $sql = "SELECT 
                    variant_id,
                    variant_name,
                    price AS original_price,
                    discount,
                    (price - discount) AS final_price,
                    status,
                    item_id
                FROM `MENU_VARIANT`
                WHERE item_id = :item_id {$statusClause}
                ORDER BY price ASC";

        $stmt = $this->conn->prepare($sql);
        $stmt->execute([':item_id' => $itemId]);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function getByCategory(int $categoryId): array {
        $sql = "SELECT 
                    mi.item_id,
                    mi.item_name,
                    mi.description,
                    mi.image_url,
                    mi.options,
                    mi.status AS item_status,
                    c.category_id,
                    c.category_name,
                    MIN(mv.price - mv.discount) AS min_price,
                    MAX(mv.price - mv.discount) AS max_price
                FROM `MENU_ITEM` mi
                INNER JOIN `CATEGORY` c ON mi.category_id = c.category_id
                INNER JOIN `MENU_VARIANT` mv ON mi.item_id = mv.item_id
                WHERE mi.category_id = :category_id 
                  AND mi.status = 'Còn món'
                  AND mv.status = 'Đang bán'
                GROUP BY 
                    mi.item_id, mi.item_name, mi.description, 
                    mi.image_url, mi.options, mi.status, 
                    c.category_id, c.category_name
                ORDER BY mi.item_id DESC";

        $stmt = $this->conn->prepare($sql);
        $stmt->execute([':category_id' => $categoryId]);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }
/**
     * Lấy các món đang có giảm giá trực tiếp trên Size (discount > 0)
     */
    public function getDiscountedProducts(int $limit = 8): array {
        $sql = "SELECT 
                    mi.item_id, mi.item_name, mi.description, mi.image_url, mi.options,
                    c.category_name,
                    MIN(mv.price - mv.discount) AS min_price,
                    MAX(mv.price - mv.discount) AS max_price,
                    MAX(mv.price) AS original_max_price,
                    MAX(mv.discount) AS max_discount
                FROM `MENU_ITEM` mi
                INNER JOIN `CATEGORY` c ON mi.category_id = c.category_id
                INNER JOIN `MENU_VARIANT` mv ON mi.item_id = mv.item_id
                WHERE mi.status = 'Còn món' AND mv.status = 'Đang bán' AND mv.discount > 0
                GROUP BY mi.item_id, mi.item_name, mi.description, mi.image_url, mi.options, c.category_name
                ORDER BY max_discount DESC
                LIMIT :limit";

        $stmt = $this->conn->prepare($sql);
        $stmt->bindValue(':limit', $limit, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }
/**
     * 4. Lấy danh sách Topping (Lấy từ MENU_ITEM thuộc danh mục có tên 'Topping')
     */
    public function getToppingsByItemId(int $itemId = 0): array {
        $sql = "SELECT 
                    mi.item_id AS topping_id,
                    mi.item_name AS topping_name,
                    mv.variant_id,
                    mv.price,
                    (mv.price - mv.discount) AS final_price,
                    mi.status
                FROM `MENU_ITEM` mi
                INNER JOIN `CATEGORY` c ON mi.category_id = c.category_id
                INNER JOIN `MENU_VARIANT` mv ON mi.item_id = mv.item_id
                WHERE (c.category_name LIKE '%Topping%' OR c.category_name LIKE '%topping%')
                  AND mi.status = 'Còn món'
                  AND mv.status = 'Đang bán'
                ORDER BY mv.price ASC";

        $stmt = $this->conn->prepare($sql);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }
    /**
     * Lấy món bán chạy nhất tính theo số lượng bán thực tế trong ORDER_ITEMS
     */
    public function getBestSellers(int $limit = 8): array {
        $sql = "SELECT 
                    mi.item_id, mi.item_name, mi.description, mi.image_url, mi.options,
                    c.category_name,
                    MIN(mv.price - mv.discount) AS min_price,
                    MAX(mv.price - mv.discount) AS max_price,
                    IFNULL(SUM(oi.quantity), 0) AS total_sold
                FROM `MENU_ITEM` mi
                INNER JOIN `CATEGORY` c ON mi.category_id = c.category_id
                INNER JOIN `MENU_VARIANT` mv ON mi.item_id = mv.item_id
                LEFT JOIN `ORDER_ITEMS` oi ON mv.variant_id = oi.variant_id
                WHERE mi.status = 'Còn món' AND mv.status = 'Đang bán'
                GROUP BY mi.item_id, mi.item_name, mi.description, mi.image_url, mi.options, c.category_name
                ORDER BY total_sold DESC, mi.item_id DESC
                LIMIT :limit";

        $stmt = $this->conn->prepare($sql);
        $stmt->bindValue(':limit', $limit, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }
    public function search(string $keyword): array {
        $sql = "SELECT 
                    mi.item_id,
                    mi.item_name,
                    mi.description,
                    mi.image_url,
                    mi.options,
                    c.category_name,
                    MIN(mv.price - mv.discount) AS min_price,
                    MAX(mv.price - mv.discount) AS max_price
                FROM `MENU_ITEM` mi
                INNER JOIN `CATEGORY` c ON mi.category_id = c.category_id
                LEFT JOIN `MENU_VARIANT` mv ON mi.item_id = mv.item_id AND mv.status = 'Đang bán'
                WHERE (mi.item_name LIKE :keyword OR mi.description LIKE :keyword)
                  AND mi.status = 'Còn món'
                GROUP BY 
                    mi.item_id, mi.item_name, mi.description, 
                    mi.image_url, mi.options, c.category_name
                ORDER BY mi.item_id DESC";

        $stmt = $this->conn->prepare($sql);
        $stmt->execute([':keyword' => '%' . trim($keyword) . '%']);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    /**
     * 6. Lấy các chương trình Combo/Khuyến mãi đang có hiệu lực theo món
     */
    public function getActiveCombosByItemId(int $itemId): array {
        $sql = "SELECT 
                    pc.combo_id,
                    pc.combo_name,
                    pc.date_start,
                    pc.date_end,
                    mv.variant_id,
                    mv.variant_name,
                    mv.price AS original_price,
                    p.promo_type,
                    p.promo_value,
                    CASE 
                        WHEN p.promo_type = 'Giảm giá trực tiếp' THEN GREATEST(0, mv.price - p.promo_value)
                        WHEN p.promo_type IN ('Phần trăm', 'GIAM_PHAN_TRAM') THEN (mv.price * (1 - p.promo_value / 100))
                        ELSE mv.price 
                    END AS promo_price
                FROM `PROMOTIONS_COMBO` pc
                INNER JOIN `PROMOTIONS` p ON pc.combo_id = p.combo_id
                INNER JOIN `MENU_VARIANT` mv ON p.variant_id = mv.variant_id
                INNER JOIN `MENU_ITEM` mi ON mv.item_id = mi.item_id
                WHERE mi.item_id = :item_id
                  AND CURRENT_DATE >= pc.date_start 
                  AND (pc.date_end IS NULL OR CURRENT_DATE <= pc.date_end)
                ORDER BY pc.combo_id DESC";

        $stmt = $this->conn->prepare($sql);
        $stmt->execute([':item_id' => $itemId]);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    /**
     * 7. Tìm kiếm combo theo tên món (Gợi ý Upsell cho khách)
     */
    public function searchCombosByItemName(string $itemName): array {
        $sql = "SELECT DISTINCT
                    pc.combo_id,
                    pc.combo_name,
                    pc.date_start,
                    pc.date_end,
                    mi.item_name,
                    mv.variant_name
                FROM `PROMOTIONS_COMBO` pc
                INNER JOIN `PROMOTIONS` p ON pc.combo_id = p.combo_id
                INNER JOIN `MENU_VARIANT` mv ON p.variant_id = mv.variant_id
                INNER JOIN `MENU_ITEM` mi ON mv.item_id = mi.item_id
                WHERE mi.item_name LIKE :item_name
                  AND CURRENT_DATE >= pc.date_start 
                  AND (pc.date_end IS NULL OR CURRENT_DATE <= pc.date_end)";

        $stmt = $this->conn->prepare($sql);
        $stmt->execute([':item_name' => '%' . trim($itemName) . '%']);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }


    /**
     * Lấy danh sách combo đang còn hiệu lực theo ngày hiện tại
     */
    public function getActiveCombos(): array {
        $sql = "SELECT `combo_id`, `combo_name`, `date_start`, `date_end`, `image_url`
                FROM `promotions_combo`
                WHERE CURDATE() BETWEEN `date_start` AND `date_end`
                ORDER BY `combo_id` ASC";
        $stmt = $this->conn->prepare($sql);
        $stmt->execute();

        return $stmt->fetchAll(PDO::FETCH_ASSOC) ?: [];
    }

    /**
     * Helper: Chuẩn hóa dữ liệu trả về, giải mã JSON variants
     */
    private function formatItemResponse(array $item): array {
        if (!empty($item['variants_json'])) {
            $item['variants'] = json_decode($item['variants_json'], true);
            unset($item['variants_json']);
        } else {
            $item['variants'] = [];
        }

        // Tách chuỗi options ("Ít đá, Nhiều đường") thành mảng để FE dễ render thẻ select
        if (!empty($item['options'])) {
            $item['options_list'] = array_map('trim', explode(',', $item['options']));
        } else {
            $item['options_list'] = [];
        }

        return $item;
    }
}