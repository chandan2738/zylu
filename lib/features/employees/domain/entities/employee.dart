import 'package:equatable/equatable.dart';

class Employee extends Equatable {
  final String id;
  final String name;
  final String email;
  final String position;
  final DateTime joiningDate;
  final bool isActive;
  final String? profileImage;

  const Employee({
    required this.id,
    required this.name,
    required this.email,
    required this.position,
    required this.joiningDate,
    required this.isActive,
    this.profileImage,
  });

  int get yearsInCompany {
    final currentDate = DateTime.now();
    int years = currentDate.year - joiningDate.year;
    if (currentDate.month < joiningDate.month ||
        (currentDate.month == joiningDate.month &&
            currentDate.day < joiningDate.day)) {
      years--;
    }
    return years;
  }

  bool get isLoyalEmployee => yearsInCompany >= 5 && isActive;

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    position,
    joiningDate,
    isActive,
    profileImage,
  ];
}
