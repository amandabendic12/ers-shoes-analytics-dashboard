<?php
$title = 'List Produk';
require 'koneksi.php';
$id = $_GET['id'];
$query = "SELECT p.*, k.* FROM produk p join kategori k on p.kategori = k.id_kategori";
$data = mysqli_query($conn, $query);




require 'header.php';
?>
<div class="panel-header bg-primary-gradient">
    <div class="page-inner py-5">
    <div class="d-flex align-items-left align-items-md-center flex-column flex-md-row">
    <div>

        </div>
        </div>

        <div class="d-flex align-items-left align-items-md-center flex-column flex-md-row">
            <div>
                <h3 class="text-white pb-2 fw-bold"><?= $title; ?></h3>
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
                        <h4 class="card-title"></h4>

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
                                    <th style="width: 15%">Jumlah Beli</th>
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
                                        <form action="resi.php?id=<?= $id ?>" method="post" id="form1" >
                                            <td><?= $no++; ?></td>
                                            <td><input type="hidden" name="id_produk" value="<?= $paket['id_produk']; ?>"><?= $paket['id_produk']; ?></td>
                                            <td><?= $paket['nama_kategori']; ?></td>
                                            <td><?= $paket['produk']; ?></td>
                                            <td><?= $paket['warna']; ?></td>
                                            <td><?= $paket['ukuran']; ?></td>
                                            <td><?= 'Rp ' . number_format($paket['harga']); ?></td>
                                            <td><?= $paket['qty']; ?></td>
                                            <td> <input type="number" name="qty" class="form-control form-control" id="defaultInput" min="1" placeholder="jumlah..." required></td>
                                            <td>
                                            <button type="submit" name="add" class="btn btn-success"> <i class="fa fa-plus"></i></button>

                                    </form>
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