import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'core/theme/app_theme.dart';
import 'di/injector.dart' as di;
import 'features/auth/domain/entities/user.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/presentation/pages/login_screen.dart';
import 'features/auth/presentation/pages/profile_screen.dart';
import 'features/employees/domain/entities/employee.dart';
import 'features/employees/presentation/bloc/employee_bloc.dart';
import 'features/employees/presentation/pages/employee_details_screen.dart';
import 'features/employees/presentation/pages/employee_list_screen.dart';

// TODO: Uncomment after `flutterfire configure`:
// import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: Switch to DefaultFirebaseOptions after flutterfire configure:
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Firebase.initializeApp();

  // google_sign_in v7 singleton must be initialized before first use.
  await GoogleSignIn.instance.initialize();

  await di.init();

  runApp(const MyApp());
}

// ─── Router ──────────────────────────────────────────────────
class AppRouter {
  final AuthBloc _authBloc;
  late final GoRouter router;

  AppRouter(this._authBloc) {
    router = GoRouter(
      initialLocation: '/',
      // Rebuild routes when auth state changes
      refreshListenable: _AuthChangeNotifier(_authBloc.stream),
      redirect: (context, state) {
        final authState = _authBloc.state;
        final isLoggingIn = state.matchedLocation == '/';

        if (authState is AuthLoading || authState is AuthInitial) {
          // Still checking auth — show splash / login screen
          return isLoggingIn ? null : '/';
        }

        final isAuthenticated = authState is Authenticated;

        // If authenticated and on login page → redirect to employees
        if (isAuthenticated && isLoggingIn) {
          return '/employees';
        }

        // If NOT authenticated and NOT on login page → kick to login
        if (!isAuthenticated && !isLoggingIn) {
          return '/';
        }

        return null; // no redirect needed
      },
      routes: [
        GoRoute(path: '/', builder: (context, state) => const LoginScreen()),
        GoRoute(
          path: '/employees',
          builder: (context, state) => const EmployeeListScreen(),
          routes: [
            GoRoute(
              path: ':id',
              builder: (context, state) =>
                  EmployeeDetailsScreen(employee: state.extra as Employee),
            ),
          ],
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => ProfileScreen(user: state.extra as User),
        ),
      ],
    );
  }
}

/// Bridges Bloc stream → Listenable so GoRouter re-evaluates redirect on every auth change.
class _AuthChangeNotifier extends ChangeNotifier {
  _AuthChangeNotifier(Stream<AuthState> stream) {
    stream.listen((_) => notifyListeners());
  }
}

// ─── App ─────────────────────────────────────────────────────
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AuthBloc _authBloc;
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _authBloc = di.sl<AuthBloc>()..add(CheckAuthStatus());
    _appRouter = AppRouter(_authBloc);
  }

  @override
  void dispose() {
    _authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _authBloc),
        BlocProvider(create: (_) => di.sl<EmployeeBloc>()),
      ],
      child: MaterialApp.router(
        title: 'Zylu Employee Directory',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        routerConfig: _appRouter.router,
      ),
    );
  }
}
