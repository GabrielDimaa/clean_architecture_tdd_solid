import 'package:clean_architecture_tdd_solid/domain/usecases/add_account.dart';
import 'package:clean_architecture_tdd_solid/domain/usecases/authentication.dart';
import 'package:faker/faker.dart';

abstract class FakeParamsFactory {
  static AddAccountParams makeAddAccount() => AddAccountParams(
    name: faker.person.name(),
    email: faker.internet.email(),
    password: faker.internet.password(),
    passwordConfirmation: faker.internet.password(),
  );

  static AuthenticationParams makeAuthentication() => AuthenticationParams(email: faker.internet.email(), password: faker.internet.password());
}