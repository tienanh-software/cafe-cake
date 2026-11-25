<?php
require_once "config/database.php";

class Orders extends DB {
    public function __construct() {
        if (method_exists('DB', '__construct')) {
            parent::__construct();
        }
    }

    // =========================================================================
    // 1. DÀNH CHO KHÁCH HÀNG (Tạo đơn & Live Tracking)
    // =========================================================================

    /**
     * Tìm đơn hàng đang hoạt động (chưa hoàn thành) của bàn
     */
    public function getActiveOrderByTable(int $tableId): ?array {
        $sql = "SELECT order_id, order_code, total_amount, status, created_at 
                FROM `ORDER` 
                WHERE table_id = :table_id 
                  AND status IN ('Chờ xử lý', 'Đang chuẩn bị')
                ORDER BY order_id DESC 
                LIMIT 1";

        $stmt = $this->conn->prepare($sql);
        $stmt->execute([':table_id' => $tableId]);
        $order = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$order) {
            return null;
        }

        // Lấy chi tiết các món trong đơn này kèm tiến độ
        $sqlItems = "SELECT oi.*, mi.item_name, mv.variant_name 
                     FROM `ORDER_ITEMS` oi
                     JOIN `MENU_VARIANT` mv ON oi.variant_id = mv.variant_id
                     JOIN `MENU_ITEM` mi ON mv.item_id = mi.item_id
                     WHERE oi.order_id = :order_id";
        $stmtItems = $this->conn->prepare($sqlItems);
        $stmtItems->execute([':order_id' => $order['order_id']]);
        $order['items'] = $stmtItems->fetchAll(PDO::FETCH_ASSOC);

