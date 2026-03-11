import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/employee.dart';
import '../repositories/employee_repository.dart';

class GetEmployees {
  final EmployeeRepository repository;

  GetEmployees(this.repository);

  Future<Either<Failure, List<Employee>>> call() {
    return repository.getEmployees();
  }
}
