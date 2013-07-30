<?php

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

include_once "../class/RestClient.php";

if (isset($_POST["send"])) {
    $response = post("paas/installPackages.json", $_POST);

    header('location: ../view/home.php?vm_name=' . $_POST['vm_name'] . '');
    return $response;
}
?>
