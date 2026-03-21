const express = require('express');
const router = express.Router();
const transactionController = require('../controllers/transaction.controller');

// Lấy danh sách giao dịch (GET /api/transactions)
router.get('/', transactionController.getAllTransactions);

// Thêm giao dịch mới (POST /api/transactions)
router.post('/', transactionController.createTransaction);

// Cập nhật giao dịch (PUT /api/transactions/:id)
router.put('/:id', transactionController.updateTransaction);

// Xóa giao dịch (DELETE /api/transactions/:id)
router.delete('/:id', transactionController.deleteTransaction);

module.exports = router;
