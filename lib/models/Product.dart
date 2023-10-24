class Product{
  final String name;
  final String category;
  final String imageUrl;
  final double price;

  Product({
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      category: json['category'],
      imageUrl: json['imageUrl'],
      price: json['price'].toDouble(),
    );
  }
}
