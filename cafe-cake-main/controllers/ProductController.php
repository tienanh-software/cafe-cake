<?php
declare(strict_types=1);

require_once "models/Products.php";

class ProductController {
    private Products $productModel;

    public function __construct() {
        $this->productModel = new Products();
    }
    /**
     * Tạo danh sách Category Chips cho thanh điều hướng danh mục
     */
    private function buildCategoryChips(int $activeCategoryId = 0): array {
        $rawCategories = $this->productModel->getCategories();
        $categoryChips = [
            [
                'href'   => 'index.php',
                'active' => ($activeCategoryId === 0),
                'label'  => 'Tất cả',
            ]
        ];

        foreach ($rawCategories as $cat) {
            $id = (int)($cat['category_id'] ?? $cat['id'] ?? 0);
            $name = $cat['category_name'] ?? $cat['name'] ?? '';
            $categoryChips[] = [
                'href'   => 'index.php?action=filter&category_id=' . $id,
                'active' => ($activeCategoryId === $id),
                'label'  => $name,
            ];
        }

        return $categoryChips;
    }

    /**
     * Chuẩn hóa dữ liệu tương thích ngược cho cả Views cũ và mới
     */
    private function mapProductData(array $item): array {
        $name = $item['item_name'] ?? $item['name'] ?? 'Món chưa đặt tên';
        $image = !empty($item['image_url']) 
            ? $item['image_url'] 
            : (!empty($item['image']) 
                ? $item['image'] 
                : 'https://images.unsplash.com/photo-1541167760496-1628856ab772?q=80&w=400&auto=format&fit=crop');

        $minPrice = (float)($item['min_price'] ?? $item['price'] ?? 0);
        $maxPrice = (float)($item['max_price'] ?? $minPrice);

        return [
            // Cặp ID
            'id'                 => (int)($item['item_id'] ?? $item['id'] ?? 0),
            'item_id'            => (int)($item['item_id'] ?? $item['id'] ?? 0),
            
            // Cặp Tên
            'name'               => $name,
            'item_name'          => $name,
            
            // Cặp Giá
            'price'              => $minPrice,
            'min_price'          => $minPrice,
            'max_price'          => $maxPrice,
            'original_max_price' => (float)($item['original_max_price'] ?? $maxPrice),
            'max_discount'       => (float)($item['max_discount'] ?? 0),
            
            // Hình ảnh & Thông tin chi tiết
            'image'              => $image,
            'image_url'          => $image,
            'description'        => $item['description'] ?? '',
            'options'            => $item['options'] ?? '',
            'options_list'       => $item['options_list'] ?? [],
            'category_name'      => $item['category_name'] ?? 'Babo Menu',
            
            // Biến thể & Khuyến mãi (nếu có)
            'variants'           => $item['variants'] ?? [],
            'active_combos'      => $item['active_combos'] ?? []
        ];
    }

    /**
     * Trang chủ hiển thị: Món Mới, Khuyến Mãi và Bán Chạy Nhất từ Database
     */
 public function index(): void {
        if (session_status() === PHP_SESSION_NONE) {
            session_start();
        }

        // 1. TRƯỜNG HỢP QUÉT QR TẠI BÀN (Có mã Token an toàn)
        if (isset($_GET['token'])) {
            $token = trim($_GET['token']);
            // Truy vấn kiểm tra token có tồn tại trong bảng TABLES không
            $table = $this->productModel->getTableByToken($token);

            if ($table) {
                $_SESSION['order_context'] = [
                    'type'         => 'Tại bàn',
                    'table_id'     => $table['table_id'],
                    'table_number' => $table['table_number']
                ];
            }
        } 
        // 2. TRƯỜNG HỢP QUÉT QR MANG VỀ (Takeaway)
        elseif (isset($_GET['mode']) && $_GET['mode'] === 'takeaway') {
            $_SESSION['order_context'] = [
                'type'         => 'Mang về',
                'table_id'     => null,
                'table_number' => 'Mang về (Take-away)'
            ];
        }

        // 3. MẶC ĐỊNH (Nếu vào trực tiếp mà chưa có Session -> Gán tạm Bàn 01 để test)
        if (!isset($_SESSION['order_context'])) {
            $_SESSION['order_context'] = [
                'type'         => 'Tại bàn',
                'table_id'     => 1,
                'table_number' => 'Bàn 01 (Demo)'
            ];
        }

        // Lấy danh sách món hiển thị như bình thường...
        $rawAll = $this->productModel->getAll();
        $menuItems = array_map([$this, 'mapProductData'], $rawAll);
        $newProducts = array_map([$this, 'mapProductData'], array_slice($rawAll, 0, 8));
        $promoProducts = array_map([$this, 'mapProductData'], $this->productModel->getDiscountedProducts(6));
        $bestsellers = array_map([$this, 'mapProductData'], $this->productModel->getBestSellers(4));
        $categoryChips = $this->buildCategoryChips(0);
        $activeCombos  = $this->productModel->getActiveCombos();

        require_once "views/home.php";
    }

    /**
     * Xem chi tiết món ăn (Kèm danh sách biến thể Size, Tùy chọn)
     */
    public function detail(): void {
        $id = isset($_GET['id']) ? (int)$_GET['id'] : 0;
        if ($id <= 0) {
            header("Location: index.php");
            exit;
        }

        $rawItem = $this->productModel->getById($id);
        if (!$rawItem) {
            header("Location: index.php");
            exit;
        }

        $product = $this->mapProductData($rawItem);
        $variants = !empty($product['variants']) 
            ? $product['variants'] 
            : $this->productModel->getVariantsByItemId($id);
 

        if (file_exists("views/detail.php")) {
            require_once "views/detail.php";
        } else {
            require_once "views/home.php";
        }
    }

    /**
     * Lọc món ăn theo danh mục
     */
    public function filterByCategory(): void {
        $categoryId = isset($_GET['category_id']) ? (int)$_GET['category_id'] : 0;
        
        if ($categoryId <= 0) {
            header("Location: index.php");
            exit;
        }

        $rawItems = $this->productModel->getByCategory($categoryId);
        $newProducts = array_map([$this, 'mapProductData'], $rawItems);
        $menuItems = $newProducts;
        
        // Khi lọc danh mục thì ẩn 2 khối ưu đãi và bán chạy
        $activeCombos = [];
        $promoProducts = [];
        $bestsellers = [];
        $categoryChips = $this->buildCategoryChips($categoryId);

        require_once "views/home.php";
    }

    /**
     * Tìm kiếm món ăn theo từ khóa
     */
    public function search(): void {
        $keyword = isset($_GET['keyword']) ? trim((string)$_GET['keyword']) : (isset($_GET['q']) ? trim((string)$_GET['q']) : '');

        if ($keyword === '') {
            $this->index();
            return;
        }

        $rawItems = $this->productModel->search($keyword);
        $newProducts = array_map([$this, 'mapProductData'], $rawItems);
        $menuItems = $newProducts;

        // Khi tìm kiếm thì chỉ hiển thị kết quả tìm được
        $activeCombos = [];
        $promoProducts = [];
        $bestsellers = [];
        $categoryChips = $this->buildCategoryChips(0);

        require_once "views/home.php";
    }
}