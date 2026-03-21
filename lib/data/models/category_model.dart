class CategoryModel {
  int? id;
  String? name;
  String? type;
  String? createdAt;

  CategoryModel({
    this.id,
    this.name,
    this.type,
    this.createdAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'created_at': createdAt,
    };
  }
}
