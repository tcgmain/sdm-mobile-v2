// ignore_for_file: file_names

import 'dart:async';
import 'package:sdm/models/update_organization.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/repository/update_organization_repository.dart';

class UpdateOrganizationBloc {
  late UpdateOrganizationRepository _updateOrganizationRepository;
  StreamController? _updateOrganizationController;

  StreamSink<Response<UpdateOrganization>> get updateOrganizationSink =>
      _updateOrganizationController!.sink as StreamSink<Response<UpdateOrganization>>;
  Stream<Response<UpdateOrganization>> get updateOrganizationStream =>
      _updateOrganizationController!.stream as Stream<Response<UpdateOrganization>>;

  UpdateOrganizationBloc() {
    _updateOrganizationController = StreamController<Response<UpdateOrganization>>.broadcast();
    _updateOrganizationRepository = UpdateOrganizationRepository();
  }

  updateOrganization(
      id,
      email,
      ownerName,
      ownerBirthday,
      phone1,
      phone2,
      whatsapp,
      address1,
      address2,
      customerTypeId,
      isMasonry,
      isWaterproofing,
      isFlooring,
      organizationColor,
      superiorOrganization,
      territoryNummer,
      selCement,
      selTileAdhesive,
      selOtherWaterProofer,
      selCementWaterProofer,
      selSandMetal,
      selPaint,
      organizationCategory) async {
    if (_updateOrganizationController?.isClosed ?? true) return;
    updateOrganizationSink.add(Response.loading(''));
    try {
      UpdateOrganization res = await _updateOrganizationRepository.updateOrganization(
          id,
          email,
          ownerName,
          ownerBirthday,
          phone1,
          phone2,
          whatsapp,
          address1,
          address2,
          customerTypeId,
          isMasonry,
          isWaterproofing,
          isFlooring,
          organizationColor,
          superiorOrganization,
          territoryNummer,
          selCement,
          selTileAdhesive,
          selOtherWaterProofer,
          selCementWaterProofer,
          selSandMetal,
          selPaint,
          organizationCategory);
      if (_updateOrganizationController?.isClosed ?? true) return;
      updateOrganizationSink.add(Response.completed(res));
      print("UPDATE ORGANIZATION SUCCESS");
    } catch (e) {
      if (_updateOrganizationController?.isClosed ?? true) return;
      updateOrganizationSink.add(Response.error(e.toString()));
      print("UPDATE ORGANIZATION ERROR");
    }
  }

  updateSuperiorOrganization(organizationId, superiorOrganizationNummer) async {
    if (_updateOrganizationController?.isClosed ?? true) return;
    updateOrganizationSink.add(Response.loading(''));
    try {
      UpdateOrganization res =
          await _updateOrganizationRepository.updateSuperiorOrganization(organizationId, superiorOrganizationNummer);
      if (_updateOrganizationController?.isClosed ?? true) return;
      updateOrganizationSink.add(Response.completed(res));
      print("UPDATE SUPERIOR ORGANIZATION SUCCESS");
    } catch (e) {
      if (_updateOrganizationController?.isClosed ?? true) return;
      updateOrganizationSink.add(Response.error(e.toString()));
      print("UPDATE SUPERIOR ORGANIZATION ERROR");
    }
  }

  dispose() {
    _updateOrganizationController?.close();
  }
}
