<?php
session_start();
include_once "../class/GetVM.php";
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
            <!-- link rel="stylesheet" href="../resource/css/custom.css" / -->
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
                                <li><a href="./home.php">Home</a></li>
                                <li><a href="./iaas.php">IaaS</a></li>
                                <li class="active"><a href="./paas.php">PaaS</a></li>
                                <li><a href="./saas.php">SaaS</a></li>
                            </ul>
                        </div><!--/.nav-collapse -->
                    </div>
                </div>
            </div>

            <div class="container">

                <h1>Configure your hosting web platform</h1>

                <br />
                <form class="form-horizontal" method="post" action="../controller/PaaSController.php">
                    <div class="control-group">
                        <label class="control-label" for="inputEmail">Virtual Machine</label>
                        <div class="controls">
                            <select name="vm_name">
                                <?php foreach ($aReturn as $index) : ?>
                                    <?php foreach ($index as $key => $value) : ?>
                                        <?php if ($key == "name") : ?>
                                            <option><?php echo $value; ?></option>        
                                        <?php endif; ?>
                                    <?php endforeach; ?>
                                <?php endforeach; ?>
                            </select>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label" for="inputPassword">MySQL Password</label>
                        <div class="controls">
                            <input type="password" name="password_mysql" id="inputPassword" placeholder="password">
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label" for="inputEmail">Application Name</label>
                        <div class="controls">
                            <input type="text" name="application" id="inputEmail" placeholder="application">
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label" for="inputEmail">Repository Url GitHub</label>
                        <div class="controls">
                            <input type="text" name="repository" id="inputEmail" placeholder="repository">
                        </div>
                    </div>
                    <div class="control-group">
                        <div class="controls">
                            <button type="submit" class="btn btn-primary" name="send" data-loading-text="Loading...">Submit</button>
                        </div>
                    </div>
                </form>

            </div> <!-- /container -->

        </body>
    </html>
<?php else : header('location: ../index.php'); ?>
<?php endif; ?>