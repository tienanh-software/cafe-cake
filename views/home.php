<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>Babo Coffee - Menu Đặt Món</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
    body {
        background-color: #f7f7f8;
        padding-bottom: 95px;
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
    }

    .category-scroll {
        display: flex;
        overflow-x: auto;
        white-space: nowrap;
        scrollbar-width: none;
        -webkit-overflow-scrolling: touch;
    }

    .category-scroll::-webkit-scrollbar {
        display: none;
    }

    .category-pill {
        display: inline-block;
        padding: 8px 16px;
        border-radius: 20px;
        background: #fff;
        color: #495057;
        font-size: 0.88rem;
        font-weight: 600;
        text-decoration: none;
        border: 1px solid #e9ecef;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
        transition: all 0.2s;
    }

    .category-pill.active,
    .category-pill:hover {
        background: #212529;
        color: #ffc107;
        border-color: #212529;
    }

    .product-card {
        border: none;
        border-radius: 14px;
        overflow: hidden;
        background: #fff;
        box-shadow: 0 2px 6px rgba(0, 0, 0, 0.04);
        height: 100%;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
    }

    .product-img-wrap {
        position: relative;
        width: 100%;
        padding-top: 80%;
        overflow: hidden;
    }

    .product-img-wrap img {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        object-fit: cover;
    }

    .product-title {
        font-size: 0.95rem;
        font-weight: 600;
        line-height: 1.3;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
        height: 2.6em;
        color: #212529;
    }

    .btn-add-quick {
        width: 34px;
        height: 34px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 0;
        font-size: 0.9rem;
    }

    .bottom-bar {
        position: fixed;
        bottom: 0;
        left: 0;
        right: 0;
        z-index: 1040;
        background: #ffffff;
        border-top: 1px solid #dee2e6;
        padding: 10px 16px;
        box-shadow: 0 -4px 12px rgba(0, 0, 0, 0.08);
    }

    @media (min-width: 768px) {
        .product-title {
            font-size: 1.05rem;
        }

        .product-img-wrap {
            padding-top: 75%;
        }

        .bottom-bar {
            max-width: 600px;
            margin: 0 auto;
            border-radius: 20px 20px 0 0;
            bottom: 0;
        }
    }
    </style>
</head>

