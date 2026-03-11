import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/employee.dart';

abstract class EmployeeRepository {
  Future<Either<Failure, List<Employee>>> getEmployees();
  Future<Either<Failure, void>> addEmployee(Employee employee);
  Future<Either<Failure, void>> updateEmployee(Employee employee);
  Future<Either<Failure, void>> deleteEmployee(String id);
}
