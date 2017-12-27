<?php
// Args: 0 => makedb.php, 1 => "$XIMDEX_DB_HOST", 2 => "$XIMDEX_DB_USER", 3 => "$XIMDEX_DB_PASSWORD", 4 => "$XIMDEX_DB_NAME"
$stderr = fopen('php://stderr', 'w');
fwrite($stderr, "\nEnsuring Ximdex database is present\n");

if (strpos($argv[1], ':') !== false)
{
	list($host, $port) = explode(':', $argv[1], 2);
}
else
{
	$host = $argv[1];
	$port = 3306;
}

try {
	$pdconnstring = "mysql:host={$host};port={$port}";
	$db = new \PDO($pdconnstring, $argv[2], $argv[3]);
	$db->setAttribute(\PDO::ATTR_ERRMODE, \PDO::ERRMODE_EXCEPTION);
	
	$sql = 'CREATE DATABASE IF NOT EXISTS ' . $argv[4];
	$db->exec($sql);
    
} catch (PDOException $e) {
    fwrite($stderr, "\nMySQL 'CREATE DATABASE' Error: " . $e->getMessage() . "\n");
    exit(1);
}
fwrite($stderr, "\nMySQL Database Created\n");