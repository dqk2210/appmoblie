class TransactionModel {
  int? id;
  String? title;
  double? amount;
  int? categoryId;
  String? note;
  String? transactionDate;
  String? createdAt;
  
  // Các field Join với bảng Categories (rất cần thiết để render UI)
  String? categoryName;
  String? categoryType;

  TransactionModel({
    this.id,
    this.title,
    this.amount,
    this.categoryId,
    this.note,
    this.transactionDate,
    this.createdAt,
    this.categoryName,
    this.categoryType,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      title: json['title'],
      // MYSQL Node.js trả DECIMAL thường dưới dạng chuỗi (String) nên cần ép về double
      amount: json['amount'] != null ? double.parse(json['amount'].toString()) : null,
      categoryId: json['category_id'],
      note: json['note'],
      // Convert String format (2023-10-25T00:00:00.000Z) sang YYYY-MM-DD
      transactionDate: json['transaction_date']?.toString().split('T')[0],
      createdAt: json['created_at'],
      categoryName: json['category_name'],
      categoryType: json['category_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'category_id': categoryId,
      'note': note,
      'transaction_date': transactionDate,
      'created_at': createdAt,
      'category_name': categoryName,
      'category_type': categoryType,
    };
  }
}
