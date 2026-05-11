<?php
// 告诉浏览器，我接下来要输出的是 JSON 格式的数据
header('Content-Type: application/json; charset=utf-8');

// 引入刚才写的数据库连接文件
include 'db.php';

// 写 SQL 查询语句：去 prodotti 表里把所有东西都拿出来
$sql = "SELECT * FROM prodotti";
$result = $conn->query($sql);

$lista_prodotti = array(); // 准备一个空数组，用来装商品

if ($result->num_rows > 0) {
    // 如果找到了数据，就一行一行地塞进数组里
    while($row = $result->fetch_assoc()) {
        $lista_prodotti[] = $row;
    }
}

// 把 PHP 的数组转换成通用的 JSON 格式，并输出在屏幕上
echo json_encode($lista_prodotti);

// 关闭数据库连接
$conn->close();
?>