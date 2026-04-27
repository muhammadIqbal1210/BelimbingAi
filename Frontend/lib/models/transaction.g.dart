// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
  transactionId: (json['transaction_id'] as num?)?.toInt(),
  accountId: (json['account_id'] as num).toInt(),
  transactionType: json['transaction_type'] as String,
  transactionAmount: (json['transaction_amount'] as num).toDouble(),
  transactionDate: json['transaction_date'] as String,
  transactionDescription: json['transaction_description'] as String?,
);

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'transaction_id': instance.transactionId,
      'account_id': instance.accountId,
      'transaction_type': instance.transactionType,
      'transaction_amount': instance.transactionAmount,
      'transaction_date': instance.transactionDate,
      'transaction_description': instance.transactionDescription,
    };
