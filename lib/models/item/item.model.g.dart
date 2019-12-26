// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) {
  return Item(
    item: json['item'] as String,
    targetPrice: json['targetPrice'] as int,
    currentSaving: json['currentSaving'] as int,
    userId: json['userId'] as String,
    id: json['id'] as String,
  );
}

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'item': instance.item,
      'targetPrice': instance.targetPrice,
      'currentSaving': instance.currentSaving,
      'id': instance.id,
      'userId': instance.userId,
    };
