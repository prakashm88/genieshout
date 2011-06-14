<?php

$loggerFile = "groupNameReq.log";
$log = fopen($loggerFile, 'a') or die("can't open file");

$userTime = date("g:i a, m/d/Y T");
$ipAddress = $_GET["ipAddress"] ;
$versionNo = $_GET["versionNo"] ;

fwrite($log, "versionNo: " . $versionNo . " IP Address: " . $ipAddress . " @ " . $userTime . "\n" );

if($versionNo != null && $versionNo != "")
{

$myFile = "groupNames.itg";

if(!file_exists($myFile))
{
fwrite($log,"creating first groupname" . "\n") ;
$gpFile = fopen($myFile , 'a') or die("can't open file");
fwrite($gpFile, "general##!##General" . "\n" );
fclose($gpFile);
}	

$lines = file($myFile) ;
echo("<groups>");	
foreach ($lines as $line_num => $line) {

$newLine = htmlspecialchars($line) ;
list($serverName, $serverLabel) = split('##!##', $newLine);
echo("<group>");
echo("<name>");
echo( $serverName);
echo("</name>");
echo("<label>");
echo( $serverLabel);
echo("</label>");
echo("</group>");

}
echo("</groups>");

fclose($log);

}

?>