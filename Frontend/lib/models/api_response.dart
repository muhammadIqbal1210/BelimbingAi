import 'package:json_annotation/json_annotation.dart';

part 'api_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  @JsonKey(name: 'status')
  final int status;

  @JsonKey(name: 'message')
  final String message;

  @JsonKey(name: 'data')
  final T? data;

  ApiResponse({required this.status, required this.message, this.data});

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) => _$ApiResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);

  bool get isSuccess => status == 200 || status == 201;
}
