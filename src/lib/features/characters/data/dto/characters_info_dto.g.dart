// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'characters_info_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CharactersInfoDto _$CharactersInfoDtoFromJson(Map<String, dynamic> json) =>
    CharactersInfoDto(
      count: (json['count'] as num?)?.toInt(),
      pages: (json['pages'] as num?)?.toInt(),
      next: json['next'] as String?,
      prev: json['prev'] as String?,
    );

Map<String, dynamic> _$CharactersInfoDtoToJson(CharactersInfoDto instance) =>
    <String, dynamic>{
      'count': instance.count,
      'pages': instance.pages,
      'next': instance.next,
      'prev': instance.prev,
    };
