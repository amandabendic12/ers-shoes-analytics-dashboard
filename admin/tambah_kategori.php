<?php
$title = 'Tambah Kategori';
require 'koneksi.php';

if (isset($_POST['btn-simpan'])) {
    $kat = $_POST['kategori'];
    $query1 = "INSERT INTO kategori (nama_kategori) values ('$kat')";

    $insert = mysqli_query($conn,$query1);
    if ($insert == 1) {
        $_SESSION['msg'] = 'Berhasil menambahkan kategori';
        header('location:kategori.php?');
    } else {
        $_SESSION['msg'] = 'Gagal menambahkan kategori!!!';
        header('location: kategori.php');
    }
}
$kategori = "SELECT * from kategori";
$data = mysqli_query($conn, $kategori);

require 'header.php';
?>
<div class="content">
    <div class="page-inner">
        <div class="page-header">
            <h4 class="page-title">Forms</h4>
            <ul class="breadcrumbs">
                <li class="nav-home">
                    <a href="index.php">
                        <i class="flaticon-home"></i>
                    </a>
                </li>
                <li class="separator">
                    <i class="flaticon-right-arrow"></i>
                </li>
                <li class="nav-item">
                    <a href="kategori.php">Kategori</a>
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
                        <div class="form-group">
                                <label for="largeInput">Kategori</label>
                                <input type="text" name="kategori" class="form-control form-control" id="defaultInput" placeholder="kategori..." required>
                            </div>
                            <div class="card-action">
                                <button type="submit" name="btn-simpan" class="btn btn-success">Submit</button>
                                <button class="btn btn-danger">Cancel</button>
                                <a href="javascript:void(0)" onclick="window.history.back();" class="btn btn-danger">Batal</a>
                            </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<?php require 'footer.php'; ?>