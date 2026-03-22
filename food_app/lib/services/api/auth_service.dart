import 'dart:io';
import 'package:dio/dio.dart';

import '../../data/models/user_model.dart';
import '../storage_service.dart';
import 'api_client.dart';

class AuthService {
  final ApiClient _apiClient;
  final StorageService _storage;

  AuthService(this._apiClient, this._storage);

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _apiClient.post('/login', data: {
        'email': email,
        'password': password,
      });

      if (response.data['success'] == true) {
        final token = response.data['data']['token']?.toString() ?? '';
        final user = UserModel.fromJson(Map<String, dynamic>.from(response.data['data']['user']));
        await _storage.saveToken(token);
        await _storage.saveUser(user.toJson());
        return {'success': true, 'user': user.toJson(), 'token': token};
      }

      return {'success': false, 'message': response.data['message'] ?? 'Login failed'};
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        return {
          'success': false,
          'message': data['message'] ?? 'Login failed',
          'errors': data['errors'],
        };
      }
      return {'success': false, 'message': 'Network error'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> register(String name, String email, String password, String address, String phone, {File? avatarPath}) async {
    try {
      dynamic requestData;
      
      if (avatarPath != null) {
        requestData = FormData.fromMap({
          'name': name,
          'email': email,
          'password': password,
          'address': address,
          'phone': phone,
          'avatar': await MultipartFile.fromFile(
            avatarPath.path,
            filename: avatarPath.path.split('/').last,
          ),
        });
      } else {
        requestData = {
          'name': name,
          'email': email,
          'password': password,
          'address': address,
          'phone': phone,
        };
      }

      final response = await _apiClient.post('/register', data: requestData);

      if (response.data['success'] == true) {
        final token = response.data['data']['token']?.toString() ?? '';
        final user = UserModel.fromJson(Map<String, dynamic>.from(response.data['data']['user']));
        await _storage.saveToken(token);
        await _storage.saveUser(user.toJson());
        return {'success': true, 'user': user.toJson(), 'token': token};
      }

      return {'success': false, 'message': response.data['message'] ?? 'Registration failed'};
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        return {
          'success': false,
          'message': data['message'] ?? 'Registration failed',
          'errors': data['errors'],
        };
      }
      return {'success': false, 'message': 'Network error'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<UserModel?> getUserProfile() async {
    try {
      final response = await _apiClient.get('/profile');
      if (response.data['success'] == true) {
        return UserModel.fromJson(Map<String, dynamic>.from(response.data['data']));
      }
    } catch (_) {}
    return null;
  }

  Future<void> logout() async {
    try {
      await _apiClient.post('/logout');
    } catch (_) {
    } finally {
      await _storage.clearAll();
    }
  }

  Future<UserModel?> getCurrentUser() => getUserProfile();

  Future<Map<String, dynamic>> updateProfile({String? name, String? phone, String? avatarPath}) async {
    try {
      final payload = <String, dynamic>{
        if (name != null) 'name': name,
        if (phone != null) 'phone': phone,
        if (avatarPath != null) 'avatar': avatarPath,
      };
      final response = await _apiClient.put('/profile', data: payload);
      if (response.data['success'] == true) {
        final user = UserModel.fromJson(Map<String, dynamic>.from(response.data['data']));
        await _storage.saveUser(user.toJson());
        return {'success': true, 'user': user.toJson()};
      }
      return {'success': false, 'message': response.data['message'] ?? 'Update failed'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.getToken();
    return token != null && token.isNotEmpty;
  }
}
