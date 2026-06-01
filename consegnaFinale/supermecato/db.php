<?php
// Permette l'accesso esterno
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

$servername = "127.0.0.1";
$username = "root";  // Utente predefinito di XAMPP
$password = "";      // Password predefinita di XAMPP
$dbname = "supermacato"; // Nome del database

// Connessione al database
$conn = new mysqli($servername, $username, $password, $dbname);

// Controllo della connessione
if ($conn->connect_error) {
    die("Connessione fallita: " . $conn->connect_error);
}

// Nessun output se la connessione è riuscita
?>
