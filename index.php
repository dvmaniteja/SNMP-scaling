<html>
<head>
<title>assignment-4</title>
</head>

<body bgcolour="#f4ddeb">
<div style="background-color:#FFFFFF; width:75%;margin:auto;text-align:center;border:30px solid #000000;height:auto;font-size:160%;">

     
	<h2>Assignment-4</h2>
  
 <div style="font-size:120%;font-size:100%;">
    <h2>Display status of devices</h2><br>
 </div>
<style>
p {
    text-align:center;color:#FFFFFF;border:10px solid #000000;padding:2px;background-color:#cbbeb5;border-top:50px;bottom:0;border-left:55px;
}
table, th, td {
    border: 2px double black; 
}
</style>


<?php
$dir = dirname(__FILE__);
$totalpath = realpath($dir . '/..');
$requiredpath = $totalpath . '/db2.conf';
$last= file($requiredpath);

for($i=0;$i<=4;$i++)
	{
	   $data=explode('"',$last[$i]);
	   $out[$i]="$data[1]";
	}

$host = $out[0];
$port = $out[1];
$database = $out[2];
$username = $out[3];
$password = $out[4];


$con= new mysqli($host,$username,$password);
if ($con->connect_error)
  {
  echo "Failed to connect to MySQL: ". $con->connect_error ;
  }

$con= new mysqli($host,$username,$password,$database);
if ($con->connect_error)
  {
  echo "Failed to connect to database: ". $con->connect_error ;
  }

$color = array("FFFFFF","FFEEEE","FF7070","FF6870","FF6070","FF5870","FF5070","FF4870","FF4070","FF3870","FF3070","FF2870","FF2070","FF1870","FF1070",
"FF0870","FF0070","FF3060","FF2860","FF2060","FF1860","FF1060","FF0860","FF0060",
"FF2850","FF2050","FF1850","FF1050","FF0850","FF0050","FF1040","FF1030");

mysqli_select_db($con,$database) or die ("Cannot select DB");
$sql3 = "SELECT * FROM manidetails";
$result = mysqli_query($con,$sql3);
print "<center><table cellpadding=5></center>"; 
print  "<tr>";
print  "<th>ID</th> ";
print  "<th>IP</th> ";
print  "<th>Port</th> ";
print  "<th>Community</th>";
print  "<th>Sysuptime</th> ";
print  "<th>SentReq</th> ";
print  "<th>LostReq</th> ";
print  "<th>UpdatedTime</th> ";
print  "<th>Status</th>";
print  "</tr>";

$PHP_SELF = " ";
while ($fetch = mysqli_fetch_assoc($result))
{

$lostreq = $fetch['lostReq'];
 $colour = "#"."$color[$lostreq]";

 print "<tr>"; 
 print "<td>".$fetch['id']."</td>";
 print "<td>".$fetch['IP']."</td>";
 print "<td>".$fetch['PORT']."</td>";
 print "<td>".$fetch['COMMUNITY']."</td>";
 print "<td>".$fetch['sysuptime']."</td>";
 print "<td>".$fetch['sentReq']."</td>";
 print "<td>".$fetch['lostReq']."</td>";
 print "<td>".$fetch['updatedtime']."</td>";
 print "<td bgcolor=$colour width=50>  </td>";
 print "</tr>";
if($lostreq > 30)
{
 $colour = "#"."FF1030";

}
}
print"</table><br><br>";

?>
	</div>
</body>
</html>
