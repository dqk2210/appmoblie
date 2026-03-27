import Category from '../models/Category.js';

export const getCategories = async (req, res) => {
  try {
    const { type } = req.query;
    const categories = await Category.getAll(type);
    res.json({ success: true, data: categories });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

export const createCategory = async (req, res) => {
  try {
    const { name, type } = req.body;
    if (!name || !type) {
      return res.status(400).json({ success: false, message: 'Name and type are required' });
    }
    const newCategory = await Category.create(name, type);
    res.status(201).json({ success: true, data: newCategory });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

export const updateCategory = async (req, res) => {
  try {
    const { id } = req.params;
    const { name } = req.body;
    if (!name) {
      return res.status(400).json({ success: false, message: 'Name is required' });
    }
    const updated = await Category.update(id, name);
    if (updated) {
      res.json({ success: true, message: 'Category updated successfully' });
    } else {
      res.status(404).json({ success: false, message: 'Category not found' });
    }
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

export const deleteCategory = async (req, res) => {
  try {
    const { id } = req.params;
    const deleted = await Category.delete(id);
    if (deleted) {
      res.json({ success: true, message: 'Category deleted successfully' });
    } else {
      res.status(404).json({ success: false, message: 'Category not found' });
    }
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};
