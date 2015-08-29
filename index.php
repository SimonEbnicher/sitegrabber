<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8"> 
	<title>NetIO Status</title>
	<style>
	table, th, td {
	border: 1px solid black;
	border-collapse: collapse;
	}
	th, td {
	padding: 5px;
	}
	</style>
</head>
<body>
<h1>Current NetIO Status Data</h1>
<table style="text-align: left; white-space: nowrap;">
<tr style="text-align: center; white-space: nowrap;">
	<th>Name</th>
	<th>IP</th>
	<th colspan="2">Ch 01</th>
	<th colspan="2">Ch 02</th>
	<th colspan="2">Ch 03</th>
	<th colspan="2">Ch 04</th>
	<th colspan="2">Ch 05</th>
	<th colspan="2">Ch 06</th>
	<th colspan="2">Ch 07</th>
	<th colspan="2">Ch 08</th>
	<th colspan="2">Ch 09</th>
	<th colspan="2">Ch 10</th>
	<th colspan="2">Ch 11</th>
	<th colspan="2">Ch 12</th>
	<th colspan="3">An 01</th>
	<th colspan="3">An 02</th>
	<th colspan="3">An 03</th>
	<th colspan="3">An 04</th>
</tr>
<tr style="text-align: center; white-space: nowrap;">
	<th> </th>
	<th> </th>
	<th>Name</th>
	<th>Stat</th>
	<th>Name</th>
	<th>Stat</th>
	<th>Name</th>
	<th>Stat</th>
	<th>Name</th>
	<th>Stat</th>
	<th>Name</th>
	<th>Stat</th>
	<th>Name</th>
	<th>Stat</th>
	<th>Name</th>
	<th>Stat</th>
	<th>Name</th>
	<th>Stat</th>
	<th>Name</th>
	<th>Stat</th>
	<th>Name</th>
	<th>Stat</th>
	<th>Name</th>
	<th>Stat</th>
	<th>Name</th>
	<th>Stat</th>
	<th>Name</th>
	<th>Value</th>
	<th>Unit</th>
	<th>Name</th>
	<th>Value</th>
	<th>Unit</th>
	<th>Name</th>
	<th>Value</th>
	<th>Unit</th>
	<th>Name</th>
	<th>Value</th>
	<th>Unit</th>
</tr>
<?php
$db_server = "localhost";
$db_user = "username";
$db_pass = "password";
$db_database = "database";

$db_conn = new mysqli($db_server, $db_user, $db_pass, $db_database);

$db_conn->query("set character_set_client='utf8'");
$db_conn->query("set character_set_results='utf8'");

$max_timestamp = null;
if ($db_conn->connect_error) {
    die("Connection failed: " . $db_conn->connect_error);
}

$result = $db_conn->query("SELECT max(timestamp) FROM records");
if ($result->num_rows == 1) {
	$row = $result->fetch_assoc();
	$max_timestamp = $row["max(timestamp)"];
}

$sql = "SELECT s.name,s.ip,s.ch01name,r.ch01,s.ch02name,r.ch02,s.ch03name,r.ch03,s.ch04name,r.ch04,s.ch05name,r.ch05,s.ch06name,r.ch06,s.ch07name,r.ch07,s.ch08name,r.ch08,s.ch09name,r.ch09,s.ch10name,r.ch10,s.ch11name,r.ch11,s.ch12name,r.ch12,s.an01name,r.an01,s.an01unit,s.an02name,r.an02,s.an02unit,s.an03name,r.an03,s.an03unit,s.an04name,r.an04,s.an04unit FROM stations AS s JOIN records AS r WHERE r.timestamp = \"$max_timestamp\" AND r.id = s.id AND s.enabled = 1";
$result = $db_conn->query($sql);

if ($result->num_rows > 0) {
	while ($row = $result->fetch_assoc()) {
		echo "<tr style=\"text-align: left; white-space: nowrap; border: 1px solid black;\">";

		echo "\t<td>".$row["name"]."</td>";
		echo "\t<td>".$row["ip"]."</td>";
		echo "\t<td>".$row["ch01name"]."</td>";
		echo "\t<td>".$row["ch01"]."</td>";
		echo "\t<td>".$row["ch02name"]."</td>";
		echo "\t<td>".$row["ch02"]."</td>";
		echo "\t<td>".$row["ch03name"]."</td>";
		echo "\t<td>".$row["ch03"]."</td>";
		echo "\t<td>".$row["ch04name"]."</td>";
		echo "\t<td>".$row["ch04"]."</td>";
		echo "\t<td>".$row["ch05name"]."</td>";
		echo "\t<td>".$row["ch05"]."</td>";
		echo "\t<td>".$row["ch06name"]."</td>";
		echo "\t<td>".$row["ch06"]."</td>";
		echo "\t<td>".$row["ch07name"]."</td>";
		echo "\t<td>".$row["ch07"]."</td>";
		echo "\t<td>".$row["ch08name"]."</td>";
		echo "\t<td>".$row["ch08"]."</td>";
		echo "\t<td>".$row["ch09name"]."</td>";
		echo "\t<td>".$row["ch09"]."</td>";
		echo "\t<td>".$row["ch10name"]."</td>";
		echo "\t<td>".$row["ch10"]."</td>";
		echo "\t<td>".$row["ch11name"]."</td>";
		echo "\t<td>".$row["ch11"]."</td>";
		echo "\t<td>".$row["ch12name"]."</td>";
		echo "\t<td>".$row["ch12"]."</td>";
		echo "\t<td>".$row["an01name"]."</td>";
		echo "\t<td>".$row["an01"]."</td>";
		echo "\t<td>".$row["an01unit"]."</td>";
		echo "\t<td>".$row["an02name"]."</td>";
		echo "\t<td>".$row["an02"]."</td>";
		echo "\t<td>".$row["an02unit"]."</td>";
		echo "\t<td>".$row["an03name"]."</td>";
		echo "\t<td>".$row["an03"]."</td>";
		echo "\t<td>".$row["an03unit"]."</td>";
		echo "\t<td>".$row["an04name"]."</td>";
		echo "\t<td>".$row["an04"]."</td>";
		echo "\t<td>".$row["an04unit"]."</td>";
	
		echo "</tr>";
	}
}

$db_conn->close();

echo "Last Update = $max_timestamp<br /><br />";

?>
</table>
</body>
</html>
