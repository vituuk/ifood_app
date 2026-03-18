import 'api/api_client.dart';
import 'api/auth_service.dart';
import 'api/food_service.dart';
import 'api/cart_service.dart';
import 'api/order_service.dart';
import 'api/favorite_service.dart';
import 'api/address_service.dart';
import 'api/review_service.dart';
import 'storage_service.dart';

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  // Core services
  late final StorageService storageService;
  late final ApiClient apiClient;

  // API services
  late final AuthService authService;
  late final FoodService foodService;
  late final CartService cartService;
  late final OrderService orderService;
  late final FavoriteService favoriteService;
  late final AddressService addressService;
  late final ReviewService reviewService;

  Future<void> init() async {
    // Initialize storage service
    storageService = StorageService();
    await storageService.init();

    // Initialize API client
    apiClient = ApiClient(storageService);

    // Initialize all API services
    authService = AuthService(apiClient, storageService);
    foodService = FoodService(apiClient);
    cartService = CartService(apiClient);
    orderService = OrderService(apiClient);
    favoriteService = FavoriteService(apiClient);
    addressService = AddressService(apiClient);
    reviewService = ReviewService(apiClient);
  }

  // Getters for easy access
  static StorageService get storage => _instance.storageService;
  static ApiClient get api => _instance.apiClient;
  static AuthService get auth => _instance.authService;
  static FoodService get food => _instance.foodService;
  static CartService get cart => _instance.cartService;
  static OrderService get order => _instance.orderService;
  static FavoriteService get favorite => _instance.favoriteService;
  static AddressService get address => _instance.addressService;
  static ReviewService get review => _instance.reviewService;
}
