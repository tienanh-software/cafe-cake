<?php include 'layouts/users/header.php'; ?>
<main>
    <!-- Hero Banner -->
    <section class="hero-section">
        <div class="container hero-grid">
            <div class="hero-content">
                <p class="hero-kicker"><?php echo htmlspecialchars($_SESSION['order_context']['table_number'] ?? 'Bàn 01', ENT_QUOTES, 'UTF-8'); ?> · Khu vực Cửa Sổ · Table Order</p>
                <h1 class="hero-title">Hương cà phê rang mộc &amp; bánh nướng mới mỗi sáng</h1>
                <p class="hero-subtitle">
                    Khám phá thực đơn đặc sản tại Maison Nâu. Chọn món trực tiếp ngay tại bàn,
                    barista pha chế chuẩn vị và phục vụ nóng hổi trong vài phút.
                </p>
                <div class="hero-actions">
                    <a href="index.php?action=order" class="btn-primary">
                        Xác nhận đơn tại bàn
                    </a>
                    <a href="index.php?action=tracking" class="btn-secondary">
                        Theo dõi đơn hàng
                    </a>
                </div>
                <div class="hero-meta-strip">
                    <div>
                        <span class="hero-meta-label">Thời gian chuẩn bị</span>
                        <span class="hero-meta-value">5 – 10 phút</span>
                    </div>
                    <div>
                        <span class="hero-meta-label">Rang xay tại xưởng</span>
                        <span class="hero-meta-value">100% Arabica Cầu Đất</span>
                    </div>
                    <div>
                        <span class="hero-meta-label">Lò bánh mỗi ngày</span>
                        <span class="hero-meta-value">06:30 sáng</span>
                    </div>
                </div>
            </div>

            <div class="hero-media">
                <img src="https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?q=80&w=800&auto=format&fit=crop"
                     alt="Cà phê Latte Art và bánh Croissant nóng hổi tại bàn Maison Nâu">
            </div>
        </div>
    </section>

    <!-- Category Bar -->
    <section class="category-section" aria-label="Danh mục sản phẩm">
  <div class="container">
    <div class="category-bar">
      <div class="category-list">
        <?php if (!empty($categoryChips)): ?>
          <?php foreach ($categoryChips as $cat): ?>
            <a href="<?= htmlspecialchars($cat['href'] ?? '#', ENT_QUOTES, 'UTF-8') ?>"
               class="category-chip <?= !empty($cat['active']) ? 'is-active' : '' ?>">
              <?= htmlspecialchars($cat['label'] ?? '', ENT_QUOTES, 'UTF-8') ?>
            </a>
          <?php endforeach; ?>
        <?php endif; ?>
      </div>
      <span class="category-table-note">Đang phục vụ: <?= htmlspecialchars($_SESSION['order_context']['table_number'] ?? 'Tại bàn', ENT_QUOTES, 'UTF-8') ?></span>
    </div>
  </div>
