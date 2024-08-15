import 'dart:async';
import 'package:sdm/models/customer_type.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/repository/customer_type_repository.dart';

class CustomerTypeBloc {
  late CustomerTypeRepository _customerTypeRepository;
  StreamController? _customerTypeController;

  StreamSink<ResponseList<CustomerType>> get customerTypeSink =>
      _customerTypeController!.sink as StreamSink<ResponseList<CustomerType>>;
  Stream<ResponseList<CustomerType>> get customerTypeStream =>
      _customerTypeController!.stream as Stream<ResponseList<CustomerType>>;

  CustomerTypeBloc() {
    _customerTypeController = StreamController<ResponseList<CustomerType>>.broadcast();
    _customerTypeRepository = CustomerTypeRepository();
  }

  getCustomerType() async {
    if (_customerTypeController?.isClosed ?? true) return;
    customerTypeSink.add(ResponseList.loading(''));
    try {
      List<CustomerType> res = await _customerTypeRepository.getCustomerType();
      if (_customerTypeController?.isClosed ?? true) return;
      customerTypeSink.add(ResponseList.completed(res));

      print("CUSTOMER TYPE SUCCESS");
    } catch (e) {
      if (_customerTypeController?.isClosed ?? true) return;
      customerTypeSink.add(ResponseList.error(e.toString()));
      print("CUSTOMER TYPE ERROR $e");
    }
  }

  dispose() {
    _customerTypeController?.close();
  }
}
