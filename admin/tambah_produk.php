<?php
$title = 'Tambah Produk';
require 'koneksi.php';

if (isset($_POST['btn-simpan'])) {
    $id = $_POST['id_produk'];
    $produk = $_POST['produk'];
    $harga = $_POST['harga'];
    $warna = $_POST['warna'];
    $ukuran = $_POST['ukuran'];
    $kat = $_POST['kategori'];
    $qty = $_POST['qty'];
    $query1 = "INSERT INTO produk (id_produk, kategori, produk, warna, ukuran, harga, qty) values ('$id','$kat','$produk', '$harga', '$warna', '$ukuran', '$qty')";

    $insert = mysqli_query($conn,$query1);
    if ($insert == 1) {
        $_SESSION['msg'] = 'Berhasil menambahkan produk';
        header('location:produk.php?');
    } else {
        $_SESSION['msg'] = 'Gagal menambahkan produk!!!';
        header('location: produk.php');
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
                    <a href="produk.php">Produk</a>
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
                                <label for="largeInput">ID Produk</label>
                                <input type="text" name="id_produk" class="form-control form-control" id="defaultInput" placeholder="ID barang..." required>
                            </div>
                            <div class="form-group">
                            <label for="largeInput">Kategori</label>
                            <select id="trans" name="kategori" class="form-control form-control" required>
                                <option disable selected>Pilih Kategori</option>
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
                                <label for="largeInput">Nama Produk</label>
                                <input type="text" name="produk" class="form-control form-control" id="defaultInput" placeholder="Nama Produk..." required>
                            </div>
                            <div class="form-group">
                                <label for="largeInput">Warna</label>
                                <input type="text" name="warna" class="form-control form-control" id="defaultInput" placeholder="Warna..." required>
                            </div>
                            <div class="form-group">
                                <label for="largeInput">Ukuran</label>
                                <input type="text" name="ukuran" class="form-control form-control" id="defaultInput" placeholder="Ukuran..." required>
                            </div>
                            <div class="form-group">
                                <label for="largeInput">Harga</label>
                                <input type="number" name="harga" class="form-control form-control" id="defaultInput" min="1" placeholder="Harga..." required>
                            </div>

                            <div class="form-group">
                                <label for="largeInput">Stok</label>
                                <input type="number" name="qty" class="form-control form-control" id="defaultInput" min="1" placeholder="Stok..." required>
                            </div>
                            <div class="card-action">
                                <button type="submit" name="btn-simpan" class="btn btn-success">Submit</button>
                                <button type="reset" class="btn btn-danger">Reset</button>
                                <a href="javascript:void(0)" onclick="window.history.back();" class="btn btn-danger">Batal</a>
                            </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<?php require 'footer.php'; ?>