<?php
$title = 'Update jumlah beli';
require 'koneksi.php';
$id_resi = $_GET['resi'];
$id_sep = $_GET['id'];


if (isset($_POST['btn-update'])) {
    $qty = $_POST['qty'];

    $cek = mysqli_query($conn, "SELECT qty from transaksi where id_transaksi = '$id_sep'");
$belis = mysqli_fetch_array($cek);
$beli = $belis['qty'];

    $cek = mysqli_query($conn, "SELECT p.qty from produk p join transaksi t
    on p.id_produk = t.id_produk where t.id_transaksi = '$id_sep'");
    $stoks = mysqli_fetch_array($cek);
    $stok = $stoks['qty'];


    $old_stok = $stok + $beli;

    // $set1 = $old_stok + ABS($beli - $qty);
    // $set2 = $old_stok - ABS($qty - $beli);

    if($beli >= $qty)
    {
    $query = "UPDATE transaksi set qty = '$qty' WHERE id_transaksi = '$id_sep'";
    $update = mysqli_query($conn, $query);
   if ($update == 1) {
       $_SESSION['msg'] = 'Berhasil Update data';
       header("location:resi.php?id=$id_resi");
   } else {
       echo "<div class='alert alert-danger>Gagal Update Data!!!</div>";
       $_SESSION['msg'] = 'Gagal mengupdate data!!!';
       header("location:resi.php?id=$id_resi");
   }
    }
   else if($beli <= $qty && $old_stok >= $qty){

    $query = "UPDATE transaksi set qty = '$qty' WHERE id_transaksi = '$id_sep'";
    $update = mysqli_query($conn, $query);
   if ($update == 1) {
       $_SESSION['msg'] = 'Berhasil Update data';
       header("location:resi.php?id=$id_resi");
   } else {
       echo "<div class='alert alert-danger>Gagal Update Data!!!</div>";
       $_SESSION['msg'] = 'Gagal mengupdate data!!!';
       header("location:resi.php?id=$id_resi");
   }
} else {
    echo "<script
    type='text/jscript'>alert('Jumlah stok tidak tersedia.')</script>";
    }
}


$sepatu = "SELECT id_produk from produk ";
$data = mysqli_query($conn, $sepatu);
require 'header.php';
?> -->
<script>
    </script>
<div class="content">
    <div class="page-inner">
        <div class="page-header">
            <h4 class="page-title">Ubah jumlah beli</h4>
            <ul class="breadcrumbs">
                <li class="nav-home">
                    <a href="index.php">
                        <i class="flaticon-home"></i>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="pelanggan.php">Resi</a>
                </li>
                <li class="separator">
                    <i class="flaticon-right-arrow"></i>
                </li>
                <li class="nav-item">
                    <a href="#"><?= $title; ?></a>
                </li>
            </ul>
        </div>
        <div class="row">
            <div class="col-md-10">
                <div class="card card-default">
                    <div class="card-header">
                        <div class="card-title"><?= $title; ?></div>
                    </div>
                    <form action="" method="POST">
                        <div class="card-body">
                            <label for="largeInput">Jumlah</label>
                                <input type="number" name="qty" class="form-control form-control" id="defaultInput" placeholder="Jumlah barang...">
                            <div class="form-group" id="formtrans">
                            </div>
                            <div class="card-action">
                                <button type="submit" name="btn-update" class="btn btn-success">Update</button>
                                <a href="javascript:void(0)" onclick="window.history.back();" class="btn btn-danger">Batal</a>
                            </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<?php require 'footer.php'; ?>