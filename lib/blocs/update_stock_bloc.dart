import 'dart:async';
import 'package:sdm/models/update_stock.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/repository/update_stock_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateStockBloc {
  late UpdateStockRepository _updateStockRepository;
  final StreamController<Response<UpdateStock>> _updateStockController =
      StreamController<Response<UpdateStock>>.broadcast();

  StreamSink<Response<UpdateStock>> get updateStockSink => _updateStockController.sink;
  Stream<Response<UpdateStock>> get updateStockStream => _updateStockController.stream;

  UpdateStockBloc() {
    _updateStockRepository = UpdateStockRepository();
  }

  updateStock(String id, String date, String productnummer, String stock, String visitNummer) async {
    updateStockSink.add(Response.loading('Loading...'));
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String username = prefs.getString('username') ?? 'Guest';


      UpdateStock res = await _updateStockRepository.updateStock(id, date, productnummer, stock, username, visitNummer);
      updateStockSink.add(Response.completed(res));
      print("STOCK UPDATE SUCCESS");
    } catch (e) {
      updateStockSink.add(Response.error(e.toString()));
      print("STOCK UPDATE FAIL $e");
    }
  }

  dispose() {
    _updateStockController.close();
  }
}
