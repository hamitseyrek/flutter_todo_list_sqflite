class Category {
  int? id;
  String? name;

  Category({required this.name});
  Category.withID({required this.id, required this.name});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['name'] = name;
    return map;
  }

  Category.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.name = map['name'];
  }

  @override
  String toString() {
    return 'Kategori {kategoriId: $id, kategoriBaslik: $name}';
  }
}
