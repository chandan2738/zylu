import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../auth/domain/entities/user.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../bloc/employee_bloc.dart';
import '../bloc/employee_event.dart';
import '../bloc/employee_state.dart';
import '../widgets/employee_card.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<EmployeeBloc>().add(LoadEmployees());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good Morning'
        : hour < 17
        ? 'Good Afternoon'
        : 'Good Evening';
    final greetingEmoji = hour < 12
        ? '☀️'
        : hour < 17
        ? '🌤'
        : '🌙';

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: isDark
            ? const Color(0xFF0F0F1A)
            : const Color(0xFFF0F2F8),
        body: Column(
          children: [
            // ── Fixed gradient header ──────────────────────────────
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authState) {
                final user = authState is Authenticated ? authState.user : null;
                return _DashboardHeader(
                  user: user,
                  greeting: '$greeting $greetingEmoji',
                  isDark: isDark,
                  onRefresh: () =>
                      context.read<EmployeeBloc>().add(RefreshEmployees()),
                  onProfile: () {
                    if (user != null) context.push('/profile', extra: user);
                  },
                );
              },
            ),

            // ── Scrollable body ────────────────────────────────────
            Expanded(
              child: BlocBuilder<EmployeeBloc, EmployeeState>(
                builder: (context, state) {
                  if (state is EmployeeLoading || state is EmployeeInitial) {
                    return _buildShimmer(isDark);
                  }

                  if (state is EmployeeError) {
                    return _buildError(state.message, context);
                  }

                  if (state is EmployeeLoaded) {
                    final employees = state.employees;
                    final total = employees.length;
                    final active = employees.where((e) => e.isActive).length;
                    final loyal = employees
                        .where((e) => e.isLoyalEmployee)
                        .length;

                    if (employees.isEmpty) {
                      return const _EmptyView();
                    }

                    return RefreshIndicator(
                      onRefresh: () async =>
                          context.read<EmployeeBloc>().add(RefreshEmployees()),
                      color: const Color(0xFF4776E6),
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          // Stats row
                          _StatsRow(
                            total: total,
                            active: active,
                            loyal: loyal,
                            isDark: isDark,
                          ),
                          // Section label
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
                            child: Text(
                              'ALL EMPLOYEES',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.4,
                                color: isDark
                                    ? Colors.white38
                                    : Colors.grey[500],
                              ),
                            ),
                          ),
                          // Employee cards
                          ...employees.map(
                            (emp) => EmployeeCard(
                              employee: emp,
                              onTap: () => context.push(
                                '/employees/${emp.id}',
                                extra: emp,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmer(bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 16),
      itemCount: 6,
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Shimmer.fromColors(
          baseColor: isDark ? const Color(0xFF2A2A3E) : Colors.grey.shade300,
          highlightColor: isDark
              ? const Color(0xFF3A3A4E)
              : Colors.grey.shade100,
          child: Container(
            height: 110,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2A2A3E) : Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildError(String message, BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_off_rounded, size: 64, color: Colors.redAccent),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.redAccent),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => context.read<EmployeeBloc>().add(LoadEmployees()),
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

// ─── Gradient Header Widget ───────────────────────────────────────────────────

class _DashboardHeader extends StatelessWidget {
  final User? user;
  final String greeting;
  final bool isDark;
  final VoidCallback onRefresh;
  final VoidCallback onProfile;

  const _DashboardHeader({
    required this.user,
    required this.greeting,
    required this.isDark,
    required this.onRefresh,
    required this.onProfile,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4776E6), Color(0xFF8E54E9)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      padding: EdgeInsets.only(
        top: topPadding + 16,
        left: 20,
        right: 20,
        bottom: 20,
      ),
      child: Row(
        children: [
          // Avatar tap → profile
          GestureDetector(
            onTap: onProfile,
            child: _Avatar(user: user, radius: 24),
          ),
          const SizedBox(width: 14),
          // Greeting + name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  greeting,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  user?.name.split(' ').first ?? 'User',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Refresh button
          _HeaderIconBtn(icon: Icons.refresh_rounded, onTap: onRefresh),
          const SizedBox(width: 10),
          // Profile button
          _HeaderIconBtn(icon: Icons.person_rounded, onTap: onProfile),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final User? user;
  final double radius;
  const _Avatar({this.user, this.radius = 20});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.white.withValues(alpha: 0.25),
      backgroundImage: user?.photoUrl != null
          ? NetworkImage(user!.photoUrl!)
          : null,
      child: user?.photoUrl == null
          ? Text(
              user?.name.isNotEmpty == true ? user!.name[0].toUpperCase() : 'Z',
              style: TextStyle(
                color: Colors.white,
                fontSize: radius * 0.75,
                fontWeight: FontWeight.bold,
              ),
            )
          : null,
    );
  }
}

class _HeaderIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _HeaderIconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }
}

// ─── Stats Row ────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final int total, active, loyal;
  final bool isDark;
  const _StatsRow({
    required this.total,
    required this.active,
    required this.loyal,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Row(
        children: [
          _StatCard(
            label: 'Total',
            value: total,
            icon: Icons.people_alt_rounded,
            color: const Color(0xFF4776E6),
            isDark: isDark,
          ),
          const SizedBox(width: 10),
          _StatCard(
            label: 'Active',
            value: active,
            icon: Icons.check_circle_outline_rounded,
            color: const Color(0xFF43A047),
            isDark: isDark,
          ),
          const SizedBox(width: 10),
          _StatCard(
            label: 'Loyal',
            value: loyal,
            icon: Icons.star_rounded,
            color: const Color(0xFFFF8F00),
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;
  final Color color;
  final bool isDark;
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(
              '$value',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? Colors.white54 : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Empty / Error views ─────────────────────────────────────────────────────

class _EmptyView extends StatelessWidget {
  const _EmptyView();
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.people_outline_rounded, size: 72, color: Colors.grey),
          SizedBox(height: 16),
          Text('No employees found.', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
