<?php

function getConfig() {
    $oConfig = json_decode(file_get_contents("../resource/config/settings.json"));

    return $oConfig;
}

?>