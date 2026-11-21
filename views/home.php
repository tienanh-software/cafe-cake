<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>Babo Lounge & Dining - Luxury Culinary Experience</title>

    <!-- Google Fonts: Sang trọng, Chuẩn Michelin/5-Star Dining -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link
        href="https://fonts.googleapis.com/css2?family=Cinzel:wght@500;600;700&family=Plus+Jakarta+Sans:wght@300;400;500;600&display=swap"
        rel="stylesheet">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
    :root {
        --gold-primary: #D4AF37;
        --gold-gradient: linear-gradient(135deg, #ECC872 0%, #B8860B 100%);
        --dark-obsidian: #0c0d0e;
        --dark-card: #151719;
        --dark-border: rgba(212, 175, 55, 0.18);
        --text-gold: #e8c872;
        --text-muted: #8E8E93;
        --cream-bg: #F4F1EA;
    }

    body {
        background-color: var(--dark-obsidian);
        color: #E5E5EA;
        font-family: 'Plus Jakarta Sans', sans-serif;
        padding-bottom: 110px;
        letter-spacing: -0.01em;
    }

    h1,
    h2,
    h3,
    h4,
    h5,
    h6,
    .brand-font {
        font-family: 'Cinzel', serif;
        letter-spacing: 0.05em;
    }

    /* Glassmorphism Header */
    .luxury-header {
        background: rgba(12, 13, 14, 0.85);
        backdrop-filter: blur(20px);
        -webkit-backdrop-filter: blur(20px);
        border-bottom: 1px solid var(--dark-border);
    }

    .gold-brand {
        background: var(--gold-gradient);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        font-weight: 700;
        font-size: 1.25rem;
        letter-spacing: 0.15em;
    }

    .table-pill {
        background: rgba(212, 175, 55, 0.08);
        border: 1px solid rgba(212, 175, 55, 0.3);
        color: var(--text-gold);
        font-size: 0.75rem;
        letter-spacing: 0.1em;
        text-transform: uppercase;
        padding: 5px 12px;
        border-radius: 30px;
    }

    /* Elegant Navigation Pills */
    .category-nav-wrap {
        background: rgba(12, 13, 14, 0.95);
        border-bottom: 1px solid rgba(255, 255, 255, 0.06);
        top: 57px;
        z-index: 1020;
    }

    .category-scroll {
        display: flex;
        overflow-x: auto;
        white-space: nowrap;
        scrollbar-width: none;
        gap: 12px;
    }

    .category-scroll::-webkit-scrollbar {
        display: none;
    }

    .luxury-pill {
        color: var(--text-muted);
        font-size: 0.8rem;
        font-weight: 500;
        letter-spacing: 0.08em;
        text-transform: uppercase;
        text-decoration: none;
        padding: 8px 18px;
        border-radius: 50px;
        border: 1px solid rgba(255, 255, 255, 0.08);
        transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
    }

    .luxury-pill.active,
    .luxury-pill:hover {
        color: var(--dark-obsidian);
        background: var(--gold-gradient);
        border-color: transparent;
        box-shadow: 0 4px 15px rgba(212, 175, 55, 0.3);
    }

    /* 5-Star Product Card */
    .luxury-card {
        background: var(--dark-card);
        border: 1px solid var(--dark-border);
        border-radius: 16px;
        overflow: hidden;
        display: flex;
        flex-direction: column;
        height: 100%;
        transition: transform 0.4s ease, border-color 0.4s ease, box-shadow 0.4s ease;
        position: relative;
    }

    .luxury-card:hover {
        transform: translateY(-4px);
        border-color: rgba(212, 175, 55, 0.5);
        box-shadow: 0 12px 30px rgba(0, 0, 0, 0.6);
    }

    .card-img-container {
        position: relative;
        width: 100%;
        padding-top: 85%;
        overflow: hidden;
        background: #1e2022;
    }

    .card-img-container img {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        object-fit: cover;
        transition: transform 0.8s cubic-bezier(0.16, 1, 0.3, 1);
        filter: brightness(0.92);
    }

    .luxury-card:hover .card-img-container img {
        transform: scale(1.08);
        filter: brightness(1.02);
    }

    .luxury-badge {
        position: absolute;
        top: 12px;
        left: 12px;
        background: rgba(12, 13, 14, 0.8);
        border: 1px solid var(--gold-primary);
        color: var(--text-gold);
        font-size: 0.68rem;
        letter-spacing: 0.1em;
        text-transform: uppercase;
        padding: 4px 10px;
        border-radius: 6px;
        backdrop-filter: blur(8px);
        z-index: 2;
    }

    .card-body-luxury {
        padding: 16px;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
        flex-grow: 1;
    }

    .item-category {
        font-size: 0.68rem;
        letter-spacing: 0.15em;
        text-transform: uppercase;
        color: var(--gold-primary);
        opacity: 0.85;
        margin-bottom: 4px;
    }

    .item-title {
        font-size: 0.98rem;
        font-weight: 600;
        line-height: 1.4;
        color: #FFFFFF;
        display: -webkit-box;
        -webkit-line-clamp: 1;
        -webkit-box-orient: vertical;
        overflow: hidden;
        margin-bottom: 6px;
    }

    .item-desc {
        font-size: 0.78rem;
        color: var(--text-muted);
        line-height: 1.4;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
        min-height: 2.2em;
        margin-bottom: 12px;
    }

    .price-tag {
        font-family: 'Cinzel', serif;
        font-size: 1.05rem;
        font-weight: 700;
        color: #FAF5E9;
        letter-spacing: 0.02em;
    }

    .btn-order-add {
        width: 36px;
        height: 36px;
        border-radius: 50%;
        background: transparent;
        border: 1px solid var(--gold-primary);
        color: var(--text-gold);
        display: flex;
        align-items: center;
        justify-content: center;
        transition: all 0.3s ease;
    }

    .btn-order-add:hover {
        background: var(--gold-gradient);
        color: var(--dark-obsidian);
        box-shadow: 0 0 15px rgba(212, 175, 55, 0.4);
    }

    /* Section Headings */
    .section-header-title {
        position: relative;
        display: inline-block;
        font-size: 1.15rem;
        font-weight: 600;
        color: #FFFFFF;
    }

    .section-header-title::after {
        content: '';
        position: absolute;
        left: 0;
        bottom: -5px;
        width: 35px;
        height: 2px;
        background: var(--gold-primary);
    }

    /* 5-Star Concierge Bottom Bar */
    .luxury-bottom-bar {
        position: fixed;
        bottom: 20px;
        left: 50%;
        transform: translateX(-50%);
        width: calc(100% - 32px);
        max-width: 520px;
        background: rgba(18, 20, 23, 0.88);
        border: 1px solid rgba(212, 175, 55, 0.35);
        backdrop-filter: blur(25px);
        -webkit-backdrop-filter: blur(25px);
        border-radius: 50px;
        padding: 8px 12px;
        box-shadow: 0 10px 40px rgba(0, 0, 0, 0.7);
        z-index: 1050;
    }

    .btn-service {
        color: #ECECED;
        font-size: 0.8rem;
        border: none;
        background: transparent;
        letter-spacing: 0.05em;
        transition: color 0.2s;
    }

    .btn-service:hover {
        color: var(--text-gold);
    }

    .btn-checkout-luxury {
        background: var(--gold-gradient);
        color: var(--dark-obsidian);
        font-weight: 600;
        font-size: 0.85rem;
        letter-spacing: 0.05em;
        padding: 9px 18px;
        border-radius: 30px;
        text-decoration: none;
        display: flex;
        align-items: center;
        box-shadow: 0 4px 15px rgba(212, 175, 55, 0.25);
    }
    </style>
</head>

<body>

    <!-- 1. VIP HEADER -->
    <header class="sticky-top luxury-header px-3 py-3">
        <div class="d-flex align-items-center justify-content-between">
            <div class="d-flex align-items-center gap-3">
                <a href="index.php" class="gold-brand text-decoration-none">BABO LOUNGE</a>
                <span class="table-pill">
                    <i class="fa-solid fa-gem me-1" style="font-size: 0.65rem;"></i>
                    <?= isset($_GET['table']) ? 'Table ' . htmlspecialchars($_GET['table']) : 'Table VIP 01' ?>
                </span>
            </div>
            <div>
                <a href="index.php?action=login" class="btn btn-sm text-secondary rounded-circle"
                    style="border: 1px solid rgba(255,255,255,0.15);">
                    <i class="fa-regular fa-user text-light"></i>
                </a>
            </div>
        </div>
    </header>

    <!-- 2. SCROLLABLE CATEGORY PILLS -->
    <div class="category-nav-wrap py-2 px-3 sticky-top">
        <div class="category-scroll">
            <a href="#new-section" class="luxury-pill active">Signature</a>
            <a href="#promo-section" class="luxury-pill">Season Offers</a>
            <a href="#best-section" class="luxury-pill">Chef's Choice</a>
            <a href="index.php?action=categories" class="luxury-pill">Grand Menu</a>
        </div>
    </div>

    <!-- 3. MAIN MENU CONTENT -->
    <main class="container px-3 mt-4">

        <!-- 3.1. SIGNATURE / MÓN MỚI -->
        <section id="new-section" class="mb-5">
            <div class="d-flex justify-content-between align-items-end mb-3">
                <div>
                    <span class="item-category">Exclusive Flavors</span>
                    <h2 class="section-header-title d-block">Món Mới Nổi Bật</h2>
                </div>
                <small class="text-secondary" style="font-size: 0.75rem; letter-spacing: 0.05em; cursor: pointer;">Khám
                    phá tất cả</small>
            </div>

            <div class="row g-3">
                <?php if(!empty($newProducts)): ?>
                <?php foreach($newProducts as $p): 
                        $minPrice = $p['min_price'] ?? 0;
                        $maxPrice = $p['max_price'] ?? 0;
                        $displayPrice = ($minPrice == $maxPrice) 
                            ? number_format((float)$minPrice, 0, ',', '.') . ' ₫'
                            : number_format((float)$minPrice, 0, ',', '.') . ' ₫+';
                    ?>
                <div class="col-6 col-md-4 col-lg-3">
                    <div class="luxury-card">
                        <span class="luxury-badge">Signature</span>
                        <a href="index.php?action=detail&id=<?= $p['item_id'] ?>" class="card-img-container">
                            <img src="<?= !empty($p['image_url']) ? htmlspecialchars($p['image_url']) : 'https://images.unsplash.com/photo-1541167760496-1628856ab772?q=80&w=400&auto=format&fit=crop' ?>"
                                alt="<?= htmlspecialchars($p['item_name']) ?>"
                                onerror="this.src='https://images.unsplash.com/photo-1541167760496-1628856ab772?q=80&w=400&auto=format&fit=crop'">
                        </a>
                        <div class="card-body-luxury">
                            <div>
                                <div class="item-category"><?= htmlspecialchars($p['category_name'] ?? 'Beverage') ?>
                                </div>
                                <a href="index.php?action=detail&id=<?= $p['item_id'] ?>" class="text-decoration-none">
                                    <h3 class="item-title"><?= htmlspecialchars($p['item_name']) ?></h3>
                                </a>
                                <p class="item-desc">
                                    <?= !empty($p['description']) ? htmlspecialchars($p['description']) : 'Thưởng thức hương vị nguyên bản chuẩn phong cách Fine Dining.' ?>
                                </p>
                            </div>
                            <div class="d-flex align-items-center justify-content-between pt-2 border-top"
                                style="border-color: rgba(255,255,255,0.06) !important;">
                                <span class="price-tag"><?= $displayPrice ?></span>
                                <a href="index.php?action=detail&id=<?= $p['item_id'] ?>"
                                    class="btn-order-add text-decoration-none">
                                    <i class="fa-solid fa-arrow-right" style="font-size: 0.8rem;"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
                <?php endforeach; ?>
                <?php else: ?>
                <div class="col-12 py-4 text-center text-muted">Đang cập nhật thực đơn...</div>
                <?php endif; ?>
            </div>
        </section>

        <!-- 3.2. SEASONAL OFFERS / ƯU ĐÃI -->
        <section id="promo-section" class="mb-5">
            <div class="d-flex justify-content-between align-items-end mb-3">
                <div>
                    <span class="item-category">Limited Privileges</span>
                    <h2 class="section-header-title d-block">Ưu Đãi Đặc Quyền</h2>
                </div>
            </div>

            <div class="row g-3">
                <?php if(!empty($promoProducts)): ?>
                <?php foreach($promoProducts as $p): ?>
                <div class="col-6 col-md-4 col-lg-3">
                    <div class="luxury-card">
                        <?php if(!empty($p['max_discount']) && $p['max_discount'] > 0): ?>
                        <span class="luxury-badge" style="border-color: #E65100; color: #FFA726;">
                            Save <?= number_format((float)$p['max_discount'], 0, ',', '.') ?>đ
                        </span>
                        <?php endif; ?>
                        <a href="index.php?action=detail&id=<?= $p['item_id'] ?>" class="card-img-container">
                            <img src="<?= !empty($p['image_url']) ? htmlspecialchars($p['image_url']) : 'https://images.unsplash.com/photo-1497935586351-b67a49e012bf?q=80&w=400&auto=format&fit=crop' ?>"
                                alt="<?= htmlspecialchars($p['item_name']) ?>"
                                onerror="this.src='https://images.unsplash.com/photo-1497935586351-b67a49e012bf?q=80&w=400&auto=format&fit=crop'">
                        </a>
                        <div class="card-body-luxury">
                            <div>
                                <div class="item-category"><?= htmlspecialchars($p['category_name'] ?? 'Promotion') ?>
                                </div>
                                <a href="index.php?action=detail&id=<?= $p['item_id'] ?>" class="text-decoration-none">
                                    <h3 class="item-title"><?= htmlspecialchars($p['item_name']) ?></h3>
                                </a>
                                <p class="item-desc">
                                    <?= !empty($p['description']) ? htmlspecialchars($p['description']) : 'Công thức pha chế độc quyền dành riêng cho sự kiện mùa này.' ?>
                                </p>
                            </div>
                            <div class="d-flex align-items-center justify-content-between pt-2 border-top"
                                style="border-color: rgba(255,255,255,0.06) !important;">
                                <div>
                                    <span class="price-tag"><?= number_format((float)$p['min_price'], 0, ',', '.') ?>
                                        ₫</span>
                                    <?php if(!empty($p['original_max_price']) && $p['original_max_price'] > $p['min_price']): ?>
                                    <small class="text-decoration-line-through text-secondary d-block"
                                        style="font-size: 0.72rem;">
                                        <?= number_format((float)$p['original_max_price'], 0, ',', '.') ?> ₫
                                    </small>
                                    <?php endif; ?>
                                </div>
                                <a href="index.php?action=detail&id=<?= $p['item_id'] ?>"
                                    class="btn-order-add text-decoration-none">
                                    <i class="fa-solid fa-arrow-right" style="font-size: 0.8rem;"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
                <?php endforeach; ?>
                <?php else: ?>
                <div class="col-12 py-4 text-center text-muted">Chưa có ưu đãi hôm nay...</div>
                <?php endif; ?>
            </div>
        </section>

        <!-- 3.3. CHEF'S CHOICE / BÁN CHẠY NHẤT -->
        <section id="best-section" class="mb-5">
            <div class="d-flex justify-content-between align-items-end mb-3">
                <div>
                    <span class="item-category">Top Selected</span>
                    <h2 class="section-header-title d-block">Được Yêu Thích Nhất</h2>
                </div>
            </div>

            <div class="row g-3">
                <?php if(!empty($bestsellers)): ?>
                <?php foreach($bestsellers as $p): ?>
                <div class="col-6 col-md-4 col-lg-3">
                    <div class="luxury-card">
                        <span class="luxury-badge">Must Try</span>
                        <a href="index.php?action=detail&id=<?= $p['item_id'] ?>" class="card-img-container">
                            <img src="<?= !empty($p['image_url']) ? htmlspecialchars($p['image_url']) : 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?q=80&w=400&auto=format&fit=crop' ?>"
                                alt="<?= htmlspecialchars($p['item_name']) ?>"
                                onerror="this.src='https://images.unsplash.com/photo-1509042239860-f550ce710b93?q=80&w=400&auto=format&fit=crop'">
                        </a>
                        <div class="card-body-luxury">
                            <div>
                                <div class="item-category">
                                    <?= htmlspecialchars($p['category_name'] ?? 'Most Popular') ?></div>
                                <a href="index.php?action=detail&id=<?= $p['item_id'] ?>" class="text-decoration-none">
                                    <h3 class="item-title"><?= htmlspecialchars($p['item_name']) ?></h3>
                                </a>
                                <p class="item-desc">
                                    <?= !empty($p['description']) ? htmlspecialchars($p['description']) : 'Lựa chọn hàng đầu được đa số khách hàng đánh giá 5 sao.' ?>
                                </p>
                            </div>
                            <div class="d-flex align-items-center justify-content-between pt-2 border-top"
                                style="border-color: rgba(255,255,255,0.06) !important;">
                                <span class="price-tag"><?= number_format((float)$p['min_price'], 0, ',', '.') ?>
                                    ₫</span>
                                <a href="index.php?action=detail&id=<?= $p['item_id'] ?>"
                                    class="btn-order-add text-decoration-none">
                                    <i class="fa-solid fa-arrow-right" style="font-size: 0.8rem;"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
                <?php endforeach; ?>
                <?php endif; ?>
            </div>
        </section>

    </main>

    <!-- 4. CONCIERGE & FLOATING ORDER BAR (FLOATING GLASS) -->
    <div class="luxury-bottom-bar d-flex align-items-center justify-content-between">
        <button class="btn-service px-3 py-2"
            onclick="alert('Concierge: Yêu cầu của Quý khách đã được chuyển tới quản lý sảnh.')">
            <i class="fa-solid fa-bell-concierge me-2 text-warning"></i> Gọi Nhân Viên
        </button>

        <a href="index.php?action=cart" class="btn-checkout-luxury">
            <span class="me-2">Trải Nghiệm</span>
            <span class="badge rounded-pill bg-dark text-warning px-2 py-1" style="font-size: 0.75rem;">
                <?= isset($_SESSION['cart']) ? count($_SESSION['cart']) : 0 ?>
            </span>
            <i class="fa-solid fa-angle-right ms-2" style="font-size: 0.75rem;"></i>
        </a>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>