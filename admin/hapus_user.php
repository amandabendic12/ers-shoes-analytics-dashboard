<?php
require 'koneksi.php';

$query = "DELETE FROM user WHERE id_user = " . $_GET['id'];
$delete = mysqli_query($conn, $query);

if ($delete) {
    $_SESSION['msg'] = 'Berhasil menghapus data user';
    header('location:user.php');
} else {
    $_SESSION['msg'] = 'Gagal Hapus Data!!!';
    header('location:staff.php');
}
