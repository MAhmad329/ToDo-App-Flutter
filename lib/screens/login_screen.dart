import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../core/constants/constants.dart';
import '../providers/authentication_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                const Center(
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                        color: AppColors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                const Center(
                  child: Text(
                    'Welcome Back',
                    style: TextStyle(
                      color: AppColors.darkGrey,
                      fontSize: 18,
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.h,
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          hintText: 'Username',
                          controller: _userNameController,
                          obsecureText: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Username';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        CustomTextField(
                          isPasswordField: true,
                          obsecureText: userProvider.isPasswordVisible == true
                              ? false
                              : true,
                          controller: _passwordController,
                          hintText: "Password",
                          suffixTap: () {
                            userProvider.changePasswordVisibility();
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter a password';
                            }

                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        if (userProvider.errorMessage != null)
                          Text(
                            userProvider.errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                      ],
                    )),
                SizedBox(
                  height: 50.h,
                ),
                CustomButton(
                  title: "Sign In",
                  onPress: () {
                    if (_formKey.currentState!.validate()) {
                      userProvider
                          .login(_userNameController.text,
                              _passwordController.text)
                          .then((_) {
                        if (userProvider.user != null) {
                          Navigator.pushReplacementNamed(context, '/tasks');
                        }
                      });
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
