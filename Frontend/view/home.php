<?php
include_once "../class/GetVM.php";
?>
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
                    <a class="brand" href="#">VirtualizeMe</a>
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

            <?php foreach ($aReturn as $index) : ?>
                <?php foreach ($index as $key => $value) : ?>
                    <?php echo ucfirst($key) . " : " . $value . " "; ?>
                    <?php if ($key == "name") : ?>
                        <a href="../controller/PowerOnController.php?vm_name=<?php echo $value ?>" title="Power ON" class="btn btn-success btn-small"><i class="icon-white icon-play"></i></a>
                        <a href="../controller/RebootController.php?vm_name=<?php echo $value ?>" title="Reboot" class="btn btn-warning btn-small"><i class="icon-white icon-repeat"></i></a>
                        <a href="../controller/PowerOffController.php?vm_name=<?php echo $value ?>" title="Power OFF" class="btn btn-danger btn-small"><i class="icon-white icon-stop"></i></a>
                        <a href="../controller/ShutdownController.php?vm_name=<?php echo $value ?>" title="Shutdown" class="btn btn-danger btn-small"><i class="icon-white icon-off"></i></a>
                        <a href="../controller/DeleteController.php?vm_name=<?php echo $value ?>" title="Delete" class="btn btn-danger btn-small"><i class="icon-white icon-trash"></i></a>
                        <?php endif; ?>
                    <br />
                <?php endforeach; ?>
                <br />
            <?php endforeach; ?>

        </div> <!-- /container -->

    </body>
</html>