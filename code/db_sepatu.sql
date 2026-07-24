-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 13, 2023 at 10:58 AM
-- Server version: 10.4.24-MariaDB
-- PHP Version: 8.1.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_sepatu`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `aset_dalam_rentang_tanggal` (IN `tgl1` DATE, IN `tgl2` DATE)   BEGIN
select t.id_transaksi as ID_transaksi, concat(p.produk, " ", p.warna, " ", p.ukuran) as Produk, k.nama_kategori as Kategori, p.harga as Harga, t.qty as Jumlah_beli,  totalhargaproduk(t.id_transaksi) AS Total, t.waktu AS Waktu_transaksi from transaksi t JOIN produk p on t.id_produk = p.id_produk join kategori k on p.kategori = k.id_kategori where date(t.waktu) BETWEEN tgl1 and tgl2;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `aset_dalam_rentang_tanggal_ket` (IN `tgl1` DATE, IN `tgl2` DATE, IN `ket` INT(2))   BEGIN
select t.id_transaksi as ID_transaksi, concat(p.produk, " ", p.warna, " ", p.ukuran) as Produk, k.nama_kategori as Kategori, p.harga as Harga, t.qty as Jumlah_beli,  totalhargaproduk(t.id_transaksi) AS Total, t.waktu AS Waktu_transaksi from transaksi t JOIN produk p on t.id_produk = p.id_produk join kategori k on p.kategori = k.id_kategori where k.id_kategori = ket AND date(t.waktu) between tgl1 and tgl2 and k.id_kategori = ket;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `aset_total` ()   BEGIN
select t.id_transaksi as ID_transaksi, concat(p.produk, " ", p.warna, " ", p.ukuran) as Produk, k.nama_kategori as Kategori, p.harga as Harga, t.qty as Jumlah_beli,  totalhargaproduk(t.id_transaksi) AS Total, t.waktu AS Waktu_transaksi from transaksi t JOIN produk p on t.id_produk = p.id_produk join kategori k on p.kategori = k.id_kategori;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `aset_total_kategori` (IN `ket` INT(5))   BEGIN
select t.id_transaksi as ID_transaksi, concat(p.produk, " ", p.warna, " ", p.ukuran) as Produk, k.nama_kategori as Kategori, p.harga as Harga, t.qty as Jumlah_beli,  totalhargaproduk(t.id_transaksi) AS Total, t.waktu AS Waktu_transaksi from transaksi t JOIN produk p on t.id_produk = p.id_produk join kategori k on p.kategori = k.id_kategori where k.id_kategori = ket;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `aset_total_ket_bln` (IN `bln` INT(2), IN `thn` INT(4), IN `ket` INT(5))   BEGIN
select t.id_transaksi as ID_transaksi, concat(p.produk, " ", p.warna, " ", p.ukuran) as Produk, k.nama_kategori as Kategori, p.harga as Harga, t.qty as Jumlah_beli,  totalhargaproduk(t.id_transaksi) AS Total, t.waktu AS Waktu_transaksi from transaksi t JOIN produk p on t.id_produk = p.id_produk join kategori k on p.kategori = k.id_kategori where month(t.waktu) = bln AND year(t.waktu) = thn AND k.id_kategori = ket;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `aset_total_perbulan` (IN `bln` INT(2), IN `thn` INT(4))   BEGIN
select t.id_transaksi as ID_transaksi, concat(p.produk, " ", p.warna, " ", p.ukuran) as Produk, k.nama_kategori as Kategori, p.harga as Harga, t.qty as Jumlah_beli,  totalhargaproduk(t.id_transaksi) AS Total, t.waktu AS Waktu_transaksi from transaksi t JOIN produk p on t.id_produk = p.id_produk join kategori k on p.kategori = k.id_kategori where month(t.waktu) = bln AND year(t.waktu) = thn;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `aset_dalam_rentang_tanggal` (`tgl1` DATE, `tgl2` DATE) RETURNS FLOAT  BEGIN
DECLARE t float;
SELECT SUM(totalhargaproduk(id_transaksi))  INTO t from transaksi where DATE(waktu) between tgl1 and tgl2;
RETURN t;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `aset_dalam_rentang_tanggal_ket` (`tgl1` DATE, `tgl2` DATE, `ket` INT(2)) RETURNS FLOAT  BEGIN
DECLARE t float;
select SUM(totalhargaproduk(t.id_transaksi)) INTO t from transaksi t join produk p on p.id_produk = t.id_produk join kategori k on p.kategori = k.id_kategori where DATE(waktu) between tgl1 and tgl2 AND k.id_kategori = ket;
RETURN t;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `aset_harian` (`tgl` DATE) RETURNS FLOAT  BEGIN
DECLARE t float;
SELECT SUM(totalhargaproduk(id_transaksi))  INTO t from transaksi where DATE(waktu) = tgl;
RETURN t;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `kembalian` (`bayar` FLOAT(12), `id_resi` INT(5)) RETURNS FLOAT  BEGIN
DECLARE Total float(15);
select total_resi(r.no_resi) INTO Total from resi r where r.no_resi = id_resi;
return ABS(Total - bayar);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `totalhargaproduk` (`no_transaksi` INT(10)) RETURNS FLOAT  BEGIN
DECLARE h_qty int;
DECLARE h_harga float;
SELECT qty INTO h_qty FROM transaksi WHERE id_transaksi = no_transaksi;
SELECT harga INTO h_harga FROM produk p JOIN transaksi t ON p.id_produk = t.id_produk
WHERE t.id_transaksi = no_transaksi;
RETURN h_qty*h_harga;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `total_aset` () RETURNS FLOAT  BEGIN
DECLARE t float;
SELECT SUM(totalhargaproduk(id_transaksi)) INTO t FROM transaksi;
RETURN t;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `total_aset_perbulan` (`bulan` INT(2), `tahun` INT(4)) RETURNS FLOAT  BEGIN
DECLARE t float;
SELECT SUM(totalhargaproduk(id_transaksi)) INTO t FROM transaksi where month(waktu) = bulan AND year(waktu) = tahun;
RETURN t;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `total_aset_per_kategori_barang` (`kategori` INT(5)) RETURNS FLOAT  BEGIN
DECLARE Total float(12);
select SUM(totalhargaproduk(t.id_transaksi)) INTO Total from transaksi t join produk p on p.id_produk = t.id_produk join kategori k on p.kategori = k.id_kategori where k.id_kategori = kategori;
RETURN Total;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `total_aset_per_kategori_bulanan` (`bulan` INT(2), `tahun` INT(4), `kat` INT(5)) RETURNS FLOAT  BEGIN
DECLARE Total float(12);
select SUM(totalhargaproduk(t.id_transaksi)) INTO Total from transaksi t join produk p on p.id_produk = t.id_produk join kategori k on p.kategori = k.id_kategori where month(t.waktu) = bulan AND year(t.waktu) = tahun AND k.id_kategori = kat;
RETURN Total;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `total_resi` (`id_resi` INT(5)) RETURNS FLOAT  BEGIN
DECLARE t float;
SELECT SUM(totalhargaproduk(id_transaksi)) INTO t FROM transaksi WHERE no_resi = id_resi;
RETURN t;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `costumer`
--

CREATE TABLE `costumer` (
  `id_costumer` int(5) NOT NULL,
  `nama` varchar(200) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `costumer`
--

INSERT INTO `costumer` (`id_costumer`, `nama`, `created_at`) VALUES
(72, 'kerinci', '2023-01-12 23:51:03'),
(74, 'Kenang', '2023-01-12 23:51:03'),
(82, 'vvbuu', '2023-01-13 01:18:27');

-- --------------------------------------------------------

--
-- Stand-in structure for view `data_costumer`
-- (See below for the actual view)
--
CREATE TABLE `data_costumer` (
`id_costumer` int(5)
,`Nama_cust` varchar(200)
,`no_resi` int(5)
,`Total` float
,`Cash` float
,`Waktu_transaksi` datetime
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `data_produk`
-- (See below for the actual view)
--
CREATE TABLE `data_produk` (
`id_produk` char(8)
,`nama_kategori` varchar(255)
,`produk` varchar(255)
,`warna` varchar(255)
,`ukuran` varchar(255)
,`harga` float unsigned
,`qty` int(4) unsigned
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `data_staff`
-- (See below for the actual view)
--
CREATE TABLE `data_staff` (
`id_staff` int(10)
,`nama` varchar(200)
,`tgl_lahir` date
,`kelamin` enum('P','L')
,`email` varchar(100)
,`alamat` varchar(200)
,`telepon` char(15)
,`status` enum('Aktif','Tidak aktif')
);

-- --------------------------------------------------------

--
-- Table structure for table `kategori`
--

CREATE TABLE `kategori` (
  `id_kategori` int(11) NOT NULL,
  `nama_kategori` varchar(255) NOT NULL,
  `wkt_input` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `kategori`
--

INSERT INTO `kategori` (`id_kategori`, `nama_kategori`, `wkt_input`) VALUES
(1, 'Sepatu', '2022-12-24 09:53:05'),
(2, 'Sendal', '2022-12-24 09:53:13'),
(3, 'Kaos Kaki', '2022-12-24 09:53:20'),
(4, 'Jepit Rambut', '2022-12-24 09:53:35');

-- --------------------------------------------------------

--
-- Table structure for table `log_produk`
--

CREATE TABLE `log_produk` (
  `id_produk` char(8) NOT NULL,
  `kategori_produk` varchar(30) NOT NULL,
  `produk` varchar(100) NOT NULL,
  `warna` varchar(255) NOT NULL,
  `ukuran` varchar(255) NOT NULL,
  `harga` int(10) NOT NULL,
  `qty` int(11) NOT NULL,
  `ket` enum('Update','Insert','Delete') NOT NULL,
  `waktu` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `log_produk`
--

INSERT INTO `log_produk` (`id_produk`, `kategori_produk`, `produk`, `warna`, `ukuran`, `harga`, `qty`, `ket`, `waktu`) VALUES
('produk', '0', 'TES', '', '', 10000, 0, 'Update', '2022-12-17 12:32:57'),
('jp_01', '0', 'Mango Pearls Hair Clips 3 Set', '', '', 244300, 0, 'Update', '2022-12-17 12:37:00'),
('jp_02', '0', 'Vero Moda Winnie Hair Claw Clip', '', '', 269000, 0, 'Update', '2022-12-17 12:37:00'),
('jp_03', '0', 'ALDO Emilis Hair Claw Clip', '', '', 272350, 0, 'Update', '2022-12-17 12:37:00'),
('jp_04', '0', 'ONLY 3 Pack Helene Hair Clips', '', '', 229500, 0, 'Update', '2022-12-17 12:37:00'),
('jp_05', '0', 'ALDO Bagar Hair Clip', '', '', 319000, 0, 'Update', '2022-12-17 12:37:00'),
('jp_06', '0', 'ONLY Maya Acrylic 3 Pack Hair Clips', '', '', 150150, 0, 'Update', '2022-12-17 12:37:00'),
('jp_07', '0', 'Pieces Konni 10 Pack Hairpins', '', '', 128700, 0, 'Update', '2022-12-17 12:37:00'),
('jp_08', '0', 'Call It Spring Theade Embellished Hairclip Set', '', '', 188100, 0, 'Update', '2022-12-17 12:37:00'),
('jp_09', '0', 'Ruby 2 Pack Amber Hair Claw', '', '', 166900, 0, 'Update', '2022-12-17 12:37:00'),
('jp_10', '0', 'Kings Collection Jepit Rambut Kupu Kupu Kristal', '', '', 419999, 0, 'Update', '2022-12-17 12:37:00'),
('sk_01', '0', 'ADIDAS low cut sock 3 pairs', '', '', 135000, 0, 'Update', '2022-12-17 12:37:00'),
('sk_02', '0', 'BOSS 2 Pack Stripe Logo Socks BOSS Body', '', '', 399000, 0, 'Update', '2022-12-17 12:37:00'),
('sk_03', '0', 'ADIDAS no show socks 3 pairs', '', '', 212500, 0, 'Update', '2022-12-17 12:37:00'),
('sk_04', '0', 'Gap Bas 3 Pack Ankle Socks', '', '', 261750, 0, 'Update', '2022-12-17 12:37:00'),
('sk_05', '0', 'Under Armour UA Heatgear Locut Socks', '', '', 312550, 0, 'Update', '2022-12-17 12:37:00'),
('sk_06', '0', 'PUMA Footie 3 Pairs Socks', '', '', 129000, 0, 'Update', '2022-12-17 12:37:00'),
('sk_07', '0', '2XU Ankle Sock 3 Pack', '', '', 419000, 0, 'Update', '2022-12-17 12:37:00'),
('sk_08', '0', 'New Balance Response Performance No Show', '', '', 129000, 0, 'Update', '2022-12-17 12:37:00'),
('sk_09', '0', 'ADIDAS thebe magugu crew socks 2 pairs', '', '', 379000, 0, 'Update', '2022-12-17 12:37:00'),
('sk_10', '0', 'UNDER Armour UA Core No Show 3 Pack', '', '', 199000, 0, 'Update', '2022-12-17 12:37:00'),
('sp_101', '0', 'ADIDAS Advantage Base Court Lifestyle Shoes', '', '', 750000, 0, 'Update', '2022-12-17 12:37:00'),
('sp_102', '0', 'Under Armour UA HOVR Apex 2 Training Shoes', '', '', 1727200, 0, 'Update', '2022-12-17 12:37:00'),
('sp_103', '0', 'ADIDAS Alphacomfy Running Shoes', '', '', 900000, 0, 'Update', '2022-12-17 12:37:00'),
('sp_104', '0', 'Converse Chuck Taylor 70s-HI', '', '', 1099000, 0, 'Update', '2022-12-17 12:37:00'),
('sp_105', '0', 'Nike Court Vision Low Next Nature Shoes', '', '', 799000, 0, 'Update', '2022-12-17 12:37:00'),
('sp_106', '0', 'New Balance 411 V2 Performance Shoes', '', '', 1099000, 0, 'Update', '2022-12-17 12:37:00'),
('sp_107', '0', 'New Balance 413 Performance Shoes', '', '', 863200, 0, 'Update', '2022-12-17 12:37:00'),
('sp_108', '0', 'Under Armour UA W Charged Assert 9 Shoes', '', '', 869000, 0, 'Update', '2022-12-17 12:37:00'),
('sp_109', '0', 'Nike Legend Essential 3 Next Nature Shoes', '', '', 819000, 0, 'Update', '2022-12-17 12:37:00'),
('sp_110', '0', 'VANS Ua Classic Slip-On', '', '', 899000, 0, 'Update', '2022-12-17 12:37:00'),
('sp_201', '0', 'Marie Claire Sepatu Flats Wanita Margie', '', '', 349900, 0, 'Update', '2022-12-17 12:37:00'),
('sp_202', '0', 'Marie Claire Sepatu Heels Wanita Cachel', '', '', 379900, 0, 'Update', '2022-12-17 12:37:00'),
('sp_203', '0', 'Guess Combat Boots', '', '', 161450, 0, 'Update', '2022-12-17 12:37:00'),
('sp_204', '0', 'ALDO Inflata Ankle Boots', '', '', 3339000, 0, 'Update', '2022-12-17 12:37:00'),
('sp_205', '0', 'Milliot & Co. Kym Pointed Toe Flats Shoes', '', '', 384300, 0, 'Update', '2022-12-17 12:37:00'),
('sp_206', '0', 'ALDO Ibreda Loafers', '', '', 941850, 0, 'Update', '2022-12-17 12:37:00'),
('sp_207', '0', 'PUMA Electrify Nitro Womens Running Shoes', '', '', 1154300, 0, 'Update', '2022-12-17 12:37:00'),
('sp_208', '0', 'ONLY Shilo Pu Sneaker', '', '', 547400, 0, 'Update', '2022-12-17 12:37:00'),
('sp_209', '0', 'ALDO Veadith Loafers', '', '', 1699000, 0, 'Update', '2022-12-17 12:37:00'),
('sp_210', '0', 'Milliot & Co. Princess Pointed Toe Flats Shoes', '', '', 518000, 0, 'Update', '2022-12-17 12:37:00'),
('sd_101', '0', 'Birkenstock Atacama Adventure Crosscountry Sandals', '', '', 1959300, 0, 'Update', '2022-12-17 12:37:00'),
('sd_102', '0', 'Birkenstock Soft Suede Nubuck Sandals', '', '', 2599000, 0, 'Update', '2022-12-17 12:37:00'),
('sd_103', '0', 'PUMA Divecat V2 Lite Slides', '', '', 299000, 0, 'Update', '2022-12-17 12:37:00'),
('sd_104', '0', 'Birkenstock Boston Oiled Leather Sandals', '', '', 1799000, 0, 'Update', '2022-12-17 12:37:00'),
('sd_105', '0', 'ALOPE Yeager Sandal gunung pria outdoor', '', '', 85000, 0, 'Update', '2022-12-17 12:37:00'),
('sd_106', '0', 'Guess Enuzo Slide Sandals', '', '', 1099000, 0, 'Update', '2022-12-17 12:37:00'),
('sd_107', '0', 'Zeger Footwear Sandal Kulit Pria BELLAMO 133', '', '', 229000, 0, 'Update', '2022-12-17 12:37:00'),
('sd_108', '0', 'Quiksilver Sessions Slide', '', '', 399000, 0, 'Update', '2022-12-17 12:37:00'),
('sd_109', '0', 'Superdry Core Pool Sliders Sportsyle Code', '', '', 369850, 0, 'Update', '2022-12-17 12:37:00'),
('sd_110', '0', 'PUMA Ultimate Comfort Sandals', '', '', 185000, 0, 'Update', '2022-12-17 12:37:00'),
('sd_201', '0', 'Birkenstock Arizona Smooth Leather Sandals', '', '', 1499000, 0, 'Update', '2022-12-17 12:37:00'),
('sd_202', '0', 'ADIDAS adilette aqua slides', '', '', 380000, 0, 'Update', '2022-12-17 12:37:00'),
('sd_203', '0', 'Kaninna Shoes Camden Slides', '', '', 199200, 0, 'Update', '2022-12-17 12:37:00'),
('sd_204', '0', 'Twenty Two Harmony Slingback Sandals', '', '', 279200, 0, 'Update', '2022-12-17 12:37:00'),
('sd_205', '0', 'Under Armour UA W Ignite IX Slides', '', '', 679000, 0, 'Update', '2022-12-17 12:37:00'),
('sd_206', '0', 'INPACA Strappy Flip Flop Sandals Elle', '', '', 259900, 0, 'Update', '2022-12-17 12:37:00'),
('sd_207', '0', 'INPACA Mono Strappy Mismatched Summer Sandals', '', '', 199900, 0, 'Update', '2022-12-17 12:37:00'),
('sd_208', '0', 'Kaninna Shoes Colby Sandals', '', '', 249000, 0, 'Update', '2022-12-17 12:37:00'),
('sd_209', '0', 'OSGOOD Sandals Oslo Walnut', '', '', 329900, 0, 'Update', '2022-12-17 12:37:00'),
('sd_210', '0', 'PUMA Sportstyle Core Popcat 20 Sandals', '', '', 259350, 0, 'Update', '2022-12-17 12:37:00'),
('tes', '0', 'tes', '', '', 10000, 0, 'Update', '2022-12-18 19:05:42'),
('', '0', '', '', '', 0, 0, 'Update', '2022-12-18 21:12:40'),
('sp_101', '0', '', '', '', 750000, 0, 'Update', '2022-12-23 01:43:42'),
('sp_101', '0', '', '', '', 0, 0, 'Update', '2022-12-23 16:40:58'),
('', '0', '', '', '', 100000, 0, 'Delete', '2022-12-24 15:42:49'),
('jp_01', '0', '', '', '', 244300, 0, 'Delete', '2022-12-24 15:42:49'),
('jp_02', '0', '', '', '', 269000, 0, 'Delete', '2022-12-24 15:42:49'),
('jp_03', '0', '', '', '', 272350, 0, 'Delete', '2022-12-24 15:42:49'),
('jp_04', '0', '', '', '', 229500, 0, 'Delete', '2022-12-24 15:42:49'),
('jp_05', '0', '', '', '', 319000, 0, 'Delete', '2022-12-24 15:42:49'),
('jp_06', '0', '', '', '', 150150, 0, 'Delete', '2022-12-24 15:42:49'),
('jp_07', '0', '', '', '', 128700, 0, 'Delete', '2022-12-24 15:42:49'),
('jp_08', '0', '', '', '', 188100, 0, 'Delete', '2022-12-24 15:42:49'),
('jp_09', '0', '', '', '', 166900, 0, 'Delete', '2022-12-24 15:42:49'),
('jp_10', '0', '', '', '', 419999, 0, 'Delete', '2022-12-24 15:42:49'),
('', 'Sepatu', '', '', '', 250000, 10, 'Insert', '2022-12-24 16:48:47'),
('kk_01', 'Kaos Kaki', 'kk_01', '', '', 100000, 10, 'Insert', '2022-12-24 16:50:52'),
('', 'Sepatu', '', '', '', 250000, 10, 'Update', '2022-12-24 17:13:22'),
('TES', 'Sendal', 'TES', '', '', 100000, 10, 'Insert', '2022-12-24 23:28:54'),
('TES', 'Sendal', 'TES', '', '', 100000, 10, 'Update', '2022-12-24 23:41:12'),
('', 'Sepatu', '', '', '', 250000, 9, 'Update', '2022-12-25 00:58:48'),
('', 'Sepatu', '', '', '', 250000, 9, 'Update', '2022-12-25 00:59:00'),
('kk_01', 'Kaos Kaki', 'kk_01', '', '', 100000, 10, 'Update', '2022-12-25 00:59:45'),
('kk_01', 'Sepatu', 'kk_01', '', '', 100000, 10, 'Update', '2022-12-25 01:00:59'),
('kk_01', 'Sepatu', 'kk_01', '', '', 100000, 10, 'Update', '2022-12-25 01:01:23'),
('kk_01', 'Sepatu', 'kk_01', '', '', 100000, 10, 'Update', '2022-12-25 01:01:32'),
('', 'Jepit Rambut', '', '', '', 250000, 9, 'Delete', '2022-12-25 01:08:00'),
('TES', 'Sendal', 'TES', '', '', 100000, 9, 'Delete', '2022-12-25 01:08:36'),
('kk_01', 'Kaos Kaki', 'kk_01', '', '', 100000, 10, 'Delete', '2022-12-25 01:10:23'),
('Tes', 'Sepatu', 'Tes', '', '', 100000, 10, 'Insert', '2022-12-25 01:40:47'),
('Tes', 'Sepatu', 'Tes', '', '', 100000, 10, 'Update', '2022-12-25 01:40:57'),
('Tes', 'Sepatu', 'Tes', '', '', 100000, 10, 'Update', '2022-12-25 13:08:11'),
('Tes', 'Sepatu', 'Tes', '', '', 100000, 7, 'Update', '2022-12-25 13:09:20'),
('Tes', 'Sepatu', 'Tes', '', '', 100000, 4, 'Update', '2022-12-25 13:11:01'),
('Tes', 'Sepatu', 'Tes', '', '', 100000, 1, 'Update', '2022-12-25 13:12:57'),
('Tes', 'Sepatu', 'Tes', '', '', 100000, 0, 'Update', '2022-12-25 13:36:21'),
('Tes', 'Sepatu', 'Tes', '', '', 100000, 1, 'Update', '2022-12-25 13:36:31'),
('Tes', 'Sepatu', 'Tes', '', '', 100000, 4, 'Update', '2022-12-25 13:36:34'),
('Tes', 'Sepatu', 'Tes', '', '', 100000, 7, 'Update', '2022-12-25 13:36:36'),
('Tes', 'Sepatu', 'Tes', '', '', 100000, 10, 'Update', '2022-12-25 13:45:15'),
('Tes', 'Sepatu', 'Tes', '', '', 100000, 9, 'Update', '2022-12-25 13:58:35'),
('jp_01', 'Kaos Kaki', 'jp_01', '', '', 15000, 10, 'Insert', '2022-12-25 16:18:27'),
('jp_01', 'Kaos Kaki', 'jp_01', '', '', 15000, 10, 'Update', '2022-12-25 16:18:41'),
('jp_01', 'Kaos Kaki', 'jp_01', '', '', 15000, 10, 'Update', '2022-12-25 16:20:54'),
('jp_01', 'Kaos Kaki', 'jp_01', '', '', 15000, 8, 'Update', '2022-12-25 18:56:25'),
('jp_01', 'Kaos Kaki', 'jp_01', '', '', 15000, 10, 'Update', '2022-12-25 18:59:01'),
('jp_01', 'Kaos Kaki', 'jp_01', '', '', 15000, 9, 'Update', '2022-12-25 18:59:01'),
('jp_01', 'Kaos Kaki', 'jp_01', '', '', 15000, 9, 'Update', '2022-12-25 18:59:36'),
('jp_01', 'Kaos Kaki', 'jp_01', '', '', 15000, 10, 'Update', '2022-12-25 19:21:47'),
('jp_01', 'Kaos Kaki', 'jp_01', '', '', 15000, 5, 'Update', '2022-12-25 19:21:47'),
('Tes', 'Sepatu', 'Tes', '', '', 100000, 8, 'Update', '2022-12-25 20:47:51'),
('jp_01', 'Kaos Kaki', 'jp_01', '', '', 15000, 5, 'Update', '2022-12-25 20:49:52'),
('Tes', 'Sepatu', 'Tes', '', '', 100000, 10, 'Update', '2022-12-26 00:58:33'),
('Tes', 'Sepatu', 'Tes', '', '', 100000, 6, 'Update', '2022-12-26 00:58:33'),
('Tes', 'Sepatu', 'Tes', '', '', 100000, 6, 'Update', '2022-12-26 14:42:35'),
('Tes', 'Sepatu', 'Tes', '', '', 100000, 10, 'Update', '2022-12-26 15:18:51'),
('Tes', 'Sepatu', 'Tes', '', '', 100000, 8, 'Update', '2022-12-26 15:18:51'),
('Tes', 'Sepatu', 'Tes', '', '', 100000, 8, 'Update', '2022-12-26 16:24:39'),
('jp_1', 'Jepit Rambut', 'jp_1', '', '', 244300, 25, 'Insert', '2022-12-27 00:25:42'),
('jp_2', 'Jepit Rambut', 'jp_2', '', '', 269000, 30, 'Insert', '2022-12-27 00:25:42'),
('jp_3', 'Jepit Rambut', 'jp_3', '', '', 272350, 21, 'Insert', '2022-12-27 00:25:42'),
('jp_4', 'Jepit Rambut', 'jp_4', '', '', 229500, 32, 'Insert', '2022-12-27 00:25:42'),
('jp_5', 'Jepit Rambut', 'jp_5', '', '', 319000, 12, 'Insert', '2022-12-27 00:25:42'),
('sd_1', 'Sendal', 'sd_1', '', '', 85000, 5, 'Insert', '2022-12-27 00:25:42'),
('sd_2', 'Sendal', 'sd_2', '', '', 85000, 5, 'Insert', '2022-12-27 00:25:42'),
('sd_3', 'Sendal', 'sd_3', '', '', 85000, 5, 'Insert', '2022-12-27 00:25:42'),
('sd_4', 'Sendal', 'sd_4', '', '', 85000, 5, 'Insert', '2022-12-27 00:25:42'),
('sd_5', 'Sendal', 'sd_5', '', '', 1099000, 3, 'Insert', '2022-12-27 00:25:42'),
('sd_6', 'Sendal', 'sd_6', '', '', 1099000, 3, 'Insert', '2022-12-27 00:25:42'),
('sd_7', 'Sendal', 'sd_7', '', '', 1099000, 3, 'Insert', '2022-12-27 00:25:42'),
('sd_8', 'Sendal', 'sd_8', '', '', 229000, 6, 'Insert', '2022-12-27 00:25:42'),
('sd_9', 'Sendal', 'sd_9', '', '', 229000, 4, 'Insert', '2022-12-27 00:25:42'),
('sd_10', 'Sendal', 'sd_10', '', '', 229000, 6, 'Insert', '2022-12-27 00:25:42'),
('sd_11', 'Sendal', 'sd_11', '', '', 399000, 5, 'Insert', '2022-12-27 00:25:42'),
('sd_12', 'Sendal', 'sd_12', '', '', 399000, 5, 'Insert', '2022-12-27 00:25:42'),
('sd_13', 'Sendal', 'sd_13', '', '', 399000, 5, 'Insert', '2022-12-27 00:25:42'),
('sd_14', 'Sendal', 'sd_14', '', '', 1499000, 2, 'Insert', '2022-12-27 00:25:42'),
('sd_15', 'Sendal', 'sd_15', '', '', 1499000, 2, 'Insert', '2022-12-27 00:25:42'),
('sd_16', 'Sendal', 'sd_16', '', '', 1499000, 2, 'Insert', '2022-12-27 00:25:42'),
('sd_17', 'Sendal', 'sd_17', '', '', 380000, 2, 'Insert', '2022-12-27 00:25:42'),
('sd_18', 'Sendal', 'sd_18', '', '', 380000, 2, 'Insert', '2022-12-27 00:25:42'),
('sd_19', 'Sendal', 'sd_19', '', '', 199200, 3, 'Insert', '2022-12-27 00:25:42'),
('sd_20', 'Sendal', 'sd_20', '', '', 199200, 3, 'Insert', '2022-12-27 00:25:42'),
('sd_21', 'Sendal', 'sd_21', '', '', 199200, 3, 'Insert', '2022-12-27 00:25:42'),
('sd_22', 'Sendal', 'sd_22', '', '', 279200, 4, 'Insert', '2022-12-27 00:25:42'),
('sd_23', 'Sendal', 'sd_23', '', '', 279200, 4, 'Insert', '2022-12-27 00:25:42'),
('sd_24', 'Sendal', 'sd_24', '', '', 279200, 4, 'Insert', '2022-12-27 00:25:42'),
('sk_1', 'Kaos Kaki', 'sk_1', '', '', 312550, 12, 'Insert', '2022-12-27 00:25:42'),
('sk_2', 'Kaos Kaki', 'sk_2', '', '', 312550, 12, 'Insert', '2022-12-27 00:25:42'),
('sk_3', 'Kaos Kaki', 'sk_3', '', '', 312550, 12, 'Insert', '2022-12-27 00:25:42'),
('sk_4', 'Kaos Kaki', 'sk_4', '', '', 312550, 12, 'Insert', '2022-12-27 00:25:42'),
('sk_5', 'Kaos Kaki', 'sk_5', '', '', 129000, 11, 'Insert', '2022-12-27 00:25:42'),
('sk_6', 'Kaos Kaki', 'sk_6', '', '', 129000, 11, 'Insert', '2022-12-27 00:25:42'),
('sk_7', 'Kaos Kaki', 'sk_7', '', '', 129000, 11, 'Insert', '2022-12-27 00:25:42'),
('sk_8', 'Kaos Kaki', 'sk_8', '', '', 419000, 6, 'Insert', '2022-12-27 00:25:42'),
('sk_9', 'Kaos Kaki', 'sk_9', '', '', 419000, 6, 'Insert', '2022-12-27 00:25:42'),
('sk_10', 'Kaos Kaki', 'sk_10', '', '', 419000, 6, 'Insert', '2022-12-27 00:25:42'),
('sk_11', 'Kaos Kaki', 'sk_11', '', '', 129000, 20, 'Insert', '2022-12-27 00:25:42'),
('sk_12', 'Kaos Kaki', 'sk_12', '', '', 129000, 20, 'Insert', '2022-12-27 00:25:42'),
('sk_13', 'Kaos Kaki', 'sk_13', '', '', 129000, 20, 'Insert', '2022-12-27 00:25:42'),
('sp_1', 'Sepatu', 'sp_1', '', '', 799000, 6, 'Insert', '2022-12-27 00:25:42'),
('sp_2', 'Sepatu', 'sp_2', '', '', 799000, 6, 'Insert', '2022-12-27 00:25:42'),
('sp_3', 'Sepatu', 'sp_3', '', '', 799000, 6, 'Insert', '2022-12-27 00:25:42'),
('sp_4', 'Sepatu', 'sp_4', '', '', 799000, 6, 'Insert', '2022-12-27 00:25:42'),
('sp_5', 'Sepatu', 'sp_5', '', '', 1099000, 7, 'Insert', '2022-12-27 00:25:42'),
('sp_6', 'Sepatu', 'sp_6', '', '', 1099000, 7, 'Insert', '2022-12-27 00:25:42'),
('sp_7', 'Sepatu', 'sp_7', '', '', 1099000, 7, 'Insert', '2022-12-27 00:25:42'),
('sp_8', 'Sepatu', 'sp_8', '', '', 863200, 9, 'Insert', '2022-12-27 00:25:42'),
('sp_9', 'Sepatu', 'sp_9', '', '', 863200, 9, 'Insert', '2022-12-27 00:25:42'),
('sp_10', 'Sepatu', 'sp_10', '', '', 349900, 6, 'Insert', '2022-12-27 00:25:42'),
('sp_11', 'Sepatu', 'sp_11', '', '', 349900, 6, 'Insert', '2022-12-27 00:25:42'),
('sp_12', 'Sepatu', 'sp_12', '', '', 349900, 6, 'Insert', '2022-12-27 00:25:42'),
('sp_13', 'Sepatu', 'sp_13', '', '', 349900, 6, 'Insert', '2022-12-27 00:25:42'),
('sp_14', 'Sepatu', 'sp_14', '', '', 349900, 6, 'Insert', '2022-12-27 00:25:42'),
('sp_15', 'Sepatu', 'sp_15', '', '', 379900, 7, 'Insert', '2022-12-27 00:25:42'),
('sp_16', 'Sepatu', 'sp_16', '', '', 379900, 7, 'Insert', '2022-12-27 00:25:42'),
('sp_17', 'Sepatu', 'sp_17', '', '', 379900, 7, 'Insert', '2022-12-27 00:25:42'),
('sp_18', 'Sepatu', 'sp_18', '', '', 379900, 7, 'Insert', '2022-12-27 00:25:42'),
('sp_19', 'Sepatu', 'sp_19', '', '', 161450, 1, 'Insert', '2022-12-27 00:25:42'),
('sp_20', 'Sepatu', 'sp_20', '', '', 161450, 1, 'Insert', '2022-12-27 00:25:42'),
('sp_21', 'Sepatu', 'sp_21', '', '', 161450, 1, 'Insert', '2022-12-27 00:25:42'),
('sp_22', 'Sepatu', 'sp_22', '', '', 3339000, 4, 'Insert', '2022-12-27 00:25:42'),
('sp_23', 'Sepatu', 'sp_23', '', '', 3339000, 4, 'Insert', '2022-12-27 00:25:42'),
('sp_24', 'Sepatu', 'sp_24', '', '', 3339000, 4, 'Insert', '2022-12-27 00:25:42'),
('sp_25', 'Sepatu', 'sp_25', '', '', 3339000, 4, 'Insert', '2022-12-27 00:25:42'),
('sp_1', 'Sepatu', 'sp_1', '', '', 799000, 6, 'Update', '2022-12-27 02:15:56'),
('sp_1', 'Sepatu', 'sp_1', '', '', 799000, 4, 'Update', '2022-12-27 02:15:56'),
('sp_11', 'Sepatu', 'sp_11', '', '', 349900, 6, 'Update', '2022-12-27 02:17:31'),
('sp_11', 'Sepatu', 'sp_11', '', '', 349900, 5, 'Update', '2022-12-27 02:17:31'),
('sp_11', 'Sepatu', 'sp_11', '', '', 349900, 5, 'Update', '2022-12-27 02:18:32'),
('sp_11', 'Sepatu', 'sp_11', '', '', 349900, 4, 'Update', '2022-12-27 02:18:32'),
('sp_11', 'Sepatu', 'sp_11', '', '', 349900, 4, 'Update', '2022-12-27 02:20:55'),
('sp_11', 'Sepatu', 'sp_11', '', '', 349900, 3, 'Update', '2022-12-27 02:20:55'),
('sp_11', 'Sepatu', 'sp_11', '', '', 349900, 3, 'Update', '2022-12-27 02:23:15'),
('sp_11', 'Sepatu', 'sp_11', '', '', 349900, 4, 'Update', '2022-12-27 02:23:18'),
('sp_11', 'Sepatu', 'sp_11', '', '', 349900, 5, 'Update', '2022-12-27 02:23:21'),
('sp_11', 'Sepatu', 'sp_11', '', '', 349900, 6, 'Update', '2022-12-27 02:23:29'),
('sp_11', 'Sepatu', 'sp_11', '', '', 349900, 5, 'Update', '2022-12-27 02:23:29'),
('sp_11', 'Sepatu', 'sp_11', '', '', 349900, 5, 'Update', '2022-12-27 02:26:10'),
('sp_11', 'Sepatu', 'sp_11', '', '', 349900, 4, 'Update', '2022-12-27 02:26:10'),
('sp_11', 'Sepatu', 'sp_11', '', '', 349900, 4, 'Update', '2022-12-27 02:27:17'),
('sp_11', 'Sepatu', 'sp_11', '', '', 349900, 3, 'Update', '2022-12-27 02:27:17'),
('sp_11', 'Sepatu', 'sp_11', '', '', 349900, 3, 'Update', '2022-12-27 02:27:25'),
('sp_11', 'Sepatu', 'sp_11', '', '', 349900, 4, 'Update', '2022-12-27 02:27:28'),
('sp_11', 'Sepatu', 'sp_11', '', '', 349900, 5, 'Update', '2022-12-27 02:27:30'),
('sp_1', 'Sepatu', 'sp_1', '', '', 799000, 4, 'Update', '2022-12-27 02:27:33'),
('sp_13', 'Sepatu', 'sp_13', '', '', 349900, 6, 'Update', '2022-12-27 02:27:40'),
('sp_13', 'Sepatu', 'sp_13', '', '', 349900, 4, 'Update', '2022-12-27 02:27:40'),
('sp_12', 'Sepatu', 'sp_12', '', '', 349900, 6, 'Update', '2022-12-27 02:27:54'),
('sp_12', 'Sepatu', 'sp_12', '', '', 349900, 4, 'Update', '2022-12-27 02:27:54'),
('Tes', 'Sepatu', 'Tes', '', '', 100000, 10, 'Update', '2022-12-27 02:28:08'),
('Tes', 'Sepatu', 'Tes', '', '', 100000, 9, 'Update', '2022-12-27 02:28:08'),
('Tes', 'Sepatu', 'Tes', '', '', 100000, 9, 'Update', '2022-12-27 02:29:15'),
('Tes', 'Sepatu', 'Tes', '', '', 100000, 8, 'Update', '2022-12-27 02:29:15'),
('Tes', 'Sepatu', 'Tes', '', '', 100000, 8, 'Update', '2022-12-27 02:30:34'),
('Tes', 'Sepatu', 'Tes', '', '', 100000, 7, 'Update', '2022-12-27 02:30:34'),
('Tes', 'Sepatu', 'Tes', '', '', 100000, 7, 'Update', '2022-12-27 02:32:48'),
('Tes', 'Sepatu', 'Tes', '', '', 100000, 6, 'Update', '2022-12-27 02:32:48'),
('Tes', 'Sepatu', 'Tes', '', '', 100000, 6, 'Update', '2022-12-27 02:33:01'),
('Tes', 'Sepatu', 'Tes', '', '', 100000, 7, 'Update', '2022-12-27 02:33:04'),
('Tes', 'Sepatu', 'Tes', '', '', 100000, 8, 'Update', '2022-12-27 02:33:06'),
('Tes', 'Sepatu', 'Tes', '', '', 100000, 9, 'Update', '2022-12-27 02:33:08'),
('sp_12', 'Sepatu', 'sp_12', '', '', 349900, 4, 'Update', '2022-12-27 02:33:11'),
('sp_13', 'Sepatu', 'sp_13', '', '', 349900, 4, 'Update', '2022-12-27 02:33:13'),
('sp_1', 'Sepatu', 'sp_1', '', '', 799000, 6, 'Update', '2022-12-27 02:33:35'),
('sp_1', 'Sepatu', 'sp_1', '', '', 799000, 5, 'Update', '2022-12-27 02:33:35'),
('sp_10', 'Sepatu', 'sp_10', '', '', 349900, 6, 'Update', '2022-12-27 02:33:40'),
('sp_10', 'Sepatu', 'sp_10', '', '', 349900, 5, 'Update', '2022-12-27 02:33:40'),
('sp_10', 'Sepatu', 'sp_10', '', '', 349900, 5, 'Update', '2022-12-27 02:34:11'),
('sp_10', 'Sepatu', 'sp_10', '', '', 349900, 4, 'Update', '2022-12-27 02:34:11'),
('sp_10', 'Sepatu', 'sp_10', '', '', 349900, 4, 'Update', '2022-12-27 02:34:34'),
('sp_10', 'Sepatu', 'sp_10', '', '', 349900, 3, 'Update', '2022-12-27 02:34:34'),
('sp_10', 'Sepatu', 'sp_10', '', '', 349900, 3, 'Update', '2022-12-27 02:43:00'),
('sp_10', 'Sepatu', 'sp_10', '', '', 349900, 4, 'Update', '2022-12-27 02:43:03'),
('sp_10', 'Sepatu', 'sp_10', '', '', 349900, 5, 'Update', '2022-12-27 02:43:05'),
('sp_10', 'Sepatu', 'sp_10', '', '', 349900, 6, 'Update', '2022-12-27 02:43:19'),
('sp_10', 'Sepatu', 'sp_10', '', '', 349900, 3, 'Update', '2022-12-27 02:43:19'),
('sp_16', 'Sepatu', 'sp_16', '', '', 379900, 7, 'Update', '2022-12-27 02:58:42'),
('sp_16', 'Sepatu', 'sp_16', '', '', 379900, 5, 'Update', '2022-12-27 02:58:42'),
('sp_16', 'Sepatu', 'sp_16', '', '', 379900, 5, 'Update', '2022-12-27 02:59:21'),
('sp_16', 'Sepatu', 'sp_16', '', '', 379900, 3, 'Update', '2022-12-27 02:59:21'),
('sp_16', 'Sepatu', 'sp_16', '', '', 379900, 3, 'Update', '2022-12-27 02:59:42'),
('sp_16', 'Sepatu', 'sp_16', '', '', 379900, 1, 'Update', '2022-12-27 02:59:42'),
('sp_16', 'Sepatu', 'sp_16', '', '', 379900, 1, 'Update', '2022-12-27 03:04:18'),
('sp_16', 'Sepatu', 'sp_16', '', '', 379900, 3, 'Update', '2022-12-27 03:04:21'),
('sp_16', 'Sepatu', 'sp_16', '', '', 379900, 5, 'Update', '2022-12-27 03:04:23'),
('sp_10', 'Sepatu', 'sp_10', '', '', 349900, 3, 'Update', '2022-12-27 03:04:26'),
('sp_17', 'Sepatu', 'sp_17', '', '', 379900, 7, 'Update', '2022-12-27 03:06:08'),
('sp_17', 'Sepatu', 'sp_17', '', '', 379900, 6, 'Update', '2022-12-27 03:06:08'),
('sp_17', 'Sepatu', 'sp_17', '', '', 379900, 6, 'Update', '2022-12-27 03:09:09'),
('sp_17', 'Sepatu', 'sp_17', '', '', 379900, 5, 'Update', '2022-12-27 03:09:09'),
('sp_17', 'Sepatu', 'sp_17', '', '', 379900, 5, 'Update', '2022-12-27 03:29:47'),
('sp_17', 'Sepatu', 'sp_17', '', '', 379900, 6, 'Update', '2022-12-27 03:29:50'),
('sp_10', 'Sepatu', 'sp_10', '', '', 349900, 6, 'Update', '2022-12-27 03:30:01'),
('sp_10', 'Sepatu', 'sp_10', '', '', 349900, 5, 'Update', '2022-12-27 03:30:01'),
('sp_10', 'Sepatu', 'sp_10', '', '', 349900, 5, 'Update', '2022-12-27 03:30:47'),
('sp_10', 'Sepatu', 'sp_10', '', '', 349900, 4, 'Update', '2022-12-27 03:30:47'),
('sp_25', 'Sepatu', 'sp_25', '', '', 3339000, 4, 'Update', '2022-12-27 03:31:01'),
('sp_25', 'Sepatu', 'sp_25', '', '', 3339000, 3, 'Update', '2022-12-27 03:31:01'),
('sp_25', 'Sepatu', 'sp_25', '', '', 3339000, 3, 'Update', '2022-12-27 03:31:33'),
('sp_10', 'Sepatu', 'sp_10', '', '', 349900, 4, 'Update', '2022-12-27 03:31:36'),
('sp_10', 'Sepatu', 'sp_10', '', '', 349900, 5, 'Update', '2022-12-27 03:31:40'),
('sp_13', 'Sepatu', 'sp_13', '', '', 349900, 6, 'Update', '2022-12-27 03:31:46'),
('sp_13', 'Sepatu', 'sp_13', '', '', 349900, 5, 'Update', '2022-12-27 03:31:46'),
('sp_13', 'Sepatu', 'sp_13', '', '', 349900, 5, 'Update', '2022-12-27 03:36:36'),
('sp_13', 'Sepatu', 'sp_13', '', '', 349900, 4, 'Update', '2022-12-27 03:36:36'),
('sp_13', 'Sepatu', 'sp_13', '', '', 349900, 4, 'Update', '2022-12-27 03:37:18'),
('sp_13', 'Sepatu', 'sp_13', '', '', 349900, 3, 'Update', '2022-12-27 03:37:18'),
('sp_13', 'Sepatu', 'sp_13', '', '', 349900, 3, 'Update', '2022-12-27 03:37:30'),
('sp_13', 'Sepatu', 'sp_13', '', '', 349900, 2, 'Update', '2022-12-27 03:37:30'),
('sp_13', 'Sepatu', 'sp_13', '', '', 349900, 2, 'Update', '2022-12-27 03:37:56'),
('sp_13', 'Sepatu', 'sp_13', '', '', 349900, 1, 'Update', '2022-12-27 03:37:56'),
('sp_13', 'Sepatu', 'sp_13', '', '', 349900, 1, 'Update', '2022-12-27 03:38:00'),
('sp_13', 'Sepatu', 'sp_13', '', '', 349900, 2, 'Update', '2022-12-27 03:38:03'),
('sp_13', 'Sepatu', 'sp_13', '', '', 349900, 3, 'Update', '2022-12-27 03:38:09'),
('sp_13', 'Sepatu', 'sp_13', '', '', 349900, 4, 'Update', '2022-12-27 03:48:26'),
('sp_13', 'Sepatu', 'sp_13', '', '', 349900, 5, 'Update', '2022-12-27 03:48:29'),
('sp_11', 'Sepatu', 'sp_11', '', '', 349900, 6, 'Update', '2022-12-27 03:55:19'),
('sp_11', 'Sepatu', 'sp_11', '', '', 349900, 5, 'Update', '2022-12-27 03:55:19'),
('sp_11', 'Sepatu', 'sp_11', '', '', 349900, 5, 'Update', '2022-12-27 03:55:45'),
('sp_11', 'Sepatu', 'sp_11', '', '', 349900, 4, 'Update', '2022-12-27 03:55:45'),
('sp_11', 'Sepatu', 'sp_11', '', '', 349900, 4, 'Update', '2022-12-27 03:59:18'),
('sp_11', 'Sepatu', 'sp_11', '', '', 349900, 5, 'Update', '2022-12-27 03:59:22'),
('sp_11', 'Sepatu', 'sp_11', '', '', 349900, 6, 'Update', '2022-12-27 03:59:39'),
('sp_11', 'Sepatu', 'sp_11', '', '', 349900, 5, 'Update', '2022-12-27 03:59:39'),
('sp_11', 'Sepatu', 'sp_11', '', '', 349900, 5, 'Update', '2022-12-27 04:00:48'),
('sp_1', 'Sepatu', 'sp_1', '', '', 799000, 5, 'Update', '2022-12-27 04:00:51'),
('sp_1', 'Sepatu', 'sp_1', '', '', 799000, 6, 'Update', '2022-12-27 04:01:36'),
('sp_1', 'Sepatu', 'sp_1', '', '', 799000, 4, 'Update', '2022-12-27 04:01:36'),
('sp_10', 'Sepatu', 'sp_10', '', '', 349900, 6, 'Update', '2022-12-27 04:01:46'),
('sp_10', 'Sepatu', 'sp_10', '', '', 349900, 4, 'Update', '2022-12-27 04:01:46'),
('sp_1', 'Sepatu', 'sp_1', '', '', 799000, 4, 'Update', '2022-12-27 15:54:32'),
('sp_1', 'Sepatu', 'sp_1', '', '', 799000, 3, 'Update', '2022-12-27 15:54:33'),
('sp_10', 'Sepatu', 'sp_10', '', '', 349900, 4, 'Update', '2022-12-27 15:54:45'),
('sp_10', 'Sepatu', 'sp_10', '', '', 349900, 3, 'Update', '2022-12-27 15:54:45'),
('sd_3', 'Sendal', 'sd_3', '', '', 85000, 5, 'Update', '2022-12-27 16:09:28'),
('sp_10', 'Sepatu', 'sp_10', '', '', 349900, 3, 'Update', '2022-12-27 17:40:03'),
('sp_10', 'Sepatu', 'sp_10', '', '', 349900, 2, 'Update', '2022-12-27 17:40:03'),
('sp_10', 'Sepatu', 'sp_10', '', '', 349900, 2, 'Update', '2022-12-27 17:40:26'),
('Smelly s', 'Kaos Kaki', 'Smelly s', '', '', 10000, 10, 'Insert', '2022-12-27 17:58:30'),
('sp_12', 'Sepatu', 'sp_12', '', '', 349900, 6, 'Update', '2022-12-27 18:00:01'),
('sp_12', 'Sepatu', 'sp_12', '', '', 349900, 4, 'Update', '2022-12-27 18:00:01'),
('sp_15', 'Sepatu', 'sp_15', '', '', 379900, 7, 'Update', '2022-12-27 18:00:25'),
('sp_15', 'Sepatu', 'sp_15', '', '', 379900, 4, 'Update', '2022-12-27 18:00:25'),
('sp_12', 'Sepatu', 'sp_12', '', '', 349900, 4, 'Update', '2022-12-27 18:00:33'),
('sp_10', 'Sepatu', 'sp_10', '', '', 349900, 3, 'Update', '2022-12-27 19:18:45'),
('sp_10', 'Sepatu', 'sp_10', '', '', 349900, 2, 'Update', '2022-12-27 19:19:04'),
('sp_11', 'Sepatu', 'sp_11', '', '', 349900, 6, 'Update', '2022-12-27 20:22:40'),
('sp_11', 'Sepatu', 'sp_11', '', '', 349900, 5, 'Update', '2022-12-27 20:22:41'),
('sd_10', 'Sendal', 'sd_10', '', '', 229000, 6, 'Update', '2022-12-27 20:22:55'),
('sd_10', 'Sendal', 'sd_10', '', '', 229000, 4, 'Update', '2022-12-27 20:22:55'),
('sd_10', 'Sendal', 'sd_10', '', '', 229000, 4, 'Update', '2022-12-27 20:29:17'),
('bla', 'Kaos Kaki', 'bla', '', '', 15000, 10, 'Insert', '2022-12-27 20:40:35'),
('jp_01', 'Kaos Kaki', 'jp_01', '', '', 15000, 1, 'Delete', '2022-12-27 20:40:47'),
('Smelly s', 'Kaos Kaki', 'Smelly s', '', '', 10000, 10, 'Delete', '2022-12-27 20:40:54'),
('sp_13', 'Sepatu', 'sp_13', '', '', 349900, 6, 'Update', '2022-12-27 21:29:24'),
('sp_13', 'Sepatu', 'sp_13', '', '', 349900, 4, 'Update', '2022-12-27 21:29:24'),
('sk_1', 'Kaos Kaki', 'sk_1', '', '', 312550, 12, 'Update', '2022-12-27 21:29:48'),
('sk_1', 'Kaos Kaki', 'sk_1', '', '', 312550, 10, 'Update', '2022-12-27 21:29:48'),
('sp_13', 'Sepatu', 'sp_13', '', '', 349900, 4, 'Update', '2022-12-27 21:36:41'),
('sk_1', 'Kaos Kaki', 'sk_1', '', '', 312550, 10, 'Update', '2022-12-27 21:36:53'),
('sp_1', 'Sepatu', 'sp_1', '', '', 799000, 3, 'Update', '2022-12-27 22:38:45'),
('sp_1', 'Sepatu', 'sp_1', '', '', 799000, 3, 'Delete', '2022-12-27 22:41:12'),
('sp_11', 'Sepatu', 'sp_11', '', '', 349900, 5, 'Update', '2022-12-27 23:17:37'),
('sp_11', 'Sepatu', 'sp_11', '', '', 349900, 3, 'Update', '2022-12-27 23:17:37'),
('sp_11', 'Sepatu', 'sp_11', '', '', 349900, 3, 'Update', '2022-12-27 23:19:56'),
('sp_11', 'Sepatu', 'sp_11', '', '', 349900, 1, 'Update', '2022-12-27 23:19:56'),
('sp_11', 'Sepatu', 'sp_11', '', '', 349900, 1, 'Update', '2022-12-27 23:20:01'),
('sp_11', 'Sepatu', 'sp_11', '', '', 349900, 3, 'Update', '2022-12-27 23:20:30'),
('sp_11', 'Sepatu', 'sp_11', '', '', 349900, 4, 'Update', '2022-12-27 23:21:04'),
('sp_11', 'Sepatu', 'sp_11', '', '', 349900, 3, 'Update', '2022-12-27 23:21:37'),
('sp_11', 'Sepatu', 'sp_11', '', '', 349900, 4, 'Update', '2022-12-28 02:18:58'),
('sp_11', 'Sepatu', 'sp_11', '', '', 349900, 2, 'Update', '2022-12-28 02:18:58'),
('sp_11', 'Sepatu', 'sp_11', '', '', 349900, 2, 'Update', '2022-12-28 02:23:46'),
('sp_11', 'Sepatu', 'sp_11', '', '', 349900, 0, 'Update', '2022-12-28 02:23:46'),
('sp_12', 'Sepatu', 'sp_12', '', '', 349900, 6, 'Update', '2022-12-28 02:25:11'),
('sp_12', 'Sepatu', 'sp_12', '', '', 349900, 4, 'Update', '2022-12-28 02:25:11'),
('sp_12', 'Sepatu', 'sp_12', '', '', 349900, 4, 'Update', '2022-12-28 02:25:29'),
('sp_16', 'Sepatu', 'sp_16', '', '', 379900, 7, 'Update', '2022-12-28 02:25:46'),
('sp_16', 'Sepatu', 'sp_16', '', '', 379900, 5, 'Update', '2022-12-28 02:25:46'),
('sp_10', 'Sepatu', 'sp_10', '', '', 349900, 3, 'Update', '2022-12-28 13:55:00'),
('sp_10', 'Sepatu', 'sp_10', '', '', 349900, 1, 'Update', '2022-12-28 13:55:00'),
('sp_10', 'Sepatu', 'sp_10', '', '', 349900, 1, 'Update', '2022-12-28 13:55:28'),
('sp_12', 'Sepatu', 'sp_12', '', '', 349900, 6, 'Update', '2022-12-28 13:56:00'),
('sp_12', 'Sepatu', 'sp_12', '', '', 349900, 4, 'Update', '2022-12-28 13:56:00'),
('sp_12', 'Sepatu', 'sp_12', '', '', 349900, 4, 'Update', '2022-12-28 13:56:10'),
('sp_12', 'Sepatu', 'sp_12', '', '', 349900, 3, 'Update', '2022-12-28 13:56:35'),
('sp_15', 'Sepatu', 'sp_15', '', '', 379900, 4, 'Update', '2022-12-28 13:56:57'),
('sp_15', 'Sepatu', 'sp_15', '', '', 379900, 2, 'Update', '2022-12-28 13:56:57'),
('sp_10', 'Sepatu', 'sp_10', '', '', 349900, 3, 'Update', '2022-12-28 13:59:51'),
('sp_10', 'Sepatu', 'sp_10', '', '', 349900, 2, 'Update', '2022-12-28 13:59:51'),
('sp_12', 'Sepatu', 'sp_12', '', '', 349900, 4, 'Update', '2022-12-28 14:06:19'),
('sp_12', 'Sepatu', 'sp_12', '', '', 349900, 3, 'Update', '2022-12-28 14:06:19'),
('sp_10', 'Sepatu', 'sp_10', '', '', 349900, 2, 'Update', '2022-12-28 14:18:16'),
('sp_10', 'Sepatu', 'sp_10', '', '', 349900, 1, 'Update', '2022-12-28 14:18:16'),
('sp_10', 'Sepatu', 'sp_10', '', '', 349900, 1, 'Update', '2022-12-28 14:18:26'),
('sp_10', 'Sepatu', 'sp_10', '', '', 349900, 2, 'Update', '2022-12-28 14:18:47'),
('sp_10', 'Sepatu', 'sp_10', '', '', 349900, 1, 'Update', '2022-12-28 14:18:47'),
('sp_10', 'Sepatu', 'sp_10', '', '', 349900, 1, 'Update', '2022-12-28 14:18:56'),
('jp_01', 'Jepit Rambut', 'jp_01', '', '', 60000, 5, 'Insert', '2022-12-28 14:23:46'),
('sd_1', 'Sendal', 'sd_1', '', '', 85000, 5, 'Update', '2022-12-28 14:39:31'),
('sd_1', 'Sendal', 'sd_1', '', '', 85000, 4, 'Update', '2022-12-28 14:39:31'),
('sp_12', 'Sepatu', 'sp_12', '', '', 349900, 3, 'Update', '2022-12-28 14:42:23'),
('sp_12', 'Sepatu', 'sp_12', '', '', 349900, 2, 'Update', '2022-12-28 14:42:23'),
('sk_1', 'Kaos Kaki', 'sk_1', '', '', 312550, 9, 'Update', '2022-12-28 15:22:29'),
('sk_1', 'Kaos Kaki', 'sk_1', '', '', 312550, 7, 'Update', '2022-12-28 15:22:29'),
('sk_1', 'Kaos Kaki', 'sk_1', '', '', 312550, 7, 'Update', '2022-12-28 15:50:44'),
('sp_14', 'Sepatu', 'sp_14', '', '', 349900, 6, 'Update', '2022-12-28 15:50:59'),
('sp_14', 'Sepatu', 'sp_14', '', '', 349900, 4, 'Update', '2022-12-28 15:50:59'),
('sp_14', 'Sepatu', 'sp_14', '', '', 349900, 4, 'Update', '2022-12-29 23:25:15'),
('sk_10', 'Kaos Kaki', 'sk_10', '', '', 419000, 6, 'Update', '2022-12-29 23:50:59'),
('sk_10', 'Kaos Kaki', 'sk_10', '', '', 419000, 4, 'Update', '2022-12-29 23:50:59'),
('sp_13', 'Sepatu', 'sp_13', '', '', 349900, 6, 'Update', '2022-12-30 00:05:10'),
('sp_13', 'Sepatu', 'sp_13', '', '', 349900, 4, 'Update', '2022-12-30 00:05:10'),
('sp_13', 'Sepatu', 'sp_13', '', '', 349900, 4, 'Update', '2022-12-30 00:07:10'),
('sp_13', 'Sepatu', 'sp_13', '', '', 349900, 6, 'Update', '2022-12-30 00:11:38'),
('sp_13', 'Sepatu', 'sp_13', '', '', 349900, 4, 'Update', '2022-12-30 00:11:38'),
('sp_12', 'Sepatu', 'sp_12', '', '', 349900, 2, 'Update', '2022-12-30 16:27:11'),
('sp_12', 'Sepatu', 'sp_12', '', '', 349900, 1, 'Update', '2022-12-30 16:27:11'),
('sp_14', 'Sepatu', 'sp_14', '', '', 349900, 6, 'Update', '2022-12-30 22:27:41'),
('sp_14', 'Sepatu', 'sp_14', '', '', 349900, 4, 'Update', '2022-12-30 22:27:41'),
('sp_16', 'Sepatu', 'sp_16', '', '', 379900, 5, 'Update', '2022-12-30 22:28:01'),
('sp_16', 'Sepatu', 'sp_16', '', '', 379900, 4, 'Update', '2022-12-30 22:28:01'),
('sp_14', 'Sepatu', 'sp_14', '', '', 349900, 4, 'Update', '2022-12-30 22:28:15'),
('sp_16', 'Sepatu', 'sp_16', '', '', 379900, 4, 'Update', '2022-12-30 22:28:23'),
('sp_19', 'Sepatu', 'sp_19', '', '', 161450, 1, 'Delete', '2022-12-30 22:42:46'),
('tess', 'Jepit Rambut', 'tess', '', '', 15000, 10, 'Insert', '2022-12-30 22:55:46'),
('sp_10', 'Sepatu', 'sp_10', '', '', 349900, 0, 'Delete', '2023-01-02 22:27:26'),
('tesss', 'Sendal', 'produk dummy', 'Kuning', 'M', 10000, 2, 'Insert', '2023-01-12 23:39:29'),
('sp_11', 'Sepatu', 'Marie Claire Sepatu Flats Wanita Margie White 37', '', '', 349900, 0, 'Update', '2023-01-13 00:04:41'),
('dummy', 'Sepatu', 'dummy', '10000', 'coklat', 0, 10, 'Insert', '2023-01-13 00:11:32'),
('sp_13', 'Sepatu', 'Marie Claire Sepatu Flats Wanita Margie Black 37', '', '', 349900, 4, 'Update', '2023-01-13 01:19:24'),
('sp_13', 'Sepatu', 'Marie Claire Sepatu Flats Wanita Margie Black 37', '', '', 349900, 2, 'Update', '2023-01-13 01:19:24'),
('sp_13', 'Sepatu', 'Marie Claire Sepatu Flats Wanita Margie Black 37', '', '', 349900, 2, 'Update', '2023-01-13 01:20:05'),
('sp_13', 'Sepatu', 'Marie Claire Sepatu Flats Wanita Margie Black 37', '', '', 349900, 3, 'Update', '2023-01-13 01:34:27'),
('sp_13', 'Sepatu', 'Marie Claire Sepatu Flats Wanita Margie Black 37', '', '', 349900, 1, 'Update', '2023-01-13 01:34:40'),
('sp_13', 'Sepatu', 'Marie Claire Sepatu Flats Wanita Margie Black 37', '', '', 349900, 0, 'Update', '2023-01-13 01:34:56'),
('sp_12', 'Sepatu', 'Marie Claire Sepatu Flats Wanita Margie Black 36', '', '', 349900, 1, 'Update', '2023-01-13 01:35:19'),
('sp_12', 'Sepatu', 'Marie Claire Sepatu Flats Wanita Margie Black 36', '', '', 349900, 0, 'Update', '2023-01-13 01:35:19'),
('sp_12', 'Sepatu', 'Marie Claire Sepatu Flats Wanita Margie Black 36', '', '', 349900, 0, 'Update', '2023-01-13 01:53:19'),
('jp_01', 'Jepit Rambut', 'Jepit rambut sakti hitam', '', '', 60000, 5, 'Update', '2023-01-13 01:55:24'),
('jp_01', 'Jepit Rambut', 'Jepit rambut sakti hitam', '', '', 60000, 4, 'Update', '2023-01-13 01:55:44'),
('jp_01', 'Jepit Rambut', 'Jepit rambut sakti hitam', '', '', 60000, 3, 'Update', '2023-01-13 01:55:52'),
('sp_12', 'Sepatu', 'Marie Claire Sepatu Flats Wanita Margie Black 36', '', '', 349900, 1, 'Update', '2023-01-13 02:08:15'),
('jp_01', 'Jepit Rambut', 'Jepit rambut sakti hitam', '', '', 60000, 4, 'Update', '2023-01-13 02:08:19'),
('sd_17', 'Sendal', 'ADIDAS adilette aqua slides Core Black 37', '', '', 380000, 2, 'Update', '2023-01-13 02:08:59'),
('sd_17', 'Sendal', 'ADIDAS adilette aqua slides Core Black 37', '', '', 380000, 1, 'Update', '2023-01-13 02:08:59'),
('sd_17', 'Sendal', 'ADIDAS adilette aqua slides Core Black 37', '', '', 380000, 1, 'Update', '2023-01-13 02:11:12'),
('sd_17', 'Sendal', 'ADIDAS adilette aqua slides Core Black 37', '', '', 380000, 0, 'Update', '2023-01-13 02:11:12'),
('sd_17', 'Sendal', 'ADIDAS adilette aqua slides Core Black 37', '', '', 380000, 0, 'Update', '2023-01-13 02:11:26'),
('sp_2', 'Sepatu', 'Nike Court Vision Low Next Nature Shoes White 38', '', '', 799000, 6, 'Update', '2023-01-13 02:12:14'),
('sp_2', 'Sepatu', 'Nike Court Vision Low Next Nature Shoes White 38', '', '', 799000, 3, 'Update', '2023-01-13 02:12:14'),
('sp_2', 'Sepatu', 'Nike Court Vision Low Next Nature Shoes White 38', '', '', 799000, 3, 'Update', '2023-01-13 02:15:25'),
('sp_2', 'Sepatu', 'Nike Court Vision Low Next Nature Shoes White 38', '', '', 799000, 4, 'Update', '2023-01-13 02:27:49'),
('dummy', 'Sepatu', 'dummy', '10000', 'coklat', 0, 10, 'Update', '2023-01-13 02:27:57'),
('dummy', 'Sepatu', 'dummy', '10000', 'coklat', 0, 5, 'Update', '2023-01-13 02:27:57'),
('sp_14', 'Sepatu', 'Marie Claire Sepatu Flats Wanita Margie Gray 36', '', '', 349900, 3, 'Update', '2023-01-13 02:50:02'),
('dummy', 'Sepatu', 'dummy', '10000', 'coklat', 0, 5, 'Update', '2023-01-13 02:52:14'),
('dummy', 'Sepatu', 'dummy', '10000', 'coklat', 0, 6, 'Update', '2023-01-13 02:52:21'),
('dummy', 'Sepatu', 'dummy', '10000', 'coklat', 0, 4, 'Update', '2023-01-13 02:54:14'),
('dummy', 'Sepatu', 'dummy', '10000', 'coklat', 0, 5, 'Update', '2023-01-13 02:54:29'),
('dummy', 'Sepatu', 'dummy', '10000', 'coklat', 0, 7, 'Update', '2023-01-13 02:54:40'),
('dummy', 'Sepatu', 'dummy', '10000', 'coklat', 0, 4, 'Update', '2023-01-13 03:03:13'),
('dummy', 'Sepatu', 'dummy', '10000', 'coklat', 0, 5, 'Update', '2023-01-13 03:09:18'),
('dummy', 'Sepatu', 'dummy', '10000', 'coklat', 0, 4, 'Update', '2023-01-13 03:10:00'),
('dummy', 'Sepatu', 'dummy', '10000', 'coklat', 0, 0, 'Update', '2023-01-13 03:13:42'),
('dummy', 'Sepatu', 'dummy', '10000', 'coklat', 0, 1, 'Update', '2023-01-13 03:16:37'),
('dummy', 'Sepatu', 'dummy', '10000', 'coklat', 0, 1, 'Update', '2023-01-13 03:16:48'),
('dummy', 'Sepatu', 'dummy', '10000', 'coklat', 0, 1, 'Update', '2023-01-13 03:17:07'),
('dummy', 'Sepatu', 'dummy', '10000', 'coklat', 0, 2, 'Update', '2023-01-13 03:18:29'),
('dummy', 'Sepatu', 'dummy', '10000', 'coklat', 0, 2, 'Update', '2023-01-13 03:19:51'),
('dummy', 'Sepatu', 'dummy', '10000', 'coklat', 0, 2, 'Update', '2023-01-13 03:20:02'),
('dummy', 'Sepatu', 'dummy', '10000', 'coklat', 0, 2, 'Update', '2023-01-13 03:22:19'),
('dummy', 'Sepatu', 'dummy', '10000', 'coklat', 0, 2, 'Update', '2023-01-13 03:22:45'),
('dummy', 'Sepatu', 'dummy', '10000', 'coklat', 0, 2, 'Update', '2023-01-13 03:24:33'),
('dummy', 'Sepatu', 'dummy', '10000', 'coklat', 0, 10, 'Update', '2023-01-13 03:24:40'),
('dummy', 'Sepatu', 'dummy', '10000', 'coklat', 0, 1, 'Update', '2023-01-13 03:24:48'),
('dummy', 'Sepatu', 'dummy', '10000', 'coklat', 0, 2, 'Update', '2023-01-13 03:25:59'),
('dummy', 'Sepatu', 'dummy', '10000', 'coklat', 0, 1, 'Update', '2023-01-13 03:26:04'),
('dummy', 'Sepatu', 'dummy', '10000', 'coklat', 0, 1, 'Update', '2023-01-13 03:26:12'),
('dummy', 'Sepatu', 'dummy', '10000', 'coklat', 0, 1, 'Update', '2023-01-13 03:29:57'),
('dummy', 'Sepatu', 'dummy', '10000', 'coklat', 0, 0, 'Update', '2023-01-13 03:30:08'),
('dummy', 'Sepatu', 'dummy', '10000', 'coklat', 0, 1, 'Update', '2023-01-13 03:30:13'),
('dummy', 'Sepatu', 'dummy', '10000', 'coklat', 0, 7, 'Update', '2023-01-13 03:30:30'),
('dummy', 'Sepatu', 'dummy', '10000', 'coklat', 0, 10, 'Update', '2023-01-13 12:32:22'),
('dummy', 'Sepatu', 'dummy', '10000', 'coklat', 0, 8, 'Update', '2023-01-13 12:32:22'),
('sp_11', 'Sepatu', 'Marie Claire Sepatu Flats Wanita Margie White 37', 'Rose', 'L', 349900, 0, 'Update', '2023-01-13 12:33:07'),
('dummy', 'Sepatu', 'dummy', '10000', 'coklat', 0, 8, 'Update', '2023-01-13 12:33:25');

-- --------------------------------------------------------

--
-- Table structure for table `log_resi`
--

CREATE TABLE `log_resi` (
  `no_resi` int(5) NOT NULL,
  `wkt_transaksi` varchar(255) NOT NULL,
  `costumer` varchar(255) NOT NULL,
  `kasir` varchar(255) NOT NULL,
  `total` float DEFAULT NULL,
  `bayar` float DEFAULT NULL,
  `ket` varchar(255) NOT NULL,
  `waktu` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `log_resi`
--

INSERT INTO `log_resi` (`no_resi`, `wkt_transaksi`, `costumer`, `kasir`, `total`, `bayar`, `ket`, `waktu`) VALUES
(126, '2022-12-30 16:13:32', 'Amanda', 'Jennie Fatma', NULL, NULL, 'INSERT', '2022-12-30 16:13:32'),
(126, '2022-12-30 16:13:32', 'Amanda', 'Jennie Fatma', NULL, NULL, 'DELETE', '2022-12-30 16:26:08'),
(124, '2022-12-30 00:05:18', 'tes', 'Jennie Fatma', 1049700, 700000, 'UPDATE', '2022-12-30 16:27:25'),
(127, '2022-12-30 22:27:18', 'Kenang', 'Jennie Fatma', NULL, NULL, 'INSERT', '2022-12-30 22:27:18'),
(127, '2022-12-30 22:27:18', 'Kenang', 'Jennie Fatma', 1049700, NULL, 'UPDATE', '2022-12-30 22:28:54'),
(124, '2022-12-30 16:27:25', 'tes', 'Jennie Fatma', 1049700, 1050000, 'DELETE', '2022-12-30 22:32:30'),
(116, '2022-12-28 02:25:57', 'Sumatera', 'Jennie Fatma', 759800, 760000, 'DELETE', '2022-12-30 22:42:53'),
(117, '2022-12-28 13:57:28', 'Jo', 'Jennie Fatma', 1459600, 1460000, 'DELETE', '2022-12-30 22:48:40'),
(127, '2022-12-30 22:28:54', 'Ken', 'Jennie Fatma', 1049700, 1050000, 'DELETE', '2022-12-30 22:57:33'),
(119, '2022-12-28 14:06:42', 'Amanda', 'Jennie Fatma', 349900, 350000, 'DELETE', '2023-01-02 22:27:37'),
(128, '2023-01-02 22:28:42', 'tes', 'Jennie Fatma', NULL, NULL, 'INSERT', '2023-01-02 22:28:42'),
(128, '2023-01-02 22:28:42', 'tes', 'Jennie Fatma', NULL, NULL, 'DELETE', '2023-01-02 22:28:47'),
(129, '2023-01-12 23:44:47', 'Amanda', 'Samsul arip', NULL, NULL, 'INSERT', '2023-01-12 23:44:47'),
(129, '2023-01-12 23:44:47', 'Amanda', 'Samsul arip', NULL, NULL, 'DELETE', '2023-01-12 23:47:58'),
(130, '2023-01-13 01:18:27', 'Agatha', 'Jennie Fatma', NULL, NULL, 'INSERT', '2023-01-13 01:18:27'),
(130, '2023-01-13 01:18:27', 'Agatha', 'Jennie Fatma', 1978000, NULL, 'UPDATE', '2023-01-13 02:17:39'),
(130, '2023-01-13 02:17:39', 'Agatha', 'Jennie Fatma', 1978000, 3000000, 'UPDATE', '2023-01-13 02:18:24'),
(130, '2023-01-13 02:17:39', 'vvbu', 'Jennie Fatma', 380000, 3000000, 'UPDATE', '2023-01-13 12:31:05');

-- --------------------------------------------------------

--
-- Table structure for table `log_staff_baru`
--

CREATE TABLE `log_staff_baru` (
  `id_staff` char(10) NOT NULL,
  `nama` varchar(200) NOT NULL,
  `tgl_lahir` date NOT NULL,
  `kelamin` enum('P','L') NOT NULL,
  `telepon` char(15) NOT NULL,
  `email` varchar(100) NOT NULL,
  `alamat` varchar(200) NOT NULL,
  `status` enum('Aktif','Tidak aktif') NOT NULL,
  `tgl_bekerja` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `log_staff_baru`
--

INSERT INTO `log_staff_baru` (`id_staff`, `nama`, `tgl_lahir`, `kelamin`, `telepon`, `email`, `alamat`, `status`, `tgl_bekerja`) VALUES
('staff_1', 'ewt', '2022-12-07', 'L', '34342432', 'erewrewr', 'ererer', 'Aktif', '2022-12-18'),
('3', 'Roger', '2022-12-26', 'L', '23121221', 'roger42069@gmail.com', 'Sumatra', 'Aktif', '2022-12-27'),
('4', 'Budi', '2005-06-28', 'L', '', 'budi@gmail.com', 'jl.budiman no.420', 'Aktif', '2022-12-28'),
('5', 'Amanda', '2022-11-30', 'P', '08136258465', 'amandabendicsmbrg12@gmail.com', 'medan', 'Aktif', '2022-12-30'),
('6', 'Amanda', '2022-12-30', 'P', '08136258465', 'amandabendicsmbrg12@gmail.com', 'medan', 'Aktif', '2022-12-30');

-- --------------------------------------------------------

--
-- Table structure for table `log_staff_tidak_aktif`
--

CREATE TABLE `log_staff_tidak_aktif` (
  `id_staff` char(10) NOT NULL,
  `nama` varchar(200) NOT NULL,
  `tgl_lahir` date NOT NULL,
  `kelamin` enum('P','L') NOT NULL,
  `telepon` char(15) NOT NULL,
  `email` varchar(100) NOT NULL,
  `alamat` varchar(200) NOT NULL,
  `status` enum('Aktif','Tidak aktif') NOT NULL,
  `tgl_tdk_aktif` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `log_staff_tidak_aktif`
--

INSERT INTO `log_staff_tidak_aktif` (`id_staff`, `nama`, `tgl_lahir`, `kelamin`, `telepon`, `email`, `alamat`, `status`, `tgl_tdk_aktif`) VALUES
('staff_1', 'ewt', '2022-12-07', 'L', '34342432', 'erewrewr', 'ererer', 'Tidak aktif', '2022-12-18'),
('3', 'Roger', '2022-12-26', 'L', '23121221', 'roger42069@gmail.com', 'Sumatra', 'Tidak aktif', '2022-12-27'),
('3', 'Roger', '2022-12-26', 'L', '23121221', 'roger42069@gmail.com', 'Sumatra', 'Tidak aktif', '2022-12-28'),
('4', 'Budi', '2005-06-28', 'L', '08136258465', 'budi@gmail.com', 'jl.budiman no.420', 'Tidak aktif', '2022-12-30');

-- --------------------------------------------------------

--
-- Table structure for table `log_transaksi`
--

CREATE TABLE `log_transaksi` (
  `id_transaksi` int(10) NOT NULL,
  `no_resi` int(5) NOT NULL,
  `produk` varchar(15) NOT NULL,
  `id_barang` char(10) NOT NULL,
  `qty` int(3) NOT NULL,
  `tgl_transaksi` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `log_transaksi`
--

INSERT INTO `log_transaksi` (`id_transaksi`, `no_resi`, `produk`, `id_barang`, `qty`, `tgl_transaksi`) VALUES
(29, 20, 'Jepit rambut', 'jepit_01', 3, '2022-12-17 12:38:22'),
(30, 21, 'Jepit rambut', 'jepit_02', 2, '2022-12-17 13:23:37'),
(32, 20, 'Jepit rambut', 'jepit_03', 13, '2022-12-17 14:16:07'),
(21, 20, 'Kaos kaki', 'kaosk_002', 8, '2022-12-17 15:33:55'),
(5, 20, 'Sepatu', 'sepatu_001', 1, '2022-12-17 15:37:29'),
(22, 24, 'Kaos kaki', 'kaosk_002', 1, '2022-12-18 01:28:26'),
(35, 20, 'Jepit rambut', 'jepit_11', 1, '2022-12-18 01:44:14'),
(5, 24, 'Sendal', 'sendal_001', 1, '2022-12-18 01:45:46'),
(10, 31, 'Sepatu', 'sepatu_001', 1, '2022-12-19 11:14:25'),
(11, 31, 'Sepatu', 'sepatu_001', 1, '2022-12-19 11:14:25'),
(6, 31, 'Sendal', 'sendal_001', 1, '2022-12-19 15:49:45'),
(14, 31, 'Sepatu', 'sepatu_001', 1, '2022-12-19 23:07:27'),
(7, 31, 'Sendal', 'sendal_001', 1, '2022-12-19 23:16:31'),
(8, 31, 'Sendal', 'sendal_001', 1, '2022-12-19 23:18:47'),
(9, 31, 'Sendal', 'sendal_001', 1, '2022-12-19 23:22:00'),
(10, 31, 'Sendal', 'sendal_001', 1, '2022-12-19 23:38:16'),
(15, 31, 'Sepatu', 'sepatu_003', 1, '2022-12-19 23:38:34'),
(16, 31, 'Sepatu', 'sepatu_050', 2, '2022-12-19 23:39:40'),
(18, 31, 'Sepatu', 'sepatu_003', 3, '2022-12-20 00:04:28'),
(11, 31, 'Sendal', 'sendal_003', 2, '2022-12-20 00:10:48'),
(14, 31, 'Sendal', 'sendal_002', 1, '2022-12-20 02:15:13'),
(15, 31, 'Sendal', 'sendal_004', 1, '2022-12-20 02:19:36'),
(16, 31, 'Sendal', 'sendal_004', 1, '2022-12-20 02:20:49'),
(17, 31, 'Sendal', 'sendal_004', 1, '2022-12-20 02:21:13'),
(18, 31, 'Sendal', 'sendal_001', 1, '2022-12-20 02:21:22'),
(19, 31, 'Sepatu', 'sepatu_002', 1, '2022-12-20 02:25:34'),
(21, 31, 'Sepatu', 'sepatu_008', 2, '2022-12-20 02:28:51'),
(22, 31, 'Sepatu', 'sepatu_012', 1, '2022-12-20 03:04:10'),
(23, 31, 'Sepatu', 'sepatu_012', 1, '2022-12-20 03:05:32'),
(26, 31, 'Sepatu', 'sepatu_004', 1, '2022-12-20 03:06:07'),
(27, 32, 'Sepatu', 'sepatu_006', 1, '2022-12-20 03:30:29'),
(19, 32, 'Sendal', 'sendal_011', 1, '2022-12-20 03:30:38'),
(36, 32, 'Jepit rambut', 'HAHA', 1, '2022-12-20 03:44:39'),
(37, 32, 'Jepit rambut', 'jepit_02', 1, '2022-12-20 03:59:18'),
(50, 31, 'Kaos kaki', 'kaosk_001', 1, '2022-12-20 08:29:48'),
(51, 31, 'Kaos kaki', 'kaosk_009', 1, '2022-12-20 08:30:02'),
(28, 31, 'Sepatu', 'sepatu_011', 1, '2022-12-20 08:51:19'),
(29, 31, 'Sepatu', 'sepatu_011', 1, '2022-12-20 08:51:50'),
(30, 65, 'Sepatu', 'sepatu_001', 1, '2022-12-20 12:18:21'),
(31, 84, 'Sepatu', 'sepatu_006', 1, '2022-12-20 19:30:29'),
(52, 84, 'Kaos kaki', 'kaosk_010', 1, '2022-12-20 19:30:38'),
(32, 66, 'Sepatu', 'sepatu_001', 2, '2022-12-22 02:52:08'),
(34, 66, 'Sepatu', 'sepatu_009', 1, '2022-12-22 03:15:14'),
(35, 66, 'Sepatu', 'sepatu_008', 2, '2022-12-22 03:31:10'),
(36, 66, 'Sepatu', 'sepatu_012', 2, '2022-12-22 03:46:10'),
(37, 66, 'Sepatu', 'sepatu_013', 2, '2022-12-22 03:48:37'),
(38, 66, 'Sepatu', 'sepatu_014', 2, '2022-12-22 03:54:04'),
(39, 66, 'Sepatu', 'sepatu_066', 4, '2022-12-22 04:20:41'),
(22, 66, 'Sendal', 'sendal_015', 5, '2022-12-22 05:10:27'),
(40, 66, 'Sepatu', 'sepatu_037', 1, '2022-12-22 05:12:54'),
(56, 66, 'Kaos kaki', 'kaosk_008', 1, '2022-12-22 05:19:16'),
(57, 66, 'Kaos kaki', 'kaosk_006', 1, '2022-12-22 05:29:41'),
(38, 66, 'Jepit rambut', 'jepit_11', 2, '2022-12-22 05:39:54'),
(41, 66, 'Sepatu', 'sepatu_004', 2, '2022-12-22 07:50:05'),
(42, 66, 'Sepatu', 'sepatu_013', 2, '2022-12-22 07:53:23'),
(45, 90, 'Sepatu', 'sepatu_081', 1, '2022-12-22 09:15:59'),
(54, 92, 'Sepatu', 'sepatu_001', 1, '2022-12-22 12:18:59'),
(55, 92, 'Sepatu', 'sepatu_002', 1, '2022-12-22 12:19:16'),
(56, 92, 'Sepatu', 'sepatu_001', 2, '2022-12-22 12:19:27'),
(57, 94, 'Sepatu', 'sepatu_001', 1, '2022-12-22 23:57:35'),
(58, 94, 'Sepatu', 'sepatu_001', 2, '2022-12-23 01:57:26'),
(59, 94, 'Sepatu', 'sepatu_002', 2, '2022-12-23 01:57:43'),
(60, 94, 'Sepatu', 'sepatu_006', 0, '2022-12-23 02:00:18'),
(61, 94, 'Sepatu', 'sepatu_001', 3, '2022-12-23 04:47:41'),
(62, 94, 'Sepatu', 'sepatu_002', 2, '2022-12-23 05:11:40'),
(63, 94, 'Sepatu', 'sepatu_007', 1, '2022-12-23 05:13:06'),
(64, 94, 'Sepatu', 'sepatu_01', 1, '2022-12-23 16:16:53'),
(65, 94, 'Sepatu', 'sepatu_077', 2, '2022-12-23 16:17:03'),
(66, 96, 'Sepatu', 'sepatu_013', 2, '2022-12-23 16:22:01'),
(23, 94, 'Sendal', 'sendal_002', 1, '2022-12-23 16:23:37'),
(24, 94, 'Sendal', 'sendal_001', 1, '2022-12-23 16:24:55'),
(58, 94, 'Kaos kaki', 'kaosk_001', 1, '2022-12-23 16:25:05'),
(67, 94, 'Sepatu', 'sepatu_079', 1, '2022-12-23 16:32:38'),
(68, 98, 'Sepatu', 'sepatu_083', 2, '2022-12-23 16:48:31'),
(69, 98, 'Sepatu', 'sepatu_001', 1, '2022-12-23 17:06:39'),
(70, 100, 'Sepatu', 'sepatu_001', 1, '2022-12-24 13:52:23'),
(25, 100, 'Sendal', 'sendal_002', 2, '2022-12-24 13:52:32'),
(59, 100, 'Kaos kaki', 'kaosk_004', 2, '2022-12-24 13:52:54'),
(3, 100, 'Kaos Kaki', 'kk_01', 10, '2022-12-24 16:57:29'),
(5, 100, 'Sepatu', '', 1, '2022-12-24 17:13:22'),
(6, 100, 'Sendal', 'TES', 1, '2022-12-24 23:41:12'),
(7, 104, 'Sepatu', 'Tes', 3, '2022-12-25 13:08:11'),
(8, 104, 'Sepatu', 'Tes', 3, '2022-12-25 13:09:20'),
(9, 104, 'Sepatu', 'Tes', 3, '2022-12-25 13:11:01'),
(11, 104, 'Sepatu', 'Tes', 1, '2022-12-25 13:12:57'),
(12, 104, 'Sepatu', 'Tes', 1, '2022-12-25 13:45:15'),
(14, 102, 'Kaos Kaki', 'jp_01', 2, '2022-12-25 16:20:54'),
(15, 102, 'Kaos Kaki', 'jp_01', 1, '2022-12-25 18:59:01'),
(16, 102, 'Kaos Kaki', 'jp_01', 5, '2022-12-25 19:21:47'),
(17, 107, 'Sepatu', 'Tes', 4, '2022-12-26 00:58:33'),
(18, 107, 'Sepatu', 'Tes', 2, '2022-12-26 15:18:51'),
(19, 110, 'Sepatu', 'sp_1', 2, '2022-12-27 02:15:56'),
(20, 110, 'Sepatu', 'sp_11', 1, '2022-12-27 02:17:31'),
(21, 110, 'Sepatu', 'sp_11', 1, '2022-12-27 02:18:32'),
(22, 110, 'Sepatu', 'sp_11', 1, '2022-12-27 02:20:55'),
(23, 110, 'Sepatu', 'sp_11', 1, '2022-12-27 02:23:29'),
(24, 110, 'Sepatu', 'sp_11', 1, '2022-12-27 02:26:10'),
(25, 110, 'Sepatu', 'sp_11', 1, '2022-12-27 02:27:17'),
(26, 110, 'Sepatu', 'sp_13', 2, '2022-12-27 02:27:40'),
(27, 110, 'Sepatu', 'sp_12', 2, '2022-12-27 02:27:54'),
(28, 110, 'Sepatu', 'Tes', 1, '2022-12-27 02:28:08'),
(29, 110, 'Sepatu', 'Tes', 1, '2022-12-27 02:29:15'),
(30, 110, 'Sepatu', 'Tes', 1, '2022-12-27 02:30:34'),
(31, 110, 'Sepatu', 'Tes', 1, '2022-12-27 02:32:48'),
(32, 110, 'Sepatu', 'sp_1', 1, '2022-12-27 02:33:35'),
(33, 110, 'Sepatu', 'sp_10', 1, '2022-12-27 02:33:40'),
(34, 110, 'Sepatu', 'sp_10', 1, '2022-12-27 02:34:11'),
(35, 110, 'Sepatu', 'sp_10', 1, '2022-12-27 02:34:34'),
(36, 110, 'Sepatu', 'sp_10', 3, '2022-12-27 02:43:19'),
(37, 110, 'Sepatu', 'sp_16', 2, '2022-12-27 02:58:42'),
(38, 110, 'Sepatu', 'sp_16', 2, '2022-12-27 02:59:21'),
(39, 110, 'Sepatu', 'sp_16', 2, '2022-12-27 02:59:42'),
(40, 110, 'Sepatu', 'sp_17', 1, '2022-12-27 03:06:08'),
(41, 110, 'Sepatu', 'sp_17', 1, '2022-12-27 03:09:09'),
(42, 110, 'Sepatu', 'sp_10', 1, '2022-12-27 03:30:01'),
(43, 110, 'Sepatu', 'sp_10', 1, '2022-12-27 03:30:47'),
(44, 110, 'Sepatu', 'sp_25', 1, '2022-12-27 03:31:01'),
(45, 110, 'Sepatu', 'sp_13', 1, '2022-12-27 03:31:46'),
(46, 110, 'Sepatu', 'sp_13', 1, '2022-12-27 03:36:36'),
(47, 110, 'Sepatu', 'sp_13', 1, '2022-12-27 03:37:18'),
(48, 110, 'Sepatu', 'sp_13', 1, '2022-12-27 03:37:30'),
(49, 110, 'Sepatu', 'sp_13', 1, '2022-12-27 03:37:56'),
(50, 110, 'Sepatu', 'sp_11', 1, '2022-12-27 03:55:19'),
(51, 110, 'Sepatu', 'sp_11', 1, '2022-12-27 03:55:45'),
(52, 110, 'Sepatu', 'sp_11', 1, '2022-12-27 03:59:39'),
(53, 110, 'Sepatu', 'sp_1', 2, '2022-12-27 04:01:36'),
(54, 110, 'Sepatu', 'sp_10', 2, '2022-12-27 04:01:46'),
(55, 111, 'Sepatu', 'sp_1', 1, '2022-12-27 15:54:32'),
(56, 111, 'Sepatu', 'sp_10', 1, '2022-12-27 15:54:45'),
(57, 111, 'Sendal', 'sd_3', 1, '2022-12-27 16:09:28'),
(58, 111, 'Sepatu', 'sp_10', 1, '2022-12-27 17:40:03'),
(59, 112, 'Sepatu', 'sp_12', 2, '2022-12-27 18:00:01'),
(60, 112, 'Sepatu', 'sp_15', 3, '2022-12-27 18:00:25'),
(61, 113, 'Sepatu', 'sp_11', 1, '2022-12-27 20:22:40'),
(62, 113, 'Sendal', 'sd_10', 2, '2022-12-27 20:22:55'),
(63, 114, 'Sepatu', 'sp_13', 2, '2022-12-27 21:29:24'),
(64, 114, 'Kaos Kaki', 'sk_1', 2, '2022-12-27 21:29:48'),
(65, 114, 'Sepatu', 'sp_11', 2, '2022-12-27 23:17:37'),
(66, 114, 'Sepatu', 'sp_11', 2, '2022-12-27 23:19:56'),
(67, 115, 'Sepatu', 'sp_11', 2, '2022-12-28 02:18:58'),
(68, 115, 'Sepatu', 'sp_11', 2, '2022-12-28 02:23:46'),
(69, 116, 'Sepatu', 'sp_12', 2, '2022-12-28 02:25:11'),
(70, 116, 'Sepatu', 'sp_16', 2, '2022-12-28 02:25:46'),
(71, 117, 'Sepatu', 'sp_10', 2, '2022-12-28 13:55:00'),
(72, 117, 'Sepatu', 'sp_12', 2, '2022-12-28 13:56:00'),
(73, 117, 'Sepatu', 'sp_15', 2, '2022-12-28 13:56:57'),
(74, 118, 'Sepatu', 'sp_10', 1, '2022-12-28 13:59:51'),
(75, 119, 'Sepatu', 'sp_12', 1, '2022-12-28 14:06:19'),
(76, 120, 'Sepatu', 'sp_10', 1, '2022-12-28 14:18:16'),
(77, 120, 'Sepatu', 'sp_10', 1, '2022-12-28 14:18:47'),
(78, 121, 'Sendal', 'sd_1', 1, '2022-12-28 14:39:31'),
(79, 122, 'Sepatu', 'sp_12', 1, '2022-12-28 14:42:23'),
(80, 123, 'Kaos Kaki', 'sk_1', 2, '2022-12-28 15:22:29'),
(81, 123, 'Sepatu', 'sp_14', 2, '2022-12-28 15:50:59'),
(82, 120, 'Kaos Kaki', 'sk_10', 2, '2022-12-29 23:50:59'),
(83, 124, 'Sepatu', 'sp_13', 2, '2022-12-30 00:05:10'),
(84, 124, 'Sepatu', 'sp_13', 2, '2022-12-30 00:11:38'),
(85, 124, 'Sepatu', 'sp_12', 1, '2022-12-30 16:27:11'),
(86, 127, 'Sepatu', 'sp_14', 2, '2022-12-30 22:27:41'),
(87, 127, 'Sepatu', 'sp_16', 1, '2022-12-30 22:28:01'),
(88, 130, 'Sepatu', 'sp_13', 2, '2023-01-13 01:19:24'),
(89, 130, 'Sepatu', 'sp_12', 1, '2023-01-13 01:35:19'),
(91, 130, 'Jepit Rambut', 'jp_01', 1, '2023-01-13 01:55:24'),
(92, 130, 'Sendal', 'sd_17', 1, '2023-01-13 02:08:59'),
(93, 130, 'Sendal', 'sd_17', 1, '2023-01-13 02:11:12'),
(94, 130, 'Sepatu', 'sp_2', 3, '2023-01-13 02:12:14'),
(95, 130, 'Sepatu', 'dummy', 5, '2023-01-13 02:27:57'),
(96, 130, 'Sepatu', 'dummy', 2, '2023-01-13 12:32:22');

-- --------------------------------------------------------

--
-- Table structure for table `log_update_staff`
--

CREATE TABLE `log_update_staff` (
  `id_staff` char(10) NOT NULL,
  `nama` varchar(200) NOT NULL,
  `tgl_lahir` date NOT NULL,
  `kelamin` enum('P','L') NOT NULL,
  `telepon` char(15) NOT NULL,
  `email` varchar(100) NOT NULL,
  `alamat` varchar(200) NOT NULL,
  `waktu` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `log_update_staff`
--

INSERT INTO `log_update_staff` (`id_staff`, `nama`, `tgl_lahir`, `kelamin`, `telepon`, `email`, `alamat`, `waktu`) VALUES
('staff_1', 'ewt', '2022-12-07', 'L', '34342432', 'dcsdcds', 'csdcds', '2022-12-18'),
('', 'Samsul arip', '2022-12-18', 'L', '', 'samsul@gmail,com', 'jl, jahanam no.69420', '2022-12-20'),
('', 'Samsul ari', '2022-12-18', 'L', '', 'samsul@gmail,com', 'jl, jahanam no.69420', '2022-12-20'),
('staff_1', 'cdccd', '2022-12-07', 'L', '34342432', 'dcsdcds', 'csdcs', '2022-12-21'),
('1', 'Samsul arip', '2022-12-18', 'L', '', 'samsul@gmail,com', 'jl, jahanam no.69420', '2022-12-25'),
('1', 'Samsul arip', '2022-12-18', 'L', '', 'samsul@gmail,com', 'jl, jahanam no.69420', '2022-12-25'),
('1', 'Samsul arip', '2022-12-18', 'L', '', 'samsul@gmail,com', 'jl, jahanam no.69420', '2022-12-26'),
('1', 'Samsul arip', '2022-12-18', 'L', '23121221', 'samsul@gmail,com', 'jl, jahanam no.69420', '2022-12-26'),
('1', 'Samsul arip', '2022-12-18', 'L', '23121221', 'samsul@gmail,com', 'jl, jahanam no.69420', '2022-12-26'),
('1', 'Samsul arip', '2022-12-18', 'L', '23121221', 'samsul@gmail,com', 'jl, jahanam no.69420', '2022-12-26'),
('1', 'Samsul arip', '2022-12-18', '', '23121221', 'samsul@gmail,com', 'jl, jahanam no.69420', '2022-12-26'),
('1', 'Samsul arip', '2022-12-18', '', '23121221', 'samsul@gmail,com', 'jl, jahanam no.69420', '2022-12-26'),
('1', 'Samsul arip', '2022-12-18', '', '23121221', 'samsul@gmail,com', 'jl, jahanam no.69420', '2022-12-26'),
('1', 'Samsul arip', '2022-12-18', '', '23121221', 'samsul@gmail,com', 'jl, jahanam no.69420', '2022-12-26'),
('1', 'Samsul arip', '2022-12-18', '', '23121221', 'samsul@gmail,com', 'jl, jahanam no.69420', '2022-12-26'),
('1', 'Samsul arip', '2022-12-18', '', '23121221', 'samsul@gmail,com', 'jl, jahanam no.69420', '2022-12-26'),
('1', 'Samsul arip', '2022-12-18', 'L', '23121221', 'samsul@gmail,com', 'jl, jahanam no.69420', '2022-12-26'),
('1', 'Samsul arip', '2022-12-18', 'L', '23121221', 'samsul@gmail,com', 'jl, jahanam no.69420', '2022-12-26'),
('1', 'Samsul arip', '2022-12-18', 'L', '23121221', 'samsul@gmail,com', 'jl, jahanam no.69420', '2022-12-26'),
('1', 'Samsul arip', '2022-12-18', 'L', '23121221', 'samsul@gmail,com', 'jl, jahanam no.69420', '2022-12-26'),
('1', 'Samsul arip', '2022-12-18', 'L', '23121221', 'samsul@gmail,com', 'jl, jahanam no.69420', '2022-12-26'),
('1', 'Samsul arip', '2022-12-18', 'L', '23121221', 'samsul@gmail,com', 'jl, jahanam no.69420', '2022-12-26'),
('2', 'cdccd', '2022-12-07', 'L', '34342432', 'dcsdcds', 'csdcs', '2022-12-26'),
('1', 'Samsul arip', '2022-12-18', 'L', '23121221', 'samsul@gmail,com', 'jl, jahanam no.69420', '2022-12-26'),
('2', 'cdccd', '2022-12-07', 'L', '34342432', 'dcsdcds', 'csdcs', '2022-12-26'),
('1', 'Samsul arip', '2022-12-18', 'L', '23121221', 'samsul@gmail,com', 'jl, jahanam no.69420', '2022-12-26'),
('2', 'cdccd', '2022-12-07', 'L', '34342432', 'dcsdcds', 'csdcs', '2022-12-26'),
('1', 'Samsul arip', '2022-12-18', 'L', '23121221', 'samsul@gmail,com', 'jl, jahanam no.69420', '2022-12-26'),
('2', 'cdccd', '2022-12-07', 'L', '34342432', 'dcsdcds', 'csdcs', '2022-12-26'),
('1', 'Samsul arip', '2022-12-18', 'L', '23121221', 'samsul@gmail,com', 'jl, jahanam no.69420', '2022-12-26'),
('2', 'cdccd', '2022-12-07', 'L', '34342432', 'dcsdcds', 'csdcs', '2022-12-26'),
('1', 'Samsul arip', '2022-12-18', 'L', '23121221', 'samsul@gmail,com', 'jl, jahanam no.69420', '2022-12-27'),
('2', 'cdccd', '2022-12-07', 'L', '34342432', 'dcsdcds', 'csdcs', '2022-12-27'),
('1', 'Samsul arip', '2022-12-18', 'L', '23121221', 'samsul@gmail,com', 'jl, jahanam no.69420', '2022-12-27'),
('2', 'cdccd', '2022-12-07', 'L', '34342432', 'dcsdcds', 'csdcs', '2022-12-27'),
('2', 'cdccd', '2022-12-07', 'L', '34342432', 'dcsdcds', 'csdcs', '2022-12-27'),
('2', 'cdccd', '2022-12-07', 'L', '34342432', 'dcsdcds', 'csdcs', '2022-12-27'),
('2', 'cdccd', '2022-12-07', 'L', '34342432', 'dcsdcds', 'csdcs', '2022-12-27'),
('2', 'cdccd', '2022-12-07', 'L', '34342432', 'dcsdcds', 'csdcs', '2022-12-27'),
('2', 'cdccd', '2001-02-14', 'P', '081353671423', 'jennie420@gmail.com', 'Koreng a Utara', '2022-12-27'),
('3', 'Roger', '2022-12-26', 'L', '23121221', 'roger42069@gmail.com', 'Sumatra', '2022-12-27'),
('3', 'Roger', '2022-12-26', 'L', '23121221', 'roger42069@gmail.com', 'Sumatra', '2022-12-27'),
('3', 'Roger', '2022-12-26', 'L', '23121221', 'roger42069@gmail.com', 'Sumatra', '2022-12-27'),
('3', 'Roger', '2022-12-26', 'L', '23121221', 'roger42069@gmail.com', 'Sumatra', '2022-12-27'),
('3', 'Roger', '2022-12-26', 'L', '23121221', 'roger42069@gmail.com', 'Sumatra', '2022-12-27'),
('3', 'Roger', '2022-12-26', 'L', '23121221', 'roger42069@gmail.com', 'Sumatra', '2022-12-27'),
('3', 'Roger', '2022-12-26', 'L', '23121221', 'roger42069@gmail.com', 'Sumatra', '2022-12-27'),
('1', 'Samsul arip', '2022-12-18', 'L', '23121221', 'samsul@gmail,com', 'jl, jahanam no.69420', '2022-12-27'),
('1', 'Samsul arip', '2022-12-18', 'L', '23121221', 'samsul@gmail,com', 'jl, jahanam no.69420', '2022-12-27'),
('1', 'Samsul arip', '2022-12-18', 'L', '23121221', 'samsul@gmail,com', 'jl, jahanam no.69420', '2022-12-27'),
('1', 'Samsul arip', '2022-12-18', 'L', '23121221', 'samsul@gmail,com', 'jl, jahanam no.69420', '2022-12-27'),
('1', 'Samsul arip', '2022-12-18', 'L', '23121221', 'samsul@gmail,com', 'jl, jahanam no.69420', '2022-12-27'),
('1', 'Samsul arip', '2022-12-18', 'L', '23121221', 'samsul@gmail,com', 'jl, jahanam no.69420', '2022-12-27'),
('1', 'Samsul arip', '2022-12-18', 'L', '23121221', 'samsul@gmail,com', 'jl, jahanam no.69420', '2022-12-27'),
('1', 'Samsul arip', '2022-12-18', 'L', '23121221', 'samsul@gmail,com', 'jl, jahanam no.69420', '2022-12-27'),
('3', 'Roger', '2022-12-26', 'L', '23121221', 'roger42069@gmail.com', 'Sumatra', '2022-12-27'),
('1', 'Samsul arip', '2022-12-18', 'L', '23121221', 'samsul@gmail,com', 'jl, jahanam no.69420', '2022-12-27'),
('1', 'Samsul arip', '2022-12-18', 'L', '23121221', 'samsul@gmail,com', 'jl, jahanam no.69420', '2022-12-27'),
('1', 'Samsul arip', '2022-12-18', 'L', '23121221', 'samsul@gmail,com', 'jl, jahanam no.69420', '2022-12-28'),
('4', 'Budi', '2005-06-28', 'L', '08136258465', 'budi@gmail.com', 'jl.budiman no.420', '2022-12-28'),
('4', 'Budi', '2005-06-28', 'L', '08136258465', 'budi@gmail.com', 'jl.budiman no.420', '2022-12-28'),
('4', 'Budi', '2005-06-28', 'L', '08136258465', 'budi@gmail.com', 'jl.budiman no.420', '2022-12-28'),
('1', 'Samsul arip', '2022-12-18', 'L', '23121221', 'samsul@gmail,com', 'jl, jahanam no.69420', '2022-12-28'),
('3', 'Roger', '2022-12-26', 'L', '23121221', 'roger42069@gmail.com', 'Sumatra', '2022-12-28'),
('3', 'Roger', '2022-12-26', 'L', '23121221', 'roger42069@gmail.com', 'Sumatra', '2022-12-28'),
('1', 'Samsul arip', '2022-12-18', 'L', '23121221', 'samsul@gmail,com', 'jl, jahanam no.69420', '2022-12-30'),
('1', 'Samsul arip', '2022-12-18', 'L', '231212999', 'samsul@gmail,com', 'jl, jahanam no.69420', '2022-12-30'),
('1', 'Samsul ', '2022-12-18', 'L', '231212999', 'samsul@gmail,com', 'jl, jahanam no.69420', '2022-12-30'),
('1', 'Samsul ', '2022-12-18', 'L', '231212999', 'samsul12@gmail,com', 'jl, jahanam no.69420', '2022-12-30'),
('4', 'Budi', '2005-06-28', 'L', '08136258465', 'budi@gmail.com', 'jl.budiman no.420', '2022-12-30'),
('1', 'Samsul arip', '2022-12-18', 'L', '231212999', 'samsul12@gmail,com', 'jl, jahanam no.69420', '2023-01-02'),
('1', 'Samsul arip', '2022-12-18', 'L', '231212999', 'samsul12@gmail,com', 'jl, jahanam no.69420', '2023-01-13'),
('1', 'Samsul arip', '2022-12-18', 'L', '231212999', 'samsul12@gmail,com', 'jl, jahanam no.69420', '2023-01-13');

-- --------------------------------------------------------

--
-- Table structure for table `log_user`
--

CREATE TABLE `log_user` (
  `id_user` int(10) NOT NULL,
  `staff` varchar(255) NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` varchar(255) NOT NULL,
  `ket` varchar(255) NOT NULL,
  `waktu` date NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `log_user`
