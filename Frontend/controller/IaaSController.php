<?php

include_once "../class/RestClient.php";

if (isset($_POST["send"])) {
    //$POST['template'] = "test";
    $response = post("iaas/clone.json", $_POST);

    //$response = get("rbvmomi/configuration.json");

    header('location: ../index.php');
    return $response;
}
?>