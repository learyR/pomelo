/// 商品模型
class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final String imageUrl;
  final List<String> imageUrls;
  final int stock;
  final String categoryId;
  final String categoryName;
  final double? rating;
  final int? salesCount;
  final Map<String, dynamic>? attributes;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.imageUrl,
    this.imageUrls = const [],
    required this.stock,
    required this.categoryId,
    required this.categoryName,
    this.rating,
    this.salesCount,
    this.attributes,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      originalPrice: json['originalPrice']?.toDouble(),
      imageUrl: json['imageUrl'] ?? '',
      imageUrls:
          json['imageUrls'] != null ? List<String>.from(json['imageUrls']) : [],
      stock: json['stock'] ?? 0,
      categoryId: json['categoryId']?.toString() ?? '',
      categoryName: json['categoryName'] ?? '',
      rating: json['rating']?.toDouble(),
      salesCount: json['salesCount'],
      attributes: json['attributes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'originalPrice': originalPrice,
      'imageUrl': imageUrl,
      'imageUrls': imageUrls,
      'stock': stock,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'rating': rating,
      'salesCount': salesCount,
      'attributes': attributes,
    };
  }

  /// 是否有折扣
  bool get hasDiscount => originalPrice != null && originalPrice! > price;

  /// 折扣率
  double get discountRate {
    if (!hasDiscount) return 0;
    return ((originalPrice! - price) / originalPrice!) * 100;
  }
}
