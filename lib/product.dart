class Product {
  int? id;
  late String name; // Use 'late' to indicate that 'name' will be initialized before use
  late double price;

  Product({required this.name, required this.price});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }

  Product.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'] ?? ""; // Use a default value if 'name' is null
    price = map['price']?.toDouble() ?? 0.0; // Use a default value if 'price' is null
    id ??= -1;
  }
}
