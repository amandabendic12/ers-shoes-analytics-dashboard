<?php
ob_start();
$title = 'Data Produk';
require 'koneksi.php';
$id_resi = $_GET['id'];
require 'header.php';
// query resi

$query = "SELECT r.*, c.nama, s.nama as nama_staff FROM resi r INNER JOIN costumer c ON c.id_costumer = r.id_costumer INNER JOIN staff s on r.id_kasir = s.id_staff
WHERE r.no_resi = '$id_resi'";
$data = mysqli_query($conn, $query);
$row = mysqli_fetch_assoc($data);

if (isset($_POST['add'])) {
    $id = $_POST['id_produk'];
    $qty = $_POST['qty'];

    $cek = mysqli_query($conn, "SELECT qty from produk where id_produk = '$id'");
    $stoks = mysqli_fetch_array($cek);

    $stok = $stoks['qty'];

    if($stok >= $qty)
    {

    $updatestok = $stok - $qty;

    $query = mysqli_query($conn,"INSERT INTO transaksi (id_produk, no_resi, qty) VALUEs ('$id', '$id_resi', '$qty')");
    $update =  mysqli_query($conn,"UPDATE produk set qty = '$updatestok' where id_produk = '$id'");

   if ($query&&$update) {
       $_SESSION['msg'] = 'Berhasil Update data';
       header("location:resi.php?id=$id_resi");
   } else {
       echo "<div class='alert alert-danger>Gagal Update Data!!!</div>";
       $_SESSION['msg'] = 'Gagal mengupdate data!!!';
       header("location:resi.php?id=$id_resi");
   }
} else {
    echo "<script
    type='text/jscript'>alert('Jumlah stok tidak tersedia.')</script>";
    }
}


if (isset($_POST['btn-bayar'])) {
    $cash = $_POST['bayar'];

    $query_total = mysqli_query($conn, "SELECT total_resi('$id_resi') as total");
    $total = mysqli_fetch_assoc($query_total);

    if($cash >= $total['total'])
    {
     $query_bayar = mysqli_query($conn, "UPDATE resi SET bayar = '$cash' where no_resi = '$id_resi'");
    } else {
        echo "<script
        type='text/jscript'>alert('Cash tidak mencukupi total.')</script>";
    }
}
$id_trans = mysqli_query($conn, "SELECT id_transaksi from transaksi where no_resi = '$id_resi'");
$id_tran = mysqli_fetch_array($id_trans);

$query_total = mysqli_query($conn, "SELECT total_resi('$id_resi') as total");
$total = mysqli_fetch_assoc($query_total);

$query_tota = mysqli_query($conn, "SELECT bayar from resi where no_resi = '$id_resi'");
$cash = mysqli_fetch_assoc($query_tota);

?>

<div class="panel-header bg-primary-gradient">
<?php if (isset($_SESSION['msg']) && $_SESSION['msg'] <> '') { ?>
            <div class="alert alert-success" role="alert" id="msg">
                <?= $_SESSION['msg']; ?>
            </div>
        <?php }
        $_SESSION['msg'] = ''; ?>
    <div class="page-inner py-5">
        <div class="d-flex align-items-left align-items-md-center flex-column flex-md-row">
            <div>
                <h2 class="text-white pb-2 fw-bold"><a href="transaksi.php">Resi</a></h2>
            </div>
        </div>

    </div>
