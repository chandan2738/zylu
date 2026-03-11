import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/employee.dart';
import '../repositories/employee_repository.dart';

class UpdateEmployee {
  final EmployeeRepository repository;

  UpdateEmployee(this.repository);

  Future<Either<Failure, void>> call(Employee employee) {
    return repository.updateEmployee(employee);
  }
}
