class Category {
  String id;
  String name;
  String description;
  String image;

  Category({
    this.id,
    this.name,
    this.description,
    this.image
  });

  Category.fromMap(Map data, String docId) {
    this.id = docId;
    this.name = data['name'];
    this.description = data['description'];
    this.image = data['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.id != null) {
      data['id'] = this.id;
    }

    data['name'] = this.name;
    data['description'] = this.description;
    data['image'] = this.image;
    
    return data;
  }
}