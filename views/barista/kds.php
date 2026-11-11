<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Barista KDS - Babo Coffee</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
    body {
        background: #121416;
        color: #fff;
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
    }

    .kds-card {
        background: #212529;
        border-radius: 16px;
        border: 2px solid #343a40;
        overflow: hidden;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
        height: 100%;
    }

    .kds-card.takeaway {
        border-color: #ffc107;
    }

    .kds-header {
        background: #2c3036;
        padding: 12px 16px;
    }

    .kds-header.takeaway {
        background: #3d3416;
    }

    .item-row {
        border-bottom: 1px dashed #343a40;
        padding: 10px 0;
    }

    .options-tag {
        background: #343a40;
        color: #ffc107;
        font-size: 0.8rem;
        padding: 2px 8px;
        border-radius: 6px;
    }
    </style>
</head>

<body class="p-3">

    <div class="d-flex justify-content-between align-items-center mb-3 pb-2 border-bottom border-secondary">
        <div class="d-flex align-items-center gap-3">
            <h4 class="fw-bold text-warning mb-0"><i class="fa-solid fa-fire me-2"></i>BARISTA KDS</h4>
            <span class="badge bg-warning text-dark fs-6 rounded-pill px-3"><?= count($activeOrders) ?> Đơn cần
                làm</span>
        </div>
        <div>
            <span class="text-secondary small me-3"><i class="fa-solid fa-rotate me-1"></i>Tự động cập nhật mỗi
                4s</span>
            <a href="index.php?action=floorMap" class="btn btn-sm btn-outline-light rounded-pill px-3">Sang Thu Ngân</a>
        </div>
    </div>

    <div class="row g-3">
        <?php if(!empty($activeOrders)): ?>
        <?php foreach($activeOrders as $order): ?>
        <div class="col-12 col-md-6 col-lg-4 col-xl-3">
            <div class="kds-card <?= $order['order_type'] === 'takeaway' ? 'takeaway' : '' ?>">
                <div>
                    <div
                        class="kds-header d-flex justify-content-between align-items-center <?= $order['order_type'] === 'takeaway' ? 'takeaway' : '' ?>">
                        <div>
                            <h5 class="fw-bold mb-0 text-white">
                                <?= $order['order_type'] === 'takeaway' ? '<span class="text-warning">MANG ĐI #' . $order['pickup_number'] . '</span>' : 'BÀN ' . $order['table_number'] ?>
                            </h5>
                            <small class="text-secondary"><?= $order['order_code'] ?></small>
                        </div>
                        <span class="badge bg-danger rounded-pill px-2 py-1">
                            <i class="fa-regular fa-clock me-1"></i><?= $order['waiting_minutes'] ?>p
                        </span>
                    </div>

                    <div class="p-3">
                        <?php if(!empty($order['note'])): ?>
                        <div class="alert alert-warning py-1 px-2 mb-2 small fw-bold">
                            <i class="fa-solid fa-triangle-exclamation me-1"></i><?= htmlspecialchars($order['note']) ?>
                        </div>
                        <?php endif; ?>

                        <?php foreach($order['items'] as $item): ?>
                        <div class="item-row d-flex justify-content-between align-items-start">
                            <div>
                                <div class="fw-bold text-white fs-6"><?= htmlspecialchars($item['product_name']) ?>
                                </div>
                                <?php if(!empty($item['options_note'])): ?>
                                <div class="options-tag mt-1 d-inline-block">
                                    <?= htmlspecialchars($item['options_note']) ?>
                                </div>
                                <?php endif; ?>
                            </div>
                            <span
                                class="badge bg-light text-dark fs-6 rounded-pill px-2">x<?= $item['quantity'] ?></span>
                        </div>
                        <?php endforeach; ?>
                    </div>
                </div>

                <div class="p-3 pt-0">
                    <form action="index.php?action=markReady" method="POST">
                        <input type="hidden" name="order_id" value="<?= $order['id'] ?>">
                        <button type="submit" class="btn btn-warning w-100 fw-bold py-2 rounded-pill shadow-sm">
                            <i class="fa-solid fa-check me-2"></i>ĐÃ XONG MÓN
                        </button>
                    </form>
                </div>
            </div>
        </div>
        <?php endforeach; ?>
        <?php else: ?>
        <div class="col-12 py-5 text-center text-secondary">
            <i class="fa-solid fa-mug-saucer fs-1 mb-3 text-secondary"></i>
            <h5>Hiện tại đã hết đơn, Barista nghỉ tay nhé!</h5>
        </div>
        <?php endif; ?>
    </div>

    <!-- Tự động load lại đơn mới mỗi 4 giây -->
    <script>
    setTimeout(() => {
        location.reload();
    }, 4000);
    </script>
</body>

</html>