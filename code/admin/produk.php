<?php
$title = 'Produk';
require 'koneksi.php';

$query = "SELECT * FROM data_produk";
$data = mysqli_query($conn, $query);

$kategori = "SELECT * from kategori";
$row = mysqli_query($conn, $kategori);

require 'header.php';
?>
<div class="panel-header bg-primary-gradient">
    <div class="page-inner py-5">
    <div class="d-flex align-items-left align-items-md-center flex-column flex-md-row">
    <div>

    <?php if (isset($_SESSION['msg']) && $_SESSION['msg'] <> '') { ?>
            <div class="alert alert-success" role="alert" id="msg">
                <?= $_SESSION['msg']; ?>
            </div>
        <?php }
        $_SESSION['msg'] = ''; ?>
        </div>
        </div>
        <div class="d-flex align-items-left align-items-md-center flex-column flex-md-row">
            <div>
                <h3 class="text-white pb-2 fw-bold">Produk</h3>
            </div>
        </div>
    </div>
</div>
<div class="page-inner mt--5">
    <diva class="row">
        <div class="col-md-12">
            <div class="card card-default">
                <div class="card-header">
                    <div class="d-flex align-items-center">
                    <div class="dropdown">
                         <button class="btn btn-primary btn-round dropdown-toggle" type="button" id="dropdownMenuButton" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                           Kategori
                         </button>
                         <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">

                         <?php
                            if (mysqli_num_rows($row) > 0) {
                                while ($paket = mysqli_fetch_assoc($row)) {
                            ?>
                                <a class="dropdown-item" href="produk_kategori.php?id=<?=$paket['id_kategori']?>"><?=$paket['nama_kategori']?></a>
                            <?php }
                            } ?>
                        </div>
                        <a href="tambah_produk.php" class="btn btn-primary btn-round mr-auto">
                            <i class="fa fa-plus"></i>
                            Tambah Produk
                        </a>
                        </div>
                        <a href="laporan/laporan_produk.php" class="btn btn-primary btn-round ml-auto">
                            <i class="fa fa-plus"></i>
                            Cetak Laporan
                        </a>
                    </div>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table id="basic-datatables" class="display table table-striped table-hover">
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
                                    <th style="width: 10%">Aksi</th>
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
                                            <td>
                                                <div class="form-button-action">
                                                    <a href="edit_produk.php?id=<?= $paket['id_produk']; ?>" type="button" data-toggle="tooltip" title="" class="btn btn-link btn-primary btn-lg" data-original-title="Edit">
                                                        <i class="fa fa-edit"></i>
                                                    </a>
                                                    <a href="hapus_produk.php?id=<?= $paket['id_produk']; ?>" onclick="return confirm('Yakin hapus data?');" type="button" data-toggle="tooltip" title="" class="btn btn-link btn-danger" data-original-title="Hapus">
                                                        <i class="fa fa-times"></i>
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                <?php }
                                }
                                ?>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

</div>
</div>
<?php
require 'footer.php';
?>