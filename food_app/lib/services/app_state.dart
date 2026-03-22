import 'package:flutter/foundation.dart';

import '../data/models/category_model.dart';
import '../data/models/user_model.dart';
import '../data/models/order_model.dart';
import '../models/food_item.dart';
import 'api/api_client.dart';
import 'api/auth_service.dart';
import 'api/cart_service.dart';
import 'api/favorite_service.dart';
import 'api/food_service.dart';
import 'api/order_service.dart';
import 'api/message_service.dart';
import 'api/address_service.dart';
import '../data/models/address_model.dart';
import '../../models/message_model.dart';
import 'storage_service.dart';
import 'dart:io';

class AppState extends ChangeNotifier {
  late final FoodService _foodService;
  late final CartService _cartService;
  late final FavoriteService _favoriteService;
  late final AuthService _authService;
  late final OrderService _orderService;
  late final MessageService _messageService;
  late final AddressService _addressService;
  final StorageService _storageService = StorageService();

  List<FoodItem> _foodItems = [];
  List<CategoryModel> _categories = [];
  final List<CartItem> _cartItems = [];
  List<FoodItem> _favoriteItems = [];
  List<MessageModel> _messages = [];
  int _unreadMessageCount = 0;
  UserModel? _currentUser;
  String? _currentOrderId;
  bool _isLoading = false;
  String? _error;
  String? _globalSearchQuery;
  int _mainNavigationIndex = 0;

  List<FoodItem> get foodItems => _foodItems;
  List<CategoryModel> get categories => _categories;
  List<CartItem> get cartItems => _cartItems;
  List<FoodItem> get favoriteItems => _favoriteItems;
  List<MessageModel> get messages => _messages;
  int get unreadMessageCount => _unreadMessageCount;
  UserModel? get currentUser => _currentUser;
  String? get currentOrderId => _currentOrderId;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;
  String? get globalSearchQuery => _globalSearchQuery;
  int get mainNavigationIndex => _mainNavigationIndex;

  void setGlobalSearchQuery(String? query) {
    _globalSearchQuery = query;
    notifyListeners();
  }

  void setMainNavigationIndex(int index) {
    _mainNavigationIndex = index;
    notifyListeners();
  }

  AppState() {
    _initializeServices();
    _loadInitialData();
  }

  void _initializeServices() {
    final apiClient = ApiClient(_storageService);
    _foodService = FoodService(apiClient);
    _cartService = CartService(apiClient);
    _favoriteService = FavoriteService(apiClient);
    _authService = AuthService(apiClient, _storageService);
    _orderService = OrderService(apiClient);
    _messageService = MessageService(apiClient);
    _addressService = AddressService(apiClient);
  }

  Future<void> _loadInitialData() async {
    await Future.wait([loadFoods(), loadCategories(), checkAuthStatus()]);
  }

  Future<void> checkAuthStatus() async {
    final token = await _storageService.getToken();
    final savedUser = await _storageService.getUser();
    if (savedUser != null) {
      _currentUser = UserModel.fromJson(savedUser);
      notifyListeners();
    }
    if (token != null && token.isNotEmpty) {
      await loadUserProfile();
    }
  }

