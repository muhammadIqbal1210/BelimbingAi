import 'package:json_annotation/json_annotation.dart';

part 'account.g.dart';

@JsonSerializable()
class Account {
  @JsonKey(name: '_id')
  final String? id;

  @JsonKey(name: 'customerId')
  final String customerId;

  @JsonKey(name: 'depositoTypeId')
  final String depositoTypeId;

  @JsonKey(name: 'balance')
  final double balance;

  @JsonKey(name: 'depositDate')
  final String depositDate; // ISO 8601 format dari backend

  @JsonKey(name: 'createdAt')
  final String? createdAt;

  @JsonKey(name: 'updatedAt')
  final String? updatedAt;

  Account({
    this.id,
    required this.customerId,
    required this.depositoTypeId,
    required this.balance,
    required this.depositDate,
    this.createdAt,
    this.updatedAt,
  });

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  Map<String, dynamic> toJson() => _$AccountToJson(this);

  Account copyWith({
    String? id,
    String? customerId,
    String? depositoTypeId,
    double? balance,
    String? depositDate,
    String? createdAt,
    String? updatedAt,
  }) {
    return Account(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      depositoTypeId: depositoTypeId ?? this.depositoTypeId,
      balance: balance ?? this.balance,
      depositDate: depositDate ?? this.depositDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Get account ID (alias untuk kompatibilitas)
  String get accountId => id ?? '';

  /// Get balance sebagai formatted string untuk UI
  String get balanceFormatted => balance.toString();
}
