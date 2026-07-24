<?php
$title = 'Tambah Data User';
require 'koneksi.php';

if (isset($_POST['btn-simpan'])) {
    $username = $_POST['username'];
    $id_staff = $_POST['id_staff'];
    $pass = md5($_POST['password']);

    $role = $_POST['role'];



    $query = "INSERT INTO user (username, id_staff, password, role) values ('$username', '$id_staff', '$pass', '$role')";

    $insert = mysqli_query($conn, $query);
    if ($insert == 1) {
        $_SESSION['msg'] = 'Berhasil menambahkan user baru';
        header('location:user.php?');
    } else {
        $_SESSION['msg'] = 'Gagal menambahkan data baru!!!';
        header('location: staff.php');
    }
}

$staff = "SELECT s.id_staff, s.nama from staff s where status = 'Aktif' AND s.id_staff NOT IN (SELECT u.id_staff from user u where u.id_staff = s.id_staff) ";
$ha = mysqli_query($conn, $staff);
require 'header.php';
?>
<div class="content">
    <div class="page-inner">
    <?php if (isset($_SESSION['msg']) && $_SESSION['msg'] <> '') { ?>
            <div class="alert alert-danger" role="alert" id="msg">
                <?= $_SESSION['msg']; ?>
            </div>
        <?php }
        $_SESSION['msg'] = ''; ?>
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
                    <a href="user.php">User</a>
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
                                    <label for="largeInput">Username</label>
                                    <input type="text" name="username" class="form-control form-control" id="defaultInput"  placeholder="Username..." required>
                                </div>
                                <div class="form-group">
                                    <label for="largeInput">Staff</label>
                                    <select id="trans" name="id_staff" class="form-control form-control" required>
                                    <option disable selected>Pilih Staff</option>
                                <?php
                                if (mysqli_num_rows($ha) > 0) {
                                    while ($paket = mysqli_fetch_assoc($ha)) {
                                ?>
                                        <option value="<?=$paket['id_staff']?>"><?=$paket['nama']?></option>
                                <?php }
                                } ?>
                                </select>
                                </div>
                                <div class="form-group">
                                    <label for="alamat">Password</label>
                                    <input type="password" name="password" class="form-control form-control" id="defaultInput"  placeholder="Password" required>
                                </div>

                                <div class="form-group">
                                    <label for="largeInput">Role</label>
                                    <select name="role" class="form-control form-control" id="defaultSelect">
                                    <option disable selected>Pilih Role</option>
                                    <option value="admin">Admin</option>
                                    <option value="kasir">Kasir</option>
                                </select>
                                </div>
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