import '../entities/symbol_entity.dart';

abstract class SymbolRepository {
  Future<List<SymbolEntity>> getSymbols();
}
