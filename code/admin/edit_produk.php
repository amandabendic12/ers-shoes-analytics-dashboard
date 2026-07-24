<?php
$title = 'Edit Produk';
require 'koneksi.php';

$id_user = $_GET['id'];
$query = mysqli_query($conn, "SELECT p.*, k.* FROM produk p join kategori k on p.kategori = k.id_kategori where p.id_produk = '$id_user'");

$kategori = "SELECT * from kategori";
$data = mysqli_query($conn, $kategori);

if (isset($_POST['btn-simpan'])) {
       $produk = $_POST['produk'];
       $kat = $_POST['id_kategori'];
       $harga = $_POST['harga'];
       $warna = $_POST['warna'];
       $ukuran = $_POST['ukuran'];
        $qty = $_POST['qty'];
        $update = mysqli_query($conn, "UPDATE produk SET produk = '$produk', harga = '$harga', warna = '$warna', ukuran = '$ukuran', qty = '$qty', kategori = '$kat' WHERE id_produk = '$id_user'");

    if ($update == 1) {
        $_SESSION['msg'] = 'Berhasil Update data';
        header('location:produk.php');
    } else {
        echo "<div class='alert alert-danger>Gagal Update Data!!!</div>";
        $_SESSION['msg'] = 'Gagal mengupdate data!!!';
        header('location:produk.php');
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
                    <a href="produk.php">Produk</a>
                </li>
                <li class="separator">
                    <i class="flaticon-right-arrow"></i>
                </li>
                <li class="nav-item">
                    <a href="#">Edit produk</a>
                </li>
            </ul>
        </div>
        <div class="row">
            <div class="col-md-10">
                <div class="card card-default">
                    <div class="card-header">
                        <div class="card-title"><?= $title; ?></div>
                    </div>
                    <?php while ($edit = mysqli_fetch_array($query)) {
                    ?>
                        <form action="" method="POST">
                            <div class="card-body">
                            <div class="form-group">
                                <label for="largeInput">ID Produk</label>
                                <input type="text" name="id_produk" readonly="readonly" value="<?php echo $edit['id_produk'];?>" class="form-control form-control" id="defaultInput" placeholder="id produk..." required>
                            </div>
                            <div class="form-group">
                            <label for="largeInput">Kategori</label>
                            <select id="trans" name="id_kategori" class="form-control form-control" required>
                                <option value = "<?php echo $edit['id_kategori'];?>"><?php echo $edit['nama_kategori'];?></option>
                                <?php
                                if (mysqli_num_rows($data) > 0) {
                                    while ($paket = mysqli_fetch_assoc($data)) {
                                ?>
                                        <option value="<?=$paket['id_kategori']?>"><?=$paket['nama_kategori']?></option>
                                <?php }
                                } ?>
                            </select>
                            </div>
                            <div class="form-group">
                                <label for="largeInput">Produk</label>
                                <input type="text" name="produk" value="<?php echo $edit['produk'];?>" class="form-control form-control" id="defaultInput" placeholder="produk..." required>
                            </div>
                            <div class="form-group">
                                <label for="largeInput">Warna</label>
                                <input type="text" name="warna"  value="<?php echo $edit['warna'];?>" class="form-control form-control" id="defaultInput" placeholder="Warna..." required>
                            </div>
                            <div class="form-group">
                                <label for="largeInput">Ukuran</label>
                                <input type="text" name="ukuran"  value="<?php echo $edit['ukuran'];?>" class="form-control form-control" id="defaultInput" placeholder="Ukuran..." required>
                            </div>
                            <div class="form-group">
                                <label for="largeInput">Harga</label>
                                <input type="number" min="1" name="harga" value="<?php echo $edit['harga'];?>" class="form-control form-control" id="defaultInput" placeholder="harga.." required>
                            </div>
                            <div class="form-group">
                                <label for="largeInput">Stok</label>
                                <input type="number" name="qty" value="<?php echo $edit['qty'];?>" class="form-control form-control" id="defaultInput" placeholder="stok.." required>
                            </div>
                                <div class="card-action">
                                    <button type="submit" name="btn-simpan" class="btn btn-success">Update</button>
                                    <!-- <button class="btn btn-danger">Cancel</button> -->
                                    <a href="javascript:void(0)" onclick="window.history.back();" class="btn btn-danger">Batal</a>
                                </div>
                        </form>
                </div>
            </div>
        </div>
    </div>
</div>
<?php } ?>
<?php require 'footer.php';
