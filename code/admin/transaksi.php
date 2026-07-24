<?php
$title = 'Transaksi';
require 'koneksi.php';

$query_resi = "SELECT r.*, c.nama, c.id_costumer as cust FROM resi r INNER JOIN costumer c ON c.id_costumer = r.id_costumer ";
$resi = mysqli_query($conn, $query_resi);

require 'header.php';
?>

<div class="panel-header bg-info-gradient">
    <div class="page-inner py-5">
    <?php if (isset($_SESSION['msg']) && $_SESSION['msg'] <> '') { ?>
            <div class="alert alert-success" role="alert" id="msg">
                <?= $_SESSION['msg']; ?>
            </div>
        <?php }
        $_SESSION['msg'] = ''; ?>
        <div class="d-flex align-items-left align-items-md-center flex-column flex-md-row">

            <div class="d-flex align-items-center">
                       <a href="tambah_resi.php" class="btn btn-primary btn-round ml-auto">
                            <i class="fa fa-plus"></i>
                            Tambah Resi
                        </a>
            </div>
        </div>
    </div>
</div>
<div class="page-inner mt--5">
<div class="row">
    <?php
    $no = 1;
    if (mysqli_num_rows($resi) > 0) {
        while ($paket = mysqli_fetch_assoc($resi)) {
        ?>
        <div class="card card-default" style="width: 20rem; margin: 5px">
          <div class="card-body">
            <h5 class="card-title">Resi <?= $paket['no_resi']; ?></h5>
            <p class="card-text">Costumer : <?= $paket['nama']; ?></p>
            <p class="card-text">Waktu    : <?= $paket['wkt_transaksi']; ?></p>
            <a href="resi.php?id=<?= $paket['no_resi']; ?>" class="btn btn-primary">Detail</a>
            <a href="up_resi.php?id=<?= $paket['cust']; ?>" class="btn btn-primary">Edit</a>
            <a href="del_resi.php?id=<?= $paket['no_resi']; ?>" class="btn btn-danger" onclick="return confirm('Yakin hapus data?');">Delete</a>
          </div>
        </div>
            <?php }
            }
            ?>
    </div>
</div>

<?php require 'footer.php'; ?>