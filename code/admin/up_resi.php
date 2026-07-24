<?php
$title = 'Edit Resi';
require 'koneksi.php';

$id = $_GET['id'];

if (isset($_POST['btn-up'])) {

    $nama = $_POST['nama'];
    $query_cust = "UPDATE costumer SET nama = '$nama' where id_costumer = '$id'";

    $insert = mysqli_query($conn, $query_cust);

    if ($insert == 1) {
        $_SESSION['msg'] = 'Berhasil mengubah nama costumer';
        header('location: transaksi.php');
    } else {
        $_SESSION['msg'] = 'Gagal menambahkan data baru!!!';
        header('location: transaksi.php');
    }
 }

 $query = "SELECT nama FROM costumer where id_costumer = '$id'";
 $in = mysqli_query($conn, $query);


require 'header.php';
?>
<script>
    </script>
<div class="content">
    <div class="page-inner">
        <div class="page-header">
            <h4 class="page-title">Resi</h4>
            <ul class="breadcrumbs">
                <li class="nav-home">
                    <a href="index.php">
                        <i class="flaticon-home"></i>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="transaksi.php">Resi</a>
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
                    <?php while ($edit = mysqli_fetch_array($in)) {
                    ?>
                    <form action="" method="POST">
                        <div class="card-body">
                            <div class="form-group">
                                <label for="largeInput">Nama Pelanggan</label>
                                <input type="text" name="nama" value="<?= $edit['nama']; ?>" class="form-control form-control" id="defaultInput" placeholder="Nama...">
                        </div>
                            </div>
                            <div class="card-action">
                                <button type="submit" name="btn-up" class="btn btn-success">Update</button>
                                <a href="javascript:void(0)" onclick="window.history.back();" class="btn btn-danger">Batal</a>
                            </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<?php } ?>
<?php require 'footer.php'; ?>
