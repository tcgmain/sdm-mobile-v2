import 'package:flutter/material.dart';
import 'package:sdm/blocs/sub_organization_bloc.dart';
import 'package:sdm/models/sub_organization.dart';

class SubOrganizationView extends StatefulWidget {
  const SubOrganizationView({super.key});

  @override
  State<SubOrganizationView> createState() => _SubOrganizationViewState();
}

class _SubOrganizationViewState extends State<SubOrganizationView> {

    late SubOrganizationBloc _subOrganizationBloc;
  final TextEditingController _searchController = TextEditingController();
  List<SubOrganization>? _filteredSubOrganizations;
  List<SubOrganization>? _allSubOrganizations;

  @override
  void initState() {
    super.initState();
    _subOrganizationBloc = SubOrganizationBloc();
    _subOrganizationBloc.getSubOrganization('');
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _subOrganizationBloc.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _filteredSubOrganizations = _allSubOrganizations
          ?.where((organization) => organization.namebspr!.toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }


  @override
  Widget build(BuildContext context) {
     return Scaffold(
      body: Text("This is sub organization page"),
    );
  }
}