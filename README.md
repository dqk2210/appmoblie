# 💰 Clevia - Ứng dụng Quản lý Thống kê Chi tiêu (Nhóm 31)

Đây là kho lưu trữ mã nguồn cho Đồ án Cuối kỳ môn **Lập trình Thiết bị Di động** - Ứng dụng Quản lý Thu - Chi cá nhân toàn diện, trực quan với phân tích dữ liệu mở rộng.

---

## 🏗 Cấu trúc Công nghệ (Stack)

Dự án phát triển theo mô hình Client-Server hiện đại:
- **Ngôn ngữ Mobile (Frontend):** Flutter & Dart
- **Quản lý Trạng thái:** GetX (Cấu trúc thư mục theo Feature/MVC)
- **Ngôn ngữ Web Server (Backend):** Node.js & Express.js
- **Hệ cơ sở quản trị dữ liệu:** MySQL (sử dụng thư viện \`mysql2\`)
- **API Communication RESTful:** Dio (bên Flutter) 

---

## ✨ Các tính năng nổi bật (MVP)

1. **Bảng Điều khiển Tổng (Dashboard):** Xem nhanh Tổng Số Dư, Tổng Thu Nhập và Tổng Chi Phí. Lịch sử giao dịch gần nhất hiện chi tiết ở trang chủ.
2. **Ghi chép Giao dịch (Add Transaction):** Giao diện thả xuống (Dropdown) mượt mà lấy trực tiếp từ API danh mục, kèm bộ lọc ngày DatePicker tự động ngăn chặn chọn ngày tương lai.
3. **Thống kê Trực quan (Statistics):** Báo cáo Dòng tiền Cơ cấu Thu-Chi thông qua Biểu đồ Tròn Sinh động (**PieChart** bằng `fl_chart`), tự động tính toán tỷ trọng phần trăm (%) và phân loại màu sắc linh hoạt.

---

## 📂 Tổ chức Thư mục

\`\`\`
nhom31_doancuoiky_thongkechitieu/
├── backend/                  # Chứa toàn bộ API Node.js và File cấu hình
│   ├── src/
│   │   ├── config/db.js      # Cấu hình Pool kết nối MySQL sử dụng utf8mb4
│   │   ├── controllers/      # Hàm xử lý Logic cho Giao dịch & Danh mục
│   │   ├── routes/           # Định tuyến API (GET/POST/PUT/DELETE)
│   │   └── server.js         # Entry point chạy Server
│   ├── .env                  # Tệp cấu hình biến môi trường ẩn
│   ├── database.sql          # File Dump khởi tạo CSDL
│   └── package.json
│
├── lib/                      # Phần Giao diện Ứng dụng Flutter
│   ├── core/
│   │   ├── constants/        # Biến môi trường (Màu sắc, API Endpoints)
│   │   └── utils/            # Công cụ fomat tiền tệ, format ngày tháng
│   ├── data/
│   │   ├── models/           # CategoryModel, TransactionModel
│   │   └── services/         # config Dio HttpClient
│   └── screens/
│       ├── dashboard/        # Màn hình Trang chủ
│       ├── statistics/       # Màn hình thống kê biểu đồ
│       └── transactions/     # Giao diện Form thêm nhập dữ liệu
└── pubspec.yaml              # Quản lý Package giao diện
\`\`\`

---

## 🚀 Hướng dấn Cài đặt và Chạy dự án (How to run)

### Bước 1: Khởi động Cơ sở dữ liệu (Database MySQL)
1. Mở **MySQL Workbench** hoặc XAMPP (phpMyAdmin).
2. Mở file \`backend/database.sql\` và bôi đen toàn bộ lệnh -> Run để tạo Structure và Data gốc.
3. Mở file \`backend/.env\` và sửa các tham số \`DB_PASS=...\` tuỳ theo mật khẩu máy tính của bạn.

### Bước 2: Chạy Backend Node.js
Mở Terminal, trỏ vào thư mục \`backend\`:
\`\`\`bash
cd backend
npm install
npm run dev
\`\`\`
*Server sẽ chay tại cổng \`http://localhost:3000\`*

### Bước 3: Build Ứng dụng Flutter
Mở một Terminal khác ở thư mục gốc của dự án:
\`\`\`bash
flutter clean
flutter pub get
flutter run
\`\`\`

> **Lưu ý Quan Trọng Về Gỡ lỗi LAN:** 
- Nếu bạn chạy **Máy Ảo (Emulator Android Studio)**: Để IP trong file \`lib/core/constants/api_endpoints.dart\` là \`10.0.2.2\`.
- Nếu tải qua **Điện Thoại Thật (Cắm cáp USB)**: Đổi IP trong \`api_endpoints.dart\` sang địa chỉ IPv4 máy tính của bạn (VD: \`192.168.1.xxx\`).

---

**© Bản quyền thuộc về Nhóm 31 - Đồ án Thực Hành Hàng Đỉnh! 🎓**
