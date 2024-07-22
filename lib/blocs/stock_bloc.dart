import 'dart:async';
import 'package:sdm/models/stock.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/repository/stock_repository.dart';

class StockBloc {
  late StockRepository _stockRepository;
  StreamController? _stockController;

  StreamSink<Response<Stock>> get stockSink => _stockController!.sink as StreamSink<Response<Stock>>;
  Stream<Response<Stock>> get stockStream => _stockController!.stream as Stream<Response<Stock>>;

  StockBloc() {
    _stockController = StreamController<Response<Stock>>.broadcast();
    _stockRepository = StockRepository();
  }

  //Getting stock response
  getProductStock(String userNummer, String organizationNummer) async {
    stockSink.add(Response.loading(''));
    try {
      Stock res = await _stockRepository.getProductStock(userNummer, organizationNummer);
      if (!_stockController!.isClosed) {
        stockSink.add(Response.completed(res));
      }

      print("GET STOCK SUCCESS");
    } catch (e) {
      if (!_stockController!.isClosed) {
        stockSink.add(Response.error(e.toString()));
      }

      print("GET STOCK ERROR");
      print(e);
    }
  }

  dispose() {
    _stockController?.close();
  }
}
