import '../auth_module.dart';

class UserModel extends AppUser {
  UserModel({
    required super.uid,
    required super.email,
    required this.password,
  });

  final String password;
}
