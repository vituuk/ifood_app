import '../../data/models/order_model.dart';
import '../../models/food_item.dart';
import 'api_client.dart';

class OrderService {
  final ApiClient _apiClient;

  OrderService(this._apiClient);

  Future<List<OrderModel>> getOrders({String? status}) async {
    try {
      final queryParams = status != null ? {'status': status} : null;
      final response = await _apiClient.get('/orders', queryParameters: queryParams);
      if (response.data['success'] == true) {
        final data = response.data['data'];
        final orderList = data is Map && data.containsKey('data') ? List.from(data['data']) : data is List ? data : const [];
        return orderList.map((json) => OrderModel.fromJson(Map<String, dynamic>.from(json))).toList();
      }
    } catch (_) {}
    return [];
  }

  Future<OrderModel?> getOrderById(String id) async {
    try {
      final response = await _apiClient.get('/orders/$id');
      if (response.data['success'] == true) {
        return OrderModel.fromJson(Map<String, dynamic>.from(response.data['data']));
      }
    } catch (_) {}
    return null;
  }

  Future<Map<String, dynamic>> createOrder({required String deliveryAddress, required String paymentMethod, required List<CartItem> items, double deliveryFee = 2, String? notes}) async {
    try {
      final payload = {
        'delivery_address': deliveryAddress,
        'delivery_fee': deliveryFee,
        'payment_method': paymentMethod,
        if (notes != null && notes.isNotEmpty) 'notes': notes,
        'items': items
            .map((item) => {
                  'food_id': item.food.id,
                  'quantity': item.quantity,
                  'price': item.food.price,
                })
            .toList(),
      };
      final response = await _apiClient.post('/orders', data: payload);
      if (response.data['success'] == true) {
        return {
          'success': true,
          'order': OrderModel.fromJson(Map<String, dynamic>.from(response.data['data'])),
          'message': response.data['message'],
        };
      }
      return {'success': false, 'message': response.data['message'] ?? 'Failed to create order'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<bool> cancelOrder(String orderId) async {
    try {
      final response = await _apiClient.post('/orders/$orderId/cancel');
      return response.data['success'] == true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteOrder(String orderId) async {
    try {
      final response = await _apiClient.delete('/orders/$orderId');
      return response.data['success'] == true;
    } catch (_) {
      return false;
    }
  }
}
