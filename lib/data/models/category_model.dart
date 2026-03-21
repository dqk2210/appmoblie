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

  // Override operator == đê DropdownButton Flutter nhận diện đúng Category
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CategoryModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
