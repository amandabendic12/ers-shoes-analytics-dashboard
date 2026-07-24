<?php
$title = 'Tambah Data Pelanggan';
require 'koneksi.php';

if (isset($_POST['btn-simpan'])) {
    $nama = $_POST['nama'];
    
    $query = "INSERT INTO costumer (nama) values ('$nama')";

    $insert = mysqli_query($conn, $query);
    if ($insert == 1) {
        $_SESSION['msg'] = 'Berhasil menambahkan pelanggan baru';
        header('location:pelanggan.php?');
    } else {
        $_SESSION['msg'] = 'Gagal menambahkan data baru!!!';
        header('location: pelanggan.php');
    }
}

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
                    <a href="pelanggan.php">Pelanggan</a>
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
                            
                            <div class="form-group" style="color: white;">
                                <label for="largeInput">Nama Pelanggan</label>
                                <input type="text" name="nama" class="form-control form-control" id="defaultInput" placeholder="Nama...">
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