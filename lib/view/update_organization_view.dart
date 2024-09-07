import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:sdm/blocs/customer_type_bloc.dart';
import 'package:sdm/blocs/organization_bloc.dart';
import 'package:sdm/blocs/route_list_bloc.dart';
import 'package:sdm/blocs/route_organization_bloc.dart';
import 'package:sdm/blocs/update_organization_bloc.dart';
import 'package:sdm/blocs/update_route_bloc.dart';
import 'package:sdm/models/customer_type.dart';
import 'package:sdm/models/organization.dart';
import 'package:sdm/models/route_list.dart';
import 'package:sdm/models/route_organization.dart';
import 'package:sdm/models/update_organization.dart';
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

class UpdateOrganizationView extends StatefulWidget {
  final String userNummer;
  final String username;
  final String loggedUserNummer;
  final bool isTeamMemberUi;
  final String organizationId;
  final String organizationNummer;
  final String organizationName;
  final String organizationTypeId;
  final String organizationMail;
  final String organizationPhone1;
  final String organizationPhone2;
  final String organizationWhatsapp;
  final String organizationAddress1;
  final String organizationAddress2;
  final String organizationAddress3;
  final String organizationTown;
  final String superiorOrganizationNummer;
  final String ownerName;
  final String ownerBirthday;
  final bool isMasonry;
  final bool isWaterproofing;
  final bool isFlooring;
  final String userOrganizationNummer;
  final String designationNummer;
  final String organizationColor;

  const UpdateOrganizationView({
    super.key,
    required this.userNummer,
    required this.username,
    required this.loggedUserNummer,
    required this.isTeamMemberUi,
    required this.organizationId,
    required this.organizationNummer,
    required this.organizationName,
    required this.organizationTypeId,
    required this.organizationMail,
    required this.organizationPhone1,
    required this.organizationPhone2,
    required this.organizationWhatsapp,
    required this.organizationAddress1,
    required this.organizationAddress2,
    required this.organizationAddress3,
    required this.organizationTown,
    required this.superiorOrganizationNummer,
    required this.ownerName,
    required this.ownerBirthday,
    required this.isMasonry,
    required this.isWaterproofing,
    required this.isFlooring,
    required this.userOrganizationNummer,
    required this.designationNummer,
    required this.organizationColor,
  });

  @override
  State<UpdateOrganizationView> createState() => _UpdateOrganizationViewState();
}

class _UpdateOrganizationViewState extends State<UpdateOrganizationView> {
  final _formKey = GlobalKey<FormState>();
  bool _isCustomerTypeLoading = false;
  bool _isSuperiorOrganizationLoading = false;
  bool _isUpdateLoading = false;
  bool _isRouteLoading = false;
  bool _isRoutesLoaded = false;
  bool _isUpdatePressed = false;
  late CustomerTypeBloc _customerTypeBloc;
  List<CustomerType>? _allCustomerTypes;
  late String latitude;
  late String longitude;
  bool _isSuccessMessageShown = false;
  bool _isRouteErrorShown = false;
  bool _isErrorMessageShown = false;
  bool _isOrganizationsLoaded = false;
  bool _isOrganizationTypeToggleShown = false;
  bool _isSelectedRouteErrorMessageShown = false;
  bool _isUpdateRouteLoading = false;
  bool _isUpdateRouteLoaded = false;
  bool _isCustomerTypeErrorMessageShown = false;
  bool _isUpdateOrganizationCompleted = false;
  bool _isUpdateRouteCompleted = false;
  bool _isUpdateRouteErrorShown = false;
  bool _isFinalSuccessMessageShown = false;
  bool _isSelectRouteCompleted = false;
  bool _isSuperiorOrganizationErrorShown = false;

