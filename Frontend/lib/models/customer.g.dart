// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerFromJson(Map<String, dynamic> json) => Customer(
  id: json['id'] as String,
  name: json['name'] as String,
  address: json['address'] as String?,
  phone: json['phone'] as String?,
  email: json['email'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'address': instance.address,
  'phone': instance.phone,
  'email': instance.email,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
