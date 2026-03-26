const db = require('../config/db');

// Hàm xử lý Đăng nhập
exports.login = async (req, res) => {
    const { username, password } = req.body;

    try {
        const [rows] = await db.execute(
            'SELECT * FROM users WHERE username = ? AND password = ?', 
            [username, password]
        );

        if (rows.length > 0) {
            res.status(200).json({ message: "Đăng nhập thành công!", user: rows[0] });
        } else {
            res.status(401).json({ message: "Sai tài khoản hoặc mật khẩu!" });
        }
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};

// Hàm xử lý Đăng ký
exports.register = (req, res) => {
    const { username, password, email } = req.body;
    const sql = "INSERT INTO users (username, password, email) VALUES (?, ?, ?)";
    
    db.query(sql, [username, password, email], (err, result) => {
        if (err) {
            return res.status(500).json({ success: false, message: "Tên tài khoản đã tồn tại!" });
        }
        res.status(201).json({ success: true, message: "Đăng ký thành công!" });
    });
};