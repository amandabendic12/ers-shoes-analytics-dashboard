<?php
require 'koneksi.php';
$id = $_GET['id'];
$query = "DELETE FROM produk WHERE id_produk = '$id'";
$delete = mysqli_query($conn, $query);

if ($delete) {
    $_SESSION['msg'] = 'Berhasil menghapus produk';
    header('location:produk.php');
} else {
    $_SESSION['msg'] = 'Gagal Hapus Data!!!';
    header('location:produk.php');
}
