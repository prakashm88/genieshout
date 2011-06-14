<?php
$loggerFile = "getChatLog.log";
$log = fopen($loggerFile, 'a') or die("can't open file");

$groupName = $_GET['gpn'] ;
$chatCount = $_GET['cnt'] ;

//echo($chatCount ) ;
fwrite($log, "GroupName: " . $groupName . "\n" );

if($groupName == null || $groupName == "") 
{
$myFile = "generalGroup.itg";
}
else
{
$myFile = $groupName.".itg" ;
}

fwrite($log, "GroupFileName: " . $myFile . "\n" );

echo("<xmlFile>");


$fileHandle = fopen($myFile, 'a') or die("can't open file");
$lines = file($myFile) ;

foreach ($lines as $line_num => $line) {
$newLine = htmlspecialchars($line) ;
//echo ($newLine ."<br/>");
list($fullChatCounter, $name, $machinename, $chattext, $chatcolor, $time) = split('##!##', $newLine);
//echo("-".$fullChatCounter);
if( $chatCount < $fullChatCounter )
{
//echo (true) ;
echo("<chatDetail>");	
echo("<name>");
echo($name);
echo("</name>");
echo("<machineUser>");
echo( $machinename);
echo("</machineUser>");
echo("<chattext>");
echo($chattext);
echo("</chattext>");
echo("<chatcolor>");
echo($chatcolor);
echo("</chatcolor>");
echo("<time>");
echo($time);
echo("</time>");
echo("<flag>");
echo("1");
echo("</flag>");	
echo("</chatDetail>");
}

}


echo("</xmlFile>");

?>