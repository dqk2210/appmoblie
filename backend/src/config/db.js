const mysql = require('mysql2');
require('dotenv').config();

// Tạo connection pool để xử lý nhiều requests một túc (tối ưu hơn createConnection)
const pool = mysql.createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASS,
    database: process.env.DB_NAME,
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});

const promisePool = pool.promise();

// Cố gắng kết nối để kiểm tra ngay khi khởi động
promisePool.getConnection()
    .then(connection => {
        console.log('✅ Connected to MySQL Database successfully!');
        connection.release();
    })
    .catch(err => {
        console.error('❌ Could not connect to MySQL Database:', err.message);
    });

module.exports = promisePool;
