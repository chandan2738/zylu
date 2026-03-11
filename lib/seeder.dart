import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'features/employees/data/models/employee_model.dart';
import 'features/employees/domain/entities/employee.dart';

Future<void> seedDatabase() async {
  final firestore = FirebaseFirestore.instance;
  final employeesCollection = firestore.collection('employees');

  final List<Employee> mockEmployees = [
    // > 5 years, active (Loyal)
    Employee(
      id: const Uuid().v4(),
      name: 'Alice Smith',
      email: 'alice@zylu.com',
      position: 'Senior Developer',
      joiningDate: DateTime(2017, 1, 15),
      isActive: true,
      profileImage: 'https://i.pravatar.cc/150?u=1',
    ),
    // > 5 years, active (Loyal)
    Employee(
      id: const Uuid().v4(),
      name: 'Bob Johnson',
      email: 'bob@zylu.com',
      position: 'Engineering Manager',
      joiningDate: DateTime(2018, 5, 20),
      isActive: true,
      profileImage: 'https://i.pravatar.cc/150?u=2',
    ),
    // > 5 years, inactive (Not loyal)
    Employee(
      id: const Uuid().v4(),
      name: 'Charlie Davis',
      email: 'charlie@zylu.com',
      position: 'QA Lead',
      joiningDate: DateTime(2016, 11, 10),
      isActive: false,
      profileImage: 'https://i.pravatar.cc/150?u=3',
    ),
    // < 5 years, active
    Employee(
      id: const Uuid().v4(),
      name: 'Diana Evans',
      email: 'diana@zylu.com',
      position: 'Scrum Master',
      joiningDate: DateTime(2022, 3, 1),
      isActive: true,
      profileImage: 'https://i.pravatar.cc/150?u=4',
    ),
    // < 5 years, active
    Employee(
      id: const Uuid().v4(),
      name: 'Evan Wright',
      email: 'evan@zylu.com',
      position: 'Frontend Developer',
      joiningDate: DateTime(2023, 7, 10),
      isActive: true,
      profileImage: 'https://i.pravatar.cc/150?u=5',
    ),
    // < 5 years, inactive
    Employee(
      id: const Uuid().v4(),
      name: 'Fiona King',
      email: 'fiona@zylu.com',
      position: 'Backend Developer',
      joiningDate: DateTime(2021, 9, 21),
      isActive: false,
      profileImage: 'https://i.pravatar.cc/150?u=6',
    ),
    // > 5 years, active (Loyal)
    Employee(
      id: const Uuid().v4(),
      name: 'George Hall',
      email: 'george@zylu.com',
      position: 'DevOps Engineer',
      joiningDate: DateTime(2015, 2, 28),
      isActive: true,
      profileImage: 'https://i.pravatar.cc/150?u=7',
    ),
    // < 5 years, active
    Employee(
      id: const Uuid().v4(),
      name: 'Hannah White',
      email: 'hannah@zylu.com',
      position: 'UI/UX Designer',
      joiningDate: DateTime(2023, 1, 15),
      isActive: true,
      profileImage: 'https://i.pravatar.cc/150?u=8',
    ),
    // > 5 years, active (Loyal)
    Employee(
      id: const Uuid().v4(),
      name: 'Ian Green',
      email: 'ian@zylu.com',
      position: 'Product Owner',
      joiningDate: DateTime(2019, 10, 5),
      isActive: true,
      profileImage: 'https://i.pravatar.cc/150?u=9',
    ),
    // < 5 years, active
    Employee(
      id: const Uuid().v4(),
      name: 'Jack Adams',
      email: 'jack@zylu.com',
      position: 'HR Manager',
      joiningDate: DateTime(2024, 1, 1),
      isActive: true,
      profileImage: 'https://i.pravatar.cc/150?u=10',
    ),
  ];

  try {
    final batch = firestore.batch();
    for (var emp in mockEmployees) {
      final docRef = employeesCollection.doc(emp.id);
      final model = EmployeeModel.fromEntity(emp);
      batch.set(docRef, model.toJson());
    }
    await batch.commit();
    if (kDebugMode) {
      print('✅ Database successfully seeded with 10 employees!');
    }
  } catch (e) {
    if (kDebugMode) {
      print('❌ Failed to seed database: $e');
    }
  }
}
