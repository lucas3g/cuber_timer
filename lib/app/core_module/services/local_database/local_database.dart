import 'params/local_database_params.dart';

abstract class ILocalDatabase {
  Future<dynamic> get({required GetDataParams params});
  Future<bool> updateOrInsert({required UpdateOrInsertDataParams params});
  Future<bool> remove({required RemoveDataParams params});
}