--

INSERT INTO `log_user` (`id_user`, `staff`, `username`, `password`, `role`, `ket`, `waktu`) VALUES
(10, 'Jennie Fatma', 'kasir', 'de28f8f7998f23ab4194b51a6029416f', 'kasir', 'Update', '2022-12-30'),
(19, 'Roger', 'admin1', 'e00cf25ad42683b3df678c61f42c6bda', 'admin', 'Delete', '2022-12-30'),
(20, 'Budi', 'admin1', '28b662d883b6d76fd96e4ddc5e9ba780', 'admin', 'Insert', '2022-12-30'),
(10, 'Jennie Fatma', 'kasir', '5378b08d03609bb19fd2036c1d09e6a8', 'kasir', 'Update', '2022-12-30'),
(21, 'Roger', 'admin1', '0192023a7bbd73250516f069df18b500', 'kasir', 'Insert', '2022-12-30'),
(21, 'Roger', 'admin1', '0192023a7bbd73250516f069df18b500', 'kasir', 'Update', '2022-12-30'),
(21, 'Roger', 'admin1', '0c909a141f1f2c0a1cb602b0b2d7d050', 'admin', 'Delete', '2022-12-30'),
(22, 'Roger', 'admin1', '6e7906b7fb3f8e1c6366c0910050e595', 'kasir', 'Insert', '2022-12-30'),
(22, 'Roger', 'admin1', '6e7906b7fb3f8e1c6366c0910050e595', 'kasir', 'Update', '2022-12-30'),
(22, 'Roger', 'kasir', 'de28f8f7998f23ab4194b51a6029416f', 'admin', 'Delete', '2022-12-30'),
(5, 'Samsul arip', 'admin', '28b662d883b6d76fd96e4ddc5e9ba780', 'admin', 'Update', '2023-01-12'),
(5, 'Samsul arip', 'admin', '773ed66c9b0581e72368f60d9382b334', 'admin', 'Update', '2023-01-12'),
(5, 'Samsul arip', 'admin', 'tes', 'admin', 'Update', '2023-01-12');

