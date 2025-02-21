// ignore_for_file: file_names

import 'dart:async';
import 'package:sdm/models/update_organization.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/repository/update_organization_location_repository.dart';

class UpdateOrganizationLocationBloc {
  late UpdateOrganizationLocationRepository _updateOrganizationLocationRepository;
  StreamController? _updateOrganizationLocationController;

  StreamSink<Response<UpdateOrganization>> get updateOrganizationLocationSink =>
      _updateOrganizationLocationController!.sink as StreamSink<Response<UpdateOrganization>>;
  Stream<Response<UpdateOrganization>> get updateOrganizationLocationStream =>
      _updateOrganizationLocationController!.stream as Stream<Response<UpdateOrganization>>;

  UpdateOrganizationLocationBloc() {
    _updateOrganizationLocationController = StreamController<Response<UpdateOrganization>>.broadcast();
    _updateOrganizationLocationRepository = UpdateOrganizationLocationRepository();
  }

  updateOrganizationLocation(id, longitude, latitude, currentTownNummer, updatedBy, updatedOn) async {
    if (_updateOrganizationLocationController?.isClosed ?? true) return;
    updateOrganizationLocationSink.add(Response.loading(''));
    try {
      UpdateOrganization res = await _updateOrganizationLocationRepository.updateOrganizationLocation(
        id,
        longitude,
        latitude, 
        currentTownNummer, 
        updatedBy, 
        updatedOn
      );
      if (_updateOrganizationLocationController?.isClosed ?? true) return;
      updateOrganizationLocationSink.add(Response.completed(res));
      print("UPDATE ORGANIZATION LOCATION SUCCESS");
    } catch (e) {
      if (_updateOrganizationLocationController?.isClosed ?? true) return;
      updateOrganizationLocationSink.add(Response.error(e.toString()));
      print("UPDATE ORGANIZATION LOCATION ERROR");
    }
  }

  dispose() {
    _updateOrganizationLocationController?.close();
  }
}