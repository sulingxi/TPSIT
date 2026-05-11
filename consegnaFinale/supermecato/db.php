<?php
// 允许外部访问 (解决未来 Flutter 连不上服务器的问题)
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

$servername = "127.0.0.1";
$username = "root";  // XAMPP 默认用户名是 root
$password = "";      // XAMPP 默认密码是空的
$dbname = "supermacato"; // 注意：这里必须和你截图里建的数据库名字一模一样！

// 创建连接
$conn = new mysqli($servername, $username, $password, $dbname);

// 检查连接是否成功
if ($conn->connect_error) {
    die("Connessione fallita (连接失败): " . $conn->connect_error);
}

// 成功的话什么都不输出，保持安静
?>