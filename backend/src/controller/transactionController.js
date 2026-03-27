import Transaction from '../models/Transaction.js';

export const getTransactions = async (req, res) => {
  try {
    const { category_id } = req.query;
    const transactions = await Transaction.getAll(category_id);
    res.json({ success: true, data: transactions });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

export const createTransaction = async (req, res) => {
  try {
    const { title, amount, category_id, note, transaction_date } = req.body;
    if (!title || !amount || !transaction_date) {
      return res.status(400).json({ success: false, message: 'Title, amount, and transaction_date are required' });
    }
    const newTransaction = await Transaction.create({ title, amount, category_id, note, transaction_date });
    res.status(201).json({ success: true, data: newTransaction });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

export const updateTransaction = async (req, res) => {
  try {
    const { id } = req.params;
    const { title, amount, category_id, note, transaction_date } = req.body;
    if (!title || !amount || !transaction_date) {
      return res.status(400).json({ success: false, message: 'Title, amount, and transaction_date are required' });
    }
    const updated = await Transaction.update(id, { title, amount, category_id, note, transaction_date });
    if (updated) {
      res.json({ success: true, message: 'Transaction updated successfully' });
    } else {
      res.status(404).json({ success: false, message: 'Transaction not found' });
    }
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

export const deleteTransaction = async (req, res) => {
  try {
    const { id } = req.params;
    const deleted = await Transaction.delete(id);
    if (deleted) {
      res.json({ success: true, message: 'Transaction deleted successfully' });
    } else {
      res.status(404).json({ success: false, message: 'Transaction not found' });
    }
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};
