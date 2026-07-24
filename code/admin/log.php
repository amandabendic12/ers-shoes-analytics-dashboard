<?php
$title = 'Log';
require 'koneksi.php';

// $query = "SELECT transaksi_sepatu.*, pelanggan.nama_pelanggan, detail_transaksi.total_harga, outlet.nama_outlet FROM transaksi INNER JOIN pelanggan ON pelanggan.id_pelanggan = transaksi.id_pelanggan INNER JOIN detail_transaksi ON detail_transaksi.id_transaksi = transaksi.id_transaksi INNER JOIN outlet ON outlet.id_outlet = transaksi.outlet_id";
// $data = mysqli_query($conn, $query);

require 'header.php';
?>

<div class="panel-header bg-info-gradient">
    <div class="page-inner py-5">
        <div class="d-flex align-items-left align-items-md-center flex-column flex-md-row">
            <div>
                <h2 class="text-white pb-2 fw-bold">Log</h2>
            </div>
        </div>
    </div>
</div>
<div class="page-inner mt--5" ">

 <div class="row">
    <div class="card card-default" style="width: 15rem; margin: 5px;">
  <div class="card-body">
    <h5 class="card-title" ><a href="log_produk.php" style="color: white;">Produk</a></h5>
  </div>
  <ul class="list-group list-group-flush">
    <li class="list-group-item"><a href="log_produk_insert.php">Tambah</a></li>
    <li class="list-group-item"><a href="log_produk_update.php">Update</a></li>
    <li class="list-group-item"><a href="log_produk_delete.php">Hapus</a></li>
  </ul>
</div>
<div class="card card-default" style="width: 18rem; margin: 5px;">
  <div class="card-body">
    <h5 class="card-title" style="color: white;">Staff</h5>
  </div>
  <ul class="list-group list-group-flush">
    <li class="list-group-item"><a href="log_staff_baru.php">Baru</a></li>
    <li class="list-group-item"><a href="log_staff_update.php">Update</a></li>
    <li class="list-group-item"><a href="log_staff_tidak_aktif.php">Tidak Aktif</a></li>
  </ul>
</div>
<div class="card card-default" style="width: 15rem; margin: 5px;">
  <div class="card-body">
    <h5 class="card-title" ><a href="log_produk.php" style="color: white;">Resi</a></h5>
  </div>
  <ul class="list-group list-group-flush">
    <li class="list-group-item"><a href="log_resi_insert.php">Buat</a></li>
    <li class="list-group-item"><a href="log_resi_update.php">Transaksi</a></li>
    <li class="list-group-item"><a href="log_resi_delete.php">Hapus</a></li>
  </ul>
</div>
<div class="card card-default" style="width: 15rem; margin: 5px;">
  <div class="card-body">
    <h5 class="card-title" ><a href="log_produk.php" style="color: white;">User</a></h5>
  </div>
  <ul class="list-group list-group-flush">
    <li class="list-group-item"><a href="log_user_insert.php">Tambah</a></li>
    <li class="list-group-item"><a href="log_user_update.php">Update</a></li>
    <li class="list-group-item"><a href="log_user_delete.php">Hapus</a></li>
  </ul>
</div>
</div>
<div class="row">
<div class="card card-default" style="width: 18rem; margin: 5px;">
  <div class="card-body">
    <h5 class="card-title" style="color: white;"><a href="log_transaksi.php">Transaksi</a></h5>
  </div>
  </div>

</div>

<?php require 'footer.php'; ?>