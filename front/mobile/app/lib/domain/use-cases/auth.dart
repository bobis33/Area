import '/data/models/data.dart';
import '/data/models/user.dart';
import '/domain/repositories/auth.dart';

class IsAuthenticated {
  final AuthRepository repository;

  IsAuthenticated(this.repository);

  Future<bool> execute() {
    return repository.isAuthenticated();
  }
}

class LoginUser {
  final AuthRepository repository;

  LoginUser(this.repository);

  Future<DataState<String>> execute(User user) {
    return repository.loginUser(user);
  }
}

class RegisterUser {
  final AuthRepository repository;

  RegisterUser(this.repository);

  Future<DataState<String>> execute(User user) {
    return repository.registerUser(user);
  }
}

class LinkToGoogle {
  final AuthRepository repository;

  LinkToGoogle(this.repository);

  Future<DataState<String>> execute(String googleToken) {
    return repository.linkToGoogle(googleToken);
  }
}
