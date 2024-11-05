// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:async';
import 'dart:math';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:sdm/blocs/add_goods_management_bloc.dart';
import 'package:sdm/blocs/add_organization_bloc.dart';
import 'package:sdm/blocs/customer_type_bloc.dart';
import 'package:sdm/blocs/organization_bloc.dart';
import 'package:sdm/blocs/route_list_bloc.dart';
import 'package:sdm/blocs/update_route_bloc.dart';
import 'package:sdm/models/add_goods_management.dart';
import 'package:sdm/models/add_organization.dart';
import 'package:sdm/models/customer_type.dart';
import 'package:sdm/models/organization.dart';
import 'package:sdm/models/route_list.dart';
import 'package:sdm/models/update_route.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/utils/constants.dart';
import 'package:sdm/utils/validations.dart';
import 'package:sdm/widgets/app_button.dart';
import 'package:sdm/widgets/appbar.dart';
import 'package:sdm/widgets/background_decoration.dart';
import 'package:sdm/widgets/date_picker_calender_2.dart';
import 'package:sdm/widgets/error_alert.dart';
import 'package:sdm/widgets/loading.dart';
import 'package:sdm/widgets/success_alert.dart';
import 'package:geolocator/geolocator.dart';

class AddOrganizationView extends StatefulWidget {
  final String userNummer;
  final String username;
  final String userOrganizationNummer;
  final String loggedUserNummer;
  final bool isTeamMemberUi;

  const AddOrganizationView({
    super.key,
    required this.userNummer,
    required this.username,
    required this.userOrganizationNummer,
    required this.loggedUserNummer,
    required this.isTeamMemberUi,
  });

  @override
  State<AddOrganizationView> createState() => _AddOrganizationViewState();
}

class _AddOrganizationViewState extends State<AddOrganizationView> {
  late CustomerTypeBloc _customerTypeBloc;
  late OrganizationBloc _organizationBloc;
  late OrganizationBloc _superiorOrganizationBloc;
  late AddOrganizationBloc _addOrganizationBloc;
  late AddGoodsManagementBloc _addGoodsManagementBloc;
  late RouteListBloc _routeListBloc;
  late UpdateRouteBloc _updateRouteBloc;
  List<CustomerType>? _allCustomerTypes;
  late String latitude;
  late String longitude;
  bool _isSuccessMessageShown = false;
  bool _isFinalSuccessMessageShown = false;
  bool _isAddGoodsManagementAPICall = false;
  bool _isAddOrganizationErrorMessageShown = false;
  bool _isNearbyOrganizationErrorMessageShown = false;
  final bool _isCustomerTypeErrorMessageShown = false;
  bool _isNearbyOrganizationPopupShown = false;
  late String organizationNummer;
  late String organizationSearchWord;
  bool _isUpdateLoading = false;
  bool _isSuperiorOrganizationLoading = false;
  bool _isSuperiorOrganizationErrorShown = false;
  bool _isGoodsManagementSuccessShown = false;
  bool _isCustomerTypeLoading = false;
  bool _isRouteLoading = false;
  bool _isUpdateRouteLoading = false;
  bool _isUpdateRouteErrorShown = false;
  bool _isLoadingNearlyOrganizations = false;
  bool _isSubmitPressed = false;
  String organizationType = "";
  String organizationColor = "";

  List<Organization> _superiorOrganizations = [];
  List<RouteList> _routeList = [];
  bool _isRouteErrorShown = false;
  Organization? _selectedSuperiorOrganization;
  bool _isOrganizationsLoaded = false;
  bool _isRoutesLoaded = false;
  bool _isUpdateRouteCompleted = false;
  bool _isUpdateOrganizationCompleted = false;
  RouteList? _selectedRoute;
  bool _isUpdateRouteLoaded = false;

  final _formKey = GlobalKey<FormState>();
  String? _selectedCustomerType;
  int? _selectedCustomerTypeIndex;
  final _nameController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final TextEditingController _ownerBirthdayController = TextEditingController();
  final _emailController = TextEditingController();
  final _phone1Controller = TextEditingController();
  final _phone2Controller = TextEditingController();
  final _whatsappController = TextEditingController();
  final _address1Controller = TextEditingController();
  final _address2Controller = TextEditingController();
  final _address3Controller = TextEditingController();
  final _townController = TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _ownerNameFocusNode = FocusNode();
  final FocusNode _ownerBirthdayFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phone1FocusNode = FocusNode();
  final FocusNode _phone2FocusNode = FocusNode();
  final FocusNode _whatsappFocusNode = FocusNode();
  final FocusNode _address1FocusNode = FocusNode();
  final FocusNode _address2FocusNode = FocusNode();
  final FocusNode _address3FocusNode = FocusNode();
  final FocusNode _townFocusNode = FocusNode();

