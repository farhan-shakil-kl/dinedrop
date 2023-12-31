class Food {
  String description;
  String discount;
  String image;
  String menuId;
  String name;
  String price;
  String rating;
  String id;
  String quantity;
  String keys;

  Food(
      {this.description,
      this.discount,
      this.image,
      this.menuId,
      this.name,
      this.price,
      this.rating,
      this.id,
      this.quantity,
      this.keys});

  Map toMap(Food food) {
    var data = Map<String, dynamic>();
    data['description'] = food.description;
    data['discount'] = food.discount;
    data['image'] = food.image;
    data['menuId'] = food.menuId;
    data['name'] = food.name;
    data['price'] = food.price;
    data['rating'] = food.discount;
    data['id'] = food.id;
    data['quantity'] = food.menuId;
    // data['quantity'] = food.quantity;
    data['keys'] = food.keys;
    return data;
  }

  Food.fromMap(Map<dynamic, dynamic> mapData) {
    this.description = mapData['description'];
    this.discount = mapData['discount'];
    this.image = mapData['image'];
    this.menuId = mapData['menuId'];
    this.name = mapData['name'];
    this.price = mapData['price'];
    this.rating = mapData['rating'];
    this.id = mapData['id'];
    this.quantity = mapData['quantity'];
    this.keys = mapData['keys'];
  }
}
