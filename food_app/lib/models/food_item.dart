import '../config/api_config.dart';

class FoodItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final String? categoryId;
  final double rating;
  final int reviews;
  final String prepTime;
  final int calories;
  final String protein;
  final String carbs;
  final String fat;
  final bool isAvailable;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.categoryId,
    required this.rating,
    required this.reviews,
    required this.prepTime,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.isAvailable = true,
    this.createdAt,
    this.updatedAt,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    String? img = json['image']?.toString();
    String parsedImageUrl;
    if (img == null || img.isEmpty) {
      parsedImageUrl = 'https://via.placeholder.com/300?text=${Uri.encodeComponent(json['name']?.toString() ?? 'Food')}';
    } else if (img.startsWith('http')) {
      parsedImageUrl = ApiConfig.resolveImageUrl(img);
    } else {
      String cleanImg = img;
      if (cleanImg.startsWith('/storage/')) cleanImg = cleanImg.replaceFirst('/storage/', '');
      if (cleanImg.startsWith('storage/')) cleanImg = cleanImg.replaceFirst('storage/', '');
      if (cleanImg.startsWith('/')) cleanImg = cleanImg.substring(1);
      parsedImageUrl = '${ApiConfig.storageUrl}/$cleanImg';
    }

    return FoodItem(
      id: json['id'].toString(),
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: double.tryParse(json['price']?.toString() ?? '') ?? 0,
      imageUrl: parsedImageUrl,
      category: json['category'] is Map<String, dynamic>
          ? (json['category']['name']?.toString() ?? 'Food')
          : (json['category_name']?.toString() ?? 'Food'),
      categoryId: json['category_id']?.toString(),
      rating: double.tryParse(json['rating']?.toString() ?? '') ?? 0,
      reviews: int.tryParse(json['reviews']?.toString() ?? '') ?? 0,
      prepTime: json['prep_time']?.toString() ?? '15-20 min',
      calories: int.tryParse(json['calories']?.toString() ?? '') ?? 0,
      protein: json['protein']?.toString() ?? '0g',
      carbs: json['carbs']?.toString() ?? '0g',
      fat: json['fat']?.toString() ?? '0g',
      isAvailable: json['is_available'] == 1 || json['is_available'] == true,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image': imageUrl,
      'category_id': categoryId,
      'rating': rating,
      'reviews': reviews,
      'prep_time': prepTime,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'is_available': isAvailable,
    };
  }
}

class CartItem {
  final FoodItem food;
  final String? remoteItemId;
  int quantity;

  CartItem({required this.food, this.quantity = 1, this.remoteItemId});

  double get totalPrice => food.price * quantity;
}
