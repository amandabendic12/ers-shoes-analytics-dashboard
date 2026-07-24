<?php
$title = 'Dashboard Analytics';
require 'koneksi.php';

function safe_date($value, $fallback) {
    if (!$value) {
        return $fallback;
    }
    return preg_match('/^\d{4}-\d{2}-\d{2}$/', $value) ? $value : $fallback;
}

function fetch_assoc_one($conn, $sql) {
    $result = mysqli_query($conn, $sql);
    if (!$result) {
        return [];
    }
    return mysqli_fetch_assoc($result) ?: [];
}

function fetch_all_rows($conn, $sql) {
    $result = mysqli_query($conn, $sql);
    $rows = [];
    if ($result) {
        while ($row = mysqli_fetch_assoc($result)) {
            $rows[] = $row;
        }
    }
    return $rows;
}

function rupiah($value) {
    return 'Rp ' . number_format((float)$value, 0, ',', '.');
}

function export_csv($filename, $headers, $rows) {
    header('Content-Type: text/csv; charset=utf-8');
    header('Content-Disposition: attachment; filename=' . $filename);
    $output = fopen('php://output', 'w');
    fputcsv($output, $headers);
    foreach ($rows as $row) {
        fputcsv($output, $row);
    }
    fclose($output);
    exit;
}