        return $order;
    }
    /**
     * Tạo đơn hàng với Transaction an toàn 100%
     */
    public function createOrder($orderData, $cartItems) {
        try {
            $this->conn->beginTransaction();

            // 1. Tính số thứ tự nhận món (pickup_number) nếu là MANG ĐI
            $pickupNumber = 0;
            if ($orderData['order_type'] === 'takeaway') {
                $sqlPickup = "SELECT COALESCE(MAX(pickup_number), 0) + 1 AS next_num 
                              FROM orders 
                              WHERE order_type = 'takeaway' AND DATE(created_at) = CURDATE()";
                $stmtPickup = $this->conn->prepare($sqlPickup);
                $stmtPickup->execute();
                $pickupNumber = (int)$stmtPickup->fetch(PDO::FETCH_ASSOC)['next_num'];
            }

            // 2. Tạo mã đơn hàng duy nhất (Ví dụ: ORD-241025-839)
            $orderCode = 'ORD-' . date('ymd') . '-' . rand(100, 999);

            // 3. Phân luồng trạng thái theo logic vận hành
            // Mặc định: Chờ duyệt / Chờ thanh toán
            $orderStatus = 'pending';
            $paymentStatus = 'unpaid';

            // Nếu ăn tại bàn mà chọn tiền mặt -> Cho phép làm luôn (trả sau)
            if ($orderData['order_type'] === 'dine_in' && $orderData['payment_method'] === 'cash') {
                $orderStatus = 'preparing'; 
            }

            // 4. Insert vào bảng orders
            $sqlOrder = "INSERT INTO orders (
                            order_code, pickup_number, order_type, table_id, 
                            customer_name, customer_phone, note, total_price, 
                            payment_method, payment_status, order_status
                         ) VALUES (
                            :order_code, :pickup_number, :order_type, :table_id, 
                            :customer_name, :customer_phone, :note, :total_price, 
                            :payment_method, :payment_status, :order_status
                         )";
            $stmtOrder = $this->conn->prepare($sqlOrder);
            $stmtOrder->execute([
                ':order_code'     => $orderCode,
                ':pickup_number'  => $pickupNumber,
                ':order_type'     => $orderData['order_type'],
                ':table_id'       => $orderData['table_id'] ?? null,
                ':customer_name'  => $orderData['customer_name'] ?? null,
                ':customer_phone' => $orderData['customer_phone'] ?? null,
                ':note'           => $orderData['note'] ?? null,
                ':total_price'    => $orderData['total_price'],
                ':payment_method' => $orderData['payment_method'],
                ':payment_status' => $paymentStatus,
                ':order_status'   => $orderStatus
            ]);

            $orderId = $this->conn->lastInsertId();

            // 5. Insert danh sách món trong giỏ hàng vào order_items
            $sqlItem = "INSERT INTO order_items (order_id, item_id, quantity, price, options_note, item_total) 
                        VALUES (:order_id, :item_id, :quantity, :price, :options_note, :item_total)";
            $stmtItem = $this->conn->prepare($sqlItem);

            foreach ($cartItems as $item) {
                $stmtItem->execute([
                    ':order_id'      => $orderId,
                    ':item_id'       => $item['item_id'],
                    ':quantity'      => $item['quantity'],
                    ':price'         => $item['price'],
                    ':options_note'  => $item['options_note'] ?? '', // vd: "Size L, 50% Đường"
                    ':item_total'    => $item['price'] * $item['quantity']
                ]);
            }

            // 6. Nếu là khách Ăn Tại Chỗ -> Đổi trạng thái bàn thành Occupied (Có khách)
            if ($orderData['order_type'] === 'dine_in' && !empty($orderData['table_id'])) {
                $sqlTable = "UPDATE tables SET status = 'occupied' WHERE id = :table_id";
                $stmtTable = $this->conn->prepare($sqlTable);
                $stmtTable->execute([':table_id' => $orderData['table_id']]);
            }

            $this->conn->commit();
            return ['status' => true, 'order_code' => $orderCode, 'order_id' => $orderId];

        } catch (Exception $e) {
            $this->conn->rollBack();
            return ['status' => false, 'message' => $e->getMessage()];
        }
    }

    // Khách dùng để theo dõi tiến độ đơn hàng (Live Tracker polling)
    public function getOrderStatusByCode($orderCode) {
        $sql = "SELECT order_code, pickup_number, order_type, table_id, 
                       order_status, payment_status, total_price, created_at
                FROM orders 
                WHERE order_code = :order_code LIMIT 1";
        $stmt = $this->conn->prepare($sql);
        $stmt->execute([':order_code' => $orderCode]);
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }


    // =========================================================================
    // 2. DÀNH CHO PHA CHẾ (Màn hình KDS Kitchen Display)
    // =========================================================================

    // Lấy danh sách các đơn đang cần pha chế (Sắp xếp món cũ làm trước - FIFO)
    public function getKdsActiveOrders() {
        $sql = "SELECT o.id, o.order_code, o.pickup_number, o.order_type, 
                       t.table_number, o.note, o.order_status, o.created_at,
                       TIMESTAMPDIFF(MINUTE, o.created_at, NOW()) AS waiting_minutes
                FROM orders o
                LEFT JOIN tables t ON o.table_id = t.id
                WHERE o.order_status IN ('confirmed', 'preparing')
                  AND (o.payment_status = 'paid' OR o.order_type = 'dine_in')
                ORDER BY o.created_at ASC";
        $stmt = $this->conn->prepare($sql);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    // Lấy danh sách món chi tiết của 1 đơn hàng để Barista nhìn công thức pha
    public function getItemsByOrderId($orderId) {
        $sql = "SELECT m.name AS product_name, oi.quantity, oi.options_note 
                FROM order_items oi
                JOIN menu_items m ON oi.item_id = m.item_id
                WHERE oi.order_id = :order_id";
        $stmt = $this->conn->prepare($sql);
        $stmt->execute([':order_id' => $orderId]);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    // Barista bấm "Đã làm xong món"
    public function markOrderReady($orderId) {
        $sql = "UPDATE orders SET order_status = 'ready' WHERE id = :order_id";
        $stmt = $this->conn->prepare($sql);
        return $stmt->execute([':order_id' => $orderId]);
    }


    // =========================================================================
    // 3. DÀNH CHO THU NGÂN / ADMIN (Sơ đồ bàn, Thu tiền, Trả bàn)
    // =========================================================================

    // Màn hình sơ đồ bàn (Floor Map) xem trạng thái bàn trống/có khách
    public function getFloorMap() {
        $sql = "SELECT t.id AS table_id, t.table_number, t.status AS table_status,
                       o.id AS order_id, o.order_code, o.total_price, o.payment_status,
                       TIMESTAMPDIFF(MINUTE, o.created_at, NOW()) AS minutes_seated
                FROM tables t
                LEFT JOIN orders o ON t.id = o.table_id 
                     AND o.order_status NOT IN ('completed', 'cancelled')
                ORDER BY t.table_number ASC";
        $stmt = $this->conn->prepare($sql);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    // Thu tiền mặt đơn Mang Đi -> Đẩy đơn vào màn hình Pha chế
    public function confirmTakeawayCash($orderId) {
        $sql = "UPDATE orders 
                SET payment_status = 'paid', order_status = 'preparing' 
                WHERE id = :order_id AND order_type = 'takeaway'";
        $stmt = $this->conn->prepare($sql);
        return $stmt->execute([':order_id' => $orderId]);
    }

    // Thu tiền khách ăn tại bàn xong + TRẢ BÀN VỀ TRỐNG
    public function completeAndClearTable($orderId, $tableId) {
        try {
            $this->conn->beginTransaction();

            // 1. Hoàn tất đơn hàng
            $sql1 = "UPDATE orders SET payment_status = 'paid', order_status = 'completed' WHERE id = :order_id";
            $stmt1 = $this->conn->prepare($sql1);
            $stmt1->execute([':order_id' => $orderId]);

            // 2. Trả bàn về trạng thái Trống (Empty)
            $sql2 = "UPDATE tables SET status = 'empty' WHERE id = :table_id";
            $stmt2 = $this->conn->prepare($sql2);
            $stmt2->execute([':table_id' => $tableId]);

            $this->conn->commit();
            return true;
        } catch (Exception $e) {
            $this->conn->rollBack();
            return false;
        }
    }

    // Báo cáo doanh thu hôm nay
    public function getTodayRevenue() {
        $sql = "SELECT COUNT(id) AS total_orders, COALESCE(SUM(total_price), 0) AS total_revenue 
                FROM orders 
                WHERE payment_status = 'paid' AND DATE(created_at) = CURDATE()";
        $stmt = $this->conn->prepare($sql);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
}