import 'dart:async';
import 'package:sdm/models/goods_management_id.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/repository/goods_management_id_repository.dart';

class GoodMangementIdBloc {
  late GoodManagementIdRepository _goodManagementIdRepository;
  StreamController? _goodManagementIdController;

  StreamSink<ResponseList<GoodManagementID>> get goodManagementIdSink =>
      _goodManagementIdController!.sink as StreamSink<ResponseList<GoodManagementID>>;
  Stream<ResponseList<GoodManagementID>> get goodManagementIdStream =>
      _goodManagementIdController!.stream as Stream<ResponseList<GoodManagementID>>;

  // ignore: non_constant_identifier_names
  GoodMangementIdBloc() {
    _goodManagementIdController = StreamController<ResponseList<GoodManagementID>>.broadcast();
    _goodManagementIdRepository = GoodManagementIdRepository();
  }

  getGoodsManagementId(String organizationNummer) async {
    goodManagementIdSink.add(ResponseList.loading(''));
    try {
      List<GoodManagementID> res = await _goodManagementIdRepository.getGoodManagementID(organizationNummer);
      goodManagementIdSink.add(ResponseList.completed(res));
      print("GET COODS MANAGEMENT ID SUCCESSFULL");
    } catch (e) {
      goodManagementIdSink.add(ResponseList.error(e.toString()));
      print("GET COODS MANAGEMENT ID ID FAIL $e");
    }
  }

  dispose() {
    _goodManagementIdController?.close();
  }
}
