<?php
header('Content-Type: application/json; charset=utf-8');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: DELETE"); // Solo richieste DELETE

include 'db.php';

// Controllo del metodo
if ($_SERVER['REQUEST_METHOD'] === 'DELETE') {

    // Controllo ID
    $id = isset($_GET['id']) ? $conn->real_escape_string($_GET['id']) : '';

    if ($id != '') {

        // Query SQL per eliminare il prodotto
        $sql = "DELETE FROM prodotti WHERE id='$id'";

        if($conn->query($sql) === TRUE) {
            echo json_encode(["status" => "success", "message" => "Prodotto eliminato"]);
        } else {
            echo json_encode(["status" => "error", "message" => $conn->error]);
        }

    } else {
        echo json_encode(["status" => "error", "message" => "ID mancante"]);
    }

} else {

    // Metodo non consentito
    echo json_encode(["status" => "error", "message" => "Metodo non consentito. Usa DELETE."]);
}

$conn->close();
?>
