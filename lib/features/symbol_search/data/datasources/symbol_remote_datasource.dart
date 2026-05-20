import 'package:aetram/core/network/api_constants.dart';
import 'package:aetram/core/network/dio_client.dart';
import 'package:aetram/features/symbol_search/data/models/symbol_model.dart';

class SymbolRemoteDataSource {
  final DioClient _dioClient;

  SymbolRemoteDataSource(this._dioClient);

  Future<List<SymbolModel>> getSymbols() async {
    final response = await _dioClient.get(ApiConstants.symbols);

    final List<dynamic> data = response.data['data'] ?? [];

    return data.map((json) => SymbolModel.fromJson(json)).toList();
  }
}
