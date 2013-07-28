<?php

function post($method, $params)
{
	$host	 = "http://127.0.0.1:9090";
	$req	 = $host."/".$method;
	$ch	 = curl_init($req);

	curl_setopt($ch, CURLOPT_HTTPHEADER, array("Content-type: multipart/form-data"));
	curl_setopt($ch, CURLOPT_HEADER, false);
	curl_setopt($ch, CURLOPT_POST, true);
	curl_setopt($ch, CURLOPT_POSTFIELDS, (is_array($params)) ? $params: array($params));
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

	$response = curl_exec($ch);
	curl_close($ch);

	return $response;
}

function get($method, $params)
{
	$host		= "http://127.0.0.1:9090";
        $req		= $host."/".$method;
	$ch             = curl_init($req);
        
	curl_setopt($ch, CURLOPT_URL, $req);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_HEADER, false);
	curl_setopt($ch, CURLOPT_TIMEOUT, '3');
	$response = curl_exec($ch);
	curl_close($ch);

        return $response;
}

function delete($method, $params)
{
	$host           = "http://127.0.0.1:9090";
	$req            = $host."/".$method;
	$ch             = curl_init($req);

	curl_setopt($ch, CURLOPT_HEADER, false);
	curl_setopt($ch, CURLOPT_POST, true);
	curl_setopt($ch, CURLOPT_POSTFIELDS, (array) $params);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "DELETE");

	$response = curl_exec($ch);
	curl_close($ch);

	return $response;
}

function put($method, $params)
{
	$host           = "http://127.0.0.1:9090";
	$req            = $host."/".$method;
	$ch             = curl_init($req);

	curl_setopt($ch, CURLOPT_HEADER, false);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, (array) $params);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "PUT");

	$response = curl_exec($ch);
	curl_close($ch);

	return $response;
}

?>