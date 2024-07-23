import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sdm/blocs/add_goods_management_bloc.dart';
import 'package:sdm/blocs/add_organization_bloc.dart';
import 'package:sdm/blocs/customer_type_bloc.dart';
import 'package:sdm/models/add_goods_management.dart';
import 'package:sdm/models/add_organization.dart';
import 'package:sdm/models/customer_type.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/utils/constants.dart';
import 'package:sdm/utils/validations.dart';
import 'package:sdm/widgets/app_button.dart';
import 'package:sdm/widgets/appbar.dart';
import 'package:sdm/widgets/background_decoration.dart';
import 'package:sdm/widgets/error_alert.dart';
import 'package:sdm/widgets/loading.dart';
import 'package:sdm/widgets/success_alert.dart';
import 'package:geolocator/geolocator.dart';

class AddOrganizationView extends StatefulWidget {
  final String userNummer;
  final String username;
  final String loggedUserNummer;
  final bool isTeamMemberUi;

  const AddOrganizationView({
    Key? key,
    required this.userNummer,
    required this.username,
    required this.loggedUserNummer,
    required this.isTeamMemberUi,
  }) : super(key: key);

  @override
  State<AddOrganizationView> createState() => _AddOrganizationViewState();
}

class _AddOrganizationViewState extends State<AddOrganizationView> {
  late CustomerTypeBloc _customerTypeBloc;
  late AddOrganizationBloc _addOrganizationBloc;
  late AddGoodsManagementBloc _addGoodsManagementBloc;
  List<CustomerType>? _allCustomerTypes;
  late String latitude;
  late String longitude;
  bool _isSuccessMessageShown = false;
  bool _isAddGoodsManagementAPICall = false;
  bool _isErrorMessageShown = false;
  late String organizationNummer;
  late String organizationSearchWord;
  bool _isUpdateLoading = false;
  bool _isCustomerTypeLoading = false;
  bool _isSubmitPressed = false;
  bool _isOrganizationTypeShown = false;

  final _formKey = GlobalKey<FormState>();
  String? _selectedCustomerType;
  int? _selectedCustomerTypeIndex;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phone1Controller = TextEditingController();
  final _phone2Controller = TextEditingController();
  final _address1Controller = TextEditingController();
  final _address2Controller = TextEditingController();
  final _address3Controller = TextEditingController();
  final _address4Controller = TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phone1FocusNode = FocusNode();
  final FocusNode _phone2FocusNode = FocusNode();
  final FocusNode _address1FocusNode = FocusNode();
  final FocusNode _address2FocusNode = FocusNode();
  final FocusNode _address3FocusNode = FocusNode();
  final FocusNode _address4FocusNode = FocusNode();

  final Map<String, bool?> _validationStatus = {
    'name': null,
    'email': null,
    'phone1': null,
    'phone2': null,
    'address1': null,
    'address2': null,
    'address3': null,
    'address4': null,
  };