  //late String organizationNummer;
  late String organizationSearchWord;
  late UpdateOrganizationBloc _updateOrganizationBloc;
  late OrganizationBloc _superiorOrganizationBloc;
  late RouteListBloc _routeListBloc;
  late UpdateRouteBloc _updateRouteBloc;
  late RouteOrganizationBloc _routeOrganizationBloc;
  Organization? _selectedSuperiorOrganization;
  String organizationType = "";
  String organizationColor = "";
  String selectedRouteNummer = "";
  List<Organization> _superiorOrganizations = [];
  List<RouteList> _routeList = [];
  RouteList? _selectedRoute;

  String? _selectedCustomerType;
  int? _selectedCustomerTypeIndex;
  late TextEditingController _ownerNameController;
  late TextEditingController _ownerBirthdayController;
  late TextEditingController _emailController;
  late TextEditingController _phone1Controller;
  late TextEditingController _phone2Controller;
  late TextEditingController _whatsappController;
  late TextEditingController _address1Controller;
  late TextEditingController _address2Controller;
  late TextEditingController _address3Controller;
  late TextEditingController _townController;

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

  late bool isMasonry;
  late bool isWaterproofing;
  late bool isFlooring;

  final Map<String, bool?> _validationStatus = {
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
    'email': null,
    'phone1': null,
    'phone2': null,
    'whatsapp': null,
    'address1': null,
    'address2': null,
    'address3': null,
    'town': null,
  };

  @override
  void initState() {
    super.initState();
    setState(() {
      _isCustomerTypeLoading = true;
      _isSuperiorOrganizationLoading = true;
      _isRouteLoading = true;
    });
    _ownerNameController = TextEditingController(text: widget.ownerName.toString());
    _ownerBirthdayController = TextEditingController(text: widget.ownerBirthday.toString());
    _emailController = TextEditingController(text: widget.organizationMail.toString());
    _phone1Controller = TextEditingController(text: widget.organizationPhone1.toString());
    _phone2Controller = TextEditingController(text: widget.organizationPhone2.toString());
    _whatsappController = TextEditingController(text: widget.organizationWhatsapp.toString());
    _address1Controller = TextEditingController(text: widget.organizationAddress1.toString());
    _address2Controller = TextEditingController(text: widget.organizationAddress2.toString());
    _address3Controller = TextEditingController(text: widget.organizationAddress3.toString());
    _townController = TextEditingController(text: widget.organizationTown.toString());
    organizationType = widget.organizationTypeId;
    organizationColor = widget.organizationColor;

    isMasonry = widget.isMasonry;
    isWaterproofing = widget.isWaterproofing;
    isFlooring = widget.isFlooring;

    _customerTypeBloc = CustomerTypeBloc();
    _updateOrganizationBloc = UpdateOrganizationBloc();
    _superiorOrganizationBloc = OrganizationBloc();
    _customerTypeBloc.getCustomerType();
    _superiorOrganizationBloc.getOrganizationByType("Distributor");
    _routeListBloc = RouteListBloc();
    _routeListBloc.getRouteList("");
    _updateRouteBloc = UpdateRouteBloc();
    _routeOrganizationBloc = RouteOrganizationBloc();
    _routeOrganizationBloc.getRouteOrganizationByOrg(widget.organizationNummer);
  }

  @override
  void dispose() {
    _updateOrganizationBloc.dispose();
    _customerTypeBloc.dispose();
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
    _superiorOrganizationBloc.dispose();
    _routeListBloc.dispose();
    _updateRouteBloc.dispose();
    super.dispose();
  }

