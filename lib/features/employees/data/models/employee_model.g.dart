// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeeModel _$EmployeeModelFromJson(Map<String, dynamic> json) =>
    EmployeeModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      position: json['position'] as String,
      joiningDate: DateTime.parse(json['joiningDate'] as String),
      isActive: json['isActive'] as bool,
      profileImage: json['profileImage'] as String?,
    );

Map<String, dynamic> _$EmployeeModelToJson(EmployeeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'position': instance.position,
      'joiningDate': instance.joiningDate.toIso8601String(),
      'isActive': instance.isActive,
      'profileImage': instance.profileImage,
    };
