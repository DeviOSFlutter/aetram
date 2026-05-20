import 'package:aetram/features/symbol_search/domain/entities/symbol_entity.dart';
import 'package:aetram/features/symbol_search/domain/repositories/symbol_repository.dart';

class GetSymbolsUseCase {
  final SymbolRepository _repository;

  GetSymbolsUseCase(this._repository);

  Future<List<SymbolEntity>> call() {
    return _repository.getSymbols();
  }
}