  final Map<String, String?> _validationMessages = {
    'name': null,
    'email': null,
    'phone1': null,
    'phone2': null,
    'address1': null,
    'address2': null,
    'address3': null,
    'address4': null,
  };

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {});
      return;
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {});
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {});
      return;
    }

    // Get the current position
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    latitude = position.latitude.toString();
    longitude = position.longitude.toString();
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
    _emailController.clear();
    _phone1Controller.clear();
    _phone2Controller.clear();
    _address1Controller.clear();
    _address2Controller.clear();
    _address3Controller.clear();
    _address4Controller.clear();

    _selectedCustomerType = null;
    _selectedCustomerTypeIndex = null; // Reset the toggle buttons selection

    _validationStatus.updateAll((key, value) => null);
    _validationMessages.updateAll((key, value) => null);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _isCustomerTypeLoading = true;
    });
    _isCustomerTypeLoading = true;
    _customerTypeBloc = CustomerTypeBloc();
    _customerTypeBloc.getCustomerType();
    _addOrganizationBloc = AddOrganizationBloc();
    _addGoodsManagementBloc = AddGoodsManagementBloc();
  }

  @override
  void dispose() {
    _customerTypeBloc.dispose();
    _addOrganizationBloc.dispose();
    _addGoodsManagementBloc.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phone1Controller.dispose();
    _phone2Controller.dispose();
    _address1Controller.dispose();
    _address2Controller.dispose();
    _address3Controller.dispose();
    _address4Controller.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _phone1FocusNode.dispose();
    _phone2FocusNode.dispose();
    _address1FocusNode.dispose();
    _address2FocusNode.dispose();
    _address3FocusNode.dispose();
    _address4FocusNode.dispose();
    super.dispose();
  }

  void _validateField(String fieldName) {
    setState(() {
      _isSuccessMessageShown = true;
      _isErrorMessageShown = true;
      switch (fieldName) {
        case 'name':
          _validationMessages['name'] = _validateName(_nameController.text);
          _validationStatus['name'] = _validationMessages['name'] == null;
          break;
        case 'email':
          _validationMessages['email'] = _validateEmail(_emailController.text);
          _validationStatus['email'] = _validationMessages['email'] == null;
          break;
        case 'phone1':
          _validationMessages['phone1'] = null;
          _validationStatus['phone1'] = true;
          break;
        case 'phone2':
          _validationMessages['phone2'] = null;
          _validationStatus['phone2'] = true;
          break;
        case 'address1':
          _validationMessages['address1'] = null;
          _validationStatus['address1'] = true;
          break;
        case 'address2':
          _validationMessages['address2'] = null;
          _validationStatus['address2'] = true;
          break;
        case 'address3':
          _validationMessages['address3'] = null;
          _validationStatus['address3'] = true;
          break;
        case 'address4':
          _validationMessages['address4'] = null;
          _validationStatus['address4'] = true;
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

  String? _validateEmail(String? value) {
    if (!value!.isValidEmail) {
      return 'Please enter a valid email';
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
                          addOrganizationResponse(),
                          addGoodsManagementResponse(),
                          customerTypeToggleButtons(),
                          if (_isOrganizationTypeShown)
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
                            controller: _address1Controller,
                            label: 'Address Line 1',
                            fieldName: 'address1',
                            focusNode: _address1FocusNode,
                            validator: (value) => null,
                          ),
                          const SizedBox(height: 16),
                          _buildValidatedTextFormField(
                            controller: _address2Controller,
                            label: 'Address Line 2',
                            fieldName: 'address2',
                            focusNode: _address2FocusNode,
                            validator: (value) => null,
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
                            controller: _address4Controller,
                            label: 'Address Line 4',
                            fieldName: 'address4',
                            focusNode: _address4FocusNode,
                            validator: (value) => null,
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: CommonAppButton(
                              buttonText: 'Submit',
                              onPressed: () {
                                setState(() {
                                  _isUpdateLoading = true;
                                });
                                _nameController.text = capitalizeWords(_nameController.text);
                                _phone1Controller.text = capitalizeWords(_phone1Controller.text);
                                _phone2Controller.text = capitalizeWords(_phone2Controller.text);
                                _address1Controller.text = capitalizeWords(_address1Controller.text);
                                _address2Controller.text = capitalizeWords(_address2Controller.text);
                                _address3Controller.text = capitalizeWords(_address3Controller.text);
                                _address4Controller.text = capitalizeWords(_address4Controller.text);

                                final customerTypeValidation = _validateCustomerType();
                                if (_formKey.currentState!.validate() && customerTypeValidation == null) {
                                  setState(() {
                                    _isUpdateLoading = true;
                                  });
                                  _getCurrentLocation().then((_) {
                                    setState(() {
                                      _isSuccessMessageShown = false;
                                      _isAddGoodsManagementAPICall = false;
                                      _isErrorMessageShown = false;
                                    });

                                    final customerTypeId = _selectedCustomerType.toString();
                                    final name = _nameController.text.toString();
                                    final email = _emailController.text.toString();
                                    final phone1 = _phone1Controller.text.toString();
                                    final phone2 = _phone2Controller.text.toString();
                                    final address1 = _address1Controller.text.toString();
                                    final address2 = _address2Controller.text.toString();
                                    final address3 = _address3Controller.text.toString();
                                    final address4 = _address4Controller.text.toString();

                                    if (!_isSubmitPressed) {
                                      _isSubmitPressed = true;
                                      _addOrganizationBloc.addOrganization(
                                          getSearchWord(name),
                                          name,
                                          email,
                                          phone1,
                                          phone2,
                                          address1,
                                          address2,
                                          address3,
                                          address4,
                                          latitude,
                                          longitude,
                                          customerTypeId,
                                          widget.loggedUserNummer);
                                    }
                                  });
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
            if (_isUpdateLoading || _isCustomerTypeLoading) const Loading(),
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
                  _isOrganizationTypeShown = true;
                  _isCustomerTypeLoading = false;
                });
              });
              _allCustomerTypes = snapshot.data!.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Organization Type', style: TextStyle(color: CustomColors.cardTextColor1)),
                  const SizedBox(height: 8),
                  ToggleButtons(
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
                        _selectedCustomerTypeIndex = index;
                        _selectedCustomerType = _allCustomerTypes![index].vaufzelemId;
                      });
                    },
                    children: _allCustomerTypes!.map((CustomerType type) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(type.aebez.toString()),
                      );
                    }).toList(),
                  ),
                ],
              );
            case Status.ERROR:
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _isCustomerTypeLoading = false;
                });
                showErrorAlertDialog(context, snapshot.data!.message.toString());
              });
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
              organizationNummer = snapshot.data!.data!.nummer.toString();
              organizationSearchWord = snapshot.data!.data!.such.toString();

              if (!_isAddGoodsManagementAPICall) {
                _addGoodsManagementBloc.addGoodsManagement(organizationSearchWord, organizationNummer);
                _isAddGoodsManagementAPICall = true;
              }
              _isSubmitPressed = false;
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
              if (!_isSuccessMessageShown) {
                final name = _nameController.text.toString();
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showSuccessAlertDialog(context, "$name has been added successfully.");
                  setState(() {
                    _isSuccessMessageShown = true;
                  });
                  Future.delayed(const Duration(milliseconds: 500), () {
                    setState(() {
                      clearFormFields();
                    });
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
              if (!_isErrorMessageShown) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showErrorAlertDialog(context, snapshot.data!.message.toString());
                  setState(() {
                    _isErrorMessageShown = true;
                  });
                });
              }
          }
        }
        return Container();
      },
    );
  }
}
