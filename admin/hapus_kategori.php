<?php
require 'koneksi.php';
$id = $_GET['id'];
$query = "DELETE FROM kategori WHERE id_kategori = '$id'";
$delete = mysqli_query($conn, $query);

if ($delete) {
    $_SESSION['msg'] = 'Berhasil menghapus kategori';
    header('location:kategori.php');
} else {
    $_SESSION['msg'] = 'Gagal Hapus kategori!!!';
    header('location:kategori.php');
}
