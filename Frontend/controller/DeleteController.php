<?php

include_once "../class/RestClient.php";

$response = delete("iaas/" . $_GET['vm_name'] . ".json", $_POST);

header('location: ../index.php');
?>