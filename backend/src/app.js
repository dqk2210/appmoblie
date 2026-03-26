const express = require('express');
const cors = require('cors');
require('dotenv').config();

const categoryRoutes = require('./routes/category.routes');
const transactionRoutes = require('./routes/transaction.routes');
// Khai báo route cho phần xác thực (Login)
const authRoutes = require('./routes/authRoutes');

const app = express();

// Middleware
app.use(cors());
app.use(express.json()); // Giúp server đọc được JSON từ client gửi lên

// Gắn Routers
app.use('/api/categories', categoryRoutes);
app.use('/api/transactions', transactionRoutes);
// Gắn đường dẫn cho Login
app.use('/api/auth', authRoutes);

// Route Test
app.get('/', (req, res) => {
    res.json({ message: 'Welcome to Finance Tracker API' });
});

// Khởi chạy server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`🚀 Server is running on port ${PORT}`);
});
