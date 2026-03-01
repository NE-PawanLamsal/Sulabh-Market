import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth.dart';
import '../constants/colors.dart';
import '../constants/validators.dart';
import '../constants/widgets.dart';
import '../screens/auth/phone_auth_screen.dart';
import 'package:sulabh_market_app/components/signup_buttons.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({
    Key? key,
  }) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  bool obsecure = true;
  Auth authService = Auth();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  late final FocusNode _firstNameNode;
  late final FocusNode _lastNameNode;
  late final FocusNode _emailNode;
  late final FocusNode _passwordNode;
  late final FocusNode _confirmPasswordNode;
  final _formKey = GlobalKey<FormState>();
  File? _userImage; // Variable to store the selected user image

  @override
  void initState() {
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _firstNameNode = FocusNode();
    _lastNameNode = FocusNode();
    _emailNode = FocusNode();
    _passwordNode = FocusNode();
    _confirmPasswordNode = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameNode.dispose();
    _lastNameNode.dispose();
    _emailNode.dispose();
    _passwordNode.dispose();
    _confirmPasswordNode.dispose();
    super.dispose();
  }

  // Method to pick an image from gallery or camera
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _userImage = File(pickedImage.path);
      });
    }
  }

  // Method to upload the user image to Firebase Storage
  Future<String?> _uploadImageToFirebase() async {
    if (_userImage == null) return null;

    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final firebaseStorageRef =
          firebase_storage.FirebaseStorage.instance.ref().child(fileName);
      await firebaseStorageRef.putFile(_userImage!);
      final imageUrl = await firebaseStorageRef.getDownloadURL();
      return imageUrl;
    } catch (e) {
      // Handle image upload error here
      print('Error uploading image: $e');
      return null;
    }
  }

  // Method to handle user registration and image upload
  Future<void> _handleRegistration() async {
    if (_formKey.currentState!.validate()) {
      final imageUrl = await _uploadImageToFirebase();

      if (imageUrl != null) {
        await authService.getAdminCredentialEmailAndPassword(
          context: context,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          isLoginUser: false,
          userImage:
              imageUrl, // Pass the image URL to the registration function
        );
      } else {
        // Handle the case when image upload fails
        print('Image upload failed.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 79,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Circular Avatar for User Image
                  GestureDetector(
                    onTap: _pickImage, // Function to select the user image
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: _userImage != null
                          ? FileImage(_userImage!) // Display selected image
                          : null,
                      child: _userImage == null
                          ? Icon(
                              Icons.add_a_photo,
                              size: 40,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextFormField(
                          focusNode: _firstNameNode,
                          validator: (value) {
                            return checkNullEmptyValidation(
                                value, 'first name');
                          },
                          controller: _firstNameController,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                              labelText: 'First Name',
                              labelStyle: TextStyle(
                                color: greyColor,
                                fontSize: 14,
                              ),
                              hintText: 'Enter your First Name',
                              hintStyle: TextStyle(
                                color: greyColor,
                                fontSize: 14,
                              ),
                              contentPadding: const EdgeInsets.all(15),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8))),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          focusNode: _lastNameNode,
                          validator: (value) {
                            return checkNullEmptyValidation(value, 'last name');
                          },
                          controller: _lastNameController,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                              labelText: 'Last Name',
                              labelStyle: TextStyle(
                                color: greyColor,
                                fontSize: 14,
                              ),
                              hintText: 'Enter your Last Name',
                              hintStyle: TextStyle(
                                color: greyColor,
                                fontSize: 14,
                              ),
                              contentPadding: const EdgeInsets.all(15),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8))),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    focusNode: _emailNode,
                    controller: _emailController,
                    validator: (value) {
                      return validateEmail(value,
                          EmailValidator.validate(_emailController.text));
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          color: greyColor,
                          fontSize: 14,
                        ),
                        hintText: 'Enter your Email',
                        hintStyle: TextStyle(
                          color: greyColor,
                          fontSize: 14,
                        ),
                        contentPadding: const EdgeInsets.all(15),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8))),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    focusNode: _passwordNode,
                    obscureText: obsecure,
                    controller: _passwordController,
                    validator: (value) {
                      return validatePassword(value, _passwordController.text);
                    },
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                            icon: Icon(
                              Icons.remove_red_eye_outlined,
                              color: obsecure ? greyColor : blackColor,
                            ),
                            onPressed: () {
                              setState(() {
                                obsecure = !obsecure;
                              });
                            }),
                        labelText: 'Password',
                        labelStyle: TextStyle(
                          color: greyColor,
                          fontSize: 14,
                        ),
                        hintText: 'Enter Your Password',
                        hintStyle: TextStyle(
                          color: greyColor,
                          fontSize: 14,
                        ),
                        contentPadding: const EdgeInsets.all(15),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8))),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    focusNode: _confirmPasswordNode,
                    obscureText: true,
                    controller: _confirmPasswordController,
                    validator: (value) {
                      return validateSamePassword(
                          value, _passwordController.text);
                    },
                    decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        labelStyle: TextStyle(
                          color: greyColor,
                          fontSize: 14,
                        ),
                        hintText: 'Enter Your Confirm Password',
                        hintStyle: TextStyle(
                          color: greyColor,
                          fontSize: 14,
                        ),
                        contentPadding: const EdgeInsets.all(15),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8))),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  // Add an option to pick an image
                  // TextButton.icon(
                  //   onPressed: _pickImage,
                  //   icon: Icon(Icons.photo),
                  //   label: Text('Add User Image'),
                  // ),
                  const SizedBox(
                    height: 30,
                  ),
                  roundedButton(
                    context: context,
                    bgColor: secondaryColor,
                    text: 'Sign Up',
                    textColor: whiteColor,
                    onPressed: _handleRegistration,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.center,
            child: Text(
              'By Signing up you agree to our Terms and Conditions, and Privacy Policy',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: greyColor,
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            'Or',
            style: TextStyle(
              fontSize: 18,
              color: greyColor,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          SignUpButtons(),
        ],
      ),
    );
  }
}
