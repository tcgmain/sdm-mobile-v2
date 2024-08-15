// ignore_for_file: file_names

import 'dart:async';
import 'package:sdm/models/add_goods_management.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/repository/add_goods_management_repository.dart';

class AddGoodsManagementBloc {
  late AddGoodsManagementRepository _addGoodsManagementRepository;
  StreamController? _addGoodsManagementController;

  StreamSink<Response<AddGoodsManagement>> get addGoodsManagementSink =>
      _addGoodsManagementController!.sink as StreamSink<Response<AddGoodsManagement>>;
  Stream<Response<AddGoodsManagement>> get addGoodsManagementStream =>
      _addGoodsManagementController!.stream as Stream<Response<AddGoodsManagement>>;

  AddGoodsManagementBloc() {
    _addGoodsManagementController = StreamController<Response<AddGoodsManagement>>.broadcast();
    _addGoodsManagementRepository = AddGoodsManagementRepository();
  }

  addGoodsManagement(
    String goodsManagementSearchWord,
    String organizationNummer,
  ) async {
    if (_addGoodsManagementController?.isClosed ?? true) return;
    addGoodsManagementSink.add(Response.loading(''));
    try {
      AddGoodsManagement res =
          await _addGoodsManagementRepository.addGoodsManagement(goodsManagementSearchWord, organizationNummer);
      if (_addGoodsManagementController?.isClosed ?? true) return;
      addGoodsManagementSink.add(Response.completed(res));
      print("ADD GOODS MANAGEMENT SUCCESS");
    } catch (e) {
      if (_addGoodsManagementController?.isClosed ?? true) return;
      addGoodsManagementSink.add(Response.error(e.toString()));
      print("ADD GOODS MANAGEMENT ERROR");
    }
  }

  dispose() {
    _addGoodsManagementController?.close();
  }
}
