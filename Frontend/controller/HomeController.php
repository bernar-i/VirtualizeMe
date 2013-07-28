<?php

include_once "../class/RestClient.php";

$response = get("iaas/virtual_machines.json");
$oResponse = json_decode($response);
$aReturn = array();

if ($oResponse != NULL) {
    if (true === (bool) $oResponse->screquest->successful) {
        $aReturn = $oResponse->screquest->return;
    }
}
?>