// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'piggy.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Piggy _$PiggyFromJson(Map json) {
  return Piggy(
    id: json['id'] as int,
    userId: json['userId'] as String,
    doubleUp: json['doubleUp'] as bool,
    isFeedAvailable: json['isFeedAvailable'] as bool,
    isApproved: json['isApproved'] as bool,
    money: json['money'] as int,
    currentFeedTime: json['currentFeedTime'] as int,
    targetPrice: json['targetPrice'] as int,
    currentSaving: json['currentSaving'] as int,
    item: json['item'] as String,
    piggyLevel: _$enumDecode(_$PiggyLevelEnumMap, json['piggyLevel']),
  );
}

Map<String, dynamic> _$PiggyToJson(Piggy instance) => <String, dynamic>{
      'id': instance.id ?? 0,
      'userId': instance.userId,
      'isFeedAvailable': instance.isFeedAvailable,
      'piggyLevel': _$PiggyLevelEnumMap[instance.piggyLevel],
      'money': instance.money,
      'currentFeedTime': instance.currentFeedTime,
      'doubleUp': instance.doubleUp,
      'isApproved': instance.isApproved,
      'item': instance.item,
      'targetPrice': instance.targetPrice,
      'currentSaving': instance.currentSaving,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

const _$PiggyLevelEnumMap = {
  PiggyLevel.Baby: 'Baby',
  PiggyLevel.Child: 'Child',
  PiggyLevel.Teen: 'Teen',
  PiggyLevel.Adult: 'Adult',
  PiggyLevel.Old: 'Old',
};
