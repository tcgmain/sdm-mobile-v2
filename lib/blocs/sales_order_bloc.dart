import 'dart:async';
import 'package:sdm/models/sales_order.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/repository/sales_order_repository.dart';

class SalesOrderBloc {
  late SalesOrderRepository _salesOrderRepository;
  StreamController? _salesOrderController;

  StreamSink<ResponseList<SalesOrder>> get salesOrderSink =>
      _salesOrderController!.sink as StreamSink<ResponseList<SalesOrder>>;
  Stream<ResponseList<SalesOrder>> get salesOrderStream =>
      _salesOrderController!.stream as Stream<ResponseList<SalesOrder>>;

  SalesOrderBloc() {
    _salesOrderController = StreamController<ResponseList<SalesOrder>>.broadcast();
    _salesOrderRepository = SalesOrderRepository();
  }

  getSalesOrder(String salesOrderType, String salesOrderNummer, String organizationNummer) async {
    //Sales Order Types = IN / OUT
    salesOrderSink.add(ResponseList.loading(''));
    try {
      if (salesOrderType == "IN") {
        List<SalesOrder> res = await _salesOrderRepository.getSalesOrderIn(organizationNummer, salesOrderNummer);
        salesOrderSink.add(ResponseList.completed(res));

        print("SALES ORDER IN SUCCESS");
      } else {
        List<SalesOrder> res = await _salesOrderRepository.getSalesOrderOut(organizationNummer, salesOrderNummer);
        salesOrderSink.add(ResponseList.completed(res));

        print("SALES ORDER OUT SUCCESS");
      }
    } catch (e) {
      salesOrderSink.add(ResponseList.error(e.toString()));
      print("SALES ORDER In / OUT ERROR $e");
    }
  }

  dispose() {
    _salesOrderController?.close();
  }
}
