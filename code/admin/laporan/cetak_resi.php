<?php

$title = 'Data Produk';
require '../koneksi.php';
$id_resi = $_GET['id'];
setlocale(LC_ALL, 'id_id');
setlocale(LC_TIME, 'id_ID.utf8');

$query = "SELECT r.*, c.nama, s.nama as nama_staff FROM resi r INNER JOIN costumer c ON c.id_costumer = r.id_costumer INNER JOIN staff s on r.id_kasir = s.id_staff
WHERE r.no_resi = '$id_resi'";
$data = mysqli_query($conn, $query);
$row = mysqli_fetch_assoc($data);

$querys = "SELECT * from toko where id_toko = 1";
$datas = mysqli_query($conn, $querys);
$rows = mysqli_fetch_assoc($datas);


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
	<meta http-equiv='Content-Type' content='text/html; charset=UTF-8' />

	<title>Editable Invoice</title>

	<link rel='stylesheet' type='text/css' href='css/style.css' />
	<link rel='stylesheet' type='text/css' href='css/print.css' media="print" />
	<script type='text/javascript' src='js/jquery-1.3.2.min.js'></script>
	<script type='text/javascript' src='js/example.js'></script>

</head>

<body>

	<div id="page-wrap">

		<textarea id="header">INVOICE</textarea>

		<div id="identity">

            <textarea id="address">
            <?php echo $rows['alamat'];?>

No Telp: <?php echo $rows['no_telp'];?></textarea>


		</div>

		<div style="clear:both"></div>

		<div id="customer">

            <textarea id="customer-title"><?php echo $rows['toko'];?></textarea>

            <table id="meta" style="width: 90%; margin: 50px; ">
                <tr>
                    <td class="meta-head">No Resi</td>
                    <td><textarea><?php echo $row['no_resi'];?></textarea></td>
                </tr>
                <tr>
                    <td class="meta-head">Nama Kasir</td>
                    <td><div class="due"><?php echo $row['nama_staff'];?></div></td>
                </tr>

                <tr>
                    <td class="meta-head">Nama Costumer</td>
                    <td><div class="due"><?php echo $row['nama'];?></div></td>
                </tr>
                <tr>
                    <td class="meta-head">Waktu Transaksi</td>
                    <td><textarea id="date"><?php echo $row['wkt_transaksi'];?></textarea></td>
                </tr>
            </table>

		</div>

		<table id="items">

		  <tr>
		      <th>Produk</th>
		      <th>Harga</th>
		      <th>Jumlah</th>
		      <th>Total</th>
		  </tr>
		  <?php
        if(!empty($id_tran)){

        $query = "SELECT t.id_transaksi, t.qty, p.produk, p.harga, p.id_produk, totalhargaproduk(t.id_transaksi) as total FROM produk p INNER JOIN transaksi t ON t.id_produk = p.id_produk WHERE t.no_resi = '$id_resi'";
        $t = mysqli_query($conn, $query);
        if (mysqli_num_rows($t) > 0) {
            while ($paket = mysqli_fetch_assoc($t)) {
        ?>

		<tr class="item-row">
		      <td class="item-name"><textarea><?= $paket['produk'];?></textarea></td>
		      <td><textarea class="cost"><?= 'Rp ' . number_format($paket["harga"])  ?></textarea></td>
		      <td><textarea class="qty"><?= $paket['qty'];?></textarea></td>
		      <td><span class="price"><?= 'Rp ' . number_format($paket["total"])  ?></span></td>
		  </tr>

<?php }
    }
    }
