<?php
include_once "./class/RestClient.php";

$response = get("iaas/virtual_machines.json");

//$response = get("rbvmomi/configuration.json", $_POST);

return $response
?>