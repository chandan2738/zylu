import 'package:flutter/material.dart';
import '../../domain/entities/employee.dart';

class EmployeeCard extends StatelessWidget {
  final Employee employee;
  final VoidCallback onTap;

  const EmployeeCard({super.key, required this.employee, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isLoyal = employee.isLoyalEmployee;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final borderColor = isLoyal
        ? (isDark ? const Color(0xFF48BB78) : const Color(0xFF38A169))
        : Colors.transparent;

    final bgColor = isLoyal
        ? (isDark
              ? const Color(0xFF22543D).withValues(alpha: 0.3)
              : const Color(0xFFF0FFF4))
        : theme.cardTheme.color;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: borderColor, width: isLoyal ? 2 : 0),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Hero(
                tag: 'profile_${employee.id}',
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  backgroundImage:
                      employee.profileImage != null &&
                          employee.profileImage!.isNotEmpty
                      ? NetworkImage(employee.profileImage!)
                      : null,
                  child:
                      employee.profileImage == null ||
                          employee.profileImage!.isEmpty
                      ? Text(
                          employee.name.isNotEmpty
                              ? employee.name[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            fontSize: 24,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            employee.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isLoyal)
                          const Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 20,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(employee.position, style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _Badge(
                          text: '${employee.yearsInCompany} yrs',
                          color: theme.colorScheme.secondaryContainer,
                          textColor: theme.colorScheme.onSecondaryContainer,
                        ),
                        const SizedBox(width: 8),
                        _Badge(
                          text: employee.isActive ? 'Active' : 'Inactive',
                          color: employee.isActive
                              ? Colors.green.withValues(alpha: 0.2)
                              : Colors.red.withValues(alpha: 0.2),
                          textColor: employee.isActive
                              ? const Color(0xFF276749)
                              : const Color(0xFF9B2C2C),
                        ),
                        if (isLoyal) ...[
                          const SizedBox(width: 8),
                          _Badge(
                            text: '⭐ Loyal',
                            color: Colors.green.withValues(alpha: 0.15),
                            textColor: isDark
                                ? const Color(0xFF68D391)
                                : const Color(0xFF276749),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;

  const _Badge({
    required this.text,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
