import 'package:json_annotation/json_annotation.dart';

part 'customer.g.dart';

@JsonSerializable()
class Customer {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'address')
  final String? address;

  @JsonKey(name: 'phone')
  final String? phone;

  @JsonKey(name: 'email')
  final String? email;

  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;

  @JsonKey(name: 'updatedAt')
  final DateTime? updatedAt;

  Customer({
    required this.id,
    required this.name,
    this.address,
    this.phone,
    this.email,
    this.createdAt,
    this.updatedAt,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    // Accept both 'id' and '_id' coming from backend
    final map = Map<String, dynamic>.from(json);
    if ((map['id'] == null || map['id'].toString().isEmpty) &&
        map['_id'] != null) {
      map['id'] = map['_id'] is Map ? map['_id'][''] ?? map['_id'] : map['_id'];
    }
    return _$CustomerFromJson(map);
  }

  Map<String, dynamic> toJson() => _$CustomerToJson(this);

  Customer copyWith({
    String? id,
    String? name,
    String? address,
    String? phone,
    String? email,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
