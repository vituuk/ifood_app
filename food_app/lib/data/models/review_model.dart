import 'user_model.dart';

class ReviewModel {
  final String id;
  final String userId;
  final String foodId;
  final String orderId;
  final int rating;
  final String? comment;
  final UserModel? user;
  final DateTime? createdAt;

  ReviewModel({
    required this.id,
    required this.userId,
    required this.foodId,
    required this.orderId,
    required this.rating,
    this.comment,
    this.user,
    this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'].toString(),
      userId: json['user_id'].toString(),
      foodId: json['food_id'].toString(),
      orderId: json['order_id'].toString(),
      rating: int.parse(json['rating'].toString()),
      comment: json['comment'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'food_id': foodId,
      'order_id': orderId,
      'rating': rating,
      'comment': comment,
    };
  }
}
