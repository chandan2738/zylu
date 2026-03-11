import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/employee_model.dart';

abstract class FirebaseEmployeeDatasource {
  Future<List<EmployeeModel>> getEmployees();
  Future<void> addEmployee(EmployeeModel employee);
  Future<void> updateEmployee(EmployeeModel employee);
  Future<void> deleteEmployee(String id);
}

class FirebaseEmployeeDatasourceImpl implements FirebaseEmployeeDatasource {
  final FirebaseFirestore _firestore;

  FirebaseEmployeeDatasourceImpl(this._firestore);

  @override
  Future<List<EmployeeModel>> getEmployees() async {
    final snapshot = await _firestore
        .collection('employees')
        .orderBy('joiningDate', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => EmployeeModel.fromJson(doc.data()))
        .toList();
  }

  @override
  Future<void> addEmployee(EmployeeModel employee) async {
    await _firestore
        .collection('employees')
        .doc(employee.id)
        .set(employee.toJson());
  }

  @override
  Future<void> updateEmployee(EmployeeModel employee) async {
    await _firestore
        .collection('employees')
        .doc(employee.id)
        .update(employee.toJson());
  }

  @override
  Future<void> deleteEmployee(String id) async {
    await _firestore.collection('employees').doc(id).delete();
  }
}
