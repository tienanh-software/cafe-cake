<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Maison Nâu Cafe & Bakery — Đặt cà phê rang mộc và bánh ngọt Pháp trực tiếp tại bàn.">
    <title><?php echo htmlspecialchars($pageTitle, ENT_QUOTES, 'UTF-8'); ?></title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700&family=DM+Serif+Display:ital@0;1&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="views/css/user/header.css"> 
    <link rel="stylesheet" href="views/css/user/home.css"> 
    <link rel="stylesheet" href="views/css/user/footer.css"> 
</head>
<body>
    <header class="site-header">
         <div class="container header-inner">
            <a href="<?php echo htmlspecialchars($linkBase . '?page=home', ENT_QUOTES, 'UTF-8'); ?>" class="brand-wordmark">
                <img src="assets/images/OG.png" alt="Maison Nâu Cafe & Bakery" class="brand-logo">
            </a>

            <div class="header-search" role="search">
                <label for="header-search-input" class="sr-only">Tìm kiếm sản phẩm</label>
                <span class="header-search-icon" aria-hidden="true">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="11" cy="11" r="8"></circle>
                        <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                    </svg>
                </span>
                <input
                    type="search"
                    id="header-search-input"
                    name="q"
                    class="header-search-input"
                    placeholder="Tìm kiếm cà phê, trà, bánh..."
                    autocomplete="off"
                >
            </div>

            <div class="header-action">
                <a href="<?php echo htmlspecialchars($linkBase . '?page=order', ENT_QUOTES, 'UTF-8'); ?>" class="btn-header-order">
                    Bàn 08 · Giỏ món (3)
                </a>
            </div>
        </div>
    </header>
