import '../../models/food_item.dart';
import 'api_client.dart';

class FavoriteService {
  final ApiClient _apiClient;

  FavoriteService(this._apiClient);

  Future<List<FoodItem>> getFavorites() async {
    try {
      final response = await _apiClient.get('/favorites');
      if (response.data['success'] == true) {
        final data = List.from(response.data['data'] as List);
        return data
            .map((json) => Map<String, dynamic>.from(json))
            .map((json) => FoodItem.fromJson(Map<String, dynamic>.from(json['food'] ?? json)))
            .toList();
      }
    } catch (_) {}
    return [];
  }

  Future<Map<String, dynamic>> toggleFavorite(String foodId) async {
    try {
      final response = await _apiClient.post('/favorites/toggle', data: {'food_id': foodId});
      if (response.data['success'] == true) {
        return {
          'success': true,
          'is_favorite': response.data['is_favorite'] ?? false,
          'message': response.data['message'] ?? 'Favorite toggled',
        };
      }
      return {'success': false, 'message': response.data['message'] ?? 'Failed to toggle favorite'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<bool> isFavorite(String foodId) async {
    try {
      final response = await _apiClient.get('/favorites/check/$foodId');
      return response.data['is_favorite'] == true;
    } catch (_) {
      return false;
    }
  }
}
