<?php
$title = 'Data Produk';
require 'koneksi.php';
require 'header.php';
$ket = $_GET['id'];
$hari1 = $_POST['hari1'];
$hari2 = $_POST['hari2'];
$_SESSION['hari1'] = $hari1;
$_SESSION['hari2'] = $hari2;
$total_as = mysqli_query($conn, "SELECT aset_dalam_rentang_tanggal_ket('$hari1','$hari2','$ket') as total_aset");
$as = mysqli_fetch_assoc($total_as);

$nama = mysqli_query($conn, "SELECT id_kategori, nama_kategori from kategori where id_kategori = '$ket'");
$namak = mysqli_fetch_assoc($nama);

$total = "CALL aset_dalam_rentang_tanggal_ket('$hari1','$hari2','$ket')";
$data = mysqli_query($conn, $total);
?>
<div class="panel-header bg-primary-gradient">
    <div class="page-inner py-5">
        <div class="d-flex align-items-left align-items-md-center flex-column flex-md-row">
            <div>
                <h2 class="text-white pb-2 fw-bold">  Aset <?=$namak['nama_kategori']?> </h2>
            </div>
        </div>
        <div class="d-flex align-items-left align-items-md-center flex-column flex-md-row">
    </div>
</div>
<div class="page-inner mt--5">
    <div class="row">
        <div class="col-md-12">
            <div class="card card-default">
                <div class="card-header">
                    <div class="d-flex align-items-center">
                        <a href="laporan/laporan_aset_kat_hari.php?id=<?=$namak['id_kategori']?>" class="btn btn-primary btn-round ml-auto">
                            <i class="fa fa-plus"></i>
                            Cetak Laporan
                        </a>
                        <a href="laporan/excel_aset_kat_hr.php?id=<?=$namak['id_kategori']?>" class="btn btn-primary btn-round " style="margin-left: 20px">
                            <i class="fa fa-plus"></i>
                            Export Excel
                        </a>
                    </div>

                </div>

                <div class="card-body">
                    <div class="table-responsive">
                        <table id="basic-datatables" class="display table table-striped table-hover">
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
                               Total Aset <?=$namak['nama_kategori']?>
                            </div>
                            <div class="row">
                               (<?=$hari1?>) - (<?=$hari2?>)
                            </div>
                            <div class="row">
                            <?= 'Rp ' . number_format($as["total_aset"])  ?>
                            </div>
                            </div>
                            </tbody>
                        </table>
                        <a href="javascript:void(0)" onclick="window.history.back();" class="btn btn-primary btn-round">Back</a>

                    </div>
                </div>
            </div>
        </div>

</div>
</div>
<script>
   function html_table_to_excel(type)
    {
        var data = document.getElementById('basic-datatables');

        var file = XLSX.utils.table_to_book(data, {sheet: "sheet1"});

        XLSX.write(file, { bookType: type, bookSST: true, type: 'base64' });

        XLSX.writeFile(file, 'file.' + type);
    }

    const export_button = document.getElementById('export_button');

    export_button.addEventListener('click', () =>  {
        html_table_to_excel('xlsx');
    });
    </script>
<?php
require 'footer.php';
?>