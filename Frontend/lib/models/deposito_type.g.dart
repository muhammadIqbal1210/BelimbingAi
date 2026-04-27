// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deposito_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DepositoType _$DepositoTypeFromJson(Map<String, dynamic> json) => DepositoType(
  depositoTypeId: (json['deposito_type_id'] as num).toInt(),
  depositoTypeName: json['deposito_type_name'] as String,
  depositoTenorMonth: (json['deposito_tenor_month'] as num).toInt(),
  depositoBunga: (json['deposito_bunga'] as num).toDouble(),
);

Map<String, dynamic> _$DepositoTypeToJson(DepositoType instance) =>
    <String, dynamic>{
      'deposito_type_id': instance.depositoTypeId,
      'deposito_type_name': instance.depositoTypeName,
      'deposito_tenor_month': instance.depositoTenorMonth,
      'deposito_bunga': instance.depositoBunga,
    };
