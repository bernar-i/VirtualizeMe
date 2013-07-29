<?php

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

include_once "RestClient.php";

function getConfigPaas($params) {
    $response = post("paas/config.json", $params);
    $oResponse = json_decode($response);
    $aReturnPaasConfig = array();
    if ($oResponse != NULL) {
        if (true === (bool) $oResponse->screquest->successful) {
            $aReturnPaasConfig = $oResponse->screquest->return;
        }
    }
    
    return $aReturnPaasConfig;
}

?>
