<?php

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

include_once "../class/RestClient.php";

$response = post("paas/gitPull.json", $_GET);

header('location: ../view/home.php?vm_name=' . $_GET['vm_name'] . '');
?>