  String capitalizeWords(String input) {
    if (input.isEmpty) return input;
    return input.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  void _validateField(String fieldName) {
    setState(() {
      _isSuccessMessageShown = true;
      _isErrorMessageShown = true;
      switch (fieldName) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonAppBar(
          title: 'Update Organizations',
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
                            Text(
                              widget.organizationName,
                              style: TextStyle(fontSize: getFontSizeLarge(), color: CustomColors.cardTextColor),
                            ),
                            getSuperiorOrganizationResponse(),
                            getRouteListResponse(),
                            updateOrganizationResponse(),
                            updateRouteResponse(),
                            getSelectedRouteResponse(),
                            const SizedBox(height: 16),
                            customerTypeToggleButtons(),
                            if (organizationType == "Project" || organizationType == "(4147,12,0)")
                              const SizedBox(height: 20),
                            if (organizationType == "Project" || organizationType == "(4147,12,0)")
                              const Align(
                                  alignment: Alignment.centerLeft,
                                  child:
                                      Text('Contractor Details', style: TextStyle(color: CustomColors.cardTextColor1))),
                            if (organizationType == "Project" || organizationType == "(4147,12,0)")
                              const SizedBox(height: 8),
                            if (organizationType == "Project" || organizationType == "(4147,12,0)")
                              _buildToggleSwitch('Masonry', isMasonry, (value) {
                                setState(() {
                                  isMasonry = value;
                                });
                              }),
                            if (organizationType == "Project" || organizationType == "(4147,12,0)")
                              _buildToggleSwitch('Waterproofing', isWaterproofing, (value) {
                                setState(() {
                                  isWaterproofing = value;
                                });
                              }),
                            if (organizationType == "Project" || organizationType == "(4147,12,0)")
                              _buildToggleSwitch('Flooring', isFlooring, (value) {
                                setState(() {
                                  isFlooring = value;
                                });
                              }),
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
                              validator: (value) => null,
                            ),
                            const SizedBox(height: 16),
                            _buildValidatedTextFormField(
                              controller: _phone2Controller,
                              label: 'Phone 2',
                              fieldName: 'phone2',
                              keyboardType: TextInputType.phone,
                              focusNode: _phone2FocusNode,
                              validator: (value) => null,
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
                            if (widget.organizationNummer != "5") buildSuperiorOrganizationDropdown(),
                            if (widget.organizationNummer != "5") const SizedBox(height: 16),
                            buildRouteDropdown(),
                            const SizedBox(height: 16),
                            Center(
                              child: CommonAppButton(
                                buttonText: 'Update',
                                onPressed: () {
                                  _isUpdatePressed = false;
                                  if (!_isUpdatePressed) {
                                    _isUpdatePressed = true;

                                    _isSuccessMessageShown = false;
                                    _isErrorMessageShown = false;
                                    _isUpdateRouteErrorShown = false;
                                    _ownerNameController.text = capitalizeWords(_ownerNameController.text);
                                    _phone1Controller.text = capitalizeWords(_phone1Controller.text);
                                    _phone2Controller.text = capitalizeWords(_phone2Controller.text);
                                    _whatsappController.text = capitalizeWords(_whatsappController.text);
                                    _address1Controller.text = capitalizeWords(_address1Controller.text);
                                    _address2Controller.text = capitalizeWords(_address2Controller.text);
                                    _address3Controller.text = capitalizeWords(_address3Controller.text);
                                    _townController.text = capitalizeWords(_townController.text);
print("NNN");
                                    if (_formKey.currentState!.validate()) {
                                      print("ttt");
                                      setState(() {
                                        _isUpdateLoading = true;
                                      });

                                      final customerTypeId = _selectedCustomerType.toString();
                                      final ownerName = _ownerNameController.text.toString();
                                      final email = _emailController.text.toString();
                                      final phone1 = _phone1Controller.text.toString();
                                      final phone2 = _phone2Controller.text.toString();
                                      final whatsapp = _whatsappController.text.toString();
                                      final address1 = _address1Controller.text.toString();
                                      final address2 = _address2Controller.text.toString();
                                      final address3 = _address3Controller.text.toString();
                                      final town = _townController.text.toString();
                                      String superiorOrganization;
                                      if (widget.organizationNummer.toString() != "5") {
                                        superiorOrganization = _selectedSuperiorOrganization!.orgnummer.toString();
                                      } else {
                                        superiorOrganization = "";
                                      }

                                      _updateOrganizationBloc.updateOrganization(
                                          widget.organizationId,
                                          email,
                                          ownerName,
                                          phone1,
                                          phone2,
                                          whatsapp,
                                          address1,
                                          address2,
                                          address3,
                                          town,
                                          customerTypeId,
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

                                      if (_selectedRoute != null && selectedRouteNummer.isEmpty) {
                                        print("rrr");
                                        String selectedRouteId = _selectedRoute!.id.toString();
                                        _updateRouteBloc.updateRoute(selectedRouteId, widget.organizationNummer);
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          setState(() {
                                            _isUpdateRouteLoading = true;
                                          });
                                        });
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
              if (_isCustomerTypeLoading ||
                  _isUpdateLoading ||
                  _isRouteLoading ||
                  _isSuperiorOrganizationLoading ||
                  _isUpdateRouteLoading)
                const Loading(),
            ],
          ),
        ));
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
            setState(() {
              _validationStatus[fieldName] = validator(value) == null;
              _validationMessages[fieldName] = validator(value);
            });
          },
        ),
      ],
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
              if (!_isOrganizationTypeToggleShown) {
                for (int i = 0; i < _allCustomerTypes!.length; i++) {
                  if (_allCustomerTypes![i].vaufzelemId == widget.organizationTypeId) {
                    _selectedCustomerTypeIndex = i;
                    _selectedCustomerType = _allCustomerTypes![i].vaufzelemId;
                    break;
                  }
                }
                _isOrganizationTypeToggleShown = true;
              }

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
                        setState(() {
                          isMasonry = false;
                          isWaterproofing = false;
                          isFlooring = false;
                          _selectedCustomerTypeIndex = index;
                          _selectedCustomerType = _allCustomerTypes![index].vaufzelemId;
                          organizationType = _allCustomerTypes![index].aebez.toString();
                          organizationColor = getOrganizationColor(organizationType);
                        });
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
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _isCustomerTypeErrorMessageShown = true;
                  _isCustomerTypeLoading = false;
                });
                if (!_isCustomerTypeErrorMessageShown) {
                  showErrorAlertDialog(context, snapshot.data!.message.toString());
                }
              });

              return Container();
          }
        }
        return Container();
      },
    );
  }

  Widget updateOrganizationResponse() {
    return StreamBuilder<Response<UpdateOrganization>>(
      stream: _updateOrganizationBloc.updateOrganizationStream,
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
              if (!_isSuccessMessageShown) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  //showSuccessAlertDialogUpdateOrganization(context, "${widget.organizationName} has been updated.");
                  _isSuccessMessageShown = true;
                  if (_selectedRoute != null) {
                    _checkForSuccess();
                  } else {
                    showSuccessAlertDialogUpdateOrganization(context, "${widget.organizationName} has been updated.");
                  }
                });
              }
              _isUpdatePressed = false;
              _isUpdateOrganizationCompleted = true;
              break;
            case Status.ERROR:
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _isUpdateLoading = false;
                });
              });
              if (!_isErrorMessageShown) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showErrorAlertDialog(context, snapshot.data!.message.toString());
                  setState(() {
                    _isErrorMessageShown = true;
                  });
                });
              }
              _isUpdatePressed = false;
          }
        }
        return Container();
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

  Future<void> showSuccessAlertDialogUpdateOrganization(BuildContext context, String successMessage) {
    Widget okButton = TextButton(
      child: const Text(
        "OK",
        style: TextStyle(
          color: CustomColors.successAlertTitleTextColor,
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
      ),
      onPressed: () {
        // (isDataViewer(widget.designationNummer))
        // ?
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pop(context, true);
          Navigator.pop(context, true);
        });
      },
    );

    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: const BorderSide(color: CustomColors.successAlertBorderColor),
      ),
      backgroundColor: CustomColors.successAlertBackgroundColor,
      elevation: 24.0,
      titlePadding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0),
      contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0),
      actionsPadding: const EdgeInsets.fromLTRB(0, 0, 8.0, 8.0),
      title: const Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            color: CustomColors.successAlertTitleTextColor,
            size: 30.0,
          ),
          SizedBox(width: 10.0),
          Text(
            "Success",
            style: TextStyle(
              color: CustomColors.successAlertTitleTextColor,
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
            ),
          ),
        ],
      ),
      content: Text(
        successMessage,
        style: const TextStyle(
          color: CustomColors.successAlertTextColor,
          fontSize: 18.0,
        ),
      ),
      actions: [
        okButton,
      ],
    );

    return showGeneralDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
        return alert;
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ).drive(Tween<Offset>(
            begin: const Offset(0, -1),
            end: Offset.zero,
          )),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
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
                      (org) => org.orgnummer == widget.superiorOrganizationNummer,
                      orElse: () => _superiorOrganizations.first, // Use a fallback, like the first item in the list
                    );
                    if (widget.organizationNummer == "5") {
                      _selectedSuperiorOrganization = null;
                    } else {
                      _selectedSuperiorOrganization = matchingOrg;
                    }
                  });
                });
              }

              break;
            case Status.ERROR:
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _isSuperiorOrganizationLoading = false;
                });
                if (!_isSuperiorOrganizationErrorShown) {
                  _isSuperiorOrganizationErrorShown = true;
                  showErrorAlertDialog(context, snapshot.data!.message.toString());
                }
              });
          }
        }
        return Container();
      },
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
      //clearButtonProps: const ClearButtonProps(isVisible: false),
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

  Widget getRouteListResponse() {
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

                    // RouteList matchingRoute = _routeList.firstWhere(
                    //   (route) => route.nummer == selectedRouteNummer,
                    //   //orElse: () => _routeList.first,
                    // );

                    // _selectedRoute = matchingRoute;
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

  Widget buildRouteDropdown() {
    return DropdownSearch<RouteList>(
      items: _routeList,
      itemAsString: (RouteList u) => u.namebsprRoute.toString(),
      onChanged: selectedRouteNummer.isEmpty
          ? (RouteList? routeOrganization) {
              setState(() {
                _selectedRoute = routeOrganization;
              });
            }
          : null,
      selectedItem: _selectedRoute,
      enabled: selectedRouteNummer.isEmpty,
      //clearButtonProps: const ClearButtonProps(isVisible: true),
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

  Widget getSelectedRouteResponse() {
    return StreamBuilder<ResponseList<RouteOrganization>>(
      stream: _routeOrganizationBloc.routeOrganizationStream,
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
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _isRouteLoading = false;
                });
              });

              if (snapshot.data!.data!.isNotEmpty) {
                selectedRouteNummer = snapshot.data!.data![0].nummer.toString();

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    RouteList matchingRoute = _routeList.firstWhere(
                      (route) => route.nummer == selectedRouteNummer,
                    );
                    if (!_isSelectRouteCompleted) {
                      _isSelectRouteCompleted = true;
                      _selectedRoute = matchingRoute;
                    }
                  });
                });
              }
              break;
            case Status.ERROR:
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!_isSelectedRouteErrorMessageShown) {
                  _isSelectedRouteErrorMessageShown = true;
                  showErrorAlertDialog(context, snapshot.data!.message.toString());
                  setState(() {
                    _isRouteLoading = false;
                  });
                }
              });
              break;
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
              _isUpdateRouteCompleted = true;
              if (!_isUpdateRouteLoaded) {
                print(snapshot.data!.data.toString());
                _isUpdateRouteLoaded = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    _isUpdateRouteLoading = false;
                  });
                  if (!_isSuccessMessageShown) {
                    _isSuccessMessageShown = true;
                  }
                  if (_selectedRoute != null) {
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

  void _checkForSuccess() {
    print("RRRRR");
    print(_isUpdateRouteCompleted);
    print(_isUpdateOrganizationCompleted);
    print(_isFinalSuccessMessageShown);
    if (_isUpdateRouteCompleted && _isUpdateOrganizationCompleted && !_isFinalSuccessMessageShown) {
      setState(() {
        _isFinalSuccessMessageShown = true;
      });
      showSuccessAlertDialogUpdateOrganization(context, "${widget.organizationName} has been updated.");
    }
  }
}
