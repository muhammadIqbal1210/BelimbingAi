import 'package:json_annotation/json_annotation.dart';

part 'deposito_type.g.dart';

@JsonSerializable()
class DepositoType {
  @JsonKey(name: 'deposito_type_id')
  final int depositoTypeId;

  @JsonKey(name: 'deposito_type_name')
  final String depositoTypeName;

  @JsonKey(name: 'deposito_tenor_month')
  final int depositoTenorMonth;

  @JsonKey(name: 'deposito_bunga')
  final double depositoBunga; // Dalam persen (%)

  DepositoType({
    required this.depositoTypeId,
    required this.depositoTypeName,
    required this.depositoTenorMonth,
    required this.depositoBunga,
  });

  factory DepositoType.fromJson(Map<String, dynamic> json) =>
      _$DepositoTypeFromJson(json);

  Map<String, dynamic> toJson() => _$DepositoTypeToJson(this);

  DepositoType copyWith({
    int? depositoTypeId,
    String? depositoTypeName,
    int? depositoTenorMonth,
    double? depositoBunga,
  }) {
    return DepositoType(
      depositoTypeId: depositoTypeId ?? this.depositoTypeId,
      depositoTypeName: depositoTypeName ?? this.depositoTypeName,
      depositoTenorMonth: depositoTenorMonth ?? this.depositoTenorMonth,
      depositoBunga: depositoBunga ?? this.depositoBunga,
    );
  }
}
