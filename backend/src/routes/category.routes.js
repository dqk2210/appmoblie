const express = require('express');
const router = express.Router();
const categoryController = require('../controllers/category.controller');

// Lấy danh sách danh mục (GET /api/categories)
router.get('/', categoryController.getAllCategories);

// Thêm danh mục mới (POST /api/categories)
router.post('/', categoryController.createCategory);

// Cập nhật danh mục (PUT /api/categories/:id)
router.put('/:id', categoryController.updateCategory);

// Xóa danh mục (DELETE /api/categories/:id)
router.delete('/:id', categoryController.deleteCategory);

module.exports = router;
