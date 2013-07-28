<?php

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

include_once "RestClient.php";

$response = get("iaas/virtual_machines.json");
$oResponse = json_decode($response);
$aReturn = array();

if ($oResponse != NULL) {
    if (true === (bool) $oResponse->screquest->successful) {
        $aReturn = $oResponse->screquest->return;
    }
}
?>