?>

		  <tr>
		      <td colspan="2" class="blank"> </td>
		      <td colspan="2" class="total-line">Subtotal</td>
		      <td class="total-value"><div id="subtotal"><?= 'Rp ' . number_format($total["total"])  ?></div></td>
		  </tr>
		  <tr>
		      <td colspan="2" class="blank"> </td>
		      <td colspan="2" class="total-line">Cash</td>

		      <td class="total-value"><div id="paid"><?= 'Rp ' .  number_format($cash['bayar'])  ?></div></td>
		  </tr>
		  <?php
        if(!empty($cash)){
            foreach($cash as $c);
            $query_total1 = mysqli_query($conn, "SELECT kembalian('$c', '$id_resi') as kembali");
        if (mysqli_num_rows($query_total1) > 0) {
            while ($paket = mysqli_fetch_assoc($query_total1)) {
                ?>
				  <tr>
		      <td colspan="2" class="blank"> </td>
		      <td colspan="2" class="total-line balance">Kembalian</td>
		      <td class="total-value balance"><div class="due"><?= 'Rp ' . number_format($paket["kembali"])  ?></div></td>
		  </tr>
<?php
            }
        }
    }
    ?>


		</table>

		<div id="terms">
		  <h5>Terima Kasih!</h5>
		  <textarea></textarea>
		</div>

	</div>
	<script>
        window.print();
    </script>
</body>

</html>

<style>
	/*
	 CSS-Tricks Example
	 by Chris Coyier
	 http://css-tricks.com
*/

* { margin: 0; padding: 0; }
body { font: 14px/1.4 Georgia, serif; }
#page-wrap { width: 800px; margin: 0 auto; }

textarea { border: 0; font: 14px Georgia, Serif; overflow: hidden; resize: none; }
table { border-collapse: collapse; }
table td, table th { border: 1px solid black; padding: 5px; }

#header { height: 25px; width: 100%; margin: 20px 0; background: #222; text-align: center; color: white; font: bold 15px Helvetica, Sans-Serif; text-decoration: uppercase; letter-spacing: 20px; padding: 8px 0px; }

#address { width: 250px; height: 150px; float: left; }
#customer { overflow: hidden; }

#logo { text-align: right; float: right; position: relative; margin-top: 25px; border: 1px solid #fff; max-width: 540px; max-height: 100px; overflow: hidden; }
#logo:hover, #logo.edit { border: 1px solid #000; margin-top: 0px; max-height: 125px; }
#logoctr { display: none; }
#logo:hover #logoctr, #logo.edit #logoctr { display: block; text-align: right; line-height: 25px; background: #eee; padding: 0 5px; }
#logohelp { text-align: left; display: none; font-style: italic; padding: 10px 5px;}
#logohelp input { margin-bottom: 5px; }
.edit #logohelp { display: block; }
.edit #save-logo, .edit #cancel-logo { display: inline; }
.edit #image, #save-logo, #cancel-logo, .edit #change-logo, .edit #delete-logo { display: none; }
#customer-title { font-size: 20px; font-weight: bold; float: left; }

#meta { margin-top: 1px; width: 300px; float: right; }
#meta td { text-align: right;  }
#meta td.meta-head { text-align: left; background: #eee; }
#meta td textarea { width: 100%; height: 20px; text-align: right; }

#items { clear: both; width: 100%; margin: 30px 0 0 0; border: 1px solid black; }
#items th { background: #eee; }
#items textarea { width: 80px; height: 50px; }
#items tr.item-row td { border: 0; vertical-align: top; }
#items td.description { width: 300px; }
#items td.item-name { width: 175px; }
#items td.description textarea, #items td.item-name textarea { width: 100%; }
#items td.total-line { border-right: 0; text-align: right; }
#items td.total-value { border-left: 0; padding: 10px; }
#items td.total-value textarea { height: 20px; background: none; }
#items td.balance { background: #eee; }
#items td.blank { border: 0; }

#terms { text-align: center; margin: 20px 0 0 0; }
#terms h5 { text-transform: uppercase; font: 13px Helvetica, Sans-Serif; letter-spacing: 10px; border-bottom: 1px solid black; padding: 0 0 8px 0; margin: 0 0 8px 0; }
#terms textarea { width: 100%; text-align: center;}

textarea:hover, textarea:focus, #items td.total-value textarea:hover, #items td.total-value textarea:focus, .delete:hover { background-color:#EEFF88; }

.delete-wpr { position: relative; }
.delete { display: block; color: #000; text-decoration: none; position: absolute; background: #EEEEEE; font-weight: bold; padding: 0px 3px; border: 1px solid; top: -6px; left: -22px; font-family: Verdana; font-size: 12px; }
</style>