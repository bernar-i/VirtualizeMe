<?php

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

include_once "../class/RestClient.php";

if (isset($_POST["send"])) {
    //$POST['template'] = "test";
    $response = post("iaas/configure.json", $_POST);

    //$response = get("rbvmomi/configuration.json");

    header('location: ../view/home.php');
    return $response;
}
?>