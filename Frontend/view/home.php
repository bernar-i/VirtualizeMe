<?php
session_start();
include_once "../class/GetVM.php";
include_once "../class/GetConfigPaas.php";
include_once "../class/GetConfigSaas.php";
?>
<?php if (isset($_SESSION['username']) && isset($_SESSION['password'])) : ?>
    <!DOCTYPE php>
    <html lang="en">
        <head>
            <meta charset="utf-8">
            <title>VirtualizeMe, oh yeah</title>
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta name="description" content="">
            <meta name="author" content="">

            <!-- Le styles -->
            <link href="../resource/bootstrap/css/bootstrap.css" rel="stylesheet">
            <link rel="stylesheet" href="../resource/css/custom.css" />
            <style>
                body {
                    padding-top: 60px; /* 60px to make the container go all the way to the bottom of the topbar */
                }
            </style>
            <link href="../resource/bootstrap/css/bootstrap-responsive.css" rel="stylesheet">

            <!-- Fav and touch icons
            <link rel="apple-touch-icon-precomposed" sizes="144x144" href="./bootstrap/ico/apple-touch-icon-144-precomposed.png">
            <link rel="apple-touch-icon-precomposed" sizes="114x114" href="./bootstrap/ico/apple-touch-icon-114-precomposed.png">
              <link rel="apple-touch-icon-precomposed" sizes="72x72" href="./bootstrap/ico/apple-touch-icon-72-precomposed.png">
                            <link rel="apple-touch-icon-precomposed" href="./bootstrap/ico/apple-touch-icon-57-precomposed.png">
                                           <link rel="shortcut icon" href="./bootstrap/ico/favicon.png"> -->
        </head>

        <body>

            <div class="navbar navbar-inverse navbar-fixed-top">
                <div class="navbar-inner">
                    <div class="container">
                        <button type="button" class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                        </button>
                        <a class="brand" href="./home.php">VirtualizeMe</a>
                        <div class="nav-collapse collapse pull-right">
                            <ul class="nav">
                                <li><a href="../controller/Logout.php" data-toggle="modal"><i class="icon-user icon-white"></i> Logout</a></li>
                                <li class="divider-vertical"></li>
                            </ul>
                        </div>
                        <div class="nav-collapse collapse">
                            <ul class="nav">
                                <li class="active"><a href="./home.php">Home</a></li>
                                <li><a href="./iaas.php">IaaS</a></li>
                                <li><a href="./paas.php">PaaS</a></li>
                                <li><a href="./saas.php">SaaS</a></li>
                            </ul>
                        </div><!--/.nav-collapse -->
                    </div>
                </div>
            </div>

            <div class="container">

                <?php $vm = array() ?>
                <?php $i = 0 ?>
                <?php foreach ($aReturn as $index) : ?>
                    <?php foreach ($index as $key => $value) : ?>
                        <?php echo ucfirst($key) . " : " . $value . " " ?>
                        <?php if ($key == "name") : ?>
                            <?php $vm[$i] = $value ?>
                            <a href="../controller/PowerOnController.php?vm_name=<?php echo $value ?>" title="Power ON" class="btn btn-success btn-small"><i class="icon-white icon-play"></i></a>
                            <a href="../controller/RebootController.php?vm_name=<?php echo $value ?>" title="Reboot" class="btn btn-warning btn-small"><i class="icon-white icon-repeat"></i></a>
                            <a href="../controller/PowerOffController.php?vm_name=<?php echo $value ?>" title="Power OFF" class="btn btn-danger btn-small"><i class="icon-white icon-stop"></i></a>
                            <a href="../controller/ShutdownController.php?vm_name=<?php echo $value ?>" title="Shutdown" class="btn btn-danger btn-small"><i class="icon-white icon-off"></i></a>
                            <a href="../controller/DeleteController.php?vm_name=<?php echo $value ?>" title="Delete" class="btn btn-danger btn-small"><i class="icon-white icon-trash"></i></a>
                            <?php endif; ?>
                        <br />
                    <?php endforeach; ?>
                    <?php $aConfigPaas = getConfigPaas($params = array("vm_name" => $vm[$i])); ?>
                    <?php if (isset($aConfigPaas)) : ?>
                        <?php foreach ($aConfigPaas as $index => $val) : ?>
                            <?php echo ucfirst($index); ?>
                            <?php //if (isset($val)) : echo $val; endif;    ?>
                            <br />
                            <?php foreach ($val as $key => $value) : ?>
                                <?php echo ucfirst($key) ?>
                                <?php if (strstr($value, "http")) : ?>
                                    : <a href="<?php echo $value ?>"><?php echo $value ?></a>
                                <?php else : ?>
                                    <?php echo " : " . $value . " " ?>
                                <?php endif; ?>
                                <br />
                            <?php endforeach; ?>
                        <?php endforeach; ?>
                    <?php endif ?>
                    <?php $aConfigSaas = getConfigSaas($params = array("vm_name" => $vm[$i])); ?>
                    <?php if (isset($aConfigSaas)) : ?>
                        <?php foreach ($aConfigSaas as $index => $val) : ?>
                            <?php echo ucfirst($index); ?>
                            <?php //if (isset($val)) : echo $val; endif;    ?>
                            <br />
                            <?php foreach ($val as $key => $value) : ?>
                                <?php echo ucfirst($key) ?>
                                <?php if (strstr($value, "http")) : ?>
                                    : <a href="<?php echo $value ?>"><?php echo $value ?></a>
                                <?php else : ?>
                                    <?php echo " : " . $value . " " ?>
                                <?php endif; ?>
                                <br />
                            <?php endforeach; ?>
                        <?php endforeach; ?>
                    <?php endif; ?>
                    <?php $i++; ?>
                    <br />
                    <br />
                <?php endforeach; ?>

            </div> <!-- /container -->

        </body>
    </html>
<?php else : header('location: ../index.php'); ?>
<?php endif; ?>