import '../../data/models/category_model.dart';
import '../../models/food_item.dart';
import 'api_client.dart';

class FoodService {
  final ApiClient _apiClient;

  FoodService(this._apiClient);

  Future<List<FoodItem>> getFoods({int? categoryId, String? search, String? sortBy, int? perPage}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (categoryId != null) queryParams['category_id'] = categoryId;
      if (search != null && search.isNotEmpty) queryParams['search'] = search;
      if (sortBy != null) queryParams['sort_by'] = sortBy;
      if (perPage != null) queryParams['per_page'] = perPage;

      print('🔍 Fetching foods from API with params: $queryParams');
      final response = await _apiClient.get('/foods', queryParameters: queryParams);
      print('📦 API Response status: ${response.statusCode}');
      print('📦 API Response data: ${response.data}');
      
      if (response.data['success'] == true) {
        final data = response.data['data'];
        final foodList = data is Map && data.containsKey('data')
            ? List.from(data['data'] as List)
            : data is List
                ? data
                : const [];
        print('✅ Parsed ${foodList.length} foods');
        return foodList.map((json) => FoodItem.fromJson(Map<String, dynamic>.from(json))).toList();
      }
      print('❌ API success was false');
    } catch (e, stackTrace) {
      print('❌ Error fetching foods: $e');
      print('Stack trace: $stackTrace');
    }
    return [];
  }

  Future<FoodItem?> getFoodById(String id) async {
    try {
      final response = await _apiClient.get('/foods/$id');
      if (response.data['success'] == true) {
        return FoodItem.fromJson(Map<String, dynamic>.from(response.data['data']));
      }
    } catch (_) {}
    return null;
  }

  Future<List<FoodItem>> searchFoods(String query) => getFoods(search: query, perPage: 100);

  Future<List<FoodItem>> getSimilarFoods(String foodId) async {
    try {
      final response = await _apiClient.get('/foods/$foodId/similar');
      if (response.data['success'] == true) {
        final data = List.from(response.data['data'] as List);
        return data.map((json) => FoodItem.fromJson(Map<String, dynamic>.from(json))).toList();
      }
    } catch (_) {}
    return [];
  }

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _apiClient.get('/categories');
      if (response.data['success'] == true) {
        final data = List.from(response.data['data'] as List);
        return data.map((json) => CategoryModel.fromJson(Map<String, dynamic>.from(json))).toList();
      }
    } catch (_) {}
    return [];
  }
}
