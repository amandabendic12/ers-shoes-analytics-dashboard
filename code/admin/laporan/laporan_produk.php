<?php
$title = 'Produk';
require '../koneksi.php';

$ps = "SELECT nama FROM staff where id_staff = '{$_SESSION['staff_id']}'";
$resultss = mysqli_query($conn, $ps);
$tessss = mysqli_fetch_assoc($resultss);

$query = "SELECT * FROM toko where id_toko = 1";
$data = mysqli_query($conn, $query);
$toko = mysqli_fetch_assoc($data);

$query = "SELECT p.*, k.* FROM produk p join kategori k on p.kategori = k.id_kategori";
$data = mysqli_query($conn, $query);

$kategori = "SELECT * from kategori";
$row = mysqli_query($conn, $kategori);

setlocale(LC_ALL, 'id_id');
setlocale(LC_TIME, 'id_ID.utf8');
?>
<!DOCTYPE html>
<html>

<head>
    <title></title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" integrity="sha384-JcKb8q3iqJ61gNV9KGb8thSsNjpSL0n8PARn9HuZOnIxN0hoP+VmmDGMN5t9UJ0Z" crossorigin="anonymous">
</head>

<body>

    <center>

        <h2>Data Laporan Stok Produk <?=$toko['toko']?> </h2>
        <h6><?= strftime('%A %d %B %Y') ?></h6>
        <h6 class="mr-auto">Oleh : <?php echo $tessss['nama']; ?></h6>
        <br>
    </center>
    <table id="basic-datatables" class="display table table-striped table-hover" style="width: 90%; margin: 50px; ">
                            <thead>
                                <tr>
                                    <th style="width: 7%">#</th>
                                    <th>ID Produk</th>
                                    <th>Kategori</th>
                                    <th>Produk</th>
                                    <th>Warna</th>
                                    <th>Ukuran</th>
                                    <th>Harga</th>
                                    <th>Stok</th>

                                </tr>
                            </thead>
                            <tbody>
                                <?php
                                $no = 1;
                                if (mysqli_num_rows($data) > 0) {
                                    while ($paket = mysqli_fetch_assoc($data)) {
                                ?>
                                        <tr>
                                            <td><?= $no++; ?></td>
                                            <td><?= $paket['id_produk']; ?></td>
                                            <td><?= $paket['nama_kategori']; ?></td>
                                            <td><?= $paket['produk']; ?></td>
                                            <td><?= $paket['warna']; ?></td>
                                            <td><?= $paket['ukuran']; ?></td>
                                            <td><?= 'Rp ' . number_format($paket['harga']); ?></td>
                                            <td><?= $paket['qty']; ?></td>

                                        </tr>
                                <?php }
                                }
                                ?>
                            </tbody>
                        </table>

<script>
    window.print();
</script>

</body>

</html>