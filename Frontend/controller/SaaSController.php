<?php
session_start();

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

include_once "../class/RestClient.php";

if (isset($_POST["send"])) {
    $response = post("saas/owncloud.json", $_POST);

    header('location: ../view/home.php');
    return $response;
}
?>
