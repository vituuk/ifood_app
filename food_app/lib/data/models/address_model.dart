class AddressModel {
  final String id;
  final String userId;
  final String label;
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final String? phone;
  final bool isDefault;

  AddressModel({
    required this.id,
    required this.userId,
    required this.label,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    this.phone,
    this.isDefault = false,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'].toString(),
      userId: json['user_id'].toString(),
      label: json['label'] ?? '',
      addressLine1: json['address_line1'] ?? json['address'] ?? '',
      addressLine2: json['address_line2'],
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      postalCode: json['postal_code'] ?? json['zip_code'] ?? '',
      country: json['country'] ?? '',
      phone: json['phone'],
      isDefault: json['is_default'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'address': addressLine1,
      'address_line2': addressLine2,
      'city': city,
      'state': state,
      'zip_code': postalCode,
      'country': country,
      'phone': phone,
      'is_default': isDefault,
    };
  }

  String get fullAddress {
    final parts = [
      addressLine1,
      if (addressLine2 != null && addressLine2!.isNotEmpty) addressLine2,
      if (city.isNotEmpty && city != 'Unknown') city,
      if (state.isNotEmpty && state != 'Unknown') state,
      if (postalCode.isNotEmpty && postalCode != '00000') postalCode,
      if (country.isNotEmpty && country != 'Unknown') country,
    ];
    return parts.where((p) => p != null && p!.isNotEmpty).join(', ');
  }
}
