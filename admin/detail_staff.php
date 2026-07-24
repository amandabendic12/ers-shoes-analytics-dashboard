<?php
$title = 'Edit Data pelanggan';
require 'koneksi.php';



$id = $_GET['ids'];
$query = "SELECT * FROM staff WHERE id_staff = '$id'";
$queryedit = mysqli_query($conn, $query);


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
                    <a href="staff.php">Staff</a>
                </li>
                <li class="separator">
                    <i class="flaticon-right-arrow"></i>
                </li>
                <li class="nav-item">
                    <a href="#">Detail Staff</a>
                </li>
            </ul>
        </div>
        <div class="row">
            <div class="col-md-10">
                <div class="card card-default">
                    <div class="card-header">
                    <div id="display-image">
    <?php
        $query = " SELECT pas_poto from staff where id_staff = '$id'";
        $result = mysqli_query($conn, $query);

        while ($data = mysqli_fetch_assoc($result)) {
    ?>
        <img src="../image/<?php echo $data['pas_poto']; ?> " style = "width: 354px; height: 472px">

    <?php
        }
    ?>
    </div>
                    </div>
                    <?php while ($edit = mysqli_fetch_array($queryedit)) {
                    ?>
                        <form action="" method="POST">
                            <div class="card-body">

                                <div class="form-group">
                                    <label for="largeInput">Nama Staff</label>
                                    <input type="text" name="nama" class="form-control form-control" readonly="readonly" id="defaultInput" value="<?= $edit['nama']; ?>" placeholder="Nama...">
                                </div>
                                <div class="form-group">
                                    <label for="largeInput">Email Staff</label>
                                    <input type="text" name="email" class="form-control form-control" readonly="readonly" id="defaultInput" value="<?= $edit['email']; ?>" placeholder="Email...">
                                </div>
                                <div class="form-group">
                                    <label for="alamat">Alamat Staff</label>
                                    <textarea class="form-control" readonly="readonly" rows="5" name="alamat"><?= $edit['alamat']; ?></textarea>
                                </div>
                                <div class="form-group">
                                    <label for="largeInput">Tanggal Lahir Staff</label>
                                    <input type="date" name="tgl_lahir" readonly="readonly" class="form-control form-control" id="defaultInput" value="<?= $edit['tgl_lahir']; ?>" placeholder="Tanggal lahir">
                                </div>
                                <div class="form-group">
                                    <label for="largeInput">No Telepon</label>
                                    <input type="text" name="telepon" readonly="readonly" class="form-control form-control" id="defaultInput" value="<?= $edit['telepon']; ?>" placeholder="No Telp...">
                                </div>
                                <div class="form-group">
                                    <label for="largeInput">Kelamin</label>
                                    <input type="text" name="kelamin" readonly="readonly" class="form-control form-control" id="defaultInput" value="<?= $edit['kelamin']; ?>" placeholder="Kelamin...">
                                </div>
                                <div class="form-group">
                                    <label for="largeInput">Status</label>
                                    <input type="text" name="status" readonly="readonly" class="form-control form-control" id="defaultInput" value="<?= $edit['status']; ?>" placeholder="Status...">
                                </div>

                        </form>
                </div>
            </div>
        </div>
    </div>
</div>
<?php } ?>
<?php require 'footer.php';
