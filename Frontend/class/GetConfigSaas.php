<?php

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

include_once "RestClient.php";

function getConfigSaas($params) {
    $response = post("saas/config.json", $params);
    $oResponse = json_decode($response);
    $aReturnSaasConfig = array();
    if ($oResponse != NULL) {
        if (true === (bool) $oResponse->screquest->successful) {
            $aReturnSaasConfig = $oResponse->screquest->return;
        }
    }
    
    return $aReturnSaasConfig;
}

?>
