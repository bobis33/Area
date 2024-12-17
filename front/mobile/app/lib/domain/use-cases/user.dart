import '/data/models/user.dart';
import '/data/models/data.dart';
import '/domain/repositories/user.dart';

class GetUser {
  final UserRepository repository;

  GetUser(this.repository);

  Future<DataState<User>> execute() {
    return repository.getUser();
  }
}

class UpdateUsername {
  final UserRepository repository;

  UpdateUsername(this.repository);

  Future<DataState<String>> execute(String username) {
    return repository.updateUsername(username);
  }
}

class UpdatePassword {
  final UserRepository repository;

  UpdatePassword(this.repository);

  Future<DataState<String>> execute(String password) {
    return repository.updatePassword(password);
  }
}

class UpdateEmail {
  final UserRepository repository;

  UpdateEmail(this.repository);

  Future<DataState<String>> execute(String email) {
    return repository.updateEmail(email);
  }
}
