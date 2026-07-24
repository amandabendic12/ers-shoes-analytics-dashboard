<?php
$title = 'Laporan';
require 'koneksi.php';
require 'header.php';

$total_as = mysqli_query($conn, "SELECT total_aset() as total_aset");
$as = mysqli_fetch_assoc($total_as);


$kategori = "SELECT * from kategori";
$row = mysqli_query($conn, $kategori);

$data = mysqli_query($conn, 'CALL aset_total()');






?>
<div class="panel-header bg-primary-gradient">
    <div class="page-inner py-5">
        <div class="d-flex align-items-left align-items-md-center flex-column flex-md-row">
            <div>
                <h2 class="text-white pb-2 fw-bold">Aset</h2>
            </div>
        </div>
        <div class="d-flex align-items-left align-items-md-center flex-column flex-md-row">
        <button class="btn btn-secondary dropdown-toggle" type="button" id="dropdownMenuButton" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            Kategori
          </button>
          <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
          <?php
             if (mysqli_num_rows($row) > 0) {
                 while ($paket = mysqli_fetch_assoc($row)) {
             ?>
                 <a class="dropdown-item" href="aset_kategori.php?id=<?=$paket['id_kategori']?>"><?=$paket['nama_kategori']?></a>
             <?php }
             } ?>
         </div>
        </div>
    </div>
</div>
<div class="page-inner mt--5">
    <div class="row">
        <div class="col-md-12">
            <div class="card card-default">
            <div class="card-header">
                    <div class="d-flex align-items-center">
                    <form class="form-inline" method='POST' action="aset_pbln.php">
                      <div class="form-group mb-2">
                        <label for="staticEmail2" class="sr-only">Bulan</label>
                        <input type="number" max="12" name="bln" class="form-control" id="inputPassword2" placeholder="Bulan">
                      </div>
                      <div class="form-group mx-sm-3 mb-2">
                        <label for="inputPassword2" class="sr-only">Tahun</label>
                        <input type="number" name="thn" class="form-control" id="inputPassword2" placeholder="Tahun">
                      </div>
                      <button type="submit" name="submit" class="btn btn-primary mb-2" style='width:10.5em;'>Aset perbulan</button>
                    </form>
                        <a href="laporan/laporan_aset.php" class="btn btn-primary btn-round ml-auto">
                            <i class="fa fa-plus"></i>
                            Cetak Laporan
                        </a>
                        <a href="laporan/excel_aset_total.php" class="btn btn-primary btn-round " style="margin-left: 20px">
                            <i class="fa fa-plus"></i>
                            Export Excel
                        </a>
                    </div>
                    <form class="form-inline" method='POST' action="aset_rentang_hari.php">
                    <div class="form-group mb-2">
                    <input type="date" value="<?= date('Y-m-d');?>" class="form-control" name="hari1" style='width:13.5em; margin-right: 15px;'>
                    </div>
                     <div class="form-group mb-2">
                    <input type="date" value="<?= date('Y-m-d');?>" class="form-control" name="hari2" style='width:13.5em; margin-right: 15px;'>
                    </div>
                    <button type="submit" name="submit" class="btn btn-primary mb-2">Rentang Tanggal</button>
                    </form>

                </div>

                <div class="card-body">
                    <div class="table-responsive">
                    <table id="basic-datatables" class="display table table-striped table-hover">
                            <thead>
                                <tr>
                                    <th style="width: 7%">#</th>
                                    <th>Produk</th>
                                    <th>Kategori</th>
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
                                            <td><?= $query['Kategori']; ?></a></td>
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
                               Total aset
                            </div>
                            <div class="row">
                            <?= 'Rp ' . number_format($as["total_aset"])  ?>
                            </div>
                            </div>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

</div>
</div>
<style>
      .buttonexport{
    border-radius: 15px;
    display: flex;
    justify-content: right;
    background-color: #1269DB;
    color: white;
    font-size: 8px;
  }
    </style>
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