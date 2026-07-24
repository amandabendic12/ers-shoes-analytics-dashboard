<?php
session_start();
$conn = mysqli_connect("localhost", "root", "", "db_sepatu");

$username = $_POST['username'];
$password = md5($_POST['password']);
$query = "SELECT * FROM user WHERE username = '$username' AND password = '$password'";
$row = mysqli_query($conn, $query);
$data = mysqli_fetch_assoc($row);
$cek = mysqli_num_rows($row);

if ($cek > 0) {
    if ($data['role'] == 'admin') {
        $_SESSION['role'] = 'admin';
        $_SESSION['username'] = $data['username'];
        $_SESSION['user_id'] = $data['id_user'];
        $_SESSION['staff_id'] = $data['id_staff'];

        header('location:admin');
    } else if ($data['role'] == 'kasir') {
        $_SESSION['role'] = 'kasir';
        $_SESSION['username'] = $data['username'];
        $_SESSION['user_id'] = $data['id_user'];
        $_SESSION['staff_id'] = $data['id_staff'];

        header('location:kasir');
    }
} else {
    $message = 'Username atau password salah!!!';
    header('location:index.php?message=' . $message);
}
