import '../../data/models/cart_model.dart';
import 'api_client.dart';

class CartService {
  final ApiClient _apiClient;

  CartService(this._apiClient);

  Future<CartModel?> getCart() async {
    try {
      final response = await _apiClient.get('/cart');
      if (response.data['success'] == true) {
        final payload = response.data['data'];
        final cartJson = payload is Map<String, dynamic> ? payload['cart'] : null;
        if (cartJson is Map<String, dynamic>) {
          return CartModel.fromJson(cartJson);
        }
      }
    } catch (_) {}
    return null;
  }

  Future<Map<String, dynamic>> addToCart(String foodId, int quantity) async {
    try {
      final response = await _apiClient.post('/cart/add', data: {'food_id': foodId, 'quantity': quantity});
      if (response.data['success'] == true) {
        return {'success': true, 'message': response.data['message'] ?? 'Item added to cart'};
      }
      return {'success': false, 'message': response.data['message'] ?? 'Failed to add to cart'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateCartItem(String itemId, int quantity) async {
    try {
      final response = await _apiClient.put('/cart/items/$itemId', data: {'quantity': quantity});
      if (response.data['success'] == true) {
        return {'success': true, 'message': response.data['message'] ?? 'Cart updated'};
      }
      return {'success': false, 'message': response.data['message'] ?? 'Failed to update cart'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> removeFromCart(String itemId) async {
    try {
      final response = await _apiClient.delete('/cart/items/$itemId');
      if (response.data['success'] == true) {
        return {'success': true, 'message': response.data['message'] ?? 'Item removed from cart'};
      }
      return {'success': false, 'message': response.data['message'] ?? 'Failed to remove from cart'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<bool> clearCart() async {
    try {
      final response = await _apiClient.delete('/cart/clear');
      return response.data['success'] == true;
    } catch (_) {
      return false;
    }
  }
}
