// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'piggy.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Piggy _$PiggyFromJson(Map json) {
  return Piggy(
    id: json['id'] as String,
    childId: json['childId'] as String,
    currentFeedAmount: json['currentFeedAmount'] as int,
    doubleUp: json['doubleUp'] as bool,
    isFeedAvailable: json['isFeedAvailable'] as bool,
    money: json['money'] as int,
  );
}

Map<String, dynamic> _$PiggyToJson(Piggy instance) => <String, dynamic>{
      'id': instance.id,
      'childId': instance.childId,
      'isFeedAvailable': instance.isFeedAvailable,
      'currentFeedAmount': instance.currentFeedAmount,
      'money': instance.money,
      'doubleUp': instance.doubleUp,
    };
