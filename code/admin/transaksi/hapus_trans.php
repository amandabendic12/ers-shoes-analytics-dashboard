<?php
require '../koneksi.php';
$resi = $_GET['resi'];
$id = $_GET['id'];
$query = "DELETE FROM transaksi WHERE id_transaksi = '$id'";
$delete = mysqli_query($conn, $query);
if ($delete) {
    $_SESSION['msg'] = 'Berhasil menghapus data';
    header("location:../resi.php?id=$resi");
} else {
    $_SESSION['msg'] = 'Gagal Hapus Data!!!';
    header("location:../resi.php?id=$resi");
}
