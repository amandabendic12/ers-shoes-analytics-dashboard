<?php
$title = 'Data User';
require 'koneksi.php';

$_SESSION['staff_id'];

$query = 'SELECT u.*, s.nama FROM user u JOIN staff s on u.id_staff = s.id_staff';
$data = mysqli_query($conn, $query);

require 'header.php';
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
                <h2 class="text-white pb-2 fw-bold"><?= $title; ?></h2>
            </div>
        </div>
    </div>
</div>
<div class="page-inner mt--5">
    <diva class="row">
        <div class="col-md-12">
            <div class="card card-default">
                <div class="card-header">
                    <div class="d-flex align-items-center">
                        <h4 class="card-title"></h4>
                        <a href="tambah_user.php" class="btn btn-primary btn-round ml-auto">
                            <i class="fa fa-plus"></i>
                            Tambah User
                        </a>
                    </div>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table id="basic-datatables" class="display table table-striped table-hover">
                            <thead>
                                <tr>
                                    <th style="width: 7%">#</th>
                                    <th>Username</th>
                                    <th>Nama Staff</th>
                                    <th style="width: 20%;">Role</th>
                                    <!-- <th style="width: 25%;">Alamat</th>
                                    <th style="width: 20%;">Tanggal Lahir</th>
                                    <th style="width: 20%;">No Telepon</th>
                                    <th style="width: 15%;">Jenis Kelamin</th>
                                    <th style="width: 15%;">status</th> -->
                                    <th style="width: 10%"><center>Aksi</center></th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php
                                $no = 1;
                                if (mysqli_num_rows($data) > 0) {
                                    while ($plg = mysqli_fetch_assoc($data)) {
                                ?>

                                        <tr>
                                            <td><?= $no++; ?></td>
                                            <td><?= $plg['username']; ?></td>
                                            <td><?= $plg['nama']; ?></td>
                                            <td><?= $plg['role']; ?></td>


                                            <td>
                                                <div class="form-button-action">
                                                <a href="edit_user.php?id=<?= $plg['id_user']; ?>" type="button" data-toggle="tooltip" title="" class="btn btn-link btn-primary btn-lg" data-original-title="Edit">
                                                        <i class="fa fa-edit"></i>
                                                    </a>
                                                    <a href="hapus_user.php?id=<?= $plg['id_user']; ?>" onclick="return confirm('Yakin hapus data?');" type="button" data-toggle="tooltip" title="" class="btn btn-link btn-danger" data-original-title="Hapus">
                                                        <i class="fa fa-times"></i>
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                <?php }
                                }
                                ?>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

</div>
</div>
<?php
require 'footer.php';
?>