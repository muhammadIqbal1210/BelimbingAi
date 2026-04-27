import 'package:json_annotation/json_annotation.dart';

part 'transaction.g.dart';

@JsonSerializable()
class Transaction {
  @JsonKey(name: 'transaction_id')
  final int? transactionId;

  @JsonKey(name: 'account_id')
  final int accountId;

  @JsonKey(name: 'transaction_type')
  final String transactionType; // Deposit, Withdraw

  @JsonKey(name: 'transaction_amount')
  final double transactionAmount;

  @JsonKey(name: 'transaction_date')
  final String transactionDate;

  @JsonKey(name: 'transaction_description')
  final String? transactionDescription;

  Transaction({
    this.transactionId,
    required this.accountId,
    required this.transactionType,
    required this.transactionAmount,
    required this.transactionDate,
    this.transactionDescription,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionToJson(this);

  Transaction copyWith({
    int? transactionId,
    int? accountId,
    String? transactionType,
    double? transactionAmount,
    String? transactionDate,
    String? transactionDescription,
  }) {
    return Transaction(
      transactionId: transactionId ?? this.transactionId,
      accountId: accountId ?? this.accountId,
      transactionType: transactionType ?? this.transactionType,
      transactionAmount: transactionAmount ?? this.transactionAmount,
      transactionDate: transactionDate ?? this.transactionDate,
      transactionDescription:
          transactionDescription ?? this.transactionDescription,
    );
  }
}
