import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/add_employee.dart';
import '../../domain/usecases/delete_employee.dart';
import '../../domain/usecases/get_employees.dart';
import '../../domain/usecases/update_employee.dart';
import 'employee_event.dart';
import 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final GetEmployees getEmployees;
  final AddEmployee addEmployee;
  final UpdateEmployee updateEmployee;
  final DeleteEmployee deleteEmployee;

  EmployeeBloc({
    required this.getEmployees,
    required this.addEmployee,
    required this.updateEmployee,
    required this.deleteEmployee,
  }) : super(EmployeeInitial()) {
    on<LoadEmployees>(_onLoadEmployees);
    on<RefreshEmployees>(_onRefreshEmployees);
    on<AddEmployeeEvent>(_onAddEmployee);
    on<UpdateEmployeeEvent>(_onUpdateEmployee);
    on<DeleteEmployeeEvent>(_onDeleteEmployee);
  }

  Future<void> _onLoadEmployees(
    LoadEmployees event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(EmployeeLoading());
    final result = await getEmployees();
    result.fold(
      (failure) => emit(EmployeeError(failure.message)),
      (employees) => emit(EmployeeLoaded(employees)),
    );
  }

  Future<void> _onRefreshEmployees(
    RefreshEmployees event,
    Emitter<EmployeeState> emit,
  ) async {
    final result = await getEmployees();
    result.fold(
      (failure) => emit(EmployeeError(failure.message)),
      (employees) => emit(EmployeeLoaded(employees)),
    );
  }

  Future<void> _onAddEmployee(
    AddEmployeeEvent event,
    Emitter<EmployeeState> emit,
  ) async {
    final result = await addEmployee(event.employee);
    result.fold(
      (failure) => emit(EmployeeError(failure.message)),
      (_) => add(LoadEmployees()),
    );
  }

  Future<void> _onUpdateEmployee(
    UpdateEmployeeEvent event,
    Emitter<EmployeeState> emit,
  ) async {
    final result = await updateEmployee(event.employee);
    result.fold(
      (failure) => emit(EmployeeError(failure.message)),
      (_) => add(LoadEmployees()),
    );
  }

  Future<void> _onDeleteEmployee(
    DeleteEmployeeEvent event,
    Emitter<EmployeeState> emit,
  ) async {
    final result = await deleteEmployee(event.id);
    result.fold(
      (failure) => emit(EmployeeError(failure.message)),
      (_) => add(LoadEmployees()),
    );
  }
}
