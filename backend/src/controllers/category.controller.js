const db = require('../config/db');

class CategoryController {
    // 1. Lấy danh sách danh mục (GET /api/categories)
    // Có thể truyền thêm query ?type=INCOME hoặc ?type=EXPENSE để lọc
    async getAllCategories(req, res) {
        try {
            const { type } = req.query;
            let query = 'SELECT * FROM categories';
            const params = [];

            if (type) {
                query += ' WHERE type = ?';
                params.push(type.toUpperCase());
            }

            query += ' ORDER BY created_at DESC';

            const [rows] = await db.execute(query, params);
            res.json({ success: true, count: rows.length, data: rows });
        } catch (error) {
            console.error('Error fetching categories:', error);
            res.status(500).json({ success: false, message: 'Server error', error: error.message });
        }
    }

    // 2. Thêm mới danh mục (POST /api/categories)
    async createCategory(req, res) {
        try {
            const { name, type } = req.body;

            // Validate dữ liệu
            if (!name || !type) {
                return res.status(400).json({ success: false, message: 'Vui lòng cung cấp name và type (INCOME/EXPENSE)' });
            }

            const query = 'INSERT INTO categories (name, type) VALUES (?, ?)';
            const [result] = await db.execute(query, [name, type.toUpperCase()]);

            res.status(201).json({
                success: true,
                message: 'Tạo danh mục thành công',
                data: { id: result.insertId, name, type }
            });
        } catch (error) {
            console.error('Error creating category:', error);
            res.status(500).json({ success: false, message: 'Server error', error: error.message });
        }
    }

    // 3. Sửa danh mục (PUT /api/categories/:id)
    async updateCategory(req, res) {
        try {
            const { id } = req.params;
            const { name, type } = req.body;

            const query = 'UPDATE categories SET name = COALESCE(?, name), type = COALESCE(?, type) WHERE id = ?';
            const [result] = await db.execute(query, [name, type ? type.toUpperCase() : null, id]);

            if (result.affectedRows === 0) {
                return res.status(404).json({ success: false, message: 'Không tìm thấy danh mục' });
            }

            res.json({ success: true, message: 'Cập nhật danh mục thành công' });
        } catch (error) {
            console.error('Error updating category:', error);
            res.status(500).json({ success: false, message: 'Server error', error: error.message });
        }
    }

    // 4. Xóa danh mục (DELETE /api/categories/:id)
    async deleteCategory(req, res) {
        try {
            const { id } = req.params;

            // Kiểm tra xem danh mục có đang được sử dụng trong giao dịch nào không (Khóa ngoại)
            const checkQuery = 'SELECT COUNT(*) as count FROM transactions WHERE category_id = ?';
            const [checkRows] = await db.execute(checkQuery, [id]);
            
            if (checkRows[0].count > 0) {
                return res.status(400).json({ 
                    success: false, 
                    message: 'Không thể xóa danh mục này vì đang chứa giao dịch. Hãy xóa/sửa giao dịch trước.' 
                });
            }

            const query = 'DELETE FROM categories WHERE id = ?';
            const [result] = await db.execute(query, [id]);

            if (result.affectedRows === 0) {
                return res.status(404).json({ success: false, message: 'Không tìm thấy danh mục' });
            }

            res.json({ success: true, message: 'Xóa danh mục thành công' });
        } catch (error) {
            console.error('Error deleting category:', error);
            res.status(500).json({ success: false, message: 'Server error', error: error.message });
        }
    }
}

module.exports = new CategoryController();
