<?php
require 'koneksi.php';
$id = $_GET['id'];
$query = "DELETE FROM resi WHERE no_resi = '$id'";
$delete = mysqli_query($conn, $query);
$query = "DELETE FROM resi WHERE no_resi = '$id'";
$delete = mysqli_query($conn, $query);
if ($delete) {
    $_SESSION['msg'] = 'Berhasil menghapus resi';
    header("location:transaksi.php");
} else {
    $_SESSION['msg'] = 'Gagal Hapus Data!!!';
    header("location:transaksi.php");
}
