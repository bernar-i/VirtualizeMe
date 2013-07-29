<?php
session_start();

include_once "../class/RestClient.php";

if (isset($_POST["send"])) {
    $response = post("iaas/clone.json", $_POST);

    header('location: ../view/home.php');
    return $response;
}
?>