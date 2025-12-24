import 'product_model.dart';

/// 购物车商品模型
class CartItemModel {
  final String id;
  final ProductModel product;
  final int quantity;
  final DateTime addedAt;

  CartItemModel({
    required this.id,
    required this.product,
    required this.quantity,
    required this.addedAt,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id']?.toString() ?? '',
      product: ProductModel.fromJson(json['product']),
      quantity: json['quantity'] ?? 1,
      addedAt: json['addedAt'] != null
          ? DateTime.parse(json['addedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product.toJson(),
      'quantity': quantity,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  /// 小计金额
  double get subtotal => product.price * quantity;

  CartItemModel copyWith({
    String? id,
    ProductModel? product,
    int? quantity,
    DateTime? addedAt,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      addedAt: addedAt ?? this.addedAt,
    );
  }
}
