// To parse this JSON data, do
//
//     final posModel = posModelFromJson(jsonString);

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

// import 'package:arilatiahflutter1/model/product_model.dart';

part 'product_models.g.dart';

List<PosModel> posModelFromJson(String str) =>
    List<PosModel>.from(json.decode(str).map((x) => PosModel.fromJson(x)));

String posModelToJson(List<PosModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class PosModel {
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "title")
  String title;
  @JsonKey(name: "price")
  double price;
  @JsonKey(name: "description")
  String description;
  @JsonKey(name: "category")
  Category category;
  @JsonKey(name: "image")
  String image;
  @JsonKey(name: "rating")
  Rating rating;

  PosModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  factory PosModel.fromJson(Map<String, dynamic> json) =>
      _$PosModelFromJson(json);

  Map<String, dynamic> toJson() => _$PosModelToJson(this);
}

enum Category {
  @JsonValue("electronics")
  ELECTRONICS,
  @JsonValue("jewelery")
  JEWELERY,
  @JsonValue("men's clothing")
  MEN_S_CLOTHING,
  @JsonValue("women's clothing")
  WOMEN_S_CLOTHING,
}

final categoryValues = EnumValues({
  "electronics": Category.ELECTRONICS,
  "jewelery": Category.JEWELERY,
  "men's clothing": Category.MEN_S_CLOTHING,
  "women's clothing": Category.WOMEN_S_CLOTHING,
});

@JsonSerializable()
class Rating {
  @JsonKey(name: "rate")
  double rate;
  @JsonKey(name: "count")
  int count;

  Rating({required this.rate, required this.count});

  factory Rating.fromJson(Map<String, dynamic> json) => _$RatingFromJson(json);

  Map<String, dynamic> toJson() => _$RatingToJson(this);
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
