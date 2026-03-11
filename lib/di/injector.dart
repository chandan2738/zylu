import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import '../features/auth/data/datasources/firebase_auth_datasource.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/get_current_user.dart';
import '../features/auth/domain/usecases/sign_in_with_google.dart';
import '../features/auth/domain/usecases/sign_out.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/employees/data/datasources/firebase_employee_datasource.dart';
import '../features/employees/data/repositories/employee_repository_impl.dart';
import '../features/employees/domain/repositories/employee_repository.dart';
import '../features/employees/domain/usecases/add_employee.dart';
import '../features/employees/domain/usecases/delete_employee.dart';
import '../features/employees/domain/usecases/get_employees.dart';
import '../features/employees/domain/usecases/update_employee.dart';
import '../features/employees/presentation/bloc/employee_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Blocs
  sl.registerFactory(
    () => AuthBloc(getCurrentUser: sl(), signInWithGoogle: sl(), signOut: sl()),
  );
  sl.registerFactory(
    () => EmployeeBloc(
      getEmployees: sl(),
      addEmployee: sl(),
      updateEmployee: sl(),
      deleteEmployee: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerLazySingleton(() => SignInWithGoogle(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));

  sl.registerLazySingleton(() => GetEmployees(sl()));
  sl.registerLazySingleton(() => AddEmployee(sl()));
  sl.registerLazySingleton(() => UpdateEmployee(sl()));
  sl.registerLazySingleton(() => DeleteEmployee(sl()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton<EmployeeRepository>(
    () => EmployeeRepositoryImpl(sl()),
  );

  // Data Sources — FirebaseAuthDatasourceImpl now takes (firebaseAuth, firestore) only.
  // GoogleSignIn v7 uses a singleton, no registration needed.
  sl.registerLazySingleton<FirebaseAuthDatasource>(
    () => FirebaseAuthDatasourceImpl(sl(), sl()),
  );
  sl.registerLazySingleton<FirebaseEmployeeDatasource>(
    () => FirebaseEmployeeDatasourceImpl(sl()),
  );

  // External / Firebase
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
}
