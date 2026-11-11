<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Sơ Đồ Bàn & Thu Ngân - Babo Coffee</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
    body {
        background: #f7f7f8;
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
    }

    .table-box {
        border-radius: 18px;
        padding: 16px;
        min-height: 150px;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
        box-shadow: 0 3px 8px rgba(0, 0, 0, 0.04);
        border: 2px solid transparent;
        transition: all 0.2s;
    }

    .table-box.empty {
        background: #ffffff;
        border-color: #e9ecef;
    }

    .table-box.occupied {
        background: #fff5f5;
        border-color: #ff6b6b;
    }
    </style>
</head>

<body class="p-3">

    <div class="container-fluid">
        <!-- Header thống kê nhanh -->
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 bg-white p-3 rounded-4 shadow-sm">
            <div>
                <h4 class="fw-bold mb-0 text-dark"><i class="fa-solid fa-store text-warning me-2"></i>Babo Coffee -
                    Floor Map</h4>
                <small class="text-muted">Quản lý sơ đồ bàn & quầy thu ngân</small>
            </div>
            <div class="d-flex gap-3 align-items-center mt-2 mt-md-0">
                <div class="text-end">
                    <small class="text-muted d-block">Doanh thu hôm nay</small>
                    <strong
                        class="text-danger fs-5"><?= number_format($dailyStats['total_revenue'] ?? 0, 0, ',', '.') ?>đ</strong>
                </div>
                <a href="index.php?action=kds" class="btn btn-dark rounded-pill px-3 fw-bold">
                    <i class="fa-solid fa-mug-hot me-1 text-warning"></i> Màn hình Bếp
                </a>
            </div>
        </div>

        <!-- SƠ ĐỒ BÀN (Floor Map Grid) -->
        <h5 class="fw-bold text-dark mb-3"><i class="fa-solid fa-border-all me-2"></i>Tình trạng bàn</h5>
        <div class="row g-3 mb-5">
            <?php foreach($tables as $t): ?>
            <div class="col-6 col-md-4 col-lg-3 col-xl-2">
                <div class="table-box <?= $t['table_status'] === 'occupied' ? 'occupied' : 'empty' ?>">
                    <div>
                        <div class="d-flex justify-content-between align-items-center mb-1">
                            <h6 class="fw-bold mb-0"><?= $t['table_number'] ?></h6>
                            <span
                                class="badge <?= $t['table_status'] === 'occupied' ? 'bg-danger' : 'bg-secondary' ?> rounded-pill">
                                <?= $t['table_status'] === 'occupied' ? 'Có khách' : 'Trống' ?>
                            </span>
                        </div>

                        <?php if($t['table_status'] === 'occupied'): ?>
                        <small
                            class="text-danger fw-bold d-block"><?= number_format($t['total_price'], 0, ',', '.') ?>đ</small>
                        <small class="text-muted" style="font-size: 0.75rem;">
                            <i class="fa-regular fa-clock"></i> Ngồi: <?= $t['minutes_seated'] ?> phút
                        </small>
                        <?php else: ?>
                        <small class="text-muted" style="font-size: 0.8rem;">Sẵn sàng đón khách</small>
                        <?php endif; ?>
                    </div>

                    <?php if($t['table_status'] === 'occupied'): ?>
                    <form action="index.php?action=clearTable" method="POST" class="mt-2"
                        onsubmit="return confirm('Xác nhận dọn dẹp và TRẢ BÀN NÀY VỀ TRỐNG?')">
                        <input type="hidden" name="order_id" value="<?= $t['order_id'] ?>">
                        <input type="hidden" name="table_id" value="<?= $t['table_id'] ?>">
                        <button type="submit" class="btn btn-sm btn-outline-danger w-100 rounded-pill fw-bold">
                            <i class="fa-solid fa-broom me-1"></i> Trả bàn
                        </button>
                    </form>
                    <?php endif; ?>
                </div>
            </div>
            <?php endforeach; ?>
        </div>
    </div>

</body>

</html>