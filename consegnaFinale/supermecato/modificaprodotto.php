<?php
header('Content-Type: application/json; charset=utf-8');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: PUT, PATCH"); // 限制只允许 PUT 或 PATCH 请求
include 'db.php';

if ($_SERVER['REQUEST_METHOD'] === 'PUT' || $_SERVER['REQUEST_METHOD'] === 'PATCH') {
    $data = json_decode(file_get_contents("php://input"), true);

    if(isset($data['id']) && isset($data['nome']) && isset($data['prezzo_originale']) && isset($data['prezzo_scontato']) && isset($data['giorni_scadenza']) && isset($data['categoria_id'])) {
        
        $id = $conn->real_escape_string($data['id']);
        $nome = $conn->real_escape_string($data['nome']);
        $prezzo_orig = $conn->real_escape_string($data['prezzo_originale']);
        $prezzo_scontato = $conn->real_escape_string($data['prezzo_scontato']);
        $giorni = $conn->real_escape_string($data['giorni_scadenza']);
        $categoria = $conn->real_escape_string($data['categoria_id']);

        $sql = "UPDATE prodotti SET 
                    nome='$nome', 
                    prezzo_originale='$prezzo_orig', 
                    prezzo_scontato='$prezzo_scontato', 
                    giorni_scadenza='$giorni', 
                    categoria_id='$categoria' 
                WHERE id='$id'";

        if($conn->query($sql) === TRUE) {
            echo json_encode(["status" => "success", "message" => "Prodotto aggiornato"]);
        } else {
            echo json_encode(["status" => "error", "message" => $conn->error]);
        }
    } else {
        echo json_encode(["status" => "error", "message" => "Dati mancanti"]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Metodo non consentito. Usa PUT o PATCH."]);
}
$conn->close();
?>