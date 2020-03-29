// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chore.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chore _$ChoreFromJson(Map json) {
  var finishedDate;
  if (json['finishedDate'] != null) {
    finishedDate = DateTime.parse(json['finishedDate'] as String);
  } else {
    finishedDate = null;
  }
  return Chore(
    choreType: _$enumDecode(_$ChoreTypeEnumMap, json['choreType']),
    details: json['details'] as String,
    isDone: json['isDone'] as bool,
    reward: json['reward'] as String,
    title: json['title'] as String,
    finishedDate: finishedDate,
    isValidated: json['isValidated'] as bool,
    childId: json['childId'] as String,
    id: json['id'] as int,
  );
}

Map<String, dynamic> _$ChoreToJson(Chore instance) => <String, dynamic>{
      'id': instance.id,
      'childId': instance.childId,
      'choreType': _$ChoreTypeEnumMap[instance.choreType],
      'title': instance.title,
      'details': instance.details,
      'reward': instance.reward,
      'finishedDate': instance.finishedDate?.toIso8601String(),
      'isDone': instance.isDone,
      'isValidated': instance.isValidated,
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

const _$ChoreTypeEnumMap = {
  ChoreType.haziMunka: 'haziMunka',
  ChoreType.iskolaiMunka: 'iskolaiMunka',
};
