import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/data/models/user_model.dart';
import 'package:task_manager/data/services/api_caller.dart';
import 'package:task_manager/ui/screens/Controller/auth_controller.dart';
import 'package:task_manager/ui/widgets/app_bar.dart';
import 'package:task_manager/ui/widgets/photo_upload.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';

import '../../../data/utils/constant.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  static const String routeName = '/profile';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileNoController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;
  bool _updateProfileInProgress = false;
  @override
  void initState() {

    super.initState();
  _loadUserData();

  }

  Future<void> _loadUserData() async {
    // ✅ Wait for user data if not loaded yet
    if (AuthController.userModel == null) {
      await AuthController.getUserData();
    }

    UserModel? user = AuthController.userModel;

    if (user != null) {
      _emailController.text = user.email;
      _firstNameController.text = user.firstName;
      _lastNameController.text = user.lastName;
      _mobileNoController.text = user.mobile;

      debugPrint("User Photo Data: ${user.photo}");

      setState(() {});
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TmAppbar(),
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24),
                  Text(
                    "Update Profile",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),

                  SizedBox(height: 24),
                  photo_upload_field(
                    onTap: _pickImageFromGallery,
                    selectedImage: _selectedImage,
                  ),

                  SizedBox(height: 8),

                  TextFormField(
                    decoration: InputDecoration(hintText: "Email"),
                    controller: _emailController,
                    enabled: false,

                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(hintText: "First Name"),
                    controller: _firstNameController,
                    validator: (String? value) {
                      if (value?.isEmpty ?? false) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(hintText: "Last Name"),
                    controller: _lastNameController,
                    validator: (String? value) {
                      if (value?.isEmpty ?? false) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(hintText: "Mobile No"),
                    validator: (String? value) {
                      if (value?.isEmpty ?? false) {
                        return 'Please enter your mobile number';
                      }
                      return null;
                    },
                    controller: _mobileNoController,
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(hintText: "Password (optional)"),
                    controller: _passwordController,
                    obscureText: true,
                    validator: (value) {
                      if ((value != null && value.isNotEmpty) && value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24),
                  Visibility(
                    visible: _updateProfileInProgress == false,
                    replacement: Center(child: CircularProgressIndicator()),
                    child: FilledButton(
                      onPressed: () {
                        _onTapUpdateProfile();

                      },
                      child: Icon(Icons.arrow_circle_right),
                    ),
                  ),
                  SizedBox(height: 36),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapUpdateProfile() {
    if (_formKey.currentState?.validate() ?? false) {
      _updateProfile();
    }
  }

  Future<void> _updateProfile() async {
    _updateProfileInProgress = true;
    setState(() {});

    final Map<String,dynamic> requestBody = {
      "firstName": _firstNameController.text.trim(),
      "lastName": _lastNameController.text.trim(),
      "mobile": _mobileNoController.text.trim(),
      if (_passwordController.text.isNotEmpty)
        "password": _passwordController.text.trim(),
    };
    String? encodedPhotoData;
    if (_selectedImage != null) {
      List<int> bytes = await _selectedImage!.readAsBytes();
      encodedPhotoData = base64Encode(bytes); // ✅ FIXED
      requestBody['photo'] = encodedPhotoData;
    }
    final  ApiResponse apiResponse = await ApiCaller.postRequest(url: Urls.updateProfile, body: requestBody);
    _updateProfileInProgress = false;
    setState(() {});
    if(apiResponse.isSuccess) {
      // Profile updated successfully
      _passwordController.clear();
      UserModel userModel = UserModel(id: AuthController.userModel!.id ,
          email: _emailController.text.trim() ,
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          mobile: _mobileNoController.text.trim(),
           photo: encodedPhotoData ?? AuthController.userModel!.photo,
      );
      await AuthController.updateProfile(userModel);
      setState(() {
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );
    } else {
      // Failed to update profile
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(apiResponse.errorMessage ?? 'Failed to update profile')),
      );
    }
  }

  Future<void> _pickImageFromGallery() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // Handle the selected image
      print('Image selected: ${image.path}');
      _selectedImage = image;
      setState(() {});
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileNoController.dispose();
    super.dispose();
  }
}
