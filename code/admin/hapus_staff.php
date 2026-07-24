<?php
require 'koneksi.php';



$query = "DELETE FROM staff WHERE id_staff = " . $_GET['ids'];
$delete = mysqli_query($conn, $query);

if ($delete) {
    $_SESSION['msg'] = 'Berhasil menghapus data staff';
    header('location:staff.php');
} else {
    $_SESSION['msg'] = 'Gagal Hapus Data!!!';
    header('location:staff.php');
}
