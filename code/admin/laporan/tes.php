
 <?php

$title = 'Data Produk';
require '../koneksi.php';
$id_resi = $_GET['id'];
setlocale(LC_ALL, 'id_id');
setlocale(LC_TIME, 'id_ID.utf8');

$query = "SELECT r.*, c.nama FROM resi r INNER JOIN costumer c ON c.id_costumer = r.id_costumer
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
<!DOCTYPE html>
<html>

<head>
    <title></title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" integrity="sha384-JcKb8q3iqJ61gNV9KGb8thSsNjpSL0n8PARn9HuZOnIxN0hoP+VmmDGMN5t9UJ0Z" crossorigin="anonymous">
</head>
 <div id="invoice-POS">

    <center id="top">
      <div class="logo"></div>
      <div class="info">
        <h1>TOKO SEPATU ERS</h1>
      </div><!--End Info-->
    </center><!--End InvoiceTop-->

    <div id="mid">
      <div class="info">
        <h2>Contact Info</h2>
        <p>
            Address : street city, state 0000</br>
            Email   : JohnDoe@gmail.com</br>
            Phone   : 555-555-5555</br>
        </p>
      </div>
    </div><!--End Invoice Mid-->

    <div id="bot">

					<div id="table">

						<table>
							<tr class="tabletitle">
								<td class="item"><h2>Produk</h2></td>
								<td class="Hours"><h2>Harga</h2></td>
								<td class="Hours"><h2>Jumlah</h2></td>
								<td class="Rate"><h2>Sub Total</h2></td>
							</tr>
                            <?php
        if(!empty($id_tran)){
        foreach($id_tran as $tran);
        $query = "SELECT t.id_transaksi, t.qty, p.produk, p.harga, p.id_produk, totalhargaproduk('$tran') as total FROM produk p INNER JOIN transaksi t ON t.id_produk = p.id_produk WHERE t.no_resi = '$id_resi'";
        $t = mysqli_query($conn, $query);
        if (mysqli_num_rows($t) > 0) {
            while ($paket = mysqli_fetch_assoc($t)) {
        ?>
							<tr class="service">
								<td class="tableitem"><p class="itemtext"><?= $paket['produk'];?></p></td>
								<td class="tableitem"><p class="itemtext"><?= 'Rp ' . number_format($paket["harga"])  ?></p></td>
								<td class="tableitem"><p class="itemtext"><?= $paket['qty'];?></p></td>
								<td class="tableitem"><p class="itemtext"><?= 'Rp ' . number_format($paket["total"])  ?></p></td>
							</tr>
<?php }
    }
    }
?>



							<tr class="tabletitle">
								<td></td>
								<td class="Rate"><h2>Total</h2></td>
								<td class="payment"><h2><?= 'Rp ' . number_format($total["total"])  ?></h2></td>
							</tr>
                            <tr class="tabletitle">
								<td></td>
								<td class="Rate">Cash</td>
								<td class="payment"><h2><?= 'Rp ' .  number_format($cash['bayar'])  ?></h2></td>
							</tr>

                            <?php
                                    if(!empty($cash)){
                                        foreach($cash as $c)
                                        $query_total1 = mysqli_query($conn, "SELECT kembalian($c, '$id_resi') as kembali");
                                    if (mysqli_num_rows($query_total1) > 0) {
                                        while ($paket = mysqli_fetch_assoc($query_total1)) {
                                            ?>
                             <tr class="tabletitle">
								<td></td>
								<td class="Rate"><h2>Kembalian</h2></td>
								<td class="payment"><h2><?= 'Rp ' . number_format($paket["kembali"])  ?></h2></td>
							</tr>
                            <?php
                                        }
                                    }
                                }
                                ?>
						</table>
					</div><!--End Table-->

					<div id="legalcopy">
						<p class="legal"><strong>Thank you for your business!</strong>  Payment is expected within 31 days; please process this invoice within that time. There will be a 5% interest charge per month on late invoices.
						</p>
					</div>

				</div><!--End InvoiceBot-->
  </div><!--End Invoice-->
  </body>

</html>
  <script>
        window.print();
    </script>
<style>
    #invoice-POS{
  box-shadow: 0 0 1in -0.25in rgba(0, 0, 0, 0.5);
  padding:2mm;
  margin: 0 auto;
  width: 44mm;
  background: #FFF;


::selection {background: #f31544; color: #FFF;}
::moz-selection {background: #f31544; color: #FFF;}
h1{
  font-size: 1.5em;
  color: #222;
}
h2{font-size: .9em;}
h3{
  font-size: 1.2em;
  font-weight: 300;
  line-height: 2em;
}
p{
  font-size: .7em;
  color: #666;
  line-height: 1.2em;
}

#top, #mid,#bot{ /* Targets all id with 'col-' */
  border-bottom: 1px solid #EEE;
}

#top{min-height: 100px;}
#mid{min-height: 80px;}
#bot{ min-height: 50px;}

#top .logo{
  //float: left;
	height: 60px;
	width: 60px;
	background: url(http://michaeltruong.ca/images/logo1.png) no-repeat;
	background-size: 60px 60px;
}
.clientlogo{
  float: left;
	height: 60px;
	width: 60px;
	background: url(http://michaeltruong.ca/images/client.jpg) no-repeat;
	background-size: 60px 60px;
  border-radius: 50px;
}
.info{
  display: block;
  //float:left;
  margin-left: 0;
}
.title{
  float: right;
}
.title p{text-align: right;}
table{
  width: 100%;
  border-collapse: collapse;
}
td{
  //padding: 5px 0 5px 15px;
  //border: 1px solid #EEE
}
.tabletitle{
  //padding: 5px;
  font-size: .5em;
  background: #EEE;
}
.service{border-bottom: 1px solid #EEE;}
.item{width: 24mm;}
.itemtext{font-size: .5em;}

#legalcopy{
  margin-top: 5mm;
}



}
    </style>