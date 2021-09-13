class Note {
  int? id;
  int? categoryId;
  String? categoryName;
  String? title;
  String? description;
  String? date;
  int? priority;

  Note(this.categoryId, this.title, this.description, this.date,
      this.priority); //verileri yazarken

  Note.withID(this.id, this.categoryId, this.title, this.description, this.date,
      this.priority); //verileri okurken

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['categoryId'] = categoryId;
    map['title'] = title;
    map['description'] = description;
    map['date'] = date;
    map['priority'] = priority;

    return map;
  }

  Note.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.categoryId = map['categoryId'];
    this.categoryName = map['categoryName'];
    this.title = map['title'];
    this.description = map['description'];
    this.date = map['date'];
    this.priority = map['priority'];
  }

  @override
  String toString() {
    return 'Not{id: $id, kategoriID: $categoryId, notBaslik: $title, notIcerik: $description, notTarih: $date, notOncelik: $priority}';
  }
}
