<?php
header('Content-Type: application/json; charset=utf-8');
header("Access-Control-Allow-Origin: *");

include 'db.php';

// Riceve i dati JSON
$data = json_decode(file_get_contents("php://input"), true);

// Controllo dei dati
if(isset($data['nome']) && isset($data['prezzo_originale']) && isset($data['prezzo_scontato']) && isset($data['giorni_scadenza']) && isset($data['categoria_id'])) {
    
    // Sicurezza
    $nome = $conn->real_escape_string($data['nome']);
    $prezzo_orig = $conn->real_escape_string($data['prezzo_originale']); // Prezzo originale
    $prezzo_scontato = $conn->real_escape_string($data['prezzo_scontato']);
    $giorni = $conn->real_escape_string($data['giorni_scadenza']);
    $categoria = $conn->real_escape_string($data['categoria_id']);

    // Query SQL
    $sql = "INSERT INTO prodotti (nome, prezzo_originale, prezzo_scontato, giorni_scadenza, categoria_id) 
            VALUES ('$nome', '$prezzo_orig', '$prezzo_scontato', '$giorni', '$categoria')";

    if($conn->query($sql) === TRUE) {
        echo json_encode(["status" => "success", "message" => "Prodotto aggiunto"]);
    } else {
        echo json_encode(["status" => "error", "message" => $conn->error]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Dati mancanti"]);
}

$conn->close();
?>
