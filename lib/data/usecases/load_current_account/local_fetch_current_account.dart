import '../../../domain/entities/account_entity.dart';
import '../../../domain/helpers/domain_error.dart';
import '../../../domain/usecases/load_current_account.dart';
import '../../cache/fetch_secure_cache_storage.dart';

class LocalLoadCurrentAccount implements LoadCurrentAccount{
  final FetchSecureCacheStorage fetchSecureCacheStorage;

  LocalLoadCurrentAccount(this.fetchSecureCacheStorage);

  @override
  Future<AccountEntity?> load() async {
    try {
      final String? token = await fetchSecureCacheStorage.fetch("token");

      if (token == null) throw Exception();

      return AccountEntity(token);
    } catch (e) {
      throw DomainError.unexpected;
    }
  }
}