import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_management/common/auth_controller.dart';
import 'package:task_management/common/widgets/app_background.dart';
import 'package:task_management/common/widgets/common_app_bar.dart';
import 'package:task_management/config/routes/routes.dart';
import 'package:task_management/constants/api_path.dart';
import 'package:task_management/constants/app_colors.dart';
import 'package:task_management/constants/app_strings.dart';
import 'package:task_management/network/network_response.dart';
import 'package:task_management/network/network_service.dart';
import 'package:task_management/screens/profile/model/profile_details_model.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final AuthenticationController _authController = AuthenticationController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isProgress = false;
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  String? _profileBase64Image;

  @override
  void initState() {
    super.initState();
    _getProfileDetails();
  }

  Future<void> _getProfileDetails() async {
    setState(() {
      _isProgress = true;
    });
    final NetworkResponse response = await NetworkService.getRequest(
        context: context, url: ApiPath.profileDetails);
    setState(() {
      _isProgress = false;
    });
    if (response.isSuccess) {
      final ProfileDetailsModel profileDetails =
          ProfileDetailsModel.fromJson(response.requestResponse);
      final profileData = profileDetails.data?.first;

      if (profileData != null) {
        _emailController.text = profileData.email ?? '';
        _firstNameController.text = profileData.firstName ?? '';
        _lastNameController.text = profileData.lastName ?? '';
        _mobileController.text = profileData.mobile ?? '';
        _passwordController.text = profileData.password ?? '';
        _profileBase64Image = profileData.photo;
      }
    } else {
      Fluttertoast.showToast(
          msg: response.errorMessage, backgroundColor: AppColors.colorRed);
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _profileUpdate() async {
    setState(() {
      _isProgress = true;
    });

    String? base64Image;
    if (_selectedImage != null) {
      final bytes = await _selectedImage!.readAsBytes();
      base64Image = base64Encode(bytes);
    }

    final Map<String, String> requestBody = {
      "email": _emailController.text.trim(),
      "firstName": _firstNameController.text,
      "lastName": _lastNameController.text,
      "mobile": _mobileController.text.trim(),
      "password": _passwordController.text,
      "photo": base64Image ?? '',
    };

    final NetworkResponse response = await NetworkService.postRequest(
        context: context, url: ApiPath.profileUpdate, requestBody: requestBody);
    setState(() {
      _isProgress = false;
    });
    if (response.isSuccess) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.signIn,
        (route) => false,
      );
      Fluttertoast.showToast(
          msg: "Profile Update Complete",
          backgroundColor: AppColors.colorGreen);
      await _authController.clearSharedPreferenceData();
    } else {
      Fluttertoast.showToast(
          msg: response.errorMessage, backgroundColor: AppColors.colorRed);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CommonAppBar(),
      body: AppBackground(
        child: Visibility(
          visible: !_isProgress,
          replacement: const Center(
            child: CircularProgressIndicator(
              backgroundColor: AppColors.colorGreen,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              reverse: true,
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : (_profileBase64Image != null
                              ? MemoryImage(base64Decode(_profileBase64Image!))
                              : null),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildProfileUpdateForm(context, formKey),
                  Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileUpdateForm(
    BuildContext context,
    GlobalKey<FormState> formKey,
  ) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            enabled: false,
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: "Email"),
          ),
          const SizedBox(height: 20),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: _firstNameController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(hintText: "First Name"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter first name";
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: _lastNameController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(hintText: "Last Name"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter last name";
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: _mobileController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(hintText: "Mobile"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter mobile number";
              } else if (!RegExp(RegularExpression.phone).hasMatch(value)) {
                return "Invalid phone number format";
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: _passwordController,
            decoration: const InputDecoration(hintText: "Password"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter password";
              } else if (!RegExp(RegularExpression.password).hasMatch(value)) {
                return "At least 8 characters and both letters and numbers";
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          Visibility(
            visible: !_isProgress,
            child: ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  _profileUpdate();
                }
              },
              child: const Icon(
                Icons.arrow_circle_right_outlined,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
