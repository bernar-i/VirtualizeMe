<?php

include_once "../class/Config.php";

if (isset($_POST['username']) && isset($_POST['password'])) {
    $oConfig = getConfig();
    if ($oConfig->user->user == $_POST['username'] && $oConfig->user->password == $_POST['password']) {

        session_start();
        $_SESSION['username'] = $_POST['username'];
        $_SESSION['password'] = $_POST['password'];

        header('location: ../view/home.php');
    } else {
        echo '<meta http-equiv="refresh" content="0;URL=../index.php">';
    }
} else {
        header('location: ../index.php');
}
?>