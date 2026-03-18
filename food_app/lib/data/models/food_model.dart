class FoodModel {
  final int id;
  final int categoryId;
  final String name;
  final String slug;
  final String? description;
  final double price;
  final String? image;
  final double rating;
  final int reviews;
  final int? prepTime;
  final int? calories;
  final double? protein;
  final double? carbs;
  final double? fat;
  final bool isAvailable;
  final String? categoryName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  FoodModel({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.slug,
    this.description,
    required this.price,
    this.image,
    required this.rating,
    required this.reviews,
    this.prepTime,
    this.calories,
    this.protein,
    this.carbs,
    this.fat,
    required this.isAvailable,
    this.categoryName,
    this.createdAt,
    this.updatedAt,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      categoryId: json['category_id'] is int ? json['category_id'] : int.parse(json['category_id'].toString()),
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'],
      price: json['price'] is double ? json['price'] : double.parse(json['price'].toString()),
      image: json['image'],
      rating: json['rating'] is double ? json['rating'] : double.parse(json['rating'].toString()),
      reviews: json['reviews'] is int ? json['reviews'] : int.parse(json['reviews'].toString()),
      prepTime: json['prep_time'],
      calories: json['calories'],
      protein: json['protein'] != null ? (json['protein'] is double ? json['protein'] : double.parse(json['protein'].toString())) : null,
      carbs: json['carbs'] != null ? (json['carbs'] is double ? json['carbs'] : double.parse(json['carbs'].toString())) : null,
      fat: json['fat'] != null ? (json['fat'] is double ? json['fat'] : double.parse(json['fat'].toString())) : null,
      isAvailable: json['is_available'] == 1 || json['is_available'] == true,
      categoryName: json['category']?['name'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'name': name,
      'slug': slug,
      'description': description,
      'price': price,
      'image': image,
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

  // Helper getters for UI
  String get imageUrl => image ?? 'https://via.placeholder.com/300?text=${Uri.encodeComponent(name)}';
  String get category => categoryName ?? 'Food';
  String get priceFormatted => '\$${price.toStringAsFixed(2)}';
  String get ratingFormatted => rating.toStringAsFixed(1);
}
