<?php

include_once "../class/RestClient.php";

$response = delete("iaas/" . $_GET['vm_name'] . ".json", $_POST);

sleep(3);
header('location: ../view/home.php');
?>