import 'dart:convert';
import '../../models/message_model.dart';
import 'api_client.dart';

class MessageService {
  final ApiClient _apiClient;

  MessageService(this._apiClient);

  Future<Map<String, dynamic>> getMessages() async {
    final response = await _apiClient.get('/messages');
    
    if (response.data != null && response.data['success'] == true && response.data['data'] != null) {
      final data = response.data['data'];
      final List<dynamic> messagesData = data['messages'] ?? [];
      final List<MessageModel> messages = messagesData
          .map((json) => MessageModel.fromJson(json))
          .toList();
      final int unreadCount = data['unread_count'] ?? 0;
      
      return {
        'success': true,
        'messages': messages,
        'unreadCount': unreadCount,
      };
    }
    
    return response.data;
  }

  Future<Map<String, dynamic>> sendMessage(String text) async {
    final response = await _apiClient.post('/messages', data: {'message': text});
    return response.data;
  }

  Future<Map<String, dynamic>> markAsRead(int id) async {
    final response = await _apiClient.put('/messages/$id/read', data: {});
    return response.data;
  }

  Future<Map<String, dynamic>> markAllAsRead() async {
    final response = await _apiClient.post('/messages/read-all', data: {});
    return response.data;
  }

  Future<Map<String, dynamic>> deleteMessage(int id) async {
    final response = await _apiClient.delete('/messages/$id');
    return response.data;
  }
}
