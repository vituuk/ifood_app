import '../../data/models/address_model.dart';
import 'api_client.dart';

class AddressService {
  final ApiClient _apiClient;

  AddressService(this._apiClient);

  Future<List<AddressModel>> getAddresses() async {
    try {
      final response = await _apiClient.get('/addresses');

      if (response.data['success'] == true) {
        final List data = response.data['data'];
        return data.map((json) => AddressModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching addresses: $e');
      return [];
    }
  }

  Future<AddressModel?> getAddressById(String id) async {
    try {
      final response = await _apiClient.get('/addresses/$id');
      if (response.data['success'] == true) {
        return AddressModel.fromJson(response.data['data']);
      }
    } catch (e) {
      print('Error fetching address: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>> createAddress(
      AddressModel address) async {
    try {
      final response =
          await _apiClient.post('/addresses', data: address.toJson());

      if (response.data['success'] == true) {
        return {
          'success': true,
          'address': AddressModel.fromJson(response.data['data']),
          'message': response.data['message']
        };
      }
      return {
        'success': false,
        'message': response.data['message'] ?? 'Failed to create address'
      };
    } catch (e) {
      print('Error creating address: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateAddress(
      String id, AddressModel address) async {
    try {
      final response =
          await _apiClient.put('/addresses/$id', data: address.toJson());

      if (response.data['success'] == true) {
        return {
          'success': true,
          'address': AddressModel.fromJson(response.data['data']),
          'message': response.data['message']
        };
      }
      return {
        'success': false,
        'message': response.data['message'] ?? 'Failed to update address'
      };
    } catch (e) {
      print('Error updating address: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<bool> deleteAddress(String id) async {
    try {
      final response = await _apiClient.delete('/addresses/$id');
      return response.data['success'] == true;
    } catch (e) {
      print('Error deleting address: $e');
      return false;
    }
  }

  Future<AddressModel?> getDefaultAddress() async {
    try {
      final addresses = await getAddresses();
      return addresses.firstWhere(
        (address) => address.isDefault,
        orElse: () => addresses.isNotEmpty ? addresses.first : throw Exception(),
      );
    } catch (e) {
      print('Error getting default address: $e');
      return null;
    }
  }
}
