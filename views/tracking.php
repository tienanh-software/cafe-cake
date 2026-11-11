<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>Theo Dõi Đơn Hàng - Babo Coffee</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
    body {
        background-color: #f7f7f8;
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
        padding-bottom: 30px;
    }

    .buzzer-box {
        background: #212529;
        color: #fff;
        border-radius: 24px;
        padding: 30px 20px;
        text-align: center;
        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
        position: relative;
        overflow: hidden;
    }

    .buzzer-number {
        font-size: 3.5rem;
        font-weight: 800;
        color: #ffc107;
        line-height: 1;
        letter-spacing: -1px;
    }

    /* Step Tracker */
    .step-timeline {
        list-style: none;
        padding: 0;
        position: relative;
    }

    .step-item {
        display: flex;
        align-items: flex-start;
        margin-bottom: 25px;
        position: relative;
    }

    .step-item:not(:last-child)::before {
        content: '';
        position: absolute;
        left: 17px;
        top: 36px;
        bottom: -22px;
        width: 2px;
        background: #dee2e6;
    }

    .step-item.active:not(:last-child)::before {
        background: #ffc107;
    }

    .step-icon {
        width: 36px;
        height: 36px;
        border-radius: 50%;
        background: #e9ecef;
        color: #adb5bd;
        display: flex;
        align-items: center;
        justify-content: center;
        margin-right: 15px;
        font-size: 0.95rem;
        z-index: 2;
    }

    .step-item.active .step-icon {
        background: #212529;
        color: #ffc107;
        box-shadow: 0 0 0 4px rgba(255, 193, 7, 0.25);
    }

    .step-item.completed .step-icon {
        background: #198754;
        color: #fff;
    }

    .pulse-anim {
        animation: pulse 1.5s infinite;
    }

    @keyframes pulse {
        0% {
            transform: scale(0.95);
            opacity: 0.8;
        }

        50% {
            transform: scale(1.05);
            opacity: 1;
        }

        100% {
            transform: scale(0.95);
            opacity: 0.8;
        }
    }
    </style>
</head>

<body>

    <header class="bg-dark text-white px-3 py-2 shadow-sm d-flex justify-content-between align-items-center">
        <a href="index.php" class="fw-bold text-warning fs-5 text-decoration-none">Babo Coffee</a>
        <a href="index.php" class="btn btn-sm btn-outline-light rounded-pill px-3">
            <i class="fa-solid fa-house me-1"></i> Trang chủ
        </a>
    </header>

    <main class="container px-3 mt-3" style="max-width: 500px;">
        <!-- Thẻ rung số thứ tự -->
        <div class="buzzer-box mb-4">
            <p class="text-uppercase text-secondary fw-semibold mb-1" style="font-size: 0.8rem; letter-spacing: 1px;">
                <?= $order['order_type'] === 'takeaway' ? 'Số Thứ Tự Nhận Món' : 'Vị Trí Phục Vụ' ?>
            </p>
            <div class="buzzer-number my-2 pulse-anim" id="display-number">
                <?= $order['order_type'] === 'takeaway' ? '#' . str_pad($order['pickup_number'], 2, '0', STR_PAD_LEFT) : 'BÀN ' . $order['table_id'] ?>
            </div>
            <span class="badge bg-warning text-dark px-3 py-1 rounded-pill fw-bold" id="badge-status">
                <?= strtoupper($order['order_status']) ?>
            </span>
            <div class="mt-3 text-muted small">Mã đơn: <strong class="text-white"><?= $order['order_code'] ?></strong>
            </div>
        </div>

        <!-- Trạng thái 4 bước chuyên nghiệp -->
        <div class="card border-0 rounded-4 shadow-sm p-4 mb-3 bg-white">
            <h6 class="fw-bold text-dark mb-4"><i class="fa-solid fa-clock-rotate-left me-2 text-warning"></i>Tiến độ
                thực hiện</h6>

            <ul class="step-timeline mb-0">
                <li class="step-item <?= in_array($order['order_status'], ['pending','confirmed','preparing','ready','completed']) ? 'completed' : '' ?>"
                    id="step-1">
                    <div class="step-icon"><i class="fa-solid fa-check"></i></div>
                    <div>
                        <h6 class="fw-bold mb-0 text-dark fs-6">Đã Nhận Đơn</h6>
                        <small class="text-muted">Quán đã ghi nhận yêu cầu của bạn</small>
                    </div>
                </li>

                <li class="step-item <?= in_array($order['order_status'], ['preparing','ready','completed']) ? ($order['order_status'] === 'preparing' ? 'active' : 'completed') : '' ?>"
                    id="step-2">
                    <div class="step-icon"><i class="fa-solid fa-mug-hot"></i></div>
                    <div>
                        <h6 class="fw-bold mb-0 text-dark fs-6">Đang Pha Chế</h6>
                        <small class="text-muted">Barista đang chuẩn bị đồ uống</small>
                    </div>
                </li>

                <li class="step-item <?= in_array($order['order_status'], ['ready','completed']) ? ($order['order_status'] === 'ready' ? 'active' : 'completed') : '' ?>"
                    id="step-3">
                    <div class="step-icon"><i class="fa-solid fa-bell"></i></div>
                    <div>
                        <h6 class="fw-bold mb-0 text-dark fs-6">Món Đã Sẵn Sàng</h6>
                        <small
                            class="text-muted"><?= $order['order_type'] === 'takeaway' ? 'Mời bạn tới quầy nhận nước' : 'Nhân viên đang mang ra bàn' ?></small>
                    </div>
                </li>

                <li class="step-item <?= $order['order_status'] === 'completed' ? 'completed' : '' ?>" id="step-4">
                    <div class="step-icon"><i class="fa-solid fa-circle-check"></i></div>
                    <div>
                        <h6 class="fw-bold mb-0 text-dark fs-6">Hoàn Tất</h6>
                        <small class="text-muted">Chúc bạn thưởng thức ngon miệng!</small>
                    </div>
                </li>
            </ul>
        </div>
    </main>

    <!-- Real-time Polling Script (Tự động cập nhật không cần F5) -->
    <script>
    const orderCode = '<?= $order['order_code'] ?>';
    let currentStatus = '<?= $order['order_status'] ?>';

    function checkStatus() {
        fetch(`index.php?action=apiTrackingStatus&code=${orderCode}`)
            .then(res => res.json())
            .then(response => {
                if (response.success && response.data) {
                    const newStatus = response.data.order_status;
                    if (newStatus !== currentStatus) {
                        if (newStatus === 'ready') {
                            navigator.vibrate && navigator.vibrate([200, 100, 200]);
                            alert("🔔 TING TING! Món nước của bạn đã làm xong rồi nhé!");
                        }
                        location.reload(); // Tự reload để đổi màu các bước
                    }
                }
            })
            .catch(err => console.log(err));
    }

    // Cứ mỗi 3 giây hỏi server 1 lần
    setInterval(checkStatus, 3000);
    </script>
</body>

</html>