</section>

    <!-- 1. KHU VỰC ƯU ĐÃI (PROMOTIONS) -->
    <section id="promotions" class="menu-section">
        <div class="container">
            <div class="section-header">
                <div>
                    <span class="section-eyebrow">Ưu đãi đặc biệt hôm nay</span>
                    <h2 class="section-title">Khu Vực Ưu Đãi &amp; Combo</h2>
                </div>
                <p class="section-subtitle">
                    Tiết kiệm đến 25% khi gọi theo combo cà phê đặc sản và bánh nướng Pháp tại bàn.
                </p>
            </div>

            <div class="promo-banner">
                <div class="promo-banner-body">
                    <span class="promo-banner-label">ƯU ĐÃI BUỔI SÁNG · GIẢM ĐẾN 25%</span>
                    <h3 class="promo-banner-title">Combo Sáng Thảnh Thơi — Cà phê Ý &amp; Croissant nóng</h3>
                    <p class="promo-banner-desc">
                        Áp dụng cho khách dùng tại quán từ 07:00 đến 11:30 hằng ngày. Tự do tùy chọn
                        Latte, Cold Brew hoặc Trà sữa thủ công đi kèm bánh nướng bơ Pháp mới ra lò.
                    </p>
                    <div class="promo-banner-action">
                        <a href="index.php?action=order" class="promo-banner-btn">
                            Đặt combo ngay
                        </a>
                        <span class="promo-banner-note">Chỉ từ 79.000đ / phần tại bàn</span>
                    </div>
                </div>
                <div class="promo-banner-image">
                    <img src="https://images.unsplash.com/photo-1517433670267-08bbd4be890f?q=80&w=800&auto=format&fit=crop"
                         alt="Chương trình ưu đãi Combo Sáng Thảnh Thơi tại Maison Nâu">
                </div>
            </div>

            <div class="product-grid">
                <?php if (!empty($promoProducts)): ?>
                    <?php foreach ($promoProducts as $p): ?>
                    <?php
                        $itemId       = $p['item_id'] ?? '';
                        $itemName     = $p['item_name'] ?? '';
                        $categoryName = $p['category_name'] ?? 'Promotion';
                        $description  = !empty($p['description'])
                        ? $p['description']
                        : 'Công thức pha chế độc quyền dành riêng cho sự kiện mùa này.';
                        $fallbackImg  = 'https://images.unsplash.com/photo-1497935586351-b67a49e012bf?q=80&w=400&auto=format&fit=crop';
                        $imgSrc       = !empty($p['image_url']) ? $p['image_url'] : $fallbackImg;

                        $minPrice         = (float)($p['min_price'] ?? 0);
                        $originalMaxPrice = (float)($p['original_max_price'] ?? 0);
                        $maxDiscount      = (float)($p['max_discount'] ?? 0);
                        $hasDiscountBadge = !empty($p['max_discount']) && $maxDiscount > 0;
                        $hasOriginalPrice = !empty($p['original_max_price']) && $originalMaxPrice > $minPrice;
                    ?>
                    <?php if (!empty($activeCombos)): ?>
                        <?php foreach ($activeCombos as $combo): ?>
                            <?php
                                $comboId   = $combo['combo_id'] ?? '';
                                $comboName = $combo['combo_name'] ?? '';
                                $dateStart = $combo['date_start'] ?? '';
                                $dateEnd   = $combo['date_end'] ?? '';
                                $comboImg   = !empty($combo['image_url']) ? $combo['image_url'] : 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?q=80&w=400&auto=format&fit=crop';
                            ?>
                            <article class="product-card">
                                <div class="product-thumb">
                                <img src="<?php echo htmlspecialchars($comboImg, ENT_QUOTES, 'UTF-8'); ?>"
                                    alt="<?php echo htmlspecialchars($comboName, ENT_QUOTES, 'UTF-8'); ?>">
                                <span class="product-badge badge-sale">COMBO</span>
                                </div>
                                <div class="product-body">
                                <span class="product-category">Ưu đãi Combo</span>
                                <h3 class="product-name"><?php echo htmlspecialchars($comboName, ENT_QUOTES, 'UTF-8'); ?></h3>
                                <p class="product-desc">Áp dụng từ <?php echo htmlspecialchars((string)$dateStart, ENT_QUOTES, 'UTF-8'); ?> đến <?php echo htmlspecialchars((string)$dateEnd, ENT_QUOTES, 'UTF-8'); ?></p>
                                <div class="product-footer">
                                    <div class="price-group">
                                    <span class="price-current">Combo ưu đãi</span>
                                    <span class="price-original"></span>
                                    </div>
                                    <a href="<?php echo htmlspecialchars('index.php?action=combo&id=' . (string)$comboId, ENT_QUOTES, 'UTF-8'); ?>" class="btn-card-add">
                                    Chọn combo
                                    </a>
                                </div>
                                </div>
                            </article>
                            <?php endforeach; ?>
                        </div>
                        <?php endif; ?>

                    <?php endforeach; ?>
                <?php else: ?>
                    <div class="col-12 py-4 text-center text-muted">Chưa có ưu đãi hôm nay...</div>
                <?php endif; ?>
                </div>
        </div>
    </section>

    <!-- 2. KHU VỰC MÓN MỚI (NEW ARRIVALS) -->
    <section id="new-arrivals" class="menu-section">
        <div class="container">
            <div class="section-header">
                <div>
                    <span class="section-eyebrow"><?= !empty($keyword) ? 'Kết quả tra cứu' : 'Sáng tạo theo mùa' ?></span>
                    <h2 class="section-title"><?= !empty($keyword) ? 'Tìm kiếm: "' . htmlspecialchars($keyword, ENT_QUOTES, 'UTF-8') . '"' : 'Khu Vực Món Mới' ?></h2>
                </div>
                <p class="section-subtitle">
                    <?= !empty($keyword) ? 'Tìm thấy ' . count($newProducts) . ' món phù hợp với từ khóa.' : 'Những hương vị vừa ra mắt trong tuần này từ quầy Barista và Bếp bánh thủ công.' ?>
                </p>
            </div>

            <div class="product-grid product-grid-4">
                 <?php if(!empty($newProducts)): ?>
                     <?php foreach ($newProducts as $p): ?>
                     <?php
                         $itemId       = $p['item_id'] ?? 0;
                         $itemName     = $p['item_name'] ?? 'Món mới';
                         $categoryName = $p['category_name'] ?? 'Beverage';
                         $description  = !empty($p['description']) ? $p['description'] : 'Thưởng thức hương vị nguyên bản chuẩn phong cách Fine Dining.';
                         $minPrice     = (float)($p['min_price'] ?? 0);
                         $fallbackImg  = 'https://images.unsplash.com/photo-1541167760496-1628856ab772?q=80&w=400&auto=format&fit=crop';
                         $imgSrc       = !empty($p['image_url']) ? $p['image_url'] : $fallbackImg;
                     ?>
                     <article class="product-card">
                         <div class="product-thumb">
                             <a href="index.php?action=detail&id=<?= $itemId ?>" class="card-img-container">
                                 <img src="<?= htmlspecialchars($imgSrc, ENT_QUOTES, 'UTF-8') ?>"
                                      alt="<?= htmlspecialchars($itemName, ENT_QUOTES, 'UTF-8') ?>"
                                      onerror="this.onerror=null;this.src='<?= htmlspecialchars($fallbackImg, ENT_QUOTES, 'UTF-8') ?>';">
                             </a>
                             <span class="product-badge badge-new">NEW</span>
                         </div>
                         <div class="product-body">
                             <span class="product-category"><?= htmlspecialchars($categoryName, ENT_QUOTES, 'UTF-8') ?></span>
                             <a href="index.php?action=detail&id=<?= $itemId ?>" class="text-decoration-none">
                                 <h3 class="product-name"><?= htmlspecialchars($itemName, ENT_QUOTES, 'UTF-8') ?></h3>
                             </a>
                             <p class="product-desc"><?= htmlspecialchars($description, ENT_QUOTES, 'UTF-8') ?></p>
                             <div class="product-footer">
                                 <div class="price-group">
                                     <span class="price-current"><?= number_format($minPrice, 0, ',', '.') ?>đ</span>
                                 </div>
                                 <a href="index.php?action=detail&id=<?= $itemId ?>" class="btn-card-add">
                                     Chọn món
                                 </a>
                             </div>
                         </div>
                     </article>
                     <?php endforeach; ?>
                 <?php else: ?>
                     <div class="col-12 py-5 text-center text-muted" style="grid-column: 1 / -1;">
                         <p style="font-size: 1.1rem; margin-bottom: 0.5rem;">Không tìm thấy món ăn nào phù hợp với từ khóa "<strong><?= htmlspecialchars($keyword ?? '', ENT_QUOTES, 'UTF-8') ?></strong>"</p>
                         <p><a href="index.php?action=home" style="color: #6F4E37; font-weight: 600; text-decoration: underline;">Xem tất cả thực đơn</a></p>
                     </div>
                 <?php endif; ?>
            </div>
                        </div>
    </section>

    <!-- 3. KHU VỰC BÁN CHẠY (BEST SELLERS) -->
    <section id="best-sellers" class="menu-section">
        <div class="container">
            <div class="section-header">
                <div>
                    <span class="section-eyebrow">Được yêu thích nhất</span>
                    <h2 class="section-title">Khu Vực Bán Chạy</h2>
                </div>
                <p class="section-subtitle">
                    Các món đặc trưng tạo nên dấu ấn riêng của Maison Nâu qua nhiều mùa.
                </p>
            </div>

            <div class="product-grid product-grid-4">
        <?php if (!empty($bestsellers)): ?>
            <?php foreach ($bestsellers as $p): ?>
            <?php
                $itemId       = $p['item_id'] ?? '';
                $itemName     = $p['item_name'] ?? '';
                $categoryName = $p['category_name'] ?? 'Most Popular';
                $description  = !empty($p['description'])
                ? $p['description']
                : 'Lựa chọn hàng đầu được đa số khách hàng đánh giá 5 sao.';
                $fallbackImg  = 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?q=80&w=400&auto=format&fit=crop';
                $imgSrc       = !empty($p['image_url']) ? $p['image_url'] : $fallbackImg;
                $minPrice     = (float)($p['min_price'] ?? 0);
            ?>
            <article class="product-card">
                <div class="product-thumb">
                <a href="index.php?action=detail&id=<?= htmlspecialchars((string)$itemId, ENT_QUOTES, 'UTF-8') ?>" class="card-img-container">
                    <img src="<?= htmlspecialchars($imgSrc, ENT_QUOTES, 'UTF-8') ?>"
                        alt="<?= htmlspecialchars($itemName, ENT_QUOTES, 'UTF-8') ?>"
                        onerror="this.onerror=null;this.src='<?= htmlspecialchars($fallbackImg, ENT_QUOTES, 'UTF-8') ?>';">
                </a>
                <span class="product-badge badge-best">BEST SELLER</span>
                </div>

                <div class="product-body">
                <span class="product-category">
                    <?= htmlspecialchars($categoryName, ENT_QUOTES, 'UTF-8') ?>
                </span>
                <a href="index.php?action=detail&id=<?= htmlspecialchars((string)$itemId, ENT_QUOTES, 'UTF-8') ?>" class="text-decoration-none">
                    <h3 class="product-name">
                    <?= htmlspecialchars($itemName, ENT_QUOTES, 'UTF-8') ?>
                    </h3>
                </a>
                <p class="product-desc">
                    <?= htmlspecialchars($description, ENT_QUOTES, 'UTF-8') ?>
                </p>

                <div class="product-footer">
                    <div class="price-group">
                    <span class="price-current">
                        <?= number_format($minPrice, 0, ',', '.') ?>đ
                    </span>
                    </div>
                    <a href="index.php?action=detail&id=<?= htmlspecialchars((string)$itemId, ENT_QUOTES, 'UTF-8') ?>" class="btn-card-add">
                    Chọn món
                    </a>
                </div>
                </div>
            </article>
            <?php endforeach; ?>
        <?php else: ?>
            <div class="col-12 py-4 text-center text-muted">Đang cập nhật món bán chạy...</div>
        <?php endif; ?>
        </div>
        </div>
    </section>

    <!-- 4. THỰC ĐƠN TẠI BÀN -->
    <section id="full-menu" class="menu-section">
        <div class="container">
            <div class="section-header">
                <div>
                    <span class="section-eyebrow">Danh sách sản phẩm</span>
                    <h2 class="section-title">Thực Đơn Cà Phê &amp; Bánh Ngọt</h2>
                </div>
                <p class="section-subtitle">
                    Mọi món uống đều có thể tùy chỉnh lượng đường, đá hoặc đổi sang sữa hạt.
                </p>
            </div>

            <div class="product-grid">
                <?php if (!empty($menuItems)): ?>
                    <?php foreach ($menuItems as $item): ?>
                    <?php
                        $itemId       = $item['item_id'] ?? $item['id'] ?? 0;
                        $itemName     = $item['item_name'] ?? $item['name'] ?? 'Món ngon';
                        $categoryName = $item['category_name'] ?? $item['category'] ?? 'Menu';
                        $description  = !empty($item['description']) ? $item['description'] : 'Hương vị nguyên bản đậm đà từ nguyên liệu tự nhiên.';
                        $imgSrc       = !empty($item['image_url']) ? $item['image_url'] : (!empty($item['image']) ? $item['image'] : 'https://images.unsplash.com/photo-1541167760496-1628856ab772?q=80&w=400&auto=format&fit=crop');
                        $priceVal     = (float)($item['min_price'] ?? $item['price'] ?? 0);
                        $formattedPrice = number_format($priceVal, 0, ',', '.') . 'đ';
                    ?>
                    <article class="product-card">
                        <div class="product-thumb">
                            <a href="index.php?action=detail&id=<?= $itemId ?>" class="card-img-container">
                                <img src="<?= htmlspecialchars($imgSrc, ENT_QUOTES, 'UTF-8') ?>"
                                     alt="<?= htmlspecialchars($itemName, ENT_QUOTES, 'UTF-8') ?>"
                                     onerror="this.onerror=null;this.src='https://images.unsplash.com/photo-1541167760496-1628856ab772?q=80&w=400&auto=format&fit=crop';">
                            </a>
                        </div>
                        <div class="product-body">
                            <span class="product-category"><?= htmlspecialchars($categoryName, ENT_QUOTES, 'UTF-8') ?></span>
                            <a href="index.php?action=detail&id=<?= $itemId ?>" class="text-decoration-none">
                                <h3 class="product-name"><?= htmlspecialchars($itemName, ENT_QUOTES, 'UTF-8') ?></h3>
                            </a>
                            <p class="product-desc"><?= htmlspecialchars($description, ENT_QUOTES, 'UTF-8') ?></p>
                            <div class="product-footer">
                                <div class="price-group">
                                    <span class="price-current"><?= $formattedPrice ?></span>
                                </div>
                                <a href="index.php?action=detail&id=<?= $itemId ?>" class="btn-card-add">
                                    Chọn món
                                </a>
                            </div>
                        </div>
                    </article>
                    <?php endforeach; ?>
                <?php else: ?>
                    <div class="col-12 py-4 text-center text-muted">Đang cập nhật thực đơn...</div>
                <?php endif; ?>
            </div>
        </div>
    </section>
</main>
<?php include 'layouts/users/footer.php'; ?>