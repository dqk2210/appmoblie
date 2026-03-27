import pool from '../configs/db.js';

class Category {
  static async getAll(type) {
    let query = 'SELECT * FROM categories';
    const params = [];
    if (type) {
      query += ' WHERE type = ?';
      params.push(type);
    }
    const [rows] = await pool.query(query, params);
    return rows;
  }

  static async create(name, type) {
    const [result] = await pool.query('INSERT INTO categories (name, type) VALUES (?, ?)', [name, type]);
    return { id: result.insertId, name, type };
  }

  static async update(id, name) {
    const [result] = await pool.query('UPDATE categories SET name = ? WHERE id = ?', [name, id]);
    return result.affectedRows > 0;
  }

  static async delete(id) {
    const [result] = await pool.query('DELETE FROM categories WHERE id = ?', [id]);
    return result.affectedRows > 0;
  }
}

export default Category;