</div>
<div class="page-inner mt--5">
    <div class="row">
        <div class="col-md-12">
            <div class="card card-default" style="color: black;">
                <div class="card-header">
                    <div class="d-flex align-items-center">
                       <a href="laporan/cetak_resi.php?id=<?php echo $id_resi?>" class="btn btn-primary btn-round ml-auto">
                            <i class="fa fa-plus"></i>
                            Cetak Resi
                        </a>
                    </div>
                </div>
                <div class="card-body ">
                    <div class="card">
                    <h3 class="card-header">No Resi : <?php echo $row['no_resi'];?></h3>
  <div class="card-body">
  <h6 class="card-title"  style="color: black;">Kasir : <?php echo $row['nama_staff'];?></h6>
    <h5 class="card-title"  style="color: black;">Costumer : <?php echo $row['nama'];?></h5>
    <p class="card-text">Waktu transaksi : <?php echo $row['wkt_transaksi'];?></p>
    <hr>
        <table>
            <tr>
                <th >Produk</th>
                <th style="padding-left: 40px;">Harga satuan</th>
                <th style="padding-left: 10px;">Jumlah Beli</th>
                <th style="padding-left: 350px;">Total Harga</th>
        </tr>
        <?php
        if(!empty($id_tran)){

        $query = "SELECT t.id_transaksi, t.qty, concat(p.produk, ' ', p.warna, ' ' , p.ukuran) as Produk, p.harga, p.id_produk, totalhargaproduk(t.id_transaksi) as total FROM produk p INNER JOIN transaksi t ON t.id_produk = p.id_produk WHERE t.no_resi = '$id_resi'";
        $t = mysqli_query($conn, $query);
        if (mysqli_num_rows($t) > 0) {
            while ($paket = mysqli_fetch_assoc($t)) {
        ?>
        <tr>
        <td><?= $paket['Produk'];?></td>
            <td style="padding-left: 40px;"><?= 'Rp ' . number_format($paket["harga"])  ?></td>
            <td style="padding-left: 20px;"><?= $paket['qty'];?>x</td>

            <td style="padding-left: 350px;"><?= 'Rp ' . number_format($paket["total"])  ?></td>
            <td>
                <div class="form-button-action">
                    <a href="edit_trans.php?id=<?= $paket['id_transaksi']; ?>&resi=<?= $id_resi?>" type="button" data-toggle="tooltip" title="" class="btn btn-link btn-primary btn-lg" data-original-title="Ganti jumlah">
                        <i class="fa fa-edit"></i>
                    </a>
                </td>
                <td>
                    <a href="transaksi/hapus_trans.php?id=<?= $paket['id_transaksi']; ?>&resi=<?= $id_resi?>" onclick="return confirm('Yakin hapus data?');" type="button" data-toggle="tooltip" title="" class="btn btn-link btn-danger" data-original-title="Hapus">
                        <i class="fa fa-times"></i>
                    </a>
                </div>
                </td>
</tr>
<?php }
    }
    }
?>


</tr>
 <tr>
        <td><b>Subtotal</b></td>
            <td colspan = 2></td>
        <td style="padding-left: 350px;"><b><?= 'Rp ' . number_format($total["total"])  ?></b></td>
</tr>


<tr>
        <td><b>Cash</b></td>
            <td colspan = 2></td>
        <td style="padding-left: 350px;"><b><?= 'Rp ' .  number_format($cash['bayar'])  ?></b></td>
</tr>


<?php
        if($cash['bayar'] != 0){
            foreach($cash as $c)
            $query_total1 = mysqli_query($conn, "SELECT kembalian('$c', '$id_resi') as kembali");
        if (mysqli_num_rows($query_total1) > 0) {
            while ($paket = mysqli_fetch_assoc($query_total1)) {
                ?>
<tr>
        <td><b>Kembalian</b></td>
            <td colspan = 2></td>
                <td style="padding-left: 350px;"><?= 'Rp ' . number_format($paket["kembali"])  ?></td>
</tr>
<?php
            }
        }
    }
    ?>


  <?php


?>

        </table>
        <hr>
        <form action="" method="post">
         <div class="form-group">
           <label for="exampleInputEmail1">Cash</label>
           <input type="number" class="form-control" name="bayar" id="exampleInputEmail1" aria-describedby="emailHelp" placeholder="Input cash" >
         </div>
         <button type="submit" name="btn-bayar" class="btn btn-primary">Submit</button>
    </form>
        <hr>
        <h4>Tambah Transaksi</h4>
        <div class="btn-group" role="group" aria-label="Basic example">
         <button type="button" class="btn btn-primary"><a style="color: white;" href="transaksi_barang.php?id=<?=$id_resi?>">Tambah Barang</a></button>
    </div>
    <hr>
</div>
 </div>
 </div>
        </div>
</div>
</div>
<?php
require 'footer.php';
?>
