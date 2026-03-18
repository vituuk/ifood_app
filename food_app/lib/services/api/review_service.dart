import '../../data/models/review_model.dart';
import 'api_client.dart';

class ReviewService {
  final ApiClient _apiClient;

  ReviewService(this._apiClient);

  Future<List<ReviewModel>> getReviews(String foodId) async {
    try {
      final response = await _apiClient.get('/foods/$foodId');
      if (response.data['success'] == true) {
        final data = response.data['data'];
        final reviews = data is Map<String, dynamic> && data['reviews'] is List ? List.from(data['reviews']) : const [];
        return reviews.map((json) => ReviewModel.fromJson(Map<String, dynamic>.from(json))).toList();
      }
    } catch (_) {}
    return [];
  }

  Future<Map<String, dynamic>> createReview({required String foodId, required String orderId, required int rating, String? comment}) async {
    try {
      final response = await _apiClient.post('/reviews', data: {
        'food_id': foodId,
        'order_id': orderId,
        'rating': rating,
        if (comment != null) 'comment': comment,
      });
      if (response.data['success'] == true) {
        return {
          'success': true,
          'review': ReviewModel.fromJson(Map<String, dynamic>.from(response.data['data'])),
          'message': response.data['message'],
        };
      }
      return {'success': false, 'message': response.data['message'] ?? 'Failed to submit review'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
