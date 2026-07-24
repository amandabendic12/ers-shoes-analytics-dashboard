<?php
session_start();

$conn = mysqli_connect("localhost", "root", "", "db_sepatu");

if (mysqli_connect_error()) {
    echo "Koneksi ke database gagal : " . mysqli_connect_error();
}
