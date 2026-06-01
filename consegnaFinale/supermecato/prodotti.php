<?php
// Output JSON data
header('Content-Type: application/json; charset=utf-8');

// Database connection file
include 'db.php';

// SQL query: get all products
$sql = "SELECT * FROM prodotti";
$result = $conn->query($sql);

$lista_prodotti = array(); // Array to store results

if ($result->num_rows > 0) {

    // Read data row by row
    while($row = $result->fetch_assoc()) {
        $lista_prodotti[] = $row;
    }
}

// Convert to JSON and output
echo json_encode($lista_prodotti);

// Close database connection
$conn->close();
?>
