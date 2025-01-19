import '/data/models/data.dart';
import '/data/models/user.dart';

abstract class AuthRepository {
  Future<bool> isAuthenticated();
  Future<DataState<String>> loginUser(User user);
  Future<DataState<String>> registerUser(User user);
  Future<DataState<String>> linkToGoogle(String googleToken);
  Future<DataState<String>> linkTo(String endpoint);
}
