import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/employee.dart';
import '../../domain/repositories/employee_repository.dart';
import '../datasources/firebase_employee_datasource.dart';
import '../models/employee_model.dart';

class EmployeeRepositoryImpl implements EmployeeRepository {
  final FirebaseEmployeeDatasource datasource;

  EmployeeRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<Employee>>> getEmployees() async {
    try {
      final models = await datasource.getEmployees();
      return Right(models.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addEmployee(Employee employee) async {
    try {
      final model = EmployeeModel.fromEntity(employee);
      await datasource.addEmployee(model);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateEmployee(Employee employee) async {
    try {
      final model = EmployeeModel.fromEntity(employee);
      await datasource.updateEmployee(model);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteEmployee(String id) async {
    try {
      await datasource.deleteEmployee(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
