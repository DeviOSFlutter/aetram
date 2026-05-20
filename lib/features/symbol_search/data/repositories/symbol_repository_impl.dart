import 'package:aetram/features/symbol_search/data/datasources/symbol_remote_datasource.dart';
import 'package:aetram/features/symbol_search/domain/entities/symbol_entity.dart';
import 'package:aetram/features/symbol_search/domain/repositories/symbol_repository.dart';

class SymbolRepositoryImpl implements SymbolRepository {
  final SymbolRemoteDataSource _remoteDataSource;

  SymbolRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<SymbolEntity>> getSymbols() {
    return _remoteDataSource.getSymbols();
  }
}
