import 'dart:async';
import 'package:sdm/models/create_so.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/repository/create_so_repository.dart';

class CreateSoBloc {
  late CreateSoRepository _createSoRepository;
  StreamController? _createSoController;

  StreamSink<Response<CreateSO>> get createSoSink => _createSoController!.sink as StreamSink<Response<CreateSO>>;
  Stream<Response<CreateSO>> get createSoStream => _createSoController!.stream as Stream<Response<CreateSO>>;

  CreateSoBloc() {
    _createSoController = StreamController<Response<CreateSO>>.broadcast();
    _createSoRepository = CreateSoRepository();
  }

  createSO(String userNummer, String date, String organizationFromNummer, String organizationToNummer, orderedList) async {
    if (_createSoController?.isClosed ?? true) return;
    createSoSink.add(Response.loading(''));
    try {
      CreateSO res = await _createSoRepository.createSO(userNummer, date, organizationFromNummer, organizationToNummer, orderedList);
      if (_createSoController?.isClosed ?? true) return;
      createSoSink.add(Response.completed(res));

     
      print("CREATE SO SUCCESS");
    } 
    
    catch (e) {
      if (_createSoController?.isClosed ?? true) return;
      createSoSink.add(Response.error(e.toString()));
      print("CREATE SO ERROR");
      print(e);
    }
  }

  dispose() {
    _createSoController?.close();
  }
}
