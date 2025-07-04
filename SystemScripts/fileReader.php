<?php
$file = __dir__."/newData.txt"; // Replace with your file path
echo $file.PHP_EOL;
if (!file_exists($file)) {
	die("Error: File not found!");
}

function getDays($inpStr)
{
	// 14:18:46 up 144 days, 19:53,  1 user,	load average: 0.25, 0.29, 0.41
	$dataArr = explode(",", $inpStr);
	$pos = strpos($dataArr[0], "up");
	$days = substr($dataArr[0], $pos + 2);
	$load = $dataArr[3] . $dataArr[4] . $dataArr[5];
	return $days . "-" . trim($load);
}
// Start Create Csv Like Data

$handle = fopen($file, "r"); // Open the file for reading
$tmpFile = __dir__."/tmpfile.txt";
$outfile = fopen($tmpFile,"w");
fclose($outfile);
$outfile = fopen($tmpFile,"a");
if ($handle && $outfile) {
	$tmpline = "";
	while (($line = fgets($handle)) !== false) {
		// Read line by line
        $tmpStr = trim($line);
        if (strpos($tmpStr, "--") !== false) {
		 	$strArr = explode("==", $tmpline);
            fwrite($outfile,"Server:".$strArr[4]."\n");
		 	fwrite($outfile,$strArr[0]."\n");
		 	fwrite($outfile,$strArr[1]."MB \n");
		 	fwrite($outfile,$strArr[2]."MB \n");
		 	$uptime = explode("-", getDays($strArr[3]));
		 	fwrite($outfile,$uptime[1]."\n");
		 	fwrite($outfile,$uptime[0]."\n");
		 	$tmpline = "";
		 	continue;
		}
		$tmpline .= $tmpStr;
		$tmpline .= "==";
	}
	fclose($handle); // Close the file
	fclose($outfile);
	/*if(file_exists($tmpFile)){
		unlink($tmpFile);
	}*/
} 
else {
	echo "Error: Unable to open the file!";
	exit;
}
// End Create Csv Like Data
#Start Creating csv file
$file = "tmpfile.txt"; // Your input file

if (!file_exists($file)) {
    die("Error: File not found!");
}

$lines = file($file, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES); // Read lines
$data = [];
$headers = [];
$temp = [];

$servers = [
	"10.141.157.74" => "(FGMS BOT)",
	"10.141.157.80" => "(FGMS DB)",
	"10.141.157.81" => "(FGMS App1)",
	"10.141.157.83" => "(FGMS CTC)",
	"10.141.157.84" => "(FGMS App2)",
	"10.141.157.94" => "(FGMS App3)",
	"10.129.9.106" => "(Astro)",
	"172.17.124.20" => "(RRB APP)",
	"172.17.124.21" => "(RRB DB)",
	"172.17.208.190" => "(CSC14599 APP)",
	"172.17.208.191" => "(CSC14599 DB)",
	"172.17.208.195" => "(Telelaw)"
];
foreach ($lines as $line) {
    if (strpos($line, "Server") === 0) {
        if (!empty($temp)) {
            $data[] = $temp;
        }
		$headArr = explode(":",trim($line));
		$ip = trim($headArr[1]);
		$value = $servers[$ip];
        $headers[] = $ip.$value; // Store Server name
        $temp = [];
    } else {
        $temp[] = trim($line); // Store values
    }
}

if (!empty($temp)) {
    $data[] = $temp; // Add last server's data
}

// Transpose Data (Convert Rows to Columns)
$transposed = [];
foreach ($data as $serverIndex => $values) {
    foreach ($values as $i => $value) {
        $transposed[$i][] = $value;
    }
}

// Output CSV Format
// echo implode(", ", $headers) . "\n"; // Print headers
$outputFile = __dir__."/CSVOUT/out_".date("Ymd_His").".csv";

foreach ($transposed as $row) {
	file_put_contents($outputFile,implode(", ",$headers)."\n".implode("\n",array_map(fn($row)=>implode(", ",$row),$transposed)));
	//echo implode(", ", $row) . "\n"; // Print row values
}

# Delete Temprary file

if(file_exists($tmpFile)){
		unlink($tmpFile);
}

#End Creating csv file
