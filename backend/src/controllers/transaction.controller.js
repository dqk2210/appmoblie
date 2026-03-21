const db = require('../config/db');

class TransactionController {
    // 1. Lấy danh sách giao dịch (GET /api/transactions)
    // Hỗ trợ lọc theo query: ?category_id=1 hoặc ?month=10&year=2023
    async getAllTransactions(req, res) {
        try {
            const { category_id, month, year } = req.query;
            
            // Dùng JOIN để lấy luôn tên category (rất cần thiết cho app Flutter sau này render UI)
            let query = `
                SELECT t.*, c.name as category_name, c.type as category_type
                FROM transactions t
                JOIN categories c ON t.category_id = c.id
                WHERE 1 = 1
            `;
            const params = [];

            if (category_id) {
                query += ' AND t.category_id = ?';
                params.push(category_id);
            }

            if (month && year) {
                query += ' AND MONTH(t.transaction_date) = ? AND YEAR(t.transaction_date) = ?';
                params.push(month, year);
            }

            query += ' ORDER BY t.transaction_date DESC, t.created_at DESC';

            const [rows] = await db.execute(query, params);
            res.json({ success: true, count: rows.length, data: rows });
        } catch (error) {
            console.error('Error fetching transactions:', error);
            res.status(500).json({ success: false, message: 'Server error', error: error.message });
        }
    }

    // 2. Thêm mới giao dịch (POST /api/transactions)
    async createTransaction(req, res) {
        try {
            const { title, amount, category_id, note, transaction_date } = req.body;

            // Yêu cầu title, amount, category_id, transaction_date (note có thể để trống)
            if (!title || !amount || !category_id || !transaction_date) {
                return res.status(400).json({ success: false, message: 'Vui lòng điền đủ title, amount, category_id, transaction_date' });
            }

            const query = 'INSERT INTO transactions (title, amount, category_id, note, transaction_date) VALUES (?, ?, ?, ?, ?)';
            const [result] = await db.execute(query, [title, amount, category_id, note || null, transaction_date]);

            res.status(201).json({
                success: true,
                message: 'Thêm giao dịch thành công',
                data: { id: result.insertId, title, amount, category_id, note, transaction_date }
            });
        } catch (error) {
            console.error('Error creating transaction:', error);
            res.status(500).json({ success: false, message: 'Server error', error: error.message });
        }
    }

    // 3. Cập nhật giao dịch (PUT /api/transactions/:id)
    async updateTransaction(req, res) {
        try {
            const { id } = req.params;
            const { title, amount, category_id, note, transaction_date } = req.body;

            const query = `
                UPDATE transactions 
                SET title = COALESCE(?, title),
                    amount = COALESCE(?, amount),
                    category_id = COALESCE(?, category_id),
                    note = COALESCE(?, note),
                    transaction_date = COALESCE(?, transaction_date)
                WHERE id = ?
            `;
            const [result] = await db.execute(query, [title, amount, category_id, note, transaction_date, id]);

            if (result.affectedRows === 0) {
                return res.status(404).json({ success: false, message: 'Không tìm thấy giao dịch' });
            }

            res.json({ success: true, message: 'Cập nhật giao dịch thành công' });
        } catch (error) {
            console.error('Error updating transaction:', error);
            res.status(500).json({ success: false, message: 'Server error', error: error.message });
        }
    }

    // 4. Xóa giao dịch (DELETE /api/transactions/:id)
    async deleteTransaction(req, res) {
        try {
            const { id } = req.params;

            const query = 'DELETE FROM transactions WHERE id = ?';
            const [result] = await db.execute(query, [id]);

            if (result.affectedRows === 0) {
                return res.status(404).json({ success: false, message: 'Không tìm thấy giao dịch' });
            }

            res.json({ success: true, message: 'Xóa giao dịch thành công' });
        } catch (error) {
            console.error('Error deleting transaction:', error);
            res.status(500).json({ success: false, message: 'Server error', error: error.message });
        }
    }
}

module.exports = new TransactionController();
