<?php
$loggerFile = "updateChatLog.log";
$log = fopen($loggerFile, 'a') or die("can't open file");
$userName = $_GET["userName"] ;
$machineUser = $_GET["machineUser"] ;
$userMessage = $_GET["message"];
$msgColor = $_GET["msgColor"];
$userTime = date("g:i a, m/d/Y T");
$groupName = $_GET["groupName"];
$versionNo = $_GET["version"] ;
$ipAddress = $_GET["ipAddress"] ;

fwrite($log, "versionNo: " . $versionNo . " IP Address: " . $ipAddress . "\n" );

if($versionNo != null && $versionNo != "")
{
if($groupName==null || $groupName=="")
{
$myFile = "generalGroup.txt";
}
else
{
$myFile = $groupName .".txt" ;
}

fwrite($log, "file name : " + $myFile . "\n" ) ;

if(!file_exists($myFile))
{
fwrite($log,"file not exists" . "\n") ;
$cCountFile = fopen("counter".$myFile , 'a') or die("can't open file");
$theData = 0;
}	
else
{
fwrite($log,"file exists" . "\n") ;
$cCountFile = fopen("counter".$myFile , 'r');
$theData = stream_get_line( $cCountFile, 1024, "##!##" ); 
}
echo($theData) ;
fwrite($log,$theData . "\n");
$theData = $theData+1;
$fh = fopen($myFile, 'a') or die("can't open file");

fwrite($fh, $theData . "##!##"  . $userName . "##!##" . $machineUser . "##!##"  . $userMessage . "##!##". $msgColor . "##!##" . $userTime . "##!##" . $ipAddress . "\n" );

$cCountFile = fopen("counter".$myFile , 'w');
fwrite($cCountFile, $theData . "##!##" );

fclose($cCountFile);
fclose($fh);
fclose($log) ;
}
?>