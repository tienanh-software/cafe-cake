<?php
class DB {
    protected $conn;
    
    public function __construct() {
        $host = "localhost";
        $port = "3306"; 
        $dbname = "restaurant_db";
        $username = "root";
        $password = "013234656798ntaA@"; 

        try {
            $this->conn = new PDO("mysql:host=$host;port=$port;dbname=$dbname;charset=utf8", $username, $password);
            $this->conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        } catch (PDOException $e) {
            die("<h3 style='color:red; text-align:center;'>Lỗi kết nối cơ sở dữ liệu: " . $e->getMessage() . "</h3>");
        }
    }
}
?>