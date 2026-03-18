import '../../models/food_item.dart';

class CartModel {
  final String id;
  final String userId;
  final List<CartItemModel> items;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CartModel({
    required this.id,
    required this.userId,
    this.items = const [],
    this.createdAt,
    this.updatedAt,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'].toString(),
      userId: json['user_id'].toString(),
      items: json['items'] != null
          ? (json['items'] as List)
              .map((item) => CartItemModel.fromJson(item))
              .toList()
          : [],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  double get total {
    return items.fold(0, (sum, item) => sum + item.totalPrice);
  }

  int get itemCount {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }
}

class CartItemModel {
  final String id;
  final String cartId;
  final String foodId;
  final int quantity;
  final double price;
  final FoodItem? food;

  CartItemModel({
    required this.id,
    required this.cartId,
    required this.foodId,
    required this.quantity,
    required this.price,
    this.food,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'].toString(),
      cartId: json['cart_id'].toString(),
      foodId: json['food_id'].toString(),
      quantity: int.parse(json['quantity'].toString()),
      price: double.parse(json['price'].toString()),
      food: json['food'] != null ? FoodItem.fromJson(json['food']) : null,
    );
  }

  double get totalPrice => price * quantity;
}
