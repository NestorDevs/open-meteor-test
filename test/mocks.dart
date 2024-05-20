import 'package:mocktail/mocktail.dart';
import 'package:open_meteor/app/features/authentication/auth_module.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class Listener<T> extends Mock {
  void call(T? previous, T next);
}
