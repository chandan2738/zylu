import 'package:equatable/equatable.dart';
import '../../domain/entities/employee.dart';

abstract class EmployeeEvent extends Equatable {
  const EmployeeEvent();
  @override
  List<Object?> get props => [];
}

class LoadEmployees extends EmployeeEvent {}

class RefreshEmployees extends EmployeeEvent {}

class AddEmployeeEvent extends EmployeeEvent {
  final Employee employee;
  const AddEmployeeEvent(this.employee);
  @override
  List<Object?> get props => [employee];
}

class UpdateEmployeeEvent extends EmployeeEvent {
  final Employee employee;
  const UpdateEmployeeEvent(this.employee);
  @override
  List<Object?> get props => [employee];
}

class DeleteEmployeeEvent extends EmployeeEvent {
  final String id;
  const DeleteEmployeeEvent(this.id);
  @override
  List<Object?> get props => [id];
}
