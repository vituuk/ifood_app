import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ApiConfig {
  // Override with: flutter run --dart-define=API_BASE_URL=http://192.168.1.10:8000/api
  static const String _overrideBaseUrl = String.fromEnvironment('API_BASE_URL');

  static String get baseUrl {
    if (_overrideBaseUrl.isNotEmpty) return _overrideBaseUrl;

    if (kIsWeb) {
      return 'http://127.0.0.1:8000/api';
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'http://10.0.2.2:8000/api';
      default:
        return 'http://127.0.0.1:8000/api';
    }
  }

  static String get adminUrl => baseUrl.replaceFirst('/api', '/admin');
  static String get storageUrl => baseUrl.replaceFirst('/api', '/storage');

  static const String login = '/login';
  static const String register = '/register';
  static const String logout = '/logout';
  static const String profile = '/profile';
  static const String updateProfile = '/profile';
  static const String foods = '/foods';
  static const String foodDetail = '/foods/{id}';
  static const String foodSimilar = '/foods/{id}/similar';
  static const String categories = '/categories';
  static const String categoryDetail = '/categories/{id}';
  static const String cart = '/cart';
  static const String cartAdd = '/cart/add';
  static const String cartUpdate = '/cart/items/{id}';
  static const String cartRemove = '/cart/items/{id}';
  static const String cartClear = '/cart/clear';
  static const String orders = '/orders';
  static const String orderDetail = '/orders/{id}';
  static const String orderCreate = '/orders';
  static const String orderCancel = '/orders/{id}/cancel';
  static const String favorites = '/favorites';
  static const String favoriteToggle = '/favorites/toggle';
  static const String favoriteCheck = '/favorites/check/{foodId}';
  static const String addresses = '/addresses';
  static const String addressDetail = '/addresses/{id}';
  static const String addressCreate = '/addresses';
  static const String addressUpdate = '/addresses/{id}';
  static const String addressDelete = '/addresses/{id}';
  static const String reviewCreate = '/reviews';
  static const String reviewUpdate = '/reviews/{id}';
  static const String reviewDelete = '/reviews/{id}';
  static const String messages = '/messages';
  static const String messageRead = '/messages/{id}/read';
  static const String messageReadAll = '/messages/read-all';
  static const String messageDelete = '/messages/{id}';
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  static String replacePath(String path, Map<String, String> params) {
    var result = path;
    params.forEach((key, value) {
      result = result.replaceAll('{$key}', value);
    });
    return result;
  }

  // Helper method to fix absolute local IPs on Android Emulators
  static String resolveImageUrl(String url) {
    if (kIsWeb) return url;
    
    if (defaultTargetPlatform == TargetPlatform.android) {
        return url.replaceAll('127.0.0.1', '10.0.2.2').replaceAll('localhost', '10.0.2.2');
    }
    return url;
  }

  static String getImageUrl(String path) {
    if (path.isEmpty) return '';
    if (path.startsWith('http')) return resolveImageUrl(path);
    if (path.startsWith('/storage/')) {
       return resolveImageUrl('${baseUrl.replaceAll('/api', '')}$path');
    }
    return resolveImageUrl('$storageUrl/$path');
  }
}
