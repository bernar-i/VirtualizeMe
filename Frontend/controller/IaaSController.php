<?php

include_once "../class/RestClient.php";

if (isset($_POST["send"])) {
    $response = post("iaas/clone.json", $_POST);

    header('location: ../view/home.php?vm_name=' . $_POST['vm_name'] . '');
    return $response;
}
?>