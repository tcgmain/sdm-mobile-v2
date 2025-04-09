// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:async';
import 'dart:math';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:sdm/blocs/add_goods_management_bloc.dart';
import 'package:sdm/blocs/add_organization_bloc.dart';
import 'package:sdm/blocs/customer_type_bloc.dart';
import 'package:sdm/blocs/organization_category_bloc.dart';
import 'package:sdm/blocs/organization_location_bloc.dart';
import 'package:sdm/blocs/organization_type_bloc.dart';
import 'package:sdm/blocs/territory_bloc.dart';
import 'package:sdm/blocs/town_bloc.dart';
import 'package:sdm/models/add_goods_management.dart';
import 'package:sdm/models/add_organization.dart';
import 'package:sdm/models/customer_type.dart';
import 'package:sdm/models/organization.dart';
import 'package:sdm/models/organization_category.dart';
import 'package:sdm/models/territory.dart';
import 'package:sdm/models/town.dart';
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
  late OrganizationLocationBloc _organizationLocationBloc;
  late OrganizationTypeBloc _organizationTypeBloc;
  late OrganizationCategoryBloc _organizationCategoryBloc;
  late AddOrganizationBloc _addOrganizationBloc;
  late AddGoodsManagementBloc _addGoodsManagementBloc;
  late TerritoryBloc _territoryBloc;
  late TownBloc _townBloc;
  OrganizationCategory? _selectedCategory;
  List<CustomerType>? _allCustomerTypes;
  List<OrganizationCategory>? _allOrganizationCategories;
  late String latitude;
  late String longitude;
  bool _isSuccessMessageShown = false;
  bool _isAddGoodsManagementAPICall = false;
  bool _isAddOrganizationErrorMessageShown = false;
  bool _isNearbyOrganizationErrorMessageShown = false;
  bool _isCustomerTypeErrorMessageShown = false;
  bool _isOrganizationCategoryErrorMessageShown = false;
  bool _isNearbyOrganizationPopupShown = false;
  late String organizationNummer;
  late String organizationSearchWord;
  bool _isUpdateLoading = false;
  bool _isSuperiorOrganizationLoading = false;
  bool _isSuperiorOrganizationErrorShown = false;
  bool _isGoodsManagementSuccessShown = false;
  bool _isGoodsManagementErrorShown = false;
  bool _isCustomerTypeLoading = false;
  bool _isOrganizationCategoryLoading = false;
  bool _isTerritoryLoading = false;
  bool _isTownLoading = false;
  bool _isLoadingNearlyOrganizations = false;
  bool _isSubmitPressed = false;
  String organizationType = "";
  String organizationColor = "";

  List<Organization> _superiorOrganizations = [];
  List<Territory> _territoryList = [];
  bool _isTerritoryErrorShown = false;
  Organization? _selectedSuperiorOrganization;
  Territory? _selectedTerritory;
  Town? _nearbyTown;
  bool _isOrganizationsLoaded = false;
  bool _isTerritoryLoaded = false;
  bool _isUpdateOrganizationCompleted = false;
  bool _isTownErrorShown = false;

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
  final _territoryController = TextEditingController();
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

  bool isMasonry = false;
  bool isWaterproofing = false;
  bool isFlooring = false;

  bool isSelCement = false;
  bool isSelTileAdhesive = false;
  bool isSelOtherWaterProofer = false;
  bool isSelCementWaterProofer = false;
  bool isSelSandMetal = false;
  bool isSelPaint = false;

  final Map<String, bool?> _validationStatus = {
    'name': null,
    'email': null,
    'phone1': null,
    'phone2': null,
    'whatsapp': null,
    'address1': null,
    'address2': null,
    'territory': null,
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
    'territory': null,
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

    if (position.latitude < 0 || position.longitude < 0) {
      showErrorAlertDialogWithBack(context, "You are not permitted to add organization from this location");
    } else {
      calculateLatLngRangeforNearbyOrg(position.latitude, position.longitude, 100);

      Map<String, double> geoTownMinRange = calculateLatLngRangeForTown(position.latitude, position.longitude, 4);
      _townBloc.getTown(geoTownMinRange['minLon'].toString(), geoTownMinRange['maxLon'].toString(),
          geoTownMinRange['minLat'].toString(), geoTownMinRange['maxLat'].toString());
    }
  }

  void calculateLatLngRangeforNearbyOrg(double lat, double lon, double distanceInMeters) {
    const double earthRadius = 6371.0;
    const double degreeToRad = pi / 180;
    const double latAdjustment = earthRadius * degreeToRad;

    double distanceInKm = distanceInMeters / 1000.0;
    double latRange = distanceInKm / latAdjustment;
    double lonRange = distanceInKm / (latAdjustment * cos(lat * degreeToRad));

    // Minimize calls to bloc by processing only when necessary

    _organizationLocationBloc.getOrganizationByLocation(
      (lon - lonRange).toString(),
      (lon + lonRange).toString(),
      (lat - latRange).toString(),
      (lat + latRange).toString(),
    );
  }

  Map<String, double> calculateLatLngRangeForTown(double latitude, double longitude, double radiusKm) {
    const double earthRadiusKm = 6371.0; // Radius of the Earth in km

    // Convert latitude and longitude from degrees to radians
    double latRad = latitude * (pi / 180);
    double lonRad = longitude * (pi / 180);

    // Calculate latitude bounds
    double latDiff = (radiusKm / earthRadiusKm) * (180 / pi);
    double minLat = latitude - latDiff;
    double maxLat = latitude + latDiff;

    // Calculate longitude bounds
    double lonDiff = (radiusKm / earthRadiusKm) * (180 / pi) / cos(latRad);
    double minLon = longitude - lonDiff;
    double maxLon = longitude + lonDiff;

    return {
      'minLat': minLat,
      'maxLat': maxLat,
      'minLon': minLon,
      'maxLon': maxLon,
    };
  }

  Town? _getNearestTown(List<Town> towns, double currentLat, double currentLng) {
    if (towns.isEmpty) return null;

    Town? nearestTown;
    double shortestDistance = double.infinity;

    for (var town in towns) {
      double distance = _calculateDistance(
          currentLat, currentLng, double.parse(town.ylatitude.toString()), double.parse(town.ylongtitude.toString()));
      if (distance < shortestDistance) {
        shortestDistance = distance;
        nearestTown = town;
      }
    }
    return nearestTown;
  }

  // Haversine Formula to calculate distance
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371; // Earth radius in km
    double dLat = _degToRad(lat2 - lat1);
    double dLon = _degToRad(lon2 - lon1);

    double a =
        sin(dLat / 2) * sin(dLat / 2) + cos(_degToRad(lat1)) * cos(_degToRad(lat2)) * sin(dLon / 2) * sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _degToRad(double deg) {
    return deg * (pi / 180);
  }

  getNearlyOrganizationsResponse() {
    return StreamBuilder<ResponseList<Organization>>(
      stream: _organizationLocationBloc.organizationLocationStream,
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
    _territoryController.clear();
    _townController.clear();

    _selectedCustomerType = null;
    _selectedCustomerTypeIndex = null; // Reset the toggle buttons selection

    _validationStatus.updateAll((key, value) => null);
    _validationMessages.updateAll((key, value) => null);

    organizationType = "";
    organizationColor = "";

    _selectedSuperiorOrganization = null;

    _isSubmitPressed = false;
  }

  @override
  void initState() {
    super.initState();
    _organizationTypeBloc = OrganizationTypeBloc();
    _customerTypeBloc = CustomerTypeBloc();
    _organizationCategoryBloc = OrganizationCategoryBloc();
    _addOrganizationBloc = AddOrganizationBloc();
    _addGoodsManagementBloc = AddGoodsManagementBloc();
    _territoryBloc = TerritoryBloc();
    _townBloc = TownBloc();
    _organizationLocationBloc = OrganizationLocationBloc();

    _customerTypeBloc.getCustomerType();
    _getCurrentLocation();

    _organizationTypeBloc.getOrganizationByType("Distributor");
    _organizationCategoryBloc.getOrganizationCategory();
    _territoryBloc.getTerritory(widget.loggedUserNummer);
    setState(() {
      _isSuperiorOrganizationLoading = true;
      _isTerritoryLoading = true;
      _isLoadingNearlyOrganizations = true;
      _isOrganizationCategoryLoading = true;
    });
  }

  @override
  void dispose() {
    _customerTypeBloc.dispose();
    _addOrganizationBloc.dispose();
    _addGoodsManagementBloc.dispose();
    _territoryBloc.dispose();
    _townBloc.dispose();
    _nameController.dispose();
    _ownerNameController.dispose();
    _ownerBirthdayController.dispose();
    _emailController.dispose();
    _phone1Controller.dispose();
    _phone2Controller.dispose();
    _whatsappController.dispose();
    _address1Controller.dispose();
    _address2Controller.dispose();
    _nameFocusNode.dispose();
    _ownerNameFocusNode.dispose();
    _ownerBirthdayFocusNode.dispose();
    _emailFocusNode.dispose();
    _phone1FocusNode.dispose();
    _phone2FocusNode.dispose();
    _whatsappFocusNode.dispose();
    _address1FocusNode.dispose();
    _address2FocusNode.dispose();
    _organizationLocationBloc.dispose();
    _organizationTypeBloc.dispose();
    _organizationCategoryBloc.dispose();
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

  String? _validateTerritory(Territory? value) {
    if (value == null) {
      return 'Please select territory';
    }
    return null;
  }

  // String? _validateTown(Town? value) {
  //   if (value == null) {
  //     return 'Please select town';
  //   }
  //   return null;
  // }

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
              child: _buildFormContainer(),
            ),
            if (_isUpdateLoading ||
                _isCustomerTypeLoading ||
                _isLoadingNearlyOrganizations ||
                _isSuperiorOrganizationLoading ||
                _isTerritoryLoading ||
                _isTownLoading)
              const Loading(),
          ],
        ),
      ),
    );
  }

  Widget _buildFormContainer() {
    return Container(
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
                addOrganizationResponse(),
                addGoodsManagementResponse(),
                customerTypeToggleButtons(),
                getTerritoryResponse(),
                getTownResponse(),
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
                //Contractor Detials List
                if (organizationType == "Project") const SizedBox(height: 20),
                if (organizationType == "Project")
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Contractor Details', style: TextStyle(color: CustomColors.cardTextColor1))),
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
                organizationCategorySelection(),
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
                const SizedBox(height: 25),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _nearbyTown != null ? _nearbyTown!.namebspr.toString() : "No town found",
                      style: TextStyle(fontSize: getFontSize()),
                    )),
                const SizedBox(height: 20),
                buildTerritoryDropdown(),
                const SizedBox(height: 16),
                buildSuperiorOrganizationDropdown(),
                const SizedBox(height: 20),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Selling Product List', style: TextStyle(color: CustomColors.cardTextColor1))),
                const SizedBox(height: 8),
                _buildToggleSwitch('Cement', isSelCement, (value) {
                  setState(() {
                    isSelCement = value;
                  });
                }),
                _buildToggleSwitch('Tile Adhesive', isSelTileAdhesive, (value) {
                  setState(() {
                    isSelTileAdhesive = value;
                  });
                }),
                _buildToggleSwitch('Cement Based Water Proofer', isSelCementWaterProofer, (value) {
                  setState(() {
                    isSelCementWaterProofer = value;
                  });
                }),
                _buildToggleSwitch('Other Water Proofer', isSelOtherWaterProofer, (value) {
                  setState(() {
                    isSelOtherWaterProofer = value;
                  });
                }),
                _buildToggleSwitch('Sand / Metal', isSelSandMetal, (value) {
                  setState(() {
                    isSelSandMetal = value;
                  });
                }),
                _buildToggleSwitch('Paint', isSelPaint, (value) {
                  setState(() {
                    isSelPaint = value;
                  });
                }),
                const SizedBox(height: 16),
                Center(
                  child: CommonAppButton(
                    buttonText: 'Register',
                    onPressed: () {
                      print("organizationCategory");
                      print(_selectedCategory.toString());
                      _nameController.text = capitalizeWords(_nameController.text);
                      _ownerNameController.text = capitalizeWords(_ownerNameController.text);
                      _phone1Controller.text = capitalizeWords(_phone1Controller.text);
                      _phone2Controller.text = capitalizeWords(_phone2Controller.text);
                      _whatsappController.text = capitalizeWords(_whatsappController.text);
                      _address1Controller.text = capitalizeWords(_address1Controller.text);
                      _address2Controller.text = capitalizeWords(_address2Controller.text);
            
                      final customerTypeValidation = _validateCustomerType();
                      if (_formKey.currentState!.validate() && customerTypeValidation == null) {
                        _isSuccessMessageShown = false;
                        _isAddGoodsManagementAPICall = false;
                        _isAddOrganizationErrorMessageShown = false;
            
                        final customerTypeId = _selectedCustomerType.toString();
                        String organizationCategory = "";
                        if (_selectedCategory != null) {
                          organizationCategory = _selectedCategory!.vaufzelemId.toString();
                        }
            
                        final name = "${_nameController.text}_${_nearbyTown!.namebspr.toString()}";
                        final email = _emailController.text.toString();
                        final phone1 = _phone1Controller.text.toString();
                        final phone2 = _phone2Controller.text.toString();
                        final whatsapp = _whatsappController.text.toString();
                        final address1 = _address1Controller.text.toString();
                        final address2 = _address2Controller.text.toString();
                        final territory = _selectedTerritory!.ytterritoryNummer.toString();
                        final town = _nearbyTown!.nummer.toString();
                        final ownerName = _ownerNameController.text.toString();
                        final ownerBirthday = _ownerBirthdayController.text.toString();
                        final superiorOrganization = _selectedSuperiorOrganization!.orgnummer.toString();
                        final selCement = isSelCement.toString();
                        final selTileAdhesive = isSelTileAdhesive.toString();
                        final selOtherWaterProofer = isSelOtherWaterProofer.toString();
                        final selCementWaterProofer = isSelCementWaterProofer.toString();
                        final selSandMetal = isSelSandMetal.toString();
                        final selPaint = isSelPaint.toString();
            
                        if (!_isSubmitPressed) {
                          setState(() {
                            _isUpdateLoading = true;
                          });
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
                              territory,
                              town,
                              latitude,
                              longitude,
                              customerTypeId,
                              organizationCategory,
                              widget.loggedUserNummer,
                              widget.userOrganizationNummer,
                              ownerName,
                              ownerBirthday,
                              isMasonry.toString(),
                              isWaterproofing.toString(),
                              isFlooring.toString(),
                              organizationColor,
                              superiorOrganization,
                              selCement,
                              selTileAdhesive,
                              selOtherWaterProofer,
                              selCementWaterProofer,
                              selSandMetal,
                              selPaint);
            
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
                _isCustomerTypeErrorMessageShown = true;
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

  Widget organizationCategorySelection() {
    return StreamBuilder<ResponseList<OrganizationCategory>>(
      stream: _organizationCategoryBloc.organizationCategoryStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status!) {
            case Status.LOADING:
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _isOrganizationCategoryLoading = true;
                });
              });
            case Status.COMPLETED:
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _isOrganizationCategoryLoading = false;
                });
              });
              _allOrganizationCategories = snapshot.data!.data!;
              return Column(
                children: [
                  DropdownButtonFormField<OrganizationCategory>(
                    value: _selectedCategory,
                    decoration: InputDecoration(
                      labelText: "Organization Category",
                      labelStyle: const TextStyle(color: CustomColors.cardTextColor1),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: CustomColors.cardTextColor1),
                      ),
                      suffixIcon: _selectedCategory == null ? null : const Icon(Icons.check, color: Colors.green),
                    ),
                    isExpanded: true,
                    onChanged: (OrganizationCategory? newValue) {
                      setState(() {
                        _selectedCategory = newValue;
                      });
                    },
                    items: _allOrganizationCategories!.map((category) {
                      return DropdownMenuItem<OrganizationCategory>(
                        value: category,
                        child: Text(
                          category.aebez.toString(),
                          style: const TextStyle(
                            fontSize: 14,
                            color: CustomColors.cardTextColor1,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              );
            case Status.ERROR:
              if (!_isOrganizationCategoryErrorMessageShown) {
                _isOrganizationCategoryErrorMessageShown = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    _isOrganizationCategoryLoading = false;
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

                  final name = _nameController.text.toString();
                  showSuccessAlertDialog(context, "$name has been added successfully.", () {
                    Navigator.pop(context, true);
                  });
                });
              }
              break;
            case Status.ERROR:
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _isUpdateLoading = false;
                });
              });
              if (!_isGoodsManagementErrorShown) {
                _isGoodsManagementErrorShown = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showErrorAlertDialog(context, snapshot.data!.message.toString());
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
      stream: _organizationTypeBloc.organizationTypeStream,
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
                    Organization? matchingOrg =
                        _superiorOrganizations.where((org) => org.orgnummer == widget.userOrganizationNummer).isNotEmpty
                            ? _superiorOrganizations.firstWhere((org) => org.orgnummer == widget.userOrganizationNummer)
                            : null;

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

  Widget getTerritoryResponse() {
    return StreamBuilder<ResponseList<Territory>>(
      stream: _territoryBloc.territoryStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status!) {
            case Status.LOADING:
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _isTerritoryLoading = true;
                });
              });

            case Status.COMPLETED:
              if (!_isTerritoryLoaded) {
                _isTerritoryLoaded = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    _isTerritoryLoading = false;

                    _territoryList = snapshot.data!.data!
                        .where((territory) => territory.ytterritoryNamebspr!.trim().isNotEmpty)
                        .toList();

                    if (_territoryList.length == 1) {
                      // Find the matching organization or set a default value
                      Territory matchingTerritory = _territoryList.firstWhere(
                        (territory) => territory.ytterritoryNamebspr == widget.userOrganizationNummer,
                        orElse: () => _territoryList.first,
                      );

                      _selectedTerritory = matchingTerritory;
                    }
                  });
                });
              }

            case Status.ERROR:
              if (!_isTerritoryErrorShown) {
                _isTerritoryErrorShown = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    _isTerritoryLoading = false;
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

  Widget getTownResponse() {
    return StreamBuilder<ResponseList<Town>>(
      stream: _townBloc.townStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status!) {
            case Status.LOADING:
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _isTownLoading = true;
                });
              });

            case Status.COMPLETED:
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _isTownLoading = false;
                });
              });

              // Extract nearest town
              Town? nearestTown =
                  _getNearestTown(snapshot.data!.data!, double.parse(latitude), double.parse(longitude));
              if (nearestTown != null) {
                _nearbyTown = nearestTown;
              }

              break;

            case Status.ERROR:
              if (!_isTownErrorShown) {
                _isTownErrorShown = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    _isTownLoading = false;
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
    return SizedBox(
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: getFontSize(), color: CustomColors.cardTextColor),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: CustomColors.buttonColor,
            activeColor: Colors.white,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }

  Widget buildTerritoryDropdown() {
    return DropdownSearch<Territory>(
      items: _territoryList,
      itemAsString: (Territory u) => u.ytterritoryNamebspr.toString(),
      onChanged: (Territory? territory) {
        setState(() {
          _selectedTerritory = territory;
        });
      },
      selectedItem: _selectedTerritory,
      dropdownDecoratorProps: const DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: "Select Territory",
          hintText: "Select Territory",
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
            labelText: 'Search Territory',
            hintText: 'Type to Search Territory...',
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
              "${item.ytterritoryNamebspr}",
              style: TextStyle(
                color: CustomColors.cardTextColor,
                fontSize: getFontSize(),
              ),
            ),
          );
        },
      ),
      validator: _validateTerritory,
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
}
