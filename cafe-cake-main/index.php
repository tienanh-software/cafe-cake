<?php
require_once "controllers/ProductController.php";
require_once "controllers/OrderController.php";

$action = $_GET['action'] ?? 'home';

$productCtrl = new ProductController();
$orderCtrl   = new OrderController();

switch ($action) {
    case 'home':
        $productCtrl->index();
        break;
    case 'detail':
        $productCtrl->detail();
        break;
    case 'search':
        $productCtrl->search();
        break;
    case 'filter':
        $productCtrl->filterByCategory();
        break;

    case 'order':
    case 'checkout':
        $orderCtrl->checkout();
        break;
    case 'placeOrder':
        $orderCtrl->placeOrder();
        break;
    case 'tracking':
        $orderCtrl->tracking();
        break;
    case 'apiTrackingStatus':
        $orderCtrl->apiTrackingStatus();
        break;

    // Quầy Pha Chế
    case 'kds':
        $orderCtrl->kds();
        break;
    case 'markReady':
        $orderCtrl->markReady();
        break;

    // Admin & Sơ Đồ Bàn
    case 'floorMap':
        $orderCtrl->floorMap();
        break;
    case 'clearTable':
        $orderCtrl->clearTable();
        break;
    case 'confirmTakeawayPayment':
        $orderCtrl->confirmTakeawayPayment();
        break;

    default:
        echo "<div style='text-align: center; margin-top: 80px; font-family: sans-serif;'>";
        echo "<h1 style='font-size: 60px; color: #8B5A2B; margin-bottom: 10px;'>404</h1>";
        echo "<h2 style='color: #333;'>Trang bạn tìm kiếm không tồn tại!</h2>";
        echo "<p style='margin-top: 20px;'><a href='index.php' style='text-decoration: none; background: #8B5A2B; color: white; padding: 10px 20px; border-radius: 5px; font-weight: bold;'>Quay lại trang chủ</a></p>";
        echo "</div>";
        break;
}
?>