<?php
$title = 'Data Toko';
require 'koneksi.php';


$query = "SELECT * FROM toko";
$queryedit = mysqli_query($conn, $query);

if (isset($_POST['btn-simpan'])) {
    $nama = $_POST['nama'];
    $alamat = $_POST['alamat'];
    $telepon = $_POST['no_telp'];
    $pemilik = $_POST['pemilik'];

    $query = "UPDATE toko SET toko = '$nama', alamat = '$alamat', no_telp = '$telepon', pemilik = '$pemilik' WHERE id_toko = 1";
    $update = mysqli_query($conn, $query);
    if ($update == 1) {
        $_SESSION['msg'] = 'Berhasil mengubah data toko';
        header("location: toko.php");
    } else {
        $_SESSION['msg'] = 'Gagal mengubah data!!!';
        header("location:toko.php");
    }
}
require 'header.php';
?>
<div class="content">
    <div class="page-inner">
    <?php if (isset($_SESSION['msg']) && $_SESSION['msg'] <> '') { ?>
            <div class="alert alert-success" role="alert" id="msg">
                <?= $_SESSION['msg']; ?>
            </div>
        <?php }
        $_SESSION['msg'] = ''; ?>
        <div class="page-header">

        </div>
        <div class="row">
            <div class="col-md-10">
                <div class="card card-default">
                    <div class="card-header">
                        <div class="card-title"><?= $title; ?></div>
                    </div>
                    <?php while ($edit = mysqli_fetch_array($queryedit)) {
                    ?>
                        <form action="" method="POST">
                            <div class="card-body">
                                <div class="form-group">
                                    <label for="largeInput">Nama Toko</label>
                                    <input type="text" name="nama" class="form-control form-control" id="defaultInput" value="<?= $edit['toko']; ?>" placeholder="Nama...">
                                </div>
                                <div class="form-group">
                                    <label for="alamat">Alamat</label>
                                    <textarea class="form-control" rows="5" name="alamat"><?= $edit['alamat']; ?></textarea>
                                </div>
                                <div class="form-group">
                                    <label for="largeInput">No Telp</label>
                                    <input type="tel" name="no_telp" class="form-control form-control" id="defaultInput" value="<?= $edit['no_telp']; ?>" placeholder="Telepon...">
                                </div>
                                <div class="form-group">
                                    <label for="largeInput">Pemilik</label>
                                    <input type="text" name="pemilik" class="form-control form-control" id="defaultInput" value="<?= $edit['pemilik']; ?>" placeholder="Pemilik...">
                                </div>
                                <div class="card-action">
                                    <button type="submit" name="btn-simpan" class="btn btn-success">Update</button>
                                    <!-- <button class="btn btn-danger">Cancel</button> -->

                                </div>
                        </form>
                </div>
            </div>
        </div>
    </div>
</div>
<?php } ?>
<?php require 'footer.php';
