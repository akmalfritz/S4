class ItemModel {
  final int id;
  final String name;
  final String description;
  final String category;

  ItemModel({
    required this.id,
    required this.name,
    required this.description,
    this.category = 'Umum',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
    };
  }

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      category: map['category'] ?? 'Umum',
    );
  }
}