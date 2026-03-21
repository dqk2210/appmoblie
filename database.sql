-- Tạo cơ sở dữ liệu nếu chưa có
CREATE DATABASE IF NOT EXISTS expense_tracker;
USE expense_tracker;

-- 1. Bảng Categories (Danh mục)
CREATE TABLE IF NOT EXISTS categories (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  type ENUM('INCOME', 'EXPENSE') NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Bảng Transactions (Giao dịch)
CREATE TABLE IF NOT EXISTS transactions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  amount DECIMAL(15,2) NOT NULL,
  category_id INT NOT NULL,
  note TEXT,
  transaction_date DATE NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE RESTRICT
);

-- Thêm một số dữ liệu mẫu (Seeder)
INSERT INTO categories (name, type) VALUES 
('Tiền lương', 'INCOME'),
('Thưởng', 'INCOME'),
('Ăn uống', 'EXPENSE'),
('Mua sắm', 'EXPENSE'),
('Di chuyển', 'EXPENSE');

USE expense_tracker;

expense_trackerexpense_tracker
