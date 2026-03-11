import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final DateTime? lastLogin;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.lastLogin,
  });

  @override
  List<Object?> get props => [id, name, email, photoUrl, lastLogin];
}
