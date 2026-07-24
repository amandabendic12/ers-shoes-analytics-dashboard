<?php
$title = 'Data Produk';
require 'koneksi.php';

$query = "SELECT * FROM log_resi WHERE ket = 'Update' ORDER BY waktu DESC";

$data = mysqli_query($conn, $query);

require 'header.php';
?>

<div class="panel-header bg-primary-gradient">
    <div class="page-inner py-5">
        <div class="d-flex align-items-left align-items-md-center flex-column flex-md-row">
            <div>
                <h2 class="text-white pb-2 fw-bold"><a href="log.php">Log</a></h2>
            </div>
        </div>
        <?php if (isset($_SESSION['msg']) && $_SESSION['msg'] <> '') { ?>
            <div class="alert alert-success" role="alert" id="msg">
                <?= $_SESSION['msg']; ?>
            </div>
        <?php }
        $_SESSION['msg'] = ''; ?>
    </div>
</div>
<div class="page-inner mt--5">
    <div class="row">
        <div class="col-md-12">
            <div class="card card-default">
                <div class="card-header">
                    <div class="d-flex align-items-center">
                        <h4 class="card-title">Log transaksi resi</h4>

                    </div>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table id="basic-datatables" class="display table table-striped table-hover">
                            <thead>
                                <tr>
                                    <th style="width: 7%">#</th>
                                    <th>No Resi</th>
                                    <th>Waktu Transaksi</th>
                                    <th>Costumer</th>
                                    <th>Kasir</th>
                                    <th>Total</th>
                                    <th>Bayar</th>
                                    <th>Waktu</th>

                                </tr>
                            </thead>
                            <tbody>
                                <?php
                                $no = 1;
                                if (mysqli_num_rows($data) > 0) {
                                    while ($paket = mysqli_fetch_assoc($data)) {
                                ?>
                                <tr>
                                        <div class="form-button-action">
                                            <td><?=$no++; ?></td>
                                            <td><?= $paket['no_resi']; ?></td>
                                            <td><?= $paket['wkt_transaksi']; ?></td>
                                            <td><?= $paket['costumer']; ?></td>
                                            <td><?= $paket['kasir']; ?></td>
                                            <td><?= 'Rp ' . number_format($paket['total']); ?></td>
                                            <td><?= 'Rp ' . number_format($paket['bayar']); ?></td>
                                            <td><?= $paket['waktu']; ?></td>
                                                </div>

                                        </tr>
                                <?php }
                                }
                                ?>
                            </tbody>
                        </table>
                        <a href="javascript:void(0)" onclick="window.history.back();" class="btn btn-primary btn-round">Back</a>

                    </div>
                </div>
            </div>
        </div>

</div>
</div>
<?php
require 'footer.php';
?>