  Future<void> loadUserProfile() async {
    try {
      final user = await _authService.getUserProfile();
      if (user != null) {
        _currentUser = user;
        await _storageService.saveUser(user.toJson());
        await Future.wait([loadCart(), loadFavorites(), loadMessages()]);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading user profile: $e');
    }
  }

  Future<void> loadFoods({int? categoryId, String? search}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      _foodItems = await _foodService.getFoods(categoryId: categoryId, search: search, perPage: 100);
    } catch (e) {
      _error = 'Failed to load foods: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCategories() async {
    try {
      _categories = await _foodService.getCategories();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading categories: $e');
    }
  }

  Future<void> loadCart() async {
    if (!isAuthenticated) return;
    try {
      final cartModel = await _cartService.getCart();
      _cartItems.clear();
      if (cartModel != null) {
        for (final item in cartModel.items) {
          if (item.food != null) {
            _cartItems.add(CartItem(food: item.food!, quantity: item.quantity, remoteItemId: item.id));
          }
        }
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading cart: $e');
    }
  }

  Future<void> loadFavorites() async {
    if (!isAuthenticated) return;
    try {
      final favorites = await _favoriteService.getFavorites();
      _favoriteItems
        ..clear()
        ..addAll(favorites);
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    }
  }

  Future<void> loadMessages() async {
    if (!isAuthenticated) return;
    try {
      final result = await _messageService.getMessages();
      if (result['success'] == true) {
        _messages = result['messages'] ?? [];
        _unreadMessageCount = result['unreadCount'] ?? 0;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading messages: $e');
    }
  }

  Future<void> markMessageAsRead(int id) async {
    final index = _messages.indexWhere((m) => m.id == id);
    if (index >= 0 && !_messages[index].isRead) {
      final message = _messages[index];
      _messages[index] = MessageModel(
        id: message.id,
        userId: message.userId,
        title: message.title,
        message: message.message,
        type: message.type,
        isUser: message.isUser,
        isRead: true,
        createdAt: message.createdAt,
      );
      if (_unreadMessageCount > 0) _unreadMessageCount--;
      notifyListeners();

      try {
        await _messageService.markAsRead(id);
      } catch (e) {
        debugPrint('Error marking message as read: $e');
      }
    }
  }
  
  Future<void> markAllMessagesAsRead() async {
    bool hasUnread = _messages.any((m) => !m.isRead);
    if (!hasUnread) return;

    _messages = _messages.map<MessageModel>((message) {
      return MessageModel(
        id: message.id,
        userId: message.userId,
        title: message.title,
        message: message.message,
        type: message.type,
        isUser: message.isUser,
        isRead: true,
        createdAt: message.createdAt,
      );
    }).toList();
    _unreadMessageCount = 0;
    notifyListeners();

    try {
      await _messageService.markAllAsRead();
    } catch (e) {
      debugPrint('Error marking all messages as read: $e');
    }
  }

  int get cartItemCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);
  double get cartTotal => _cartItems.fold(0, (sum, item) => sum + item.totalPrice);

  Future<void> addToCart(FoodItem food, int quantity) async {
    final existingIndex = _cartItems.indexWhere((item) => item.food.id == food.id);
    if (existingIndex >= 0) {
      _cartItems[existingIndex].quantity += quantity;
    } else {
      _cartItems.add(CartItem(food: food, quantity: quantity));
    }
    notifyListeners();

    if (!isAuthenticated) return;

    try {
      final result = await _cartService.addToCart(food.id, quantity);
      if (result['success'] == true) {
        await loadCart();
      }
    } catch (e) {
      debugPrint('Error adding to cart: $e');
    }
  }

  Future<void> removeFromCart(String foodId) async {
    final index = _cartItems.indexWhere((item) => item.food.id == foodId);
    if (index < 0) return;

    final removedItem = _cartItems.removeAt(index);
    notifyListeners();

    if (!isAuthenticated) return;
    final remoteItemId = removedItem.remoteItemId;
    if (remoteItemId == null || remoteItemId.isEmpty) {
      await loadCart();
      return;
    }

    try {
      final result = await _cartService.removeFromCart(remoteItemId);
      if (result['success'] != true) {
        _cartItems.insert(index, removedItem);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error removing from cart: $e');
      _cartItems.insert(index, removedItem);
      notifyListeners();
    }
  }

  Future<void> updateCartItemQuantity(String foodId, int quantity) async {
    final index = _cartItems.indexWhere((item) => item.food.id == foodId);
    if (index < 0) return;

    if (quantity <= 0) {
      await removeFromCart(foodId);
      return;
    }

    final item = _cartItems[index];
    final previousQuantity = item.quantity;
    item.quantity = quantity;
    notifyListeners();

    if (!isAuthenticated || item.remoteItemId == null) return;

    try {
      final result = await _cartService.updateCartItem(item.remoteItemId!, quantity);
      if (result['success'] != true) {
        item.quantity = previousQuantity;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating cart quantity: $e');
      item.quantity = previousQuantity;
      notifyListeners();
    }
  }

  Future<void> clearCart() async {
    final previousItems = List<CartItem>.from(_cartItems);
    _cartItems.clear();
    notifyListeners();

    if (!isAuthenticated) return;
    final ok = await _cartService.clearCart();
    if (!ok) {
      _cartItems
        ..clear()
        ..addAll(previousItems);
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(FoodItem food) async {
    final index = _favoriteItems.indexWhere((item) => item.id == food.id);
    if (index >= 0) {
      _favoriteItems.removeAt(index);
    } else {
      _favoriteItems.add(food);
    }
    notifyListeners();

    if (!isAuthenticated) return;
    try {
      final result = await _favoriteService.toggleFavorite(food.id);
      if (result['success'] == true) {
        await loadFavorites();
      }
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
    }
  }

  bool isFavorite(String foodId) => _favoriteItems.any((item) => item.id == foodId);

  void clearFavorites() {
    _favoriteItems.clear();
    notifyListeners();
  }

  void setCurrentOrderId(String orderId) {
    _currentOrderId = orderId;
    notifyListeners();
  }

  Future<List<OrderModel>> getOrders({String? status}) async {
    return await _orderService.getOrders(status: status);
  }

  Future<bool> deleteOrder(String orderId) async {
    return await _orderService.deleteOrder(orderId);
  }

  Future<Map<String, dynamic>> placeOrder({required String deliveryAddress, required String paymentMethod, String? notes}) async {
    if (_cartItems.isEmpty) {
      return {'success': false, 'message': 'Your cart is empty'};
    }

    try {
      _isLoading = true;
      notifyListeners();
      final result = await _orderService.createOrder(
        deliveryAddress: deliveryAddress,
        paymentMethod: paymentMethod,
        items: List<CartItem>.from(_cartItems),
        notes: notes,
      );
      if (result['success'] == true && result['order'] != null) {
        _currentOrderId = result['order'].orderNumber;
        _cartItems.clear();
      }
      return result;
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  FoodItem? getFoodById(String id) {
    try {
      return _foodItems.firstWhere((food) => food.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      final result = await _authService.login(email, password);
      if (result['success'] == true && result['user'] != null) {
        _currentUser = UserModel.fromJson(Map<String, dynamic>.from(result['user']));
        await Future.wait([loadCart(), loadFavorites(), loadMessages()]);
      } else {
        throw Exception(result['message'] ?? 'Login failed');
      }
    } catch (e) {
      _error = 'Login failed: $e';
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(String name, String email, String password, String address, String phone, {File? avatarFile}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      final result = await _authService.register(name, email, password, address, phone, avatarPath: avatarFile);
      if (result['success'] == true && result['user'] != null) {
        _currentUser = UserModel.fromJson(Map<String, dynamic>.from(result['user']));
        await Future.wait([loadCart(), loadFavorites(), loadMessages()]);
      } else {
        throw Exception(result['message'] ?? 'Registration failed');
      }
    } catch (e) {
      _error = 'Registration failed: $e';
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      await _authService.logout();
    } catch (e) {
      debugPrint('Backend logout error (safe to ignore): $e');
    } finally {
      _currentUser = null;
      _cartItems.clear();
      _favoriteItems.clear();
      _messages.clear();
      _unreadMessageCount = 0;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<AddressModel?> getDefaultAddress() async {
    return await _addressService.getDefaultAddress();
  }
}
