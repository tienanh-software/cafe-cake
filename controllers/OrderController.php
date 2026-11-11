<?php
require_once "models/Orders.php";

class OrderController {
    private $orderModel;

    public function __construct() {
        if (session_status() === PHP_SESSION_NONE) {
            session_start();
        }
        $this->orderModel = new Orders();
    }

    // =========================================================================
    // 1. DÀNH CHO KHÁCH HÀNG (Đặt món, Thanh toán, Theo dõi đơn)
    // =========================================================================

    // Màn hình trang Giỏ hàng / Thanh toán
    public function checkout() {
        if (empty($_SESSION['cart'])) {
            header("Location: index.php");
            exit;
        }

        // Nhận diện mã bàn từ URL (nếu khách quét QR bàn) hoặc lấy mặc định
        $tableId = isset($_GET['table']) ? (int)$_GET['table'] : ($_SESSION['current_table_id'] ?? null);
        $orderType = !empty($tableId) ? 'dine_in' : 'takeaway';

        $cart = $_SESSION['cart'];
        $totalAmount = 0;
        foreach ($cart as $item) {
            $totalAmount += $item['price'] * $item['quantity'];
        }

        if (file_exists("views/checkout.php")) {
            require_once "views/checkout.php";
        } else {
            // Nếu chưa làm trang checkout riêng thì render tạm trang giỏ hàng
            require_once "views/home.php";
        }
    }

    // Xử lý khi khách bấm nút [ ĐẶT ĐƠN ]
    public function placeOrder() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            header("Location: index.php");
            exit;
        }

        if (empty($_SESSION['cart'])) {
            header("Location: index.php");
            exit;
        }

        // Thu thập thông tin từ Form đặt món
        $orderType     = $_POST['order_type'] ?? 'takeaway';
        $tableId       = !empty($_POST['table_id']) ? (int)$_POST['table_id'] : null;
        $customerName  = trim($_POST['customer_name'] ?? 'Khách hàng');
        $customerPhone = trim($_POST['customer_phone'] ?? '');
        $note          = trim($_POST['note'] ?? '');
        $paymentMethod = $_POST['payment_method'] ?? 'cash'; // 'cash' hoặc 'bank_transfer'

        // Tính tổng tiền an toàn trên máy chủ
        $totalPrice = 0;
        foreach ($_SESSION['cart'] as $item) {
            $totalPrice += $item['price'] * $item['quantity'];
        }

        $orderData = [
            'order_type'     => $orderType,
            'table_id'       => $tableId,
            'customer_name'  => $customerName,
            'customer_phone' => $customerPhone,
            'note'           => $note,
            'payment_method' => $paymentMethod,
            'total_price'    => $totalPrice
        ];

        // Gọi Model xử lý lưu đơn hàng vào Database
        $result = $this->orderModel->createOrder($orderData, $_SESSION['cart']);

        if ($result['status']) {
            // Xóa giỏ hàng sau khi đặt thành công
            unset($_SESSION['cart']);

            // Chuyển hướng sang trang theo dõi đơn hàng
            header("Location: index.php?action=tracking&code=" . $result['order_code']);
            exit;
        } else {
            die("Lỗi đặt món: " . $result['message']);
        }
    }

    // Trang Khách kiểm tra đơn hàng (views/tracking.php)
    public function tracking() {
        $orderCode = isset($_GET['code']) ? trim($_GET['code']) : '';
        if (empty($orderCode)) {
            header("Location: index.php");
            exit;
        }

        $order = $this->orderModel->getOrderStatusByCode($orderCode);
        if (!$order) {
            header("Location: index.php");
            exit;
        }

        require_once "views/tracking.php";
    }

    // API JSON để trang tracking tự động kiểm tra trạng thái mỗi 3 giây
    public function apiTrackingStatus() {
        header('Content-Type: application/json');
        $orderCode = $_GET['code'] ?? '';
        $order = $this->orderModel->getOrderStatusByCode($orderCode);

        echo json_encode([
            'success' => $order ? true : false,
            'data'    => $order
        ]);
        exit;
    }


    // =========================================================================
    // 2. DÀNH CHO QUẦY PHA CHẾ (views/barista/kds.php)
    // =========================================================================

    // Màn hình KDS cho Barista
    public function kds() {
        $rawOrders = $this->orderModel->getKdsActiveOrders();

        // Gắn danh sách món vào từng đơn để Barista nhìn công thức làm
        $activeOrders = [];
        foreach ($rawOrders as $ord) {
            $ord['items'] = $this->orderModel->getItemsByOrderId($ord['id']);
            $activeOrders[] = $ord;
        }

        require_once "views/barista/kds.php";
    }

    // Barista bấm nút [ ĐÃ XONG MÓN ]
    public function markReady() {
        $orderId = isset($_POST['order_id']) ? (int)$_POST['order_id'] : 0;
        if ($orderId > 0) {
            $this->orderModel->markOrderReady($orderId);
        }
        header("Location: index.php?action=kds");
        exit;
    }


    // =========================================================================
    // 3. DÀNH CHO ADMIN / THU NGÂN (views/admin/tables.php)
    // =========================================================================

    // Màn hình Sơ đồ bàn & Báo cáo doanh thu
    public function floorMap() {
        $tables = $this->orderModel->getFloorMap();
        $dailyStats = $this->orderModel->getTodayRevenue();

        require_once "views/admin/tables.php";
    }

    // Thu ngân xác nhận thu tiền mặt cho đơn Mang Đi (để đẩy vào quầy Barista)
    public function confirmTakeawayPayment() {
        $orderId = isset($_POST['order_id']) ? (int)$_POST['order_id'] : 0;
        if ($orderId > 0) {
            $this->orderModel->confirmTakeawayCash($orderId);
        }
        header("Location: index.php?action=floorMap");
        exit;
    }

    // Khách rời quán -> Thu ngân/Nhân viên bấm [ TRẢ BÀN ]
    public function clearTable() {
        $orderId = isset($_POST['order_id']) ? (int)$_POST['order_id'] : 0;
        $tableId = isset($_POST['table_id']) ? (int)$_POST['table_id'] : 0;

        if ($orderId > 0 && $tableId > 0) {
            $this->orderModel->completeAndClearTable($orderId, $tableId);
        }
        header("Location: index.php?action=floorMap");
        exit;
    }
}
?>