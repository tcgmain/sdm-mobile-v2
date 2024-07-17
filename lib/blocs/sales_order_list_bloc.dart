import 'dart:async';
import 'package:sdm/models/sales_order.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/repository/sales_order_list_repository.dart';

class SalesOrderListBloc {
  late SalesOrderListRepository _salesOrderListRepository;
  StreamController? _salesOrderListController;

  StreamSink<ResponseList<SalesOrder>> get salesOrderListSink =>
      _salesOrderListController!.sink as StreamSink<ResponseList<SalesOrder>>;
  Stream<ResponseList<SalesOrder>> get salesOrderListStream =>
      _salesOrderListController!.stream as Stream<ResponseList<SalesOrder>>;

  SalesOrderListBloc() {
    _salesOrderListController = StreamController<ResponseList<SalesOrder>>.broadcast();
    _salesOrderListRepository = SalesOrderListRepository();
  }

  getSalesOrderList(String salesOrderType, String organizationNummer) async {
    //Sales Order Types = IN / OUT
    salesOrderListSink.add(ResponseList.loading(''));
    try {
      if (salesOrderType == "IN") {
        List<SalesOrder> res = await _salesOrderListRepository.getSalesOrderInList(organizationNummer);
        salesOrderListSink.add(ResponseList.completed(res));

        print("SALES ORDER IN LIST SUCCESS");
      } else {
        List<SalesOrder> res = await _salesOrderListRepository.getSalesOrderOutList(organizationNummer);
        salesOrderListSink.add(ResponseList.completed(res));

        print("SALES ORDER OUT LIST SUCCESS");
      }
    } catch (e) {
      salesOrderListSink.add(ResponseList.error(e.toString()));
      print("SALES ORDER In / OUT LIST ERROR $e");
    }
  }

  dispose() {
    _salesOrderListController?.close();
  }
}
