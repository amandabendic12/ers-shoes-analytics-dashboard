<?php
$title = 'Tambah Data Staff';
require 'koneksi.php';

if (isset($_POST['btn-simpan'])) {
    $nama = $_POST['nama'];
    $alamat = $_POST['alamat'];
    $email = $_POST['email'];
    $telepon = $_POST['telepon'];
    $tgl_lahir = $_POST['tgl_lahir'];
    $status = $_POST['status'];
    $kelamin = $_POST['kelamin'];
    $query = "INSERT INTO staff (nama, alamat, email, telepon,tgl_lahir, kelamin,status) values ('$nama', '$alamat', '$email', '$telepon','$tgl_lahir', '$kelamin','$status')";

    $insert = mysqli_query($conn, $query);
    if ($insert == 1) {
        $_SESSION['msg'] = 'Berhasil menambahkan staff baru';
        header('location:staff.php?');
    } else {
        $_SESSION['msg'] = 'Gagal menambahkan data baru!!!';
        header('location: staff.php');
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
                    <a href="pelanggan.php">Staff</a>
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
                                    <label for="largeInput">Nama Staff</label>
                                    <input type="text" name="nama" class="form-control form-control" id="defaultInput"  placeholder="Nama...">
                                </div>
                                <div class="form-group">
                                    <label for="largeInput">Email Staff</label>
                                    <input type="email" name="email" class="form-control form-control" id="defaultInput" placeholder="Email...">
                                </div>
                                <div class="form-group">
                                    <label for="alamat">Alamat Staff</label>
                                    <textarea class="form-control" rows="5" name="alamat"></textarea>
                                </div>
                                <div class="form-group">
                                    <label for="largeInput">Tanggal Lahir Staff</label>
                                    <input type="date" name="tgl_lahir" class="form-control form-control" id="defaultInput"  placeholder="Tanggal lahir">
                                </div>
                                <div class="form-group">
                                    <label for="largeInput">No Telepon</label>
                                    <input type="tel" name="telepon" class="form-control form-control" id="defaultInput"  placeholder="No Telp...">
                                </div>
                                <div class="form-group">
                                <label for="defaultSelect">Jenis Kelamin</label>
                                <select name="kelamin" class="form-control form-control" id="defaultSelect">
                                    <option value="L">Laki-laki</option>
                                    <option value="P">Perempuan</option>
                                </select>
                                <label for="defaultSelect">Status</label>
                                <select name="status" class="form-control form-control" id="defaultSelect">
                                    <option value="Aktif">Aktif</option>
                                    <option value="Tidak aktif">Tidak Aktif</option>
                                </select>
                            </div>
                            <div class="card-action">
                                <button type="submit" name="btn-simpan" class="btn btn-success">Submit</button>
                                <!-- <button class="btn btn-danger">Cancel</button> -->
                                <a href="javascript:void(0)" onclick="window.history.back();" class="btn btn-danger">Batal</a>
                            </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<?php require 'footer.php'; ?>