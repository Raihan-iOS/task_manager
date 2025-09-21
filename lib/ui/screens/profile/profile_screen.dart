import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/ui/widgets/app_bar.dart';
import 'package:task_manager/ui/widgets/photo_upload.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';

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
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(hintText: "First Name"),
                    controller: _firstNameController,
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(hintText: "Last Name"),
                    controller: _lastNameController,
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(hintText: "Mobile No"),
                    controller: _mobileNoController,
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(hintText: "Password"),
                    controller: _passwordController,
                    obscureText: true,
                  ),
                  SizedBox(height: 24),
                  FilledButton(
                    onPressed: () {},
                    child: Icon(Icons.arrow_circle_right),
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
