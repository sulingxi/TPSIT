<?php
header('Content-Type: application/json; charset=utf-8');
header("Access-Control-Allow-Origin: *");
include 'db.php';

// 接收 Flutter 发送过来的 JSON 数据 (Riceve i dati JSON in formato array)
$data = json_decode(file_get_contents("php://input"), true);

// 检查所有必要的数据是否都传过来了，包含 prezzo_originale (Controllo dati)
if(isset($data['nome']) && isset($data['prezzo_originale']) && isset($data['prezzo_scontato']) && isset($data['giorni_scadenza']) && isset($data['categoria_id'])) {
    
    // 清理数据，防止 SQL 注入攻击 (Sicurezza)
    $nome = $conn->real_escape_string($data['nome']);
    $prezzo_orig = $conn->real_escape_string($data['prezzo_originale']); // 接收原价
    $prezzo_scontato = $conn->real_escape_string($data['prezzo_scontato']);
    $giorni = $conn->real_escape_string($data['giorni_scadenza']);
    $categoria = $conn->real_escape_string($data['categoria_id']);

    // 写入数据库的 SQL 指令，加入 prezzo_originale (Query SQL aggiornata)
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