  bool isMasonry = false;
  bool isWaterproofing = false;
  bool isFlooring = false;

  final Map<String, bool?> _validationStatus = {
    'name': null,
    'email': null,
    'phone1': null,
    'phone2': null,
    'whatsapp': null,
    'address1': null,
    'address2': null,
    'address3': null,
    'town': null,
  };

  final Map<String, String?> _validationMessages = {
    'name': null,
    'email': null,
    'phone1': null,
    'phone2': null,
    'whatsapp': null,
    'address1': null,
    'address2': null,
    'address3': null,
    'town': null,
  };

  Future<void> _getCurrentLocation() async {
    // Check if location services are enabled
    if (!await Geolocator.isLocationServiceEnabled()) {
      // Only call setState here if you need to update the UI
      setState(() {});
      return;
    }

    // Check and request location permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        // Only call setState here if you need to show permission warning UI
        setState(() {});
        return;
      }
    }

    // Use last known position as fallback for faster retrieval if available
    Position? position = await Geolocator.getLastKnownPosition();
    position ??= await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    // Avoid calling setState if latitude and longitude don’t affect UI immediately
    latitude = position.latitude.toString();
    longitude = position.longitude.toString();

    calculateLatLngRange(position.latitude, position.longitude, 100);
  }

  void calculateLatLngRange(double lat, double lon, double distanceInMeters) {
    const double earthRadius = 6371.0;
    const double degreeToRad = pi / 180;
    const double latAdjustment = earthRadius * degreeToRad;

    double distanceInKm = distanceInMeters / 1000.0;
    double latRange = distanceInKm / latAdjustment;
    double lonRange = distanceInKm / (latAdjustment * cos(lat * degreeToRad));

    // Minimize calls to bloc by processing only when necessary
    _organizationBloc.getOrganizationByLocation(
      (lon - lonRange).toString(),
      (lon + lonRange).toString(),
      (lat - latRange).toString(),
      (lat + latRange).toString(),
    );
  }

  getNearlyOrganizationsResponse() {
    return StreamBuilder<ResponseList<Organization>>(
      stream: _organizationBloc.organizationStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();

        switch (snapshot.data!.status!) {
          case Status.LOADING:
            if (!_isLoadingNearlyOrganizations) {
              _isLoadingNearlyOrganizations = true;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {});
              });
            }
            break;

          case Status.COMPLETED:
            if (_isLoadingNearlyOrganizations) {
              _isLoadingNearlyOrganizations = false;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {});
              });
            }

            List<Organization>? nearByOrganizations = snapshot.data!.data;
            if (nearByOrganizations != null && nearByOrganizations.isNotEmpty && !_isNearbyOrganizationPopupShown) {
              _isNearbyOrganizationPopupShown = true;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showNearbyOrganizationsPopup(context, nearByOrganizations);
              });
            }
            break;

          case Status.ERROR:
            if (!_isNearbyOrganizationErrorMessageShown) {
              _isNearbyOrganizationErrorMessageShown = true;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _isLoadingNearlyOrganizations = false;
                });
                showErrorAlertDialog(context, snapshot.data!.message.toString());
              });
            }
            break;
        }
        return Container();
      },
    );
  }

  String capitalizeWords(String input) {
    if (input.isEmpty) return input;
    return input.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  void clearFormFields() {
    _nameController.clear();
    _ownerNameController.clear();
    _emailController.clear();
    _phone1Controller.clear();
    _phone2Controller.clear();
    _whatsappController.clear();
    _address1Controller.clear();
    _address2Controller.clear();
    _address3Controller.clear();
    _townController.clear();

    _selectedCustomerType = null;
    _selectedCustomerTypeIndex = null; // Reset the toggle buttons selection

    _validationStatus.updateAll((key, value) => null);
    _validationMessages.updateAll((key, value) => null);

    organizationType = "";
    organizationColor = "";

    _selectedSuperiorOrganization = null;
    _selectedRoute = null;

    _isSubmitPressed = false;
  }

  @override
  void initState() {
    super.initState();
    _superiorOrganizationBloc = OrganizationBloc();
    _customerTypeBloc = CustomerTypeBloc();
    _addOrganizationBloc = AddOrganizationBloc();
    _addGoodsManagementBloc = AddGoodsManagementBloc();
    _organizationBloc = OrganizationBloc();
    _routeListBloc = RouteListBloc();
    _updateRouteBloc = UpdateRouteBloc();

    _customerTypeBloc.getCustomerType();
    _getCurrentLocation();

    _superiorOrganizationBloc.getOrganizationByType("Distributor");
    _routeListBloc.getRouteList("");
    setState(() {
      _isSuperiorOrganizationLoading = true;
      _isRouteLoading = true;
      _isLoadingNearlyOrganizations = true;
    });
  }

  @override
  void dispose() {
    _customerTypeBloc.dispose();
    _addOrganizationBloc.dispose();
    _addGoodsManagementBloc.dispose();
    _nameController.dispose();
    _ownerNameController.dispose();
    _ownerBirthdayController.dispose();
    _emailController.dispose();
    _phone1Controller.dispose();
    _phone2Controller.dispose();
    _whatsappController.dispose();
    _address1Controller.dispose();
    _address2Controller.dispose();
    _address3Controller.dispose();
    _townController.dispose();
    _nameFocusNode.dispose();
    _ownerNameFocusNode.dispose();
    _ownerBirthdayFocusNode.dispose();
    _emailFocusNode.dispose();
    _phone1FocusNode.dispose();
    _phone2FocusNode.dispose();
    _whatsappFocusNode.dispose();
    _address1FocusNode.dispose();
    _address2FocusNode.dispose();
    _address3FocusNode.dispose();
    _townFocusNode.dispose();
    _organizationBloc.dispose();
    _superiorOrganizationBloc.dispose();
    _routeListBloc.dispose();
    _updateRouteBloc.dispose();
    super.dispose();
  }

  void _validateField(String fieldName) {
    _isSuccessMessageShown = true;
    _isAddOrganizationErrorMessageShown = true;
    setState(() {
      switch (fieldName) {
        case 'name':
          _validationMessages['name'] = _validateName(_nameController.text);
          _validationStatus['name'] = _validationMessages['name'] == null;
          break;
        case 'ownerName':
          _validationMessages['ownerName'] = null;
          _validationStatus['ownerName'] = true;
          break;
        case 'ownerBirthday':
          _validationMessages['ownerBirthday'] = null;
          _validationStatus['ownerBirthday'] = true;
          break;
        case 'email':
          _validationMessages['email'] = _validateEmail(_emailController.text);
          _validationStatus['email'] = _validationMessages['email'] == null;
          break;
        case 'phone1':
          _validationMessages['phone1'] = _validatePhone1(_phone1Controller.text);
          _validationStatus['phone1'] = _validationMessages['phone1'] == null;
          break;
        case 'phone2':
          _validationMessages['phone2'] = _validatePhone2(_phone2Controller.text);
          _validationStatus['phone2'] = _validationMessages['phone2'] == null;
          break;
        case 'whatsapp':
          _validationMessages['whatsapp'] = _validateWhatsapp(_whatsappController.text);
          _validationStatus['whatsapp'] = _validationMessages['whatsapp'] == null;
          break;
        case 'address1':
          _validationMessages['address1'] = _validateAddress1(_address1Controller.text);
          _validationStatus['address1'] = _validationMessages['address1'] == null;
          break;
        case 'address2':
          _validationMessages['address2'] = _validateAddress2(_address2Controller.text);
          _validationStatus['address2'] = _validationMessages['address2'] == null;
          break;
        case 'address3':
          _validationMessages['address3'] = null;
          _validationStatus['address3'] = true;
          break;
        case 'town':
          _validationMessages['town'] = _validateTown(_townController.text);
          _validationStatus['town'] = _validationMessages['town'] == null;
          break;
      }
    });
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a name';
    }
    return null;
  }

  String? _validateAddress1(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter address line 1';
    }
    return null;
  }

  String? _validateAddress2(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter address line 2';
    }
    return null;
  }

  String? _validateTown(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter town';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value!.isNotEmpty && !value.isValidEmail) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePhone1(String? value) {
    final phoneRegExp = RegExp(r'^\+?[0-9]{7,15}$');

    if (value == null || value.isEmpty) {
      return 'Please enter phone 1';
    } else if (value.isNotEmpty && !phoneRegExp.hasMatch(value)) {
      return 'Please enter a valid number';
    }
    return null;
  }

  String? _validatePhone2(String? value) {
    final phoneRegExp = RegExp(r'^\+?[0-9]{7,15}$');

    if (value!.isNotEmpty && !phoneRegExp.hasMatch(value)) {
      return 'Please enter a valid number';
    }
    return null;
  }

  String? _validateWhatsapp(String? value) {
    final phoneRegExp = RegExp(r'^\+?[0-9]{7,15}$');

    if (value!.isNotEmpty && !phoneRegExp.hasMatch(value)) {
      return 'Please enter a valid whatsapp number';
    }
    return null;
  }

  //Validate Customer Type
  String? _validateCustomerType() {
    if (_selectedCustomerType == null) {
      return 'Please select an organization type';
    }
    return null;
  }

  //Create Search word
  String getSearchWord(String name) {
    return name.toUpperCase().replaceAll(' ', '_');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Add Organizations',
        onBackButtonPressed: () {
          Navigator.pop(context, true);
        },
        isHomePage: false,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            BackgroundImage(
              isTeamMemberUi: widget.isTeamMemberUi,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1),
                  gradient: LinearGradient(
                    colors: [
                      Colors.grey.shade400,
                      Colors.white,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          getNearlyOrganizationsResponse(),
                          getSuperiorOrganizationResponse(),
                          getRouteResponse(),
                          addOrganizationResponse(),
                          updateRouteResponse(),
                          addGoodsManagementResponse(),
                          customerTypeToggleButtons(),
                          if (_validateCustomerType() != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  _validateCustomerType()!,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                            ),
                          if (organizationType == "Project") const SizedBox(height: 20),
                          if (organizationType == "Project")
                            const Align(
                                alignment: Alignment.centerLeft,
                                child:
                                    Text('Contractor Details', style: TextStyle(color: CustomColors.cardTextColor1))),
                          if (organizationType == "Project") const SizedBox(height: 8),
                          if (organizationType == "Project")
                            _buildToggleSwitch('Masonry', isMasonry, (value) {
                              setState(() {
                                isMasonry = value;
                              });
                            }),
                          if (organizationType == "Project")
                            _buildToggleSwitch('Waterproofing', isWaterproofing, (value) {
                              setState(() {
                                isWaterproofing = value;
                              });
                            }),
                          if (organizationType == "Project")
                            _buildToggleSwitch('Flooring', isFlooring, (value) {
                              setState(() {
                                isFlooring = value;
                              });
                            }),
                          const SizedBox(height: 16),
                          _buildValidatedTextFormField(
                            controller: _nameController,
                            label: 'Name',
                            fieldName: 'name',
                            focusNode: _nameFocusNode,
                            validator: _validateName,
                          ),
                          const SizedBox(height: 16),
                          _buildValidatedTextFormField(
                            controller: _ownerNameController,
                            label: 'Owner Name',
                            fieldName: 'ownerName',
                            focusNode: _ownerNameFocusNode,
                            validator: (value) => null,
                          ),
                          const SizedBox(height: 16),
                          CustomDatePicker.buildDateSelectionFormField(
                            controller: _ownerBirthdayController,
                            label: 'Owner Birthday',
                            fieldName: 'ownerBirthday',
                            focusNode: _ownerBirthdayFocusNode,
                            context: context,
                            validator: (value) => null,
                            validateField: _validateField,
                            validationStatus: _validationStatus,
                          ),
                          const SizedBox(height: 16),
                          _buildValidatedTextFormField(
                            controller: _emailController,
                            label: 'E-mail',
                            fieldName: 'email',
                            keyboardType: TextInputType.emailAddress,
                            focusNode: _emailFocusNode,
                            validator: _validateEmail,
                          ),
                          const SizedBox(height: 16),
                          _buildValidatedTextFormField(
                            controller: _phone1Controller,
                            label: 'Phone 1',
                            fieldName: 'phone1',
                            keyboardType: TextInputType.phone,
                            focusNode: _phone1FocusNode,
                            validator: _validatePhone1,
                          ),
                          const SizedBox(height: 16),
                          _buildValidatedTextFormField(
                            controller: _phone2Controller,
                            label: 'Phone 2',
                            fieldName: 'phone2',
                            keyboardType: TextInputType.phone,
                            focusNode: _phone2FocusNode,
                            validator: _validatePhone2,
                          ),
                          const SizedBox(height: 16),
                          _buildValidatedTextFormField(
                            controller: _whatsappController,
                            label: 'Whatsapp',
                            fieldName: 'whatsapp',
                            keyboardType: TextInputType.phone,
                            focusNode: _whatsappFocusNode,
                            validator: _validateWhatsapp,
                          ),
                          const SizedBox(height: 16),
                          _buildValidatedTextFormField(
                            controller: _address1Controller,
                            label: 'Address Line 1',
                            fieldName: 'address1',
                            focusNode: _address1FocusNode,
                            validator: _validateAddress1,
                          ),
                          const SizedBox(height: 16),
                          _buildValidatedTextFormField(
                            controller: _address2Controller,
                            label: 'Address Line 2',
                            fieldName: 'address2',
                            focusNode: _address2FocusNode,
                            validator: _validateAddress2,
                          ),
                          const SizedBox(height: 16),
                          _buildValidatedTextFormField(
                            controller: _address3Controller,
                            label: 'Address Line 3',
                            fieldName: 'address3',
                            focusNode: _address3FocusNode,
                            validator: (value) => null,
                          ),
                          const SizedBox(height: 16),
                          _buildValidatedTextFormField(
                            controller: _townController,
                            label: 'Town',
                            fieldName: 'town',
                            focusNode: _townFocusNode,
                            validator: _validateTown,
                          ),
                          const SizedBox(height: 16),
                          buildSuperiorOrganizationDropdown(),
                          const SizedBox(height: 16),
                          buildRouteDropdown(),
                          const SizedBox(height: 16),
                          Center(
                            child: CommonAppButton(
                              buttonText: 'Register',
                              onPressed: () {
                                _nameController.text = capitalizeWords(_nameController.text);
                                _ownerNameController.text = capitalizeWords(_ownerNameController.text);
                                _phone1Controller.text = capitalizeWords(_phone1Controller.text);
                                _phone2Controller.text = capitalizeWords(_phone2Controller.text);
                                _whatsappController.text = capitalizeWords(_whatsappController.text);
                                _address1Controller.text = capitalizeWords(_address1Controller.text);
                                _address2Controller.text = capitalizeWords(_address2Controller.text);
                                _address3Controller.text = capitalizeWords(_address3Controller.text);
                                _townController.text = capitalizeWords(_townController.text);

                                print(_ownerBirthdayController.text);

                                final customerTypeValidation = _validateCustomerType();
                                if (_formKey.currentState!.validate() && customerTypeValidation == null) {
                                  _isSuccessMessageShown = false;
                                  _isAddGoodsManagementAPICall = false;
                                  _isAddOrganizationErrorMessageShown = false;
                                  _isUpdateRouteLoaded = false;

                                  final customerTypeId = _selectedCustomerType.toString();
                                  final name = "${_nameController.text}_${_townController.text}";
                                  final email = _emailController.text.toString();
                                  final phone1 = _phone1Controller.text.toString();
                                  final phone2 = _phone2Controller.text.toString();
                                  final whatsapp = _whatsappController.text.toString();
                                  final address1 = _address1Controller.text.toString();
                                  final address2 = _address2Controller.text.toString();
                                  final address3 = _address3Controller.text.toString();
                                  final town = _townController.text.toString();
                                  final ownerName = _ownerNameController.text.toString();
                                  final ownerBirthday = _ownerBirthdayController.text.toString();
                                  final superiorOrganization = _selectedSuperiorOrganization!.orgnummer.toString();

                                  if (!_isSubmitPressed) {
                                    setState(() {
                                      _isUpdateLoading = true;
                                    });
                                    _isUpdateRouteErrorShown = false;
                                    _isSubmitPressed = true;

                                    _addOrganizationBloc.addOrganization(
                                        getSearchWord(name),
                                        name,
                                        email,
                                        phone1,
                                        phone2,
                                        whatsapp,
                                        address1,
                                        address2,
                                        address3,
                                        town,
                                        latitude,
                                        longitude,
                                        customerTypeId,
                                        widget.loggedUserNummer,
                                        widget.userOrganizationNummer,
                                        ownerName,
                                        ownerBirthday,
                                        isMasonry.toString(),
                                        isWaterproofing.toString(),
                                        isFlooring.toString(),
                                        organizationColor,
                                        superiorOrganization);

                                    if (organizationType != "Project" || organizationType != "(4147,12,0)") {
                                      isMasonry = false;
                                      isWaterproofing = false;
                                      isFlooring = false;
                                    }
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (_isUpdateLoading ||
                _isCustomerTypeLoading ||
                _isLoadingNearlyOrganizations ||
                _isSuperiorOrganizationLoading ||
                _isRouteLoading ||
                _isUpdateRouteLoading)
              const Loading(),
          ],
        ),
      ),
    );
  }

  Widget customerTypeToggleButtons() {
    return StreamBuilder<ResponseList<CustomerType>>(
      stream: _customerTypeBloc.customerTypeStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status!) {
            case Status.LOADING:
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _isCustomerTypeLoading = true;
                });
              });
            case Status.COMPLETED:
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _isCustomerTypeLoading = false;
                });
              });
              _allCustomerTypes = snapshot.data!.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Organization Type', style: TextStyle(color: CustomColors.cardTextColor1)),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ToggleButtons(
                      color: CustomColors.cardTextColor1,
                      selectedColor: CustomColors.textColor,
                      fillColor: CustomColors.buttonColor3,
                      highlightColor: CustomColors.buttonColor2,
                      isSelected: List.generate(
                        _allCustomerTypes!.length,
                        (index) => index == _selectedCustomerTypeIndex,
                      ),
                      onPressed: (index) {
                        isMasonry = false;
                        isWaterproofing = false;
                        isFlooring = false;
                        _selectedCustomerTypeIndex = index;
                        _selectedCustomerType = _allCustomerTypes![index].vaufzelemId;
                        organizationType = _allCustomerTypes![index].aebez.toString();
                        organizationColor = getOrganizationColor(organizationType);
                      },
                      children: _allCustomerTypes!.map((CustomerType type) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(type.aebez.toString()),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              );
            case Status.ERROR:
              if (!_isCustomerTypeErrorMessageShown) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    _isCustomerTypeLoading = false;
                  });
                  showErrorAlertDialog(context, snapshot.data!.message.toString());
                });
              }

              return Container();
          }
        }
        return Container();
      },
    );
  }

  Widget _buildValidatedTextFormField({
    required TextEditingController controller,
    required String label,
    required String fieldName,
    required FocusNode focusNode,
    TextInputType keyboardType = TextInputType.text,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: CustomColors.cardTextColor1),
            suffixIcon: _validationStatus[fieldName] == null
                ? null
                : _validationStatus[fieldName]!
                    ? const Icon(Icons.check, color: Colors.green)
                    : const Icon(Icons.error, color: Colors.red),
          ),
          keyboardType: keyboardType,
          focusNode: focusNode,
          validator: validator,
          onChanged: (value) {
            _validateField(fieldName);
          },
        ),
      ],
    );
  }

  Widget addOrganizationResponse() {
    return StreamBuilder<Response<AddOrganization>>(
      stream: _addOrganizationBloc.addOrganizationStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status!) {
            case Status.LOADING:
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _isUpdateLoading = true;
                });
              });

            case Status.COMPLETED:
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _isUpdateLoading = false;
                });
              });

              if (!_isAddGoodsManagementAPICall) {
                _isAddGoodsManagementAPICall = true;
                organizationNummer = snapshot.data!.data!.nummer.toString();
                organizationSearchWord = snapshot.data!.data!.such.toString();

                if (_selectedRoute != null) {
                  String selectedRouteId = _selectedRoute!.id.toString();
                  _updateRouteBloc.updateRoute(selectedRouteId, organizationNummer);
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {
                      _isUpdateRouteLoading = true;
                    });
                  });
                }

                _addGoodsManagementBloc.addGoodsManagement(organizationSearchWord, organizationNummer);
              }
              _isSubmitPressed = false;
              break;
            case Status.ERROR:
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _isUpdateLoading = false;
                });
              });
              if (!_isAddOrganizationErrorMessageShown) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showErrorAlertDialog(context, snapshot.data!.message.toString());
                  _isAddOrganizationErrorMessageShown = true;
                });
              }
              _isSubmitPressed = false;
          }
        }
        return Container();
      },
    );
  }

  Widget addGoodsManagementResponse() {
    return StreamBuilder<Response<AddGoodsManagement>>(
      stream: _addGoodsManagementBloc.addGoodsManagementStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status!) {
            case Status.LOADING:
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _isUpdateLoading = true;
                });
              });

            case Status.COMPLETED:
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _isUpdateLoading = false;
                });
              });
              if (!_isGoodsManagementSuccessShown) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _isGoodsManagementSuccessShown = true;
                  _isUpdateOrganizationCompleted = true;
                  if (_selectedRoute != null) {
                    print("WWWWWWWWWWWWWWW");
                    _checkForSuccess();
                  } else {
                    final name = _nameController.text.toString();
                    showSuccessAlertDialog(context, "$name has been added successfully.", () {
                      Navigator.pop(context, true);
                    });
                  }
                });
              }
              break;
            case Status.ERROR:
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _isUpdateLoading = false;
                });
              });
              if (!_isAddOrganizationErrorMessageShown) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showErrorAlertDialog(context, snapshot.data!.message.toString());
                  setState(() {
                    _isAddOrganizationErrorMessageShown = true;
                  });
                });
              }
          }
        }
        return Container();
      },
    );
  }

  getSuperiorOrganizationResponse() {
    return StreamBuilder<ResponseList<Organization>>(
      stream: _superiorOrganizationBloc.organizationStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status!) {
            case Status.LOADING:
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _isSuperiorOrganizationLoading = true;
                });
              });

            case Status.COMPLETED:
              if (!_isOrganizationsLoaded) {
                _isOrganizationsLoaded = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    _isSuperiorOrganizationLoading = false;
                    _superiorOrganizations = snapshot.data!.data!;
                    // Find the matching organization or set a default value
                    Organization matchingOrg = _superiorOrganizations.firstWhere(
                      (org) => org.orgnummer == widget.userOrganizationNummer,
                      orElse: () => _superiorOrganizations.first, // Use a fallback, like the first item in the list
                    );

                    _selectedSuperiorOrganization = matchingOrg;
                  });
                });
              }

              break;
            case Status.ERROR:
              if (!_isSuperiorOrganizationErrorShown) {
                _isSuperiorOrganizationErrorShown = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    _isSuperiorOrganizationLoading = false;
                  });
                  showErrorAlertDialog(context, snapshot.data!.message.toString());
                });
              }
          }
        }
        return Container();
      },
    );
  }

  Widget getRouteResponse() {
    return StreamBuilder<ResponseList<RouteList>>(
      stream: _routeListBloc.routeListStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status!) {
            case Status.LOADING:
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _isRouteLoading = true;
                });
              });

            case Status.COMPLETED:
              if (!_isRoutesLoaded) {
                _isRoutesLoaded = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    _isRouteLoading = false;
                    _routeList = snapshot.data!.data!;
                  });
                });
              }

            case Status.ERROR:
              if (!_isRouteErrorShown) {
                _isRouteErrorShown = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    _isRouteLoading = false;
                  });
                  showErrorAlertDialog(context, snapshot.data!.message.toString());
                });
              }
          }
        }
        return Container();
      },
    );
  }

  Widget updateRouteResponse() {
    return StreamBuilder<Response<UpdateRoute>>(
      stream: _updateRouteBloc.updateRouteStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status!) {
            case Status.LOADING:
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _isUpdateRouteLoading = true;
                });
              });

            case Status.COMPLETED:
              if (!_isUpdateRouteLoaded) {
                _isUpdateRouteLoaded = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    _isUpdateRouteLoading = false;
                    _isUpdateRouteCompleted = true;
                  });
                  if (!_isSuccessMessageShown) {
                    _isSuccessMessageShown = true;
                  }
                  if (_selectedRoute != null) {
                    print("xxxxxxxxxxxxxxxxx");
                    _checkForSuccess();
                  }
                });
              }

              break;
            case Status.ERROR:
              if (!_isUpdateRouteErrorShown) {
                _isUpdateRouteErrorShown = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    _isUpdateRouteLoading = false;
                  });
                  showErrorAlertDialog(context, snapshot.data!.message.toString());
                });
              }
          }
        }
        return Container();
      },
    );
  }

  showNearbyOrganizationsPopup(BuildContext context, List<Organization> nearbyOrganizations) {
    String organizationCount = nearbyOrganizations.length.toString();
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: const BorderSide(color: CustomColors.successAlertBorderColor),
          ),
          elevation: 24.0,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              gradient: LinearGradient(
                colors: [
                  Colors.grey.shade400,
                  Colors.white,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0),
                  child: Text(
                    "Nearby Organizations Found",
                    style: TextStyle(
                      color: CustomColors.errorAlertTitleTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: getFontSizeLarge(),
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "This location has $organizationCount nearby organizations. Do you want to continue?",
                            style: TextStyle(fontSize: getFontSize(), color: CustomColors.cardTextColor),
                          ),
                          const SizedBox(height: 10),
                          ...nearbyOrganizations.map((org) => Text(
                                "_${org.namebspr}",
                                style: TextStyle(fontSize: getFontSize()),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.fromLTRB(0, 0, 8.0, 8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          "No",
                          style: TextStyle(
                            color: CustomColors.errorAlertTitleTextColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          "Yes",
                          style: TextStyle(
                            color: CustomColors.errorAlertTitleTextColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildToggleSwitch(String title, bool value, ValueChanged<bool> onChanged) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
            width: 150,
            child: Text(title, style: TextStyle(fontSize: getFontSize(), color: CustomColors.cardTextColor))),
        Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: CustomColors.buttonColor,
            activeColor: Colors.white,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap),
      ],
    );
  }

  Widget buildSuperiorOrganizationDropdown() {
    return DropdownSearch<Organization>(
      items: _superiorOrganizations,
      itemAsString: (Organization u) => u.namebspr.toString(),
      onChanged: (Organization? organization) {
        setState(() {
          _selectedSuperiorOrganization = organization;
        });
      },
      selectedItem: _selectedSuperiorOrganization,
      //clearButtonProps: const ClearButtonProps(isVisible: true),
      dropdownDecoratorProps: const DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: "Select Superior Organization",
          hintText: "Select Superior Organization",
          fillColor: CustomColors.textFieldFillColor,
          labelStyle: TextStyle(
            color: CustomColors.textFieldTextColor,
          ),
        ),
      ),
      popupProps: PopupProps.bottomSheet(
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            focusColor: CustomColors.buttonColor,
            labelText: 'Search Superior Organization',
            hintText: 'Type to Search Superior Organization...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50.0),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50.0),
              borderSide: const BorderSide(
                color: CustomColors.textFieldBorderColor,
                width: 2.0,
              ),
            ),
            fillColor: CustomColors.textFieldFillColor,
            filled: true,
            labelStyle: const TextStyle(
              color: CustomColors.textFieldTextColor,
            ),
          ),
        ),
        itemBuilder: (context, item, isSelected) {
          return ListTile(
            title: Text(
              "${item.namebspr} | ${item.yassigto} | ${item.orgnummer}",
              style: TextStyle(
                color: CustomColors.cardTextColor,
                fontSize: getFontSize(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildRouteDropdown() {
    // // Use a Set to store unique route names
    // final Set<String> uniqueRouteNames = _routeList.map((e) => e.namebsprRoute.toString()).toSet();

    // // Filter the _routeOrganization list to include only unique route names
    // final List<RouteList> uniqueRoutes = _routeList.where((route) {
    //   if (uniqueRouteNames.contains(route.namebsprRoute)) {
    //     uniqueRouteNames.remove(route.namebsprRoute);
    //     return true;
    //   }
    //   return false;
    // }).toList();

    return DropdownSearch<RouteList>(
      items: _routeList,
      itemAsString: (RouteList u) => u.namebsprRoute.toString(),
      onChanged: (RouteList? routeOrganization) {
        setState(() {
          _selectedRoute = routeOrganization;
        });
      },
      selectedItem: _selectedRoute,
      clearButtonProps: const ClearButtonProps(isVisible: true),
      dropdownDecoratorProps: const DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: "Select Route",
          hintText: "Select Route",
          fillColor: CustomColors.textFieldFillColor,
          labelStyle: TextStyle(
            color: CustomColors.textFieldTextColor,
          ),
        ),
      ),
      popupProps: PopupProps.bottomSheet(
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            focusColor: CustomColors.buttonColor,
            labelText: 'Search Route',
            hintText: 'Type to Search Route...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50.0),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50.0),
              borderSide: const BorderSide(
                color: CustomColors.textFieldBorderColor,
                width: 2.0,
              ),
            ),
            fillColor: CustomColors.textFieldFillColor,
            filled: true,
            labelStyle: const TextStyle(
              color: CustomColors.textFieldTextColor,
            ),
          ),
        ),
        itemBuilder: (context, item, isSelected) {
          return ListTile(
            title: Text(
              item.namebsprRoute.toString(),
              style: TextStyle(
                color: CustomColors.cardTextColor,
                fontSize: getFontSize(),
              ),
            ),
          );
        },
      ),
    );
  }

  void _checkForSuccess() {
    print("LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL");
    print(_isUpdateRouteCompleted);
    print(_isUpdateOrganizationCompleted);
    print(_isFinalSuccessMessageShown);
    if (_isUpdateRouteCompleted && _isUpdateOrganizationCompleted && !_isFinalSuccessMessageShown) {
      setState(() {
        _isFinalSuccessMessageShown = true;
      });
      final name = _nameController.text.toString();
      showSuccessAlertDialog(context, "$name has been added successfully.", () {
        // Future.delayed(const Duration(milliseconds: 500), () {
        //   setState(() {
        //     clearFormFields();
        //   });
        // });
        Navigator.pop(context, true);
        //Navigator.pop(context, true);
      });
    }
  }
}
