<?php
$title = 'Selamat Datang di ERS`Shoes';
require 'koneksi.php';
require 'header.php';

setlocale(LC_ALL, 'id_id');
setlocale(LC_TIME, 'id_ID.utf8');
$query = mysqli_query($conn, "SELECT * FROM staff ");
$staff = mysqli_fetch_assoc($query);

$query = mysqli_query($conn, "SELECT COUNT(id_staff) as jumlah_staff FROM staff where status = 'Aktif'");
$jumlah_staff = mysqli_fetch_assoc($query);

$query = mysqli_query($conn, "SELECT COUNT(id_kategori) as kategori FROM kategori");
$kategori = mysqli_fetch_assoc($query);

$query = mysqli_query($conn, "SELECT COUNT(id_costumer) as jumlah_customer FROM costumer");
$jumlah_customer = mysqli_fetch_assoc($query);

$kat = mysqli_query($conn, "SELECT id_kategori from kategori");
$id_k = mysqli_fetch_array($kat);

$total_as = mysqli_query($conn, "SELECT total_aset() as total_aset");
$as = mysqli_fetch_assoc($total_as);

// var_dump($a);
?>

<div class="panel-header bg-primary-gradient">
    <div class="page-inner py-5">
        <div class="d-flex align-items-left align-items-md-center flex-column flex-md-row">
            <div>
                <h1 class="text-white pb-2 fw-bold"><?= $title; ?></h1>
                <h2 class="text-white op-7 mb-2"> Dashboard</h2>
            </div>
        </div>
    </div>
</div>
<div class="page-inner mt--5">
    <div class="row">
        <div class="col-sm-6 col-md-3">
            <div class="card card-stats card-round card-default">
                <div class="card-body ">
                    <div class="row align-items-center">
                        <div class="col-icon">
                            <div class="icon-big text-center icon-primary bubble-shadow-small">
                                <i class="fas fa-users"></i>
                            </div>
                        </div>
                        <div class="col col-stats ml-3 ml-sm-0">
                            <div class="numbers">
                                <p class="card-category">Jumlah Staff Aktif</p>
                                <h4 class="card-title"><?=$jumlah_staff['jumlah_staff']?></h4>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-sm-6 col-md-3">
            <div class="card card-stats card-round card-default">
                <div class="card-body">
                    <div class="row align-items-center">
                        <div class="col-icon">
                            <div class="icon-big text-center icon-info bubble-shadow-small">
                                <i class="fas fa-users"></i>
                            </div>
                        </div>
                        <div class="col col-stats ml-3 ml-sm-0">
                            <div class="numbers">
                                <p class="card-category">Jumlah Pelanggan</p>
                                <h4 class="card-title"><?=$jumlah_customer['jumlah_customer']?></h4>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-sm-6 col-md-3">
            <div class="card card-stats card-round card-default">
                <div class="card-body">
                    <div class="row align-items-center">
                        <div class="col-icon">
                            <div class="icon-big text-center icon-info bubble-shadow-small">
                                <i class="fas fa-users"></i>
                            </div>
                        </div>
                        <div class="col col-stats ml-3 ml-sm-0">
                            <div class="numbers">
                                <p class="card-category"><a href= "kategori.php" style="color: white;">Kategori</a></p>
                                <h4 class="card-title"><?=$kategori['kategori']?></h4>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <?php
    $query_k = "SELECT *, total_aset_per_kategori_barang(id_kategori) as Total FROM kategori ";
    $kat = mysqli_query($conn, $query_k);
    if (mysqli_num_rows($kat) > 0) {
        while ($paket = mysqli_fetch_assoc($kat)) {
    ?>
        <div class="col-sm-6 col-md-3">
            <div class="card card-stats card-round card-default">
                <div class="card-body">
                    <div class="row align-items-center">
                        <div class="col-icon">
                            <div class="icon-big text-center icon-secondary bubble-shadow-small">
                                <i class="flaticon-success"></i>
                            </div>
                        </div>
                        <div class="col col-stats ml-3 ml-sm-0">
                            <div class="numbers">
                                <p class="card-category"><a href= "aset_kategori.php?id=<?=$paket["id_kategori"]?>" style="color: white;"> Aset <?=$paket["nama_kategori"]?></a></p>
                                <h4 class="card-title"><?= 'Rp ' . number_format($paket["Total"])  ?></h4>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <?php
        }
        }

        ?>
        <div class="col-sm-6 col-md-3">
            <div class="card card-stats card-round card-default">
                <div class="card-body">
                    <div class="row align-items-center">
                        <div class="col-icon">
                            <div class="icon-big text-center icon-success bubble-shadow-small">
                                <i class="flaticon-graph"></i>
                            </div>
                        </div>
                        <div class="col col-stats ml-3 ml-sm-0">
                            <div class="numbers">
                                <p class="card-category"><a href= "aset.php" style="color: white;"> Total Penghasilan</a></p>
                                <h4 class="card-title"><?= 'Rp ' . number_format($as["total_aset"]) ?></h4>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    </div>
</div>
</div>
<?php
require 'footer.php';
?>