-- --------------------------------------------------------

--
-- Table structure for table `produk`
--

CREATE TABLE `produk` (
  `id_produk` char(8) NOT NULL,
  `kategori` int(11) NOT NULL,
  `produk` varchar(255) NOT NULL,
  `warna` varchar(255) NOT NULL,
  `ukuran` varchar(255) NOT NULL,
  `harga` float UNSIGNED NOT NULL,
  `qty` int(4) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `produk`
--

INSERT INTO `produk` (`id_produk`, `kategori`, `produk`, `warna`, `ukuran`, `harga`, `qty`) VALUES
('bla', 3, 'Smelly shocks Black 40', '', '', 15000, 10),
('dummy', 1, 'dummy', 'coklat', 'L', 10000, 8),
('jp_01', 4, 'Jepit rambut sakti hitam', '', '', 60000, 5),
('jp_1', 4, 'Mango Pearls Hair Clips 3 Set Gold', '', '', 244300, 25),
('jp_2', 4, 'Vero Moda Winnie Hair Claw Clip Pastel Lilac', '', '', 269000, 30),
('jp_3', 4, 'ALDO Emilis Hair Claw Clip Ice', '', '', 272350, 21),
('jp_4', 4, 'ONLY 3 Pack Helene Hair Clips Black Mel', '', '', 229500, 32),
('jp_5', 4, 'ALDO Bagar Hair Clip Ice', '', '', 319000, 12),
('sd_1', 2, 'ALOPE Yeager Sandal gunung pria outdoor Maroon 39', '', '', 85000, 4),
('sd_10', 2, 'Zeger Footwear Sandal Kulit Pria BELLAMO 133 Black 40', '', '', 229000, 3),
('sd_11', 2, 'Quiksilver Sessions Slide Black 40', '', '', 399000, 5),
('sd_12', 2, 'Quiksilver Sessions Slide Black 41', '', '', 399000, 5),
('sd_13', 2, 'Quiksilver Sessions Slide Brown 40', '', '', 399000, 5),
('sd_14', 2, 'Birkenstock Arizona Smooth Leather Sandals Blue 36', '', '', 1499000, 2),
('sd_15', 2, 'Birkenstock Arizona Smooth Leather Sandals Blue 37', '', '', 1499000, 2),
('sd_16', 2, 'Birkenstock Arizona Smooth Leather Sandals Brown 38', '', '', 1499000, 2),
('sd_17', 2, 'ADIDAS adilette aqua slides Core Black 37', '', '', 380000, 1),
('sd_18', 2, 'ADIDAS adilette aqua slides Core Black 39', '', '', 380000, 2),
('sd_19', 2, 'Kaninna Shoes Camden Slides Black 36', '', '', 199200, 3),
('sd_2', 2, 'ALOPE Yeager Sandal gunung pria outdoor Maroon 40', '', '', 85000, 5),
('sd_20', 2, 'Kaninna Shoes Camden Slides Blue 37', '', '', 199200, 3),
('sd_21', 2, 'Kaninna Shoes Camden Slides White 37', '', '', 199200, 3),
('sd_22', 2, 'Twenty Two Harmony Slingback Sandals Gold 37', '', '', 279200, 4),
('sd_23', 2, 'Twenty Two Harmony Slingback Sandals Maroon 37', '', '', 279200, 4),
('sd_24', 2, 'Twenty Two Harmony Slingback Sandals Maroon 38', '', '', 279200, 4),
('sd_3', 2, 'ALOPE Yeager Sandal gunung pria outdoor Maroon 41', '', '', 85000, 4),
('sd_4', 2, 'ALOPE Yeager Sandal gunung pria outdoor Gray 41', '', '', 85000, 5),
('sd_5', 2, 'Guess Enuzo Slide Sandals Black Multi 40', '', '', 1099000, 3),
('sd_6', 2, 'Guess Enuzo Slide Sandals Black Multi 41', '', '', 1099000, 3),
('sd_7', 2, 'Guess Enuzo Slide Sandals Gray 42', '', '', 1099000, 3),
('sd_8', 2, 'Zeger Footwear Sandal Kulit Pria BELLAMO 133 Brown 40', '', '', 229000, 6),
('sd_9', 2, 'Zeger Footwear Sandal Kulit Pria BELLAMO 133 Black 39', '', '', 229000, 4),
('sk_1', 3, 'Under Armour UA Heatgear Locut Socks Black S', '', '', 312550, 9),
('sk_10', 3, '2XU Ankle Sock 3 Pack Black S', '', '', 419000, 4),
('sk_11', 3, 'New Balance Response Performance No Show Gray S', '', '', 129000, 20),
('sk_12', 3, 'New Balance Response Performance No Show Gray M', '', '', 129000, 20),
('sk_13', 3, 'New Balance Response Performance No Show White S', '', '', 129000, 20),
('sk_2', 3, 'Under Armour UA Heatgear Locut Socks Black M', '', '', 312550, 12),
('sk_3', 3, 'Under Armour UA Heatgear Locut Socks White S', '', '', 312550, 12),
('sk_4', 3, 'Under Armour UA Heatgear Locut Socks White L', '', '', 312550, 12),
('sk_5', 3, 'PUMA Footie 3 Pairs Socks Black M', '', '', 129000, 11),
('sk_6', 3, 'PUMA Footie 3 Pairs Socks Black L', '', '', 129000, 11),
('sk_7', 3, 'PUMA Footie 3 Pairs Socks White M', '', '', 129000, 11),
('sk_8', 3, '2XU Ankle Sock 3 Pack Gray M', '', '', 419000, 6),
('sk_9', 3, '2XU Ankle Sock 3 Pack Gray L', '', '', 419000, 6),
('sp_11', 1, 'Marie Claire Sepatu Flats Wanita Margie White 37', 'Rose', 'L', 349900, 10),
('sp_12', 1, 'Marie Claire Sepatu Flats Wanita Margie Black 36', '', '', 349900, 1),
('sp_13', 1, 'Marie Claire Sepatu Flats Wanita Margie Black 37', '', '', 349900, 4),
('sp_14', 1, 'Marie Claire Sepatu Flats Wanita Margie Gray 36', '', '', 349900, 4),
('sp_15', 1, 'Marie Claire Sepatu Heels Wanita Cachel Black 37', '', '', 379900, 2),
('sp_16', 1, 'Marie Claire Sepatu Heels Wanita Cachel Black 38', '', '', 379900, 5),
('sp_17', 1, 'Marie Claire Sepatu Heels Wanita Cachel Gold 37', '', '', 379900, 7),
('sp_18', 1, 'Marie Claire Sepatu Heels Wanita Cachel Gold 38', '', '', 379900, 7),
('sp_2', 1, 'Nike Court Vision Low Next Nature Shoes White 38', '', '', 799000, 6),
('sp_20', 1, 'Guess Combat Boots Black 40', '', '', 161450, 1),
('sp_21', 1, 'Guess Combat Boots Brown 38', '', '', 161450, 1),
('sp_22', 1, 'ALDO Inflata Ankle Boots Gray 37', '', '', 3339000, 4),
('sp_23', 1, 'ALDO Inflata Ankle Boots Gray 39', '', '', 3339000, 4),
('sp_24', 1, 'ALDO Inflata Ankle Boots Black 37', '', '', 3339000, 4),
('sp_25', 1, 'ALDO Inflata Ankle Boots White 37', '', '', 3339000, 4),
('sp_3', 1, 'Nike Court Vision Low Next Nature Shoes Black 37', '', '', 799000, 6),
('sp_4', 1, 'Nike Court Vision Low Next Nature Shoes Black 40', '', '', 799000, 6),
('sp_5', 1, 'New Balance 411 V2 Performance Shoes Gray 39', '', '', 1099000, 7),
('sp_6', 1, 'New Balance 411 V2 Performance Shoes White 39', '', '', 1099000, 7),
('sp_7', 1, 'New Balance 411 V2 Performance Shoes Black 41', '', '', 1099000, 7),
('sp_8', 1, 'New Balance 413 Performance Shoes Navy Blue 40', '', '', 863200, 9),
('sp_9', 1, 'New Balance 413 Performance Shoes Black 40', '', '', 863200, 9),
('Tes', 1, 'HAHA', '', '', 100000, 10),
('tess', 4, 'Jpt rambut M', '', '', 15000, 10),
('tesss', 2, 'produk dummy', 'Kuning', 'M', 10000, 2);

--
-- Triggers `produk`
--
DELIMITER $$
CREATE TRIGGER `log_delete_produk` AFTER DELETE ON `produk` FOR EACH ROW BEGIN
DECLARE kat varchar(255);
SELECT nama_kategori INTO kat from kategori where id_kategori = OLD.kategori;
INSERT INTO log_produk
SET
id_produk = OLD.id_produk,
kategori_produk = kat,
produk = OLD.produk,
warna = OLD.warna,
ukuran = OLD.ukuran,
harga = OLD.harga,
qty = OLD.qty,
ket = 'Delete',
waktu = NOW();
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `log_insert_produk` AFTER INSERT ON `produk` FOR EACH ROW BEGIN
DECLARE kat varchar(255);
SELECT nama_kategori INTO kat from kategori where id_kategori = NEW.kategori;
INSERT INTO log_produk
SET
id_produk = NEW.id_produk,
kategori_produk = kat,
produk = NEW.produk,
warna = NEW.warna,
ukuran = NEW.ukuran,
harga = NEW.harga,
qty = NEW.qty,
ket = 'Insert',
waktu = NOW();
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `log_update_produk` AFTER UPDATE ON `produk` FOR EACH ROW BEGIN
DECLARE kat varchar(255);
SELECT nama_kategori INTO kat from kategori where id_kategori = OLD.kategori;
INSERT INTO log_produk
SET
id_produk = OLD.id_produk,
kategori_produk = kat,
produk = OLD.produk,
warna = OLD.warna,
ukuran = OLD.ukuran,
harga = OLD.harga,
qty = OLD.qty,
ket = 'Update',
waktu = NOW();
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `validasi_update_produk` BEFORE UPDATE ON `produk` FOR EACH ROW BEGIN
IF(NEW.id_produk <> OLD.id_produk)
THEN SET NEW.id_produk = OLD.id_produk;
signal SQLSTATE'45000' set MESSAGE_TEXT = 'Maaf, id_produk tidak bisa diubah';
END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `resi`
--

CREATE TABLE `resi` (
  `no_resi` int(5) NOT NULL,
  `wkt_transaksi` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `id_kasir` int(10) NOT NULL,
  `id_costumer` int(5) NOT NULL,
  `bayar` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `resi`
--

INSERT INTO `resi` (`no_resi`, `wkt_transaksi`, `id_kasir`, `id_costumer`, `bayar`) VALUES
(118, '2022-12-28 13:59:43', 2, 72, NULL),
(120, '2022-12-29 23:51:13', 2, 74, 1637800),
(130, '2023-01-13 12:31:05', 2, 82, 400000);

--
-- Triggers `resi`
--
DELIMITER $$
CREATE TRIGGER `log_resi_delete` BEFORE DELETE ON `resi` FOR EACH ROW BEGIN
DECLARE namac varchar(255);
DECLARE namas varchar(255);

SELECT c.nama INTO namac from costumer c join resi r on c.id_costumer = r.id_costumer where r.no_resi = OLD.no_resi;

SELECT s.nama INTO namas from staff s join resi r on s.id_staff = r.id_kasir where r.no_resi = OLD.no_resi;

INSERT INTO log_resi
SET
no_resi = OLD.no_resi,
wkt_transaksi = OLD.wkt_transaksi,
costumer = namac,
kasir = namas,
total = total_resi(OLD.no_resi),
bayar = OLD.bayar,
ket = 'DELETE',
waktu = NOW();
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `log_resi_insert` AFTER INSERT ON `resi` FOR EACH ROW BEGIN
DECLARE namac varchar(255);
DECLARE namas varchar(255);

SELECT c.nama INTO namac from costumer c join resi r on c.id_costumer = r.id_costumer where r.no_resi = NEW.no_resi;

SELECT s.nama INTO namas from staff s join resi r on s.id_staff = r.id_kasir where r.no_resi = NEW.no_resi;

INSERT INTO log_resi
SET
no_resi = NEW.no_resi,
wkt_transaksi = NEW.wkt_transaksi,
costumer = namac,
kasir = namas,
total = total_resi(NEW.no_resi),
bayar = NEW.bayar,
ket = 'INSERT',
waktu = NOW();
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `log_resi_update` AFTER UPDATE ON `resi` FOR EACH ROW BEGIN
DECLARE namac varchar(255);
DECLARE namas varchar(255);

SELECT c.nama INTO namac from costumer c join resi r on c.id_costumer = r.id_costumer where r.no_resi = OLD.no_resi;

SELECT s.nama INTO namas from staff s join resi r on s.id_staff = r.id_kasir where r.no_resi = OLD.no_resi;

INSERT INTO log_resi
SET
no_resi = OLD.no_resi,
wkt_transaksi = OLD.wkt_transaksi,
costumer = namac,
kasir = namas,
total = total_resi(OLD.no_resi),
bayar = OLD.bayar,
ket = 'UPDATE',
waktu = NOW();
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `resi_transaksi`
-- (See below for the actual view)
--
CREATE TABLE `resi_transaksi` (
`no_resi` int(5)
,`id_costumer` int(5)
,`Total` float
,`Waktu` datetime
);

-- --------------------------------------------------------

--
-- Table structure for table `staff`
--

CREATE TABLE `staff` (
  `id_staff` int(10) NOT NULL,
  `nama` varchar(200) NOT NULL,
  `tgl_lahir` date NOT NULL,
  `kelamin` enum('P','L') NOT NULL,
  `telepon` char(15) NOT NULL,
  `email` varchar(100) NOT NULL,
  `alamat` varchar(200) NOT NULL,
  `pas_poto` varchar(255) NOT NULL,
  `status` enum('Aktif','Tidak aktif') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `staff`
--

INSERT INTO `staff` (`id_staff`, `nama`, `tgl_lahir`, `kelamin`, `telepon`, `email`, `alamat`, `pas_poto`, `status`) VALUES
(1, 'Samsul arip', '2022-12-18', 'L', '231212999', 'samsul12@gmail,com', 'jl, jahanam no.69420', 'e27d8107ad358def2c9cf2044dd3323b.jpg', 'Aktif'),
(2, 'Jennie Fatma', '2001-02-14', 'P', '081353671423', 'jennie420@gmail.com', 'Koreng a Utara', 'PicsArt_09-01-05.40.55.jpg', 'Aktif'),
(3, 'Roger', '2022-12-26', 'L', '23121221', 'roger42069@gmail.com', 'Sumatra', '9e3573d537e38c85e95d93da63564013.jpg', 'Aktif');

--
-- Triggers `staff`
--
DELIMITER $$
CREATE TRIGGER `catat_staff_tdk_aktif` BEFORE UPDATE ON `staff` FOR EACH ROW BEGIN
IF (NEW.status = 'Tidak aktif')
THEN
INSERT INTO log_staff_tidak_aktif
SET id_staff = OLD.id_staff,
nama = OLD.nama,
tgl_lahir = OLD.tgl_lahir,
kelamin = OLD.kelamin,
telepon = OLD.telepon,
email = OLD.email,
alamat = OLD.alamat,
status = NEW.status,
tgl_tdk_aktif = NOW();
END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `log_staff_baru` AFTER INSERT ON `staff` FOR EACH ROW BEGIN
INSERT INTO log_staff_baru
SET id_staff = NEW.id_staff,
nama = NEW.nama,
tgl_lahir = NEW.tgl_lahir,
kelamin = NEW.kelamin,
telepon = NEW.telepon,
email = NEW.email,
alamat = NEW.alamat,
status = NEW.status,
tgl_bekerja = NOW();
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `log_update_staff` BEFORE UPDATE ON `staff` FOR EACH ROW BEGIN
IF(NEW.id_staff <> OLD.id_staff)
THEN SET NEW.id_staff = OLD.id_staff;
signal SQLSTATE'45000' set MESSAGE_TEXT = 'Maaf, id_staff tidak bisa diubah';
ELSE
INSERT INTO log_update_staff
SET id_staff = OLD.id_staff,
nama = OLD.nama,
tgl_lahir = NEW.tgl_lahir,
kelamin = NEW.kelamin,
telepon = NEW.telepon,
email = NEW.email,
alamat = NEW.alamat,
waktu = NOW();
END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `validasi_update_staff` BEFORE UPDATE ON `staff` FOR EACH ROW BEGIN
IF(NEW.id_staff <> OLD.id_staff)
THEN SET NEW.id_staff = OLD.id_staff;
signal SQLSTATE'45000' set MESSAGE_TEXT = 'Maaf, id_staff tidak bisa diubah';
END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `toko`
--

CREATE TABLE `toko` (
  `id_toko` int(11) NOT NULL,
  `toko` varchar(255) NOT NULL,
  `alamat` varchar(255) DEFAULT NULL,
  `no_telp` varchar(255) DEFAULT NULL,
  `pemilik` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `toko`
--

INSERT INTO `toko` (`id_toko`, `toko`, `alamat`, `no_telp`, `pemilik`) VALUES
(1, 'Ers shoess', ' Jl. Cipto Lubuk pakam', '+62 812-6230-0398', 'erselina');

-- --------------------------------------------------------

--
-- Table structure for table `transaksi`
--

CREATE TABLE `transaksi` (
  `id_transaksi` int(10) NOT NULL,
  `no_resi` int(5) DEFAULT NULL,
  `id_produk` char(10) NOT NULL,
  `qty` int(4) UNSIGNED NOT NULL,
  `waktu` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `transaksi`
--

INSERT INTO `transaksi` (`id_transaksi`, `no_resi`, `id_produk`, `qty`, `waktu`) VALUES
(67, NULL, 'sp_11', 2, '2022-12-29 23:34:49'),
(68, NULL, 'sp_11', 2, '2022-12-29 23:34:49'),
(70, NULL, 'sp_16', 2, '2022-12-29 23:34:49'),
(72, NULL, 'sp_12', 2, '2022-12-29 23:34:49'),
(73, NULL, 'sp_15', 2, '2022-12-29 23:34:49'),
(75, NULL, 'sp_12', 1, '2022-12-29 23:34:49'),
(79, NULL, 'sp_12', 1, '2022-12-29 23:34:49'),
(82, 120, 'sk_10', 2, '2022-12-29 23:50:59'),
(84, NULL, 'sp_13', 2, '2022-12-30 00:11:38'),
(85, NULL, 'sp_12', 1, '2022-12-30 16:27:11'),
(86, NULL, 'sp_14', 2, '2022-12-30 22:27:41'),
(92, 130, 'sd_17', 1, '2023-01-13 02:08:59'),
(96, 130, 'dummy', 2, '2023-01-13 12:32:22');

--
-- Triggers `transaksi`
--
DELIMITER $$
CREATE TRIGGER `log_transaksi` AFTER INSERT ON `transaksi` FOR EACH ROW BEGIN
DECLARE kat varchar(255);
SELECT k.nama_kategori INTO kat from kategori k join produk p on k.id_kategori = p.kategori join transaksi t on p.id_produk = t.id_produk where t.id_transaksi = NEW.id_transaksi;
INSERT INTO log_transaksi
SET
id_transaksi = NEW.id_transaksi,
no_resi = NEW.no_resi,
produk = kat,
id_barang = NEW.id_produk,
qty = NEW.qty,
tgl_transaksi = NOW();
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `pengembalian_stok_barang` AFTER DELETE ON `transaksi` FOR EACH ROW BEGIN
UPDATE produk SET qty = qty + OLD.qty WHERE id_produk = OLD.id_produk;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `perubahan_jmlh_beli` BEFORE UPDATE ON `transaksi` FOR EACH ROW BEGIN
DECLARE qtys int(4);
SELECT p.qty INTO qtys
FROM produk p
INNER JOIN transaksi t
   ON t.id_produk = p.id_produk
   WHERE t.id_transaksi = NEW.id_transaksi;
 
IF (OLD.qty >= NEW.qty)
THEN
UPDATE produk SET qty = qty + ABS(OLD.qty - NEW.qty) WHERE id_produk = OLD.id_produk;
ELSEIF (OLD.qty <= NEW.qty) AND ((qtys + OLD.qty) >= NEW.qty)
THEN
UPDATE produk SET qty = qty - ABS(NEW.qty - OLD.qty) WHERE id_produk = OLD.id_produk;
ELSE
signal SQLSTATE'45000' set MESSAGE_TEXT = 'Maaf, jumlah produk yang anda inginkan tidak tersedia';
END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_stok_produk` AFTER INSERT ON `transaksi` FOR EACH ROW BEGIN
DECLARE qtys INT(4);
SELECT p.qty INTO qtys
FROM produk p
INNER JOIN transaksi t
   ON t.id_produk = p.id_produk
   WHERE t.id_transaksi = NEW.id_transaksi;
IF (qtys >= NEW.qty)
THEN
UPDATE produk SET qty = qty - NEW.qty WHERE id_produk = NEW.id_produk;
ELSE
signal SQLSTATE'45000' set MESSAGE_TEXT = 'Maaf, jumlah produk yang anda inginkan tidak tersedia';
END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id_user` int(3) NOT NULL,
  `id_staff` int(10) NOT NULL,
  `username` varchar(15) NOT NULL,
  `password` varchar(255) DEFAULT NULL,
  `role` enum('admin','kasir') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id_user`, `id_staff`, `username`, `password`, `role`) VALUES
(5, 1, 'admin', '28b662d883b6d76fd96e4ddc5e9ba780', 'admin'),
(10, 2, 'kasir', '101a6ec9f938885df0a44f20458d2eb4', 'kasir');

--
-- Triggers `user`
--
DELIMITER $$
CREATE TRIGGER `log_user_delete` BEFORE DELETE ON `user` FOR EACH ROW BEGIN

DECLARE namas varchar(255);

SELECT s.nama INTO namas from staff s join user u on s.id_staff = u.id_staff where u.id_staff = OLD.id_staff;

INSERT INTO log_user
SET
id_user = OLD.id_user,
staff = namas,
username = OLD.username,
password = OLD.password,
role = OLD.role,
ket = 'Delete',
waktu = NOW();
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `log_user_insert` AFTER INSERT ON `user` FOR EACH ROW BEGIN

DECLARE namas varchar(255);

SELECT s.nama INTO namas from staff s join user u on s.id_staff = u.id_staff where u.id_staff = NEW.id_staff;

INSERT INTO log_user
SET
id_user = NEW.id_user,
staff = namas,
username = NEW.username,
password = NEW.password,
role = NEW.role,
ket = 'Insert',
waktu = NOW();
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `log_user_update` AFTER UPDATE ON `user` FOR EACH ROW BEGIN

DECLARE namas varchar(255);

SELECT s.nama INTO namas from staff s join user u on s.id_staff = u.id_staff where u.id_staff = OLD.id_staff;

INSERT INTO log_user
SET
id_user = OLD.id_user,
staff = namas,
username = OLD.username,
password = OLD.password,
role = OLD.role,
ket = 'Update',
waktu = NOW();
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `validasi_update_user` BEFORE UPDATE ON `user` FOR EACH ROW BEGIN
IF(NEW.id_user <> OLD.id_user)
THEN SET NEW.id_user = OLD.id_user;
signal SQLSTATE'45000' set MESSAGE_TEXT = 'Maaf, id_user tidak bisa diubah';
END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure for view `data_costumer`
--
DROP TABLE IF EXISTS `data_costumer`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `data_costumer`  AS SELECT `c`.`id_costumer` AS `id_costumer`, `c`.`nama` AS `Nama_cust`, `r`.`no_resi` AS `no_resi`, `total_resi`(`r`.`no_resi`) AS `Total`, `r`.`bayar` AS `Cash`, `c`.`created_at` AS `Waktu_transaksi` FROM (`costumer` `c` left join `resi` `r` on(`c`.`id_costumer` = `r`.`id_costumer`))  ;

-- --------------------------------------------------------

--
-- Structure for view `data_produk`
--
DROP TABLE IF EXISTS `data_produk`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `data_produk`  AS SELECT `p`.`id_produk` AS `id_produk`, `k`.`nama_kategori` AS `nama_kategori`, `p`.`produk` AS `produk`, `p`.`warna` AS `warna`, `p`.`ukuran` AS `ukuran`, `p`.`harga` AS `harga`, `p`.`qty` AS `qty` FROM (`produk` `p` join `kategori` `k` on(`p`.`kategori` = `k`.`id_kategori`))  ;

-- --------------------------------------------------------

--
-- Structure for view `data_staff`
--
DROP TABLE IF EXISTS `data_staff`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `data_staff`  AS SELECT `s`.`id_staff` AS `id_staff`, `s`.`nama` AS `nama`, `s`.`tgl_lahir` AS `tgl_lahir`, `s`.`kelamin` AS `kelamin`, `s`.`email` AS `email`, `s`.`alamat` AS `alamat`, `s`.`telepon` AS `telepon`, `s`.`status` AS `status` FROM `staff` AS `s`  ;

-- --------------------------------------------------------

--
-- Structure for view `resi_transaksi`
--
DROP TABLE IF EXISTS `resi_transaksi`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `resi_transaksi`  AS SELECT `r`.`no_resi` AS `no_resi`, `c`.`id_costumer` AS `id_costumer`, `total_resi`(`r`.`no_resi`) AS `Total`, `r`.`wkt_transaksi` AS `Waktu` FROM (`resi` `r` join `costumer` `c` on(`c`.`id_costumer` = `r`.`id_costumer`))  ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `costumer`
--
ALTER TABLE `costumer`
  ADD PRIMARY KEY (`id_costumer`);

--
-- Indexes for table `kategori`
--
ALTER TABLE `kategori`
  ADD PRIMARY KEY (`id_kategori`);

--
-- Indexes for table `produk`
--
ALTER TABLE `produk`
  ADD PRIMARY KEY (`id_produk`),
  ADD KEY `kategori` (`kategori`);

--
-- Indexes for table `resi`
--
ALTER TABLE `resi`
  ADD PRIMARY KEY (`no_resi`),
  ADD KEY `id_costumer` (`id_costumer`),
  ADD KEY `id_kasir` (`id_kasir`);

--
-- Indexes for table `staff`
--
ALTER TABLE `staff`
  ADD PRIMARY KEY (`id_staff`);

--
-- Indexes for table `toko`
--
ALTER TABLE `toko`
  ADD PRIMARY KEY (`id_toko`);

--
-- Indexes for table `transaksi`
--
ALTER TABLE `transaksi`
  ADD PRIMARY KEY (`id_transaksi`),
  ADD KEY `transaksi_ibfk_1` (`id_produk`),
  ADD KEY `transaksi_ibfk_2` (`no_resi`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id_user`),
  ADD KEY `id_staff` (`id_staff`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `costumer`
--
ALTER TABLE `costumer`
  MODIFY `id_costumer` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=83;

--
-- AUTO_INCREMENT for table `kategori`
--
ALTER TABLE `kategori`
  MODIFY `id_kategori` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `resi`
--
ALTER TABLE `resi`
  MODIFY `no_resi` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=131;

--
-- AUTO_INCREMENT for table `staff`
--
ALTER TABLE `staff`
  MODIFY `id_staff` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `toko`
--
ALTER TABLE `toko`
  MODIFY `id_toko` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `transaksi`
--
ALTER TABLE `transaksi`
  MODIFY `id_transaksi` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=97;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id_user` int(3) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `produk`
--
ALTER TABLE `produk`
  ADD CONSTRAINT `produk_ibfk_1` FOREIGN KEY (`kategori`) REFERENCES `kategori` (`id_kategori`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `resi`
--
ALTER TABLE `resi`
  ADD CONSTRAINT `resi_ibfk_1` FOREIGN KEY (`id_kasir`) REFERENCES `staff` (`id_staff`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `resi_ibfk_2` FOREIGN KEY (`id_costumer`) REFERENCES `costumer` (`id_costumer`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `transaksi`
--
ALTER TABLE `transaksi`
  ADD CONSTRAINT `transaksi_ibfk_1` FOREIGN KEY (`id_produk`) REFERENCES `produk` (`id_produk`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `transaksi_ibfk_2` FOREIGN KEY (`no_resi`) REFERENCES `resi` (`no_resi`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `user`
--
ALTER TABLE `user`
  ADD CONSTRAINT `user_ibfk_1` FOREIGN KEY (`id_staff`) REFERENCES `staff` (`id_staff`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