$range = fetch_assoc_one($conn, "
    SELECT
        COALESCE(DATE(MIN(waktu)), CURDATE()) AS min_date,
        COALESCE(DATE(MAX(waktu)), CURDATE()) AS max_date
    FROM transaksi
    WHERE no_resi IS NOT NULL
");
$default_start = $range['min_date'] ?? date('Y-m-d');
$default_end = $range['max_date'] ?? date('Y-m-d');

$start_date = safe_date($_GET['start_date'] ?? '', $default_start);
$end_date = safe_date($_GET['end_date'] ?? '', $default_end);

$start_sql = mysqli_real_escape_string($conn, $start_date);
$end_sql = mysqli_real_escape_string($conn, $end_date);
$sales_filter = "t.no_resi IS NOT NULL AND DATE(t.waktu) BETWEEN '$start_sql' AND '$end_sql'";

if (isset($_GET['export'])) {
    $export = $_GET['export'];

    if ($export === 'top_products') {
        $rows = fetch_all_rows($conn, "
            SELECT p.id_produk, p.produk, k.nama_kategori, SUM(t.qty) AS qty_terjual,
                   SUM(t.qty * p.harga) AS pendapatan, p.qty AS stok_saat_ini
            FROM transaksi t
            JOIN produk p ON p.id_produk = t.id_produk
            JOIN kategori k ON k.id_kategori = p.kategori
            WHERE $sales_filter
            GROUP BY p.id_produk, p.produk, k.nama_kategori, p.qty
            ORDER BY qty_terjual DESC, pendapatan DESC
            LIMIT 20
        ");
        export_csv('top_produk_terlaris.csv', ['ID Produk', 'Produk', 'Kategori', 'Qty Terjual', 'Pendapatan', 'Stok Saat Ini'], $rows);
    }

    if ($export === 'low_stock') {
        $rows = fetch_all_rows($conn, "
            SELECT p.id_produk, p.produk, k.nama_kategori, p.qty, p.harga, (p.qty * p.harga) AS nilai_stok
            FROM produk p
            JOIN kategori k ON k.id_kategori = p.kategori
            WHERE p.qty <= 5
            ORDER BY p.qty ASC, p.produk ASC
        ");
        export_csv('produk_stok_menipis.csv', ['ID Produk', 'Produk', 'Kategori', 'Qty', 'Harga', 'Nilai Stok'], $rows);
    }

    if ($export === 'category_sales') {
        $rows = fetch_all_rows($conn, "
            SELECT k.nama_kategori, SUM(t.qty) AS qty_terjual, SUM(t.qty * p.harga) AS pendapatan
            FROM transaksi t
            JOIN produk p ON p.id_produk = t.id_produk
            JOIN kategori k ON k.id_kategori = p.kategori
            WHERE $sales_filter
            GROUP BY k.id_kategori, k.nama_kategori
            ORDER BY pendapatan DESC
        ");
        export_csv('penjualan_per_kategori.csv', ['Kategori', 'Qty Terjual', 'Pendapatan'], $rows);
    }

    if ($export === 'monthly_sales') {
        $rows = fetch_all_rows($conn, "
            SELECT DATE_FORMAT(t.waktu, '%Y-%m') AS bulan,
                   SUM(t.qty) AS qty_terjual,
                   COUNT(DISTINCT t.no_resi) AS jumlah_resi,
                   SUM(t.qty * p.harga) AS pendapatan
            FROM transaksi t
            JOIN produk p ON p.id_produk = t.id_produk
            WHERE $sales_filter
            GROUP BY DATE_FORMAT(t.waktu, '%Y-%m')
            ORDER BY bulan ASC
        ");
        export_csv('tren_penjualan_bulanan.csv', ['Bulan', 'Qty Terjual', 'Jumlah Resi', 'Pendapatan'], $rows);
    }
}

$kpi = fetch_assoc_one($conn, "
    SELECT
        COALESCE(SUM(t.qty * p.harga), 0) AS total_pendapatan,
        COALESCE(SUM(t.qty), 0) AS total_qty_terjual,
        COUNT(DISTINCT t.no_resi) AS total_resi,
        COUNT(DISTINCT t.id_produk) AS produk_terjual
    FROM transaksi t
    JOIN produk p ON p.id_produk = t.id_produk
    WHERE $sales_filter
");

$inventory = fetch_assoc_one($conn, "
    SELECT
        COUNT(*) AS total_produk,
        COALESCE(SUM(qty), 0) AS total_stok,
        COALESCE(SUM(qty * harga), 0) AS nilai_persediaan,
        SUM(CASE WHEN qty <= 5 THEN 1 ELSE 0 END) AS stok_menipis
    FROM produk
");

$customer = fetch_assoc_one($conn, "SELECT COUNT(*) AS total_customer FROM costumer");
$avg_receipt = ((float)($kpi['total_resi'] ?? 0) > 0) ? ((float)$kpi['total_pendapatan'] / (float)$kpi['total_resi']) : 0;

$category_sales = fetch_all_rows($conn, "
    SELECT k.nama_kategori AS kategori, COALESCE(SUM(t.qty), 0) AS qty_terjual,
           COALESCE(SUM(t.qty * p.harga), 0) AS pendapatan
    FROM transaksi t
    JOIN produk p ON p.id_produk = t.id_produk
    JOIN kategori k ON k.id_kategori = p.kategori
    WHERE $sales_filter
    GROUP BY k.id_kategori, k.nama_kategori
    ORDER BY pendapatan DESC
");

$monthly_sales = fetch_all_rows($conn, "
    SELECT DATE_FORMAT(t.waktu, '%Y-%m') AS bulan,
           COALESCE(SUM(t.qty), 0) AS qty_terjual,
           COUNT(DISTINCT t.no_resi) AS jumlah_resi,
           COALESCE(SUM(t.qty * p.harga), 0) AS pendapatan
    FROM transaksi t
    JOIN produk p ON p.id_produk = t.id_produk
    WHERE $sales_filter
    GROUP BY DATE_FORMAT(t.waktu, '%Y-%m')
    ORDER BY bulan ASC
");

$top_products = fetch_all_rows($conn, "
    SELECT p.id_produk, p.produk, k.nama_kategori AS kategori,
           SUM(t.qty) AS qty_terjual,
           SUM(t.qty * p.harga) AS pendapatan,
           p.qty AS stok_saat_ini
    FROM transaksi t
    JOIN produk p ON p.id_produk = t.id_produk
    JOIN kategori k ON k.id_kategori = p.kategori
    WHERE $sales_filter
    GROUP BY p.id_produk, p.produk, k.nama_kategori, p.qty
    ORDER BY qty_terjual DESC, pendapatan DESC
    LIMIT 10
");

$low_stock = fetch_all_rows($conn, "
    SELECT p.id_produk, p.produk, k.nama_kategori AS kategori, p.qty, p.harga, (p.qty * p.harga) AS nilai_stok
    FROM produk p
    JOIN kategori k ON k.id_kategori = p.kategori
    WHERE p.qty <= 5
    ORDER BY p.qty ASC, p.produk ASC
    LIMIT 10
");

$stock_by_category = fetch_all_rows($conn, "
    SELECT k.nama_kategori AS kategori,
           SUM(p.qty) AS total_stok,
           SUM(p.qty * p.harga) AS nilai_stok
    FROM produk p
    JOIN kategori k ON k.id_kategori = p.kategori
    GROUP BY k.id_kategori, k.nama_kategori
    ORDER BY nilai_stok DESC
");

$category_labels = array_column($category_sales, 'kategori');
$category_revenue = array_map('floatval', array_column($category_sales, 'pendapatan'));
$category_qty = array_map('intval', array_column($category_sales, 'qty_terjual'));
$month_labels = array_column($monthly_sales, 'bulan');
$month_revenue = array_map('floatval', array_column($monthly_sales, 'pendapatan'));
$top_labels = array_column($top_products, 'produk');
$top_qty = array_map('intval', array_column($top_products, 'qty_terjual'));
$stock_labels = array_column($stock_by_category, 'kategori');
$stock_values = array_map('intval', array_column($stock_by_category, 'total_stok'));

require 'header.php';
?>

<div class="panel-header bg-primary-gradient">
    <div class="page-inner py-5">
        <div class="d-flex align-items-left align-items-md-center flex-column flex-md-row">
            <div>
                <h1 class="text-white pb-2 fw-bold">Dashboard Analytics ERS Shoes</h1>
                <h2 class="text-white op-7 mb-2">Analisis penjualan, persediaan, dan performa produk</h2>
            </div>
        </div>
    </div>
</div>

<div class="page-inner mt--5">
    <div class="card">
        <div class="card-body">
            <form method="GET" class="row align-items-end">
                <div class="col-md-4">
                    <label>Start Date</label>
                    <input type="date" name="start_date" class="form-control" value="<?= htmlspecialchars($start_date) ?>">
                </div>
                <div class="col-md-4">
                    <label>End Date</label>
                    <input type="date" name="end_date" class="form-control" value="<?= htmlspecialchars($end_date) ?>">
                </div>
                <div class="col-md-4">
                    <button class="btn btn-primary btn-block" type="submit">Terapkan Filter</button>
                </div>
            </form>
        </div>
    </div>

    <div class="row">
        <div class="col-sm-6 col-md-3">
            <div class="card card-stats card-round">
                <div class="card-body"><div class="row align-items-center">
                    <div class="col-icon"><div class="icon-big text-center icon-success bubble-shadow-small"><i class="fas fa-money-bill-wave"></i></div></div>
                    <div class="col col-stats ml-3 ml-sm-0"><div class="numbers"><p class="card-category">Total Pendapatan</p><h4 class="card-title"><?= rupiah($kpi['total_pendapatan'] ?? 0) ?></h4></div></div>
                </div></div>
            </div>
        </div>
        <div class="col-sm-6 col-md-3">
            <div class="card card-stats card-round">
                <div class="card-body"><div class="row align-items-center">
                    <div class="col-icon"><div class="icon-big text-center icon-primary bubble-shadow-small"><i class="fas fa-receipt"></i></div></div>
                    <div class="col col-stats ml-3 ml-sm-0"><div class="numbers"><p class="card-category">Total Resi</p><h4 class="card-title"><?= number_format((int)($kpi['total_resi'] ?? 0), 0, ',', '.') ?></h4></div></div>
                </div></div>
            </div>
        </div>
        <div class="col-sm-6 col-md-3">
            <div class="card card-stats card-round">
                <div class="card-body"><div class="row align-items-center">
                    <div class="col-icon"><div class="icon-big text-center icon-info bubble-shadow-small"><i class="fas fa-shopping-bag"></i></div></div>
                    <div class="col col-stats ml-3 ml-sm-0"><div class="numbers"><p class="card-category">Qty Terjual</p><h4 class="card-title"><?= number_format((int)($kpi['total_qty_terjual'] ?? 0), 0, ',', '.') ?></h4></div></div>
                </div></div>
            </div>
        </div>
        <div class="col-sm-6 col-md-3">
            <div class="card card-stats card-round">
                <div class="card-body"><div class="row align-items-center">
                    <div class="col-icon"><div class="icon-big text-center icon-warning bubble-shadow-small"><i class="fas fa-box-open"></i></div></div>
                    <div class="col col-stats ml-3 ml-sm-0"><div class="numbers"><p class="card-category">Produk Stok Menipis</p><h4 class="card-title"><?= number_format((int)($inventory['stok_menipis'] ?? 0), 0, ',', '.') ?></h4></div></div>
                </div></div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-sm-6 col-md-3"><div class="card"><div class="card-body"><p class="card-category">Rata-rata Nilai Resi</p><h3><?= rupiah($avg_receipt) ?></h3></div></div></div>
        <div class="col-sm-6 col-md-3"><div class="card"><div class="card-body"><p class="card-category">Total Produk</p><h3><?= number_format((int)($inventory['total_produk'] ?? 0), 0, ',', '.') ?></h3></div></div></div>
        <div class="col-sm-6 col-md-3"><div class="card"><div class="card-body"><p class="card-category">Total Customer</p><h3><?= number_format((int)($customer['total_customer'] ?? 0), 0, ',', '.') ?></h3></div></div></div>
        <div class="col-sm-6 col-md-3"><div class="card"><div class="card-body"><p class="card-category">Nilai Persediaan</p><h3><?= rupiah($inventory['nilai_persediaan'] ?? 0) ?></h3></div></div></div>
    </div>

    <div class="row">
        <div class="col-md-6">
            <div class="card"><div class="card-header"><div class="card-title">Pendapatan per Kategori</div></div><div class="card-body"><canvas id="categoryRevenueChart"></canvas></div></div>
        </div>
        <div class="col-md-6">
            <div class="card"><div class="card-header"><div class="card-title">Tren Pendapatan Bulanan</div></div><div class="card-body"><canvas id="monthlySalesChart"></canvas></div></div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-6">
            <div class="card"><div class="card-header"><div class="card-title">Top Produk Berdasarkan Qty Terjual</div></div><div class="card-body"><canvas id="topProductsChart"></canvas></div></div>
        </div>
        <div class="col-md-6">
            <div class="card"><div class="card-header"><div class="card-title">Stok Produk per Kategori</div></div><div class="card-body"><canvas id="stockCategoryChart"></canvas></div></div>
        </div>
    </div>

    <div class="row">
        <div class="col-md-7">
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <div class="card-title">Top 10 Produk Terlaris</div>
                    <a class="btn btn-sm btn-success" href="analytics.php?export=top_products&start_date=<?= $start_date ?>&end_date=<?= $end_date ?>">Export CSV</a>
                </div>
                <div class="card-body table-responsive">
                    <table class="table table-striped table-hover">
                        <thead><tr><th>Produk</th><th>Kategori</th><th class="text-right">Qty</th><th class="text-right">Pendapatan</th><th class="text-right">Stok</th></tr></thead>
                        <tbody>
                        <?php foreach ($top_products as $row): ?>
                            <tr>
                                <td><?= htmlspecialchars($row['produk']) ?></td>
                                <td><?= htmlspecialchars($row['kategori']) ?></td>
                                <td class="text-right"><?= number_format((int)$row['qty_terjual'], 0, ',', '.') ?></td>
                                <td class="text-right"><?= rupiah($row['pendapatan']) ?></td>
                                <td class="text-right"><?= number_format((int)$row['stok_saat_ini'], 0, ',', '.') ?></td>
                            </tr>
                        <?php endforeach; ?>
                        <?php if (count($top_products) === 0): ?><tr><td colspan="5" class="text-center">Tidak ada data transaksi pada periode ini.</td></tr><?php endif; ?>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <div class="col-md-5">
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <div class="card-title">Produk Stok Menipis</div>
                    <a class="btn btn-sm btn-success" href="analytics.php?export=low_stock&start_date=<?= $start_date ?>&end_date=<?= $end_date ?>">Export CSV</a>
                </div>
                <div class="card-body table-responsive">
                    <table class="table table-striped table-hover">
                        <thead><tr><th>Produk</th><th>Kategori</th><th class="text-right">Stok</th><th class="text-right">Nilai Stok</th></tr></thead>
                        <tbody>
                        <?php foreach ($low_stock as $row): ?>
                            <tr>
                                <td><?= htmlspecialchars($row['produk']) ?></td>
                                <td><?= htmlspecialchars($row['kategori']) ?></td>
                                <td class="text-right"><span class="badge badge-warning"><?= number_format((int)$row['qty'], 0, ',', '.') ?></span></td>
                                <td class="text-right"><?= rupiah($row['nilai_stok']) ?></td>
                            </tr>
                        <?php endforeach; ?>
                        <?php if (count($low_stock) === 0): ?><tr><td colspan="4" class="text-center">Tidak ada produk stok menipis.</td></tr><?php endif; ?>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div class="card">
        <div class="card-header"><div class="card-title">Insight Ringkas untuk Portofolio Data Analyst</div></div>
        <div class="card-body">
            <ul>
                <li>Dashboard ini mengubah data transaksi dan stok menjadi KPI bisnis seperti pendapatan, produk terlaris, stok menipis, dan nilai persediaan.</li>
                <li>Analisis kategori membantu melihat kategori produk yang paling berkontribusi terhadap penjualan.</li>
                <li>Analisis stok menipis dapat digunakan untuk mendukung keputusan restock dan pengelolaan inventori.</li>
            </ul>
        </div>
    </div>
</div>

<script src="../assets/js/plugin/chart.js/chart.min.js"></script>
<script>
const categoryLabels = <?= json_encode($category_labels) ?>;
const categoryRevenue = <?= json_encode($category_revenue) ?>;
const categoryQty = <?= json_encode($category_qty) ?>;
const monthLabels = <?= json_encode($month_labels) ?>;
const monthRevenue = <?= json_encode($month_revenue) ?>;
const topLabels = <?= json_encode($top_labels) ?>;
const topQty = <?= json_encode($top_qty) ?>;
const stockLabels = <?= json_encode($stock_labels) ?>;
const stockValues = <?= json_encode($stock_values) ?>;

function makeBarChart(canvasId, labels, data, label) {
    new Chart(document.getElementById(canvasId), {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [{ label: label, data: data, backgroundColor: '#1572E8' }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            legend: { display: false },
            scales: { yAxes: [{ ticks: { beginAtZero: true } }] }
        }
    });
}

function makeLineChart(canvasId, labels, data, label) {
    new Chart(document.getElementById(canvasId), {
        type: 'line',
        data: {
            labels: labels,
            datasets: [{ label: label, data: data, borderColor: '#31CE36', backgroundColor: 'rgba(49,206,54,0.15)', fill: true }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: { yAxes: [{ ticks: { beginAtZero: true } }] }
        }
    });
}

document.getElementById('categoryRevenueChart').height = 250;
document.getElementById('monthlySalesChart').height = 250;
document.getElementById('topProductsChart').height = 250;
document.getElementById('stockCategoryChart').height = 250;
makeBarChart('categoryRevenueChart', categoryLabels, categoryRevenue, 'Pendapatan');
makeLineChart('monthlySalesChart', monthLabels, monthRevenue, 'Pendapatan Bulanan');
makeBarChart('topProductsChart', topLabels, topQty, 'Qty Terjual');
makeBarChart('stockCategoryChart', stockLabels, stockValues, 'Total Stok');
</script>

<?php require 'footer.php'; ?>
