// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PosModel _$PosModelFromJson(Map<String, dynamic> json) => PosModel(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  price: (json['price'] as num).toDouble(),
  description: json['description'] as String,
  category: $enumDecode(_$CategoryEnumMap, json['category']),
  image: json['image'] as String,
  rating: Rating.fromJson(json['rating'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PosModelToJson(PosModel instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'price': instance.price,
  'description': instance.description,
  'category': _$CategoryEnumMap[instance.category]!,
  'image': instance.image,
  'rating': instance.rating,
};

const _$CategoryEnumMap = {
  Category.ELECTRONICS: 'electronics',
  Category.JEWELERY: 'jewelery',
  Category.MEN_S_CLOTHING: "men's clothing",
  Category.WOMEN_S_CLOTHING: "women's clothing",
};

Rating _$RatingFromJson(Map<String, dynamic> json) => Rating(
  rate: (json['rate'] as num).toDouble(),
  count: (json['count'] as num).toInt(),
);

Map<String, dynamic> _$RatingToJson(Rating instance) => <String, dynamic>{
  'rate': instance.rate,
  'count': instance.count,
};
