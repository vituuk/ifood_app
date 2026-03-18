class OrderModel {
  final String id;
  final String userId;
  final String orderNumber;
  final String? addressId;
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double total;
  final String status;
  final String? deliveryNotes;
  final List<OrderItemModel> items;
  final PaymentModel? payment;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.orderNumber,
    this.addressId,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
    required this.total,
    required this.status,
    this.deliveryNotes,
    this.items = const [],
    this.payment,
    this.createdAt,
    this.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'].toString(),
      userId: json['user_id'].toString(),
      orderNumber: json['order_number'] ?? '',
      addressId: json['address_id']?.toString(),
      subtotal: double.parse(json['subtotal']?.toString() ?? '0'),
      deliveryFee: double.parse(json['delivery_fee']?.toString() ?? '0'),
      tax: double.parse(json['tax']?.toString() ?? '0'),
      total: double.parse(json['total']?.toString() ?? '0'),
      status: json['status'] ?? 'pending',
      deliveryNotes: json['delivery_notes'],
      items: json['items'] != null
          ? (json['items'] as List)
              .map((item) => OrderItemModel.fromJson(item))
              .toList()
          : [],
      payment: json['payment'] != null
          ? PaymentModel.fromJson(json['payment'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'order_number': orderNumber,
      'address_id': addressId,
      'subtotal': subtotal,
      'delivery_fee': deliveryFee,
      'tax': tax,
      'total': total,
      'status': status,
      'delivery_notes': deliveryNotes,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class OrderItemModel {
  final String id;
  final String orderId;
  final String foodId;
  final int quantity;
  final double price;
  final dynamic food; // Can be FoodItem or Map

  OrderItemModel({
    required this.id,
    required this.orderId,
    required this.foodId,
    required this.quantity,
    required this.price,
    this.food,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'].toString(),
      orderId: json['order_id'].toString(),
      foodId: json['food_id'].toString(),
      quantity: int.parse(json['quantity'].toString()),
      price: double.parse(json['price'].toString()),
      food: json['food'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'food_id': foodId,
      'quantity': quantity,
      'price': price,
    };
  }

  double get totalPrice => price * quantity;

  String get foodName {
    if (food is Map) {
      return food['name'] ?? '';
    }
    return '';
  }

  String? get foodImage {
    if (food is Map) {
      return food['image'];
    }
    return null;
  }
}

class PaymentModel {
  final String id;
  final String orderId;
  final String userId;
  final double amount;
  final String paymentMethod;
  final String status;
  final String? transactionId;

  PaymentModel({
    required this.id,
    required this.orderId,
    required this.userId,
    required this.amount,
    required this.paymentMethod,
    required this.status,
    this.transactionId,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'].toString(),
      orderId: json['order_id'].toString(),
      userId: json['user_id'].toString(),
      amount: double.parse(json['amount'].toString()),
      paymentMethod: json['payment_method'] ?? '',
      status: json['status'] ?? 'pending',
      transactionId: json['transaction_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'user_id': userId,
      'amount': amount,
      'payment_method': paymentMethod,
      'status': status,
      'transaction_id': transactionId,
    };
  }
}
