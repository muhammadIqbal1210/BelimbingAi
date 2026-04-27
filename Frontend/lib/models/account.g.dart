// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Account _$AccountFromJson(Map<String, dynamic> json) => Account(
  id: json['_id'] as String?,
  customerId: json['customerId'] as String,
  depositoTypeId: json['depositoTypeId'] as String,
  balance: (json['balance'] as num).toDouble(),
  depositDate: json['depositDate'] as String,
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
);

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
  '_id': instance.id,
  'customerId': instance.customerId,
  'depositoTypeId': instance.depositoTypeId,
  'balance': instance.balance,
  'depositDate': instance.depositDate,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
};
