<?php
$title = 'Data Costumer';
require 'koneksi.php';

$query = "SELECT * FROM data_costumer";
$data = mysqli_query($conn, $query);



require 'header.php';
?>
<div class="panel-header bg-primary-gradient">
    <div class="page-inner py-5">
    <div class="d-flex align-items-left align-items-md-center flex-column flex-md-row">
    <div>

    <?php if (isset($_SESSION['msg']) && $_SESSION['msg'] <> '') { ?>
            <div class="alert alert-success" role="alert" id="msg">
                <?= $_SESSION['msg']; ?>
            </div>
        <?php }
        $_SESSION['msg'] = ''; ?>
        </div>
        </div>
        <div class="d-flex align-items-left align-items-md-center flex-column flex-md-row">
            <div>
                <h3 class="text-white pb-2 fw-bold"><?= $title ?></h3>
            </div>
        </div>
    </div>
</div>
<div class="page-inner mt--5">
    <diva class="row">
        <div class="col-md-12">
            <div class="card card-default">
                <div class="card-header">
                    <div class="d-flex align-items-center">
                    <div class="dropdown">


                    </div>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table id="basic-datatables" class="display table table-striped table-hover">
                            <thead>
                                <tr>
                                    <th style="width: 7%">#</th>
                                    <th>ID Costumer</th>
                                    <th>Nama Costumer</th>
                                    <th>No Resi</th>
                                    <th>Total</th>
                                    <th>Cash</th>
                                    <th>Waktu Transaksi</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php
                                $no = 1;
                                if (mysqli_num_rows($data) > 0) {
                                    while ($paket = mysqli_fetch_assoc($data)) {
                                ?>
                                        <tr>
                                            <td><?= $no++; ?></td>
                                            <td><?= $paket['id_costumer']; ?></td>
                                            <td><?= $paket['Nama_cust']; ?></td>
                                            <td><?= $paket['no_resi']; ?></td>
                                            <td><?= 'Rp ' . number_format($paket['Total']); ?></td>
                                            <td><?= 'Rp ' . number_format($paket['Cash']); ?></td>
                                            <td><?= $paket['Waktu_transaksi']; ?></td>

                                        </tr>
                                <?php }
                                }
                                ?>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

</div>
</div>
<?php
require 'footer.php';
?>