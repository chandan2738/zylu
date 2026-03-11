import 'package:json_annotation/json_annotation.dart';

import '../../../../features/auth/data/models/user_model.dart';
import '../../domain/entities/employee.dart';

part 'employee_model.g.dart';

@JsonSerializable(explicitToJson: true)
class EmployeeModel {
  final String id;
  final String name;
  final String email;
  final String position;
  @TimestampConverter()
  final DateTime joiningDate;
  final bool isActive;
  final String? profileImage;

  const EmployeeModel({
    required this.id,
    required this.name,
    required this.email,
    required this.position,
    required this.joiningDate,
    required this.isActive,
    this.profileImage,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) =>
      _$EmployeeModelFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeeModelToJson(this);

  Employee toEntity() => Employee(
    id: id,
    name: name,
    email: email,
    position: position,
    joiningDate: joiningDate,
    isActive: isActive,
    profileImage: profileImage,
  );

  factory EmployeeModel.fromEntity(Employee employee) => EmployeeModel(
    id: employee.id,
    name: employee.name,
    email: employee.email,
    position: employee.position,
    joiningDate: employee.joiningDate,
    isActive: employee.isActive,
    profileImage: employee.profileImage,
  );
}
