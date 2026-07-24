<?php

$title = 'Data Produk';
require '../koneksi.php';

$ket = $_GET['id'];
$bln = $_SESSION['bln'];
$thn = $_SESSION['thn'];

$query = "SELECT * FROM toko where id_toko = 1";
$data = mysqli_query($conn, $query);
$toko = mysqli_fetch_assoc($data);

$ps = "SELECT nama FROM staff where id_staff = '{$_SESSION['staff_id']}'";
$resultss = mysqli_query($conn, $ps);
$tessss = mysqli_fetch_assoc($resultss);

$total_as = mysqli_query($conn, "SELECT total_aset_per_kategori_bulanan('$bln', '$thn', '$ket') as total_aset");
$as = mysqli_fetch_assoc($total_as);

$nama = mysqli_query($conn, "SELECT id_kategori, nama_kategori from kategori where id_kategori = '$ket'");
$namak = mysqli_fetch_assoc($nama);

$total = "CALL aset_total_ket_bln('$bln', '$thn', '$ket')";
$data = mysqli_query($conn, $total);
setlocale(LC_ALL, 'id_id');
setlocale(LC_TIME, 'id_ID.utf8');
?>
<!DOCTYPE html
    PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="id" lang="id">

<head>

    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.1.0/jquery.min.js"></script>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" integrity="sha384-JcKb8q3iqJ61gNV9KGb8thSsNjpSL0n8PARn9HuZOnIxN0hoP+VmmDGMN5t9UJ0Z" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.10.22/css/jquery.dataTables.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/buttons/1.6.4/css/buttons.dataTables.min.css">


    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/js/all.min.js"
        integrity="sha512-RXf+QSDCUQs5uwRKaDoXt55jygZZm2V++WUZduaU/Ui/9EGp3f/2KZVahFZBKGH0s774sd3HmrhUy+SgOFQLVQ=="
        crossorigin="anonymous" referrerpolicy="no-referrer"></script>
    <script src="https://cdn.datatables.net/1.10.22/js/jquery.dataTables.min.js"></script>
    <script type="text/javascript" src="https://unpkg.com/xlsx@0.15.1/dist/xlsx.full.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/1.6.4/js/dataTables.buttons.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/1.6.4/js/buttons.flash.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/pdfmake.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/vfs_fonts.js"></script>
    <script src="https://cdn.datatables.net/buttons/1.6.4/js/buttons.html5.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/1.6.4/js/buttons.print.min.js"></script>
</head>

<body>
<center>

<h2>DATA LAPORAN ASET BULANAN <?=$namak['nama_kategori']?> ERS SHOES<?=$toko['toko']?></h2>
<h6><?= strftime('%A %d %B %Y') ?></h6>
<h6 class="mr-auto">Oleh : <?php echo $tessss['nama']; ?></h6>
<br>
</center>
<table id="tableData" class="table table-bordered" style="width: 90%; margin: 50px; ">
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
                               Total aset <?=$namak['nama_kategori']?> (<?=$bln?>/<?=$thn?>)
                            </div>
                            <div class="row">
                            <?= 'Rp ' . number_format($as["total_aset"])  ?>
                            </div>
                            </div>
                            </tbody>
                        </table>
                        <div class="pdfbtn">
    <button class="listbutton" id="export_button" >
        <i class="fa fa-file-excel-o"></i>
    Export XLSX
    </button>
    </div>
        </body>
</html>
<script>

// excel export
function html_table_to_excel(type)
    {
        var data = document.getElementById('tableData');

        var file = XLSX.utils.table_to_book(data, {sheet: "sheet1"});

        XLSX.write(file, { bookType: type, bookSST: true, type: 'base64' });

        XLSX.writeFile(file, 'aset_total_ket_bln.' + type);
    }

    const export_button = document.getElementById('export_button');

    export_button.addEventListener('click', () =>  {
        html_table_to_excel('xlsx');
    });

</script>