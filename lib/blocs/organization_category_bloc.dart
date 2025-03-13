import 'dart:async';
import 'package:sdm/models/organization_category.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/repository/organization_category_repository.dart';

class OrganizationCategoryBloc {
  late OrganizationCategoryRepository _organizationCategoryRepository;
  StreamController? _organizationCategoryController;

  StreamSink<ResponseList<OrganizationCategory>> get organizationCategorySink =>
      _organizationCategoryController!.sink as StreamSink<ResponseList<OrganizationCategory>>;
  Stream<ResponseList<OrganizationCategory>> get organizationCategoryStream =>
      _organizationCategoryController!.stream as Stream<ResponseList<OrganizationCategory>>;

  OrganizationCategoryBloc() {
    _organizationCategoryController = StreamController<ResponseList<OrganizationCategory>>.broadcast();
    _organizationCategoryRepository = OrganizationCategoryRepository();
  }

  getOrganizationCategory() async {
    if (_organizationCategoryController?.isClosed ?? true) return;
    organizationCategorySink.add(ResponseList.loading(''));
    try {
      List<OrganizationCategory> res = await _organizationCategoryRepository.getOrganizationCategory();
      if (_organizationCategoryController?.isClosed ?? true) return;
      organizationCategorySink.add(ResponseList.completed(res));

      print("ORGANIZATION CATEGORY SUCCESS");
    } catch (e) {
      if (_organizationCategoryController?.isClosed ?? true) return;
      organizationCategorySink.add(ResponseList.error(e.toString()));
      print("ORGANIZATION CATEGORY ERROR $e");
    }
  }

  dispose() {
    _organizationCategoryController?.close();
  }
}
