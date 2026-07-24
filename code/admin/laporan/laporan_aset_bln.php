<?php


require '../koneksi.php';
$bln = $_SESSION['bln'];
$thn = $_SESSION['thn'];

$query = "SELECT * FROM toko where id_toko = 1";
$data = mysqli_query($conn, $query);
$toko = mysqli_fetch_assoc($data);

$ps = "SELECT nama FROM staff where id_staff = '{$_SESSION['staff_id']}'";
$resultss = mysqli_query($conn, $ps);
$tessss = mysqli_fetch_assoc($resultss);

$total_as = mysqli_query($conn, "SELECT total_aset_perbulan('$bln', '$thn') as total_aset");
$as = mysqli_fetch_assoc($total_as);
$total = "CALL aset_total_perbulan('$bln', '$thn')";
$data = mysqli_query($conn, $total);
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

        <h2>DATA LAPORAN TOTAL ASET BULANAN <?=$toko['toko']?></h2>
        <h6><?= strftime('%A %d %B %Y') ?></h6>
        <h6 class="mr-auto">Oleh : <?php echo $tessss['nama']; ?></h6>
        <br>
    </center>
    <table class="table table-bordered" style="width: 90%; margin: 50px; ">
<center>
<thead>
                                <tr>
                                    <th style="width: 7%">#</th>
                                    <th>Produk</th>
                                    <th>Harga</th>
                                    <th>Jumlah Beli</th>
                                    <th>Total</th>
                                    <th>Waktu Transaksi</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php

                                $no = 1;
                                if (mysqli_num_rows($data) > 0) {
                                    while ($query = mysqli_fetch_assoc($data)) {
                                ?>
                                        <tr>
                                            <td><?= $no++; ?></td>
                                            <td><?= $query['Produk']; ?></a></td>
                                            <td><?= 'Rp ' . number_format($query['Harga']); ?></td>
                                            <td><?= $query['Jumlah_beli']; ?></a></td>
                                            <td><?= 'Rp ' . number_format($query['Total']); ?></td>
                                            <td><?= $query['Waktu_transaksi']; ?></td>
                                            </td>
                                        </tr>
                                <?php }
                                }
                                ?>
                                <div class="card-body">
                                <div class="row">
                               Total aset (<?=$bln?>/<?=$thn?>)
                            </div>
                            <div class="row">
                            <?= 'Rp ' . number_format($as["total_aset"])  ?>
                            </div>
                            </div>
                            </tbody>
                        </table>

    <script>
        window.print();
    </script>

</body>

</html>