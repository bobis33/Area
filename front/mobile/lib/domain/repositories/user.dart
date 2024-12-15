import '/data/models/data.dart';
import '/data/models/user.dart';

abstract class UserRepository {
  Future<DataState<User>> getUser();
  Future<DataState<String>> updateUsername(String username);
  Future<DataState<String>> updatePassword(String password);
  Future<DataState<String>> updateEmail(String email);
}
