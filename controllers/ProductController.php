<?php
require_once "models/Products.php";

class ProductController {
    private $productModel;

    public function __construct() {
        $this->productModel = new Products();
    }

    private function mapProductData($item) {
        $name = $item['item_name'] ?? $item['name'] ?? 'Chưa đặt tên';
        $image = !empty($item['image_url']) ? $item['image_url'] : (!empty($item['image']) ? $item['image'] : 'https://images.unsplash.com/photo-1541167760496-1628856ab772?q=80&w=400&auto=format&fit=crop');
        return [
            'id' => $item['item_id'] ?? $item['id'] ?? 0,
            'item_id'  => $item['item_id'] ?? $item['id'] ?? 0,
            'name'  => $name,
            'item_name'  => $name,
            'price'  => $item['min_price'] ?? 0,
            'min_price'  => $item['min_price'] ?? 0,
            'image'  => $image,
            'image_url'  => $image,
            'description'  => $item['description'] ?? '',
            'category_name' => $item['category_name'] ?? ''
        ];
    }

    public function index() {
        $rawItems = $this->productModel->getAll();
        
        $products = [];
        foreach ($rawItems as $item) {
            $products[] = $this->mapProductData($item);
        }

        $newProducts = array_slice($products, 0, 4);
        $promoProducts = array_slice($products, 0, 4);
        $bestsellers = array_slice($products, 0, 4);

        require_once "views/home.php";
    }

    public function detail() {
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
        $variants = $this->productModel->getVariantsByItemId($id);
        $toppings = $this->productModel->getToppingsByItemId($id);

        if (file_exists("views/detail.php")) {
            require_once "views/detail.php";
        } else {
            require_once "views/home.php";
        }
    }

    public function filterByCategory() {
        $categoryId = isset($_GET['category_id']) ? (int)$_GET['category_id'] : 0;
        $rawItems = $this->productModel->getByCategory($categoryId);

        $products = [];
        foreach ($rawItems as $item) {
            $products[] = $this->mapProductData($item);
        }

        $newProducts = $products;
        $promoProducts = [];
        $bestsellers = [];

        require_once "views/home.php";
    }

    public function search() {
        $keyword = isset($_GET['keyword']) ? trim($_GET['keyword']) : '';
        $rawItems = $this->productModel->search($keyword);

        $products = [];
        foreach ($rawItems as $item) {
            $products[] = $this->mapProductData($item);
        }

        $newProducts = $products;
        $promoProducts = [];
        $bestsellers = [];

        require_once "views/home.php";
    }
    
}
?>