import 'dart:async';
import 'package:sdm/models/sales_order.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/repository/sales_order_list_repository.dart';

class SalesOrderListBloc {
  late SalesOrderListRepository _salesOrderListRepository;
  StreamController? _salesOrderListController;

  StreamSink<ResponseList<SalesOrder>> get salesOrderListSink => _salesOrderListController!.sink as StreamSink<ResponseList<SalesOrder>>;
  Stream<ResponseList<SalesOrder>> get salesOrderListStream =>  _salesOrderListController!.stream as Stream<ResponseList<SalesOrder>>;

  SalesOrderListBloc() {
    _salesOrderListController = StreamController<ResponseList<SalesOrder>>.broadcast();
    _salesOrderListRepository = SalesOrderListRepository();
  }

  getSalesOrderInList(String organizationNummer) async {
    // Sales Order Types = IN / OUT
    if (_salesOrderListController?.isClosed ?? true) return;
    salesOrderListSink.add(ResponseList.loading(''));
    try {
      List<SalesOrder> res = await _salesOrderListRepository.getSalesOrderInList(organizationNummer);
      print("SALES ORDER IN LIST SUCCESS");
      if (_salesOrderListController?.isClosed ?? true) return;
      salesOrderListSink.add(ResponseList.completed(res));
    } catch (e) {
      salesOrderListSink.add(ResponseList.error(e.toString()));
      print("SALES ORDER IN / OUT LIST ERROR: $e");
    }
  }

  getSalesOrderOutList(String organizationNummer) async {
    // Sales Order Types = IN / OUT
    if (_salesOrderListController?.isClosed ?? true) return;
    salesOrderListSink.add(ResponseList.loading(''));
    try {
      List<SalesOrder> res = await _salesOrderListRepository.getSalesOrderOutList(organizationNummer);
      print("SALES ORDER IN LIST SUCCESS");
      if (_salesOrderListController?.isClosed ?? true) return;
      salesOrderListSink.add(ResponseList.completed(res));
    } catch (e) {
      salesOrderListSink.add(ResponseList.error(e.toString()));
      print("SALES ORDER IN / OUT LIST ERROR: $e");
    }
  }

  void dispose() {
    _salesOrderListController?.close();
  }
}
