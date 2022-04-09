import 'package:clean_architecture_tdd_solid/domain/entities/account_entity.dart';
import 'package:faker/faker.dart';

abstract class FakeAccountFactory {
  static Map makeApiJson() => {
    'accessToken': faker.guid.guid(),
    'name': faker.person.name(),
  };

  static AccountEntity makeEntity() => AccountEntity(faker.guid.guid());
}