<body>

    <header class="sticky-top bg-dark text-white px-3 py-2 shadow-sm">
        <div class="d-flex align-items-center justify-content-between">
            <div class="d-flex align-items-center gap-2">
                <a href="index.php" class="fw-bold text-warning fs-4 text-decoration-none">Babo Coffee</a>
                <span class="badge bg-warning text-dark px-2 py-1 rounded-pill fw-bold">
                    <i
                        class="fa-solid fa-qrcode me-1"></i><?= isset($_GET['table']) ? 'Bàn ' . htmlspecialchars($_GET['table']) : 'Bàn 01' ?>
                </span>
            </div>
            <div>
                <a href="index.php?action=login" class="btn btn-sm btn-outline-light rounded-pill px-3">
                    <i class="fa-solid fa-user"></i>
                </a>
            </div>
        </div>
    </header>

    <div class="bg-white border-bottom py-2 px-3 sticky-top" style="top: 53px; z-index: 1020;">
        <div class="category-scroll gap-2">
            <a href="#new-section" class="category-pill active"><i
                    class="fa-solid fa-sparkles me-1 text-warning"></i>Món Mới</a>
            <a href="#promo-section" class="category-pill"><i class="fa-solid fa-fire me-1 text-danger"></i>Khuyến
                Mãi</a>
            <a href="#best-section" class="category-pill"><i class="fa-solid fa-crown me-1 text-warning"></i>Bán
                Chạy</a>
            <a href="index.php?action=categories" class="category-pill"><i class="fa-solid fa-list me-1"></i>Tất Cả
                Menu</a>
        </div>
    </div>

    <main class="container px-2 px-md-3 mt-3">

        <section id="new-section" class="mb-4">
            <div class="d-flex justify-content-between align-items-center mb-2 px-1">
                <h6 class="fw-bold text-dark mb-0 fs-5"><i class="fa-solid fa-star text-warning me-2"></i>Món Mới Nổi
                    Bật</h6>
                <small class="text-muted">Xem hết</small>
            </div>
            <div class="row g-2 g-md-3">
                <?php if(!empty($newProducts)): ?>
                <?php foreach($newProducts as $p): ?>
                <div class="col-6 col-md-4 col-lg-3">
                    <div class="product-card">
                        <a href="index.php?action=detail&id=<?= $p['id'] ?>"
                            class="product-img-wrap text-decoration-none">
                            <img src="<?= htmlspecialchars($p['image']) ?>" alt="<?= htmlspecialchars($p['name']) ?>"
                                onerror="this.src='https://images.unsplash.com/photo-1541167760496-1628856ab772?q=80&w=400&auto=format&fit=crop'">
                        </a>
                        <div class="p-2 p-md-3 d-flex flex-column justify-content-between flex-grow-1">
                            <a href="index.php?action=detail&id=<?= $p['id'] ?>" class="text-decoration-none">
                                <h2 class="product-title mb-1"><?= htmlspecialchars($p['name']) ?></h2>
                            </a>
                            <div class="d-flex align-items-center justify-content-between mt-2">
                                <span class="text-danger fw-bold fs-6">
                                    <?= is_numeric($p['price']) ? number_format($p['price'], 0, ',', '.') . 'đ' : htmlspecialchars($p['price']) ?>
                                </span>
                                <a href="index.php?action=detail&id=<?= $p['id'] ?>"
                                    class="btn btn-warning btn-add-quick text-dark shadow-sm">
                                    <i class="fa-solid fa-plus"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
                <?php endforeach; ?>
                <?php else: ?>
                <div class="col-12 py-3 text-center text-muted">Đang cập nhật món mới...</div>
                <?php endif; ?>
            </div>
        </section>

        <section id="promo-section" class="mb-4">
            <div class="d-flex justify-content-between align-items-center mb-2 px-1">
                <h6 class="fw-bold text-dark mb-0 fs-5"><i class="fa-solid fa-tag text-danger me-2"></i>Ưu Đãi Đặc Biệt
                </h6>
                <small class="text-muted">Xem hết</small>
            </div>
            <div class="row g-2 g-md-3">
                <?php if(!empty($promoProducts)): ?>
                <?php foreach($promoProducts as $p): ?>
                <div class="col-6 col-md-4 col-lg-3">
                    <div class="product-card">
                        <a href="index.php?action=detail&id=<?= $p['id'] ?>"
                            class="product-img-wrap text-decoration-none">
                            <img src="<?= htmlspecialchars($p['image']) ?>" alt="<?= htmlspecialchars($p['name']) ?>"
                                onerror="this.src='https://images.unsplash.com/photo-1497935586351-b67a49e012bf?q=80&w=400&auto=format&fit=crop'">
                        </a>
                        <div class="p-2 p-md-3 d-flex flex-column justify-content-between flex-grow-1">
                            <a href="index.php?action=detail&id=<?= $p['id'] ?>" class="text-decoration-none">
                                <h2 class="product-title mb-1"><?= htmlspecialchars($p['name']) ?></h2>
                            </a>
                            <div class="d-flex align-items-center justify-content-between mt-2">
                                <span class="text-danger fw-bold fs-6">
                                    <?= is_numeric($p['price']) ? number_format($p['price'], 0, ',', '.') . 'đ' : htmlspecialchars($p['price']) ?>
                                </span>
                                <a href="index.php?action=detail&id=<?= $p['id'] ?>"
                                    class="btn btn-warning btn-add-quick text-dark shadow-sm">
                                    <i class="fa-solid fa-plus"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
                <?php endforeach; ?>
                <?php else: ?>
                <div class="col-12 py-3 text-center text-muted">Đang cập nhật ưu đãi...</div>
                <?php endif; ?>
            </div>
        </section>

        <section id="best-section" class="mb-4">
            <div class="d-flex justify-content-between align-items-center mb-2 px-1">
                <h6 class="fw-bold text-dark mb-0 fs-5"><i
                        class="fa-solid fa-fire-flame-curved text-warning me-2"></i>Món Bán Chạy Nhất</h6>
                <small class="text-muted">Xem hết</small>
            </div>
            <div class="row g-2 g-md-3">
                <?php if(!empty($bestsellers)): ?>
                <?php foreach($bestsellers as $p): ?>
                <div class="col-6 col-md-4 col-lg-3">
                    <div class="product-card">
                        <a href="index.php?action=detail&id=<?= $p['id'] ?>"
                            class="product-img-wrap text-decoration-none">
                            <img src="<?= htmlspecialchars($p['image']) ?>" alt="<?= htmlspecialchars($p['name']) ?>"
                                onerror="this.src='https://images.unsplash.com/photo-1509042239860-f550ce710b93?q=80&w=400&auto=format&fit=crop'">
                        </a>
                        <div class="p-2 p-md-3 d-flex flex-column justify-content-between flex-grow-1">
                            <a href="index.php?action=detail&id=<?= $p['id'] ?>" class="text-decoration-none">
                                <h2 class="product-title mb-1"><?= htmlspecialchars($p['name']) ?></h2>
                            </a>
                            <div class="d-flex align-items-center justify-content-between mt-2">
                                <span class="text-danger fw-bold fs-6">
                                    <?= is_numeric($p['price']) ? number_format($p['price'], 0, ',', '.') . 'đ' : htmlspecialchars($p['price']) ?>
                                </span>
                                <a href="index.php?action=detail&id=<?= $p['id'] ?>"
                                    class="btn btn-warning btn-add-quick text-dark shadow-sm">
                                    <i class="fa-solid fa-plus"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
                <?php endforeach; ?>
                <?php else: ?>
                <div class="col-12 py-3 text-center text-muted">Đang cập nhật món bán chạy...</div>
                <?php endif; ?>
            </div>
        </section>

    </main>

    <div class="bottom-bar">
        <div class="d-flex gap-2 align-items-center justify-content-between">
            <button class="btn btn-outline-secondary rounded-pill px-3 py-2 fw-semibold fs-6" style="flex: 1;"
                onclick="alert('Đã gửi yêu cầu đến nhân viên!')">
                <i class="fa-solid fa-bell text-warning me-1"></i> Gọi phục vụ
            </button>

            <a href="index.php?action=cart"
                class="btn btn-dark rounded-pill px-3 py-2 fw-bold d-flex align-items-center justify-content-between text-decoration-none shadow"
                style="flex: 2;">
                <div class="d-flex align-items-center gap-2">
                    <span class="badge bg-warning text-dark rounded-pill fs-7">1</span>
                    <span class="text-white fs-6">Xem đơn hàng</span>
                </div>
                <span class="text-warning fw-bold fs-6">35.000đ <i class="fa-solid fa-chevron-right ms-1"></i></span>
            </a>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>