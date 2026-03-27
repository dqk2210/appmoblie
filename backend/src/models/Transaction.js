import pool from '../configs/db.js';

class Transaction {
  static async getAll(categoryId) {
    let query = `
      SELECT t.*, c.name AS category_name, c.type AS category_type 
      FROM transactions t 
      LEFT JOIN categories c ON t.category_id = c.id
    `;
    const params = [];
    if (categoryId) {
      query += ' WHERE t.category_id = ?';
      params.push(categoryId);
    }
    query += ' ORDER BY t.transaction_date DESC, t.created_at DESC';
    const [rows] = await pool.query(query, params);
    return rows;
  }

  static async create(data) {
    const { title, amount, category_id, note, transaction_date } = data;
    const [result] = await pool.query(
      'INSERT INTO transactions (title, amount, category_id, note, transaction_date) VALUES (?, ?, ?, ?, ?)',
      [title, amount, category_id, note, transaction_date]
    );
    return { id: result.insertId, ...data };
  }

  static async update(id, data) {
    const { title, amount, category_id, note, transaction_date } = data;
    const [result] = await pool.query(
      'UPDATE transactions SET title = ?, amount = ?, category_id = ?, note = ?, transaction_date = ? WHERE id = ?',
      [title, amount, category_id, note, transaction_date, id]
    );
    return result.affectedRows > 0;
  }

  static async delete(id) {
    const [result] = await pool.query('DELETE FROM transactions WHERE id = ?', [id]);
    return result.affectedRows > 0;
  }
}

export default Transaction;
