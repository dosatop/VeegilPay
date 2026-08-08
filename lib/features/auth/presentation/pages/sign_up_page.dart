import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:veegil_pay/core/network/dio_provider.dart';

import 'package:veegil_pay/core/theme/app_colors.dart';
import 'package:veegil_pay/core/widgets/custom_textfield.dart';
import 'package:veegil_pay/features/auth/models/login_info.dart';
import 'package:veegil_pay/features/auth/models/signup_request.dart';
import 'package:veegil_pay/features/auth/provider/auth_provider.dart';
import 'package:veegil_pay/features/auth/provider/saved_login_provider.dart';

class SignUpPage extends ConsumerStatefulWidget {
  final Function()? onTogglePage;

  const SignUpPage({super.key, this.onTogglePage});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final _phoneController = TextEditingController();

  final _passwordController = TextEditingController();

  final _confirmPasswordController = TextEditingController();
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    final size = MediaQuery.of(context).size;

    final keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      resizeToAvoidBottomInset: true,

      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            children: [
              Stack(
                children: [
                  ClipPath(
                    clipper: WaveClipperOne(),

                    child: Container(
                      height: keyboardOpen
                          ? size.height * .15
                          : size.height * .25,

                      color: const Color(0xFF091993),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(
                      left: size.width * .1,

                      top: size.height * .04,
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          "Sign Up",

                          style: TextStyle(
                            color: Colors.white,

                            fontSize: size.width * .10,

                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          "Register to join hassle-free banking.",

                          style: TextStyle(color: Colors.white70, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 50),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * .08),

                child: Form(
                  key: _formKey,

                  child: Column(
                    children: [
                      CustomTextfield(
                        enabled: !authState.isLoading,
                        controller: _phoneController,

                        hintText: "Phone Number",

                        iconType: Icons.phone_android,

                        textFieldName: "Phone Number",

                        textInputType: TextInputType.phone,

                        obscureText: false,

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Phone number required";
                          }

                          if (value.length < 11) {
                            return "Enter valid phone number";
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 10),

                      CustomTextfield(
                        enabled: !authState.isLoading,
                        controller: _passwordController,

                        hintText: "Password",

                        iconType: Icons.lock_outline,

                        textFieldName: "Password",

                        obscureText: true,

                        showPasswordToggle: !authState.isLoading,
                        forceObscure: authState.isLoading,

                        textInputType: TextInputType.visiblePassword,

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password required";
                          }

                          if (value.length < 8) {
                            return "Minimum 8 characters";
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 10),

                      CustomTextfield(
                        enabled: !authState.isLoading,
                        controller: _confirmPasswordController,

                        hintText: "Confirm Password",

                        iconType: Icons.lock_outline,

                        textFieldName: "Confirm Password",
                        showPasswordToggle: !authState.isLoading,
                        forceObscure: authState.isLoading,

                        obscureText: true,

                        textInputType: TextInputType.visiblePassword,

                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "You need to confirm your password";
                          }

                          if (value != _passwordController.text) {
                            return "Passwords do not match";
                          }

                          return null;
                        },
                      ),

                      SizedBox(
                        height: 35,
                        child: Center(
                          child: _errorMessage != null
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.cancel,
                                      size: 18,
                                      color: Colors.red,
                                    ),

                                    const SizedBox(width: 6),

                                    Flexible(
                                      child: Text(
                                        _errorMessage!,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : null,
                        ),
                      ),

                      SizedBox(
                        width: double.infinity,

                        height: 50,

                        child: ElevatedButton(
                          onPressed: authState.isLoading
                              ? null
                              : () async {
                                  FocusScope.of(context).unfocus();

                                  if (!_formKey.currentState!.validate()) {
                                    return;
                                  }

                                  setState(() {
                                    _errorMessage = null;
                                  });

                                  final request = SignupRequest(
                                    phoneNumber: _phoneController.text.trim(),
                                    password: _passwordController.text.trim(),
                                  );

                                  final error = await ref
                                      .read(authProvider.notifier)
                                      .signup(request);

                                  final storage = ref.read(
                                    secureStorageProvider,
                                  );

                                  if (error == null) {
                                    await storage.saveLoginInfo(
                                      LoginInfo(
                                        phoneNumber: request.phoneNumber,
                                      ),
                                    );

                                    await ref
                                        .read(savedLoginProvider.notifier)
                                        .loadSavedLogin();

                                    _phoneController.clear();
                                    _passwordController.clear();
                                    _confirmPasswordController.clear();

                                    if (!mounted) return;

                                    context.go('/dashboard');
                                  } else {
                                    await storage.clearLoginInfo();

                                    if (!mounted) return;

                                    setState(() {
                                      _errorMessage = getSignupErrorMessage(
                                        error,
                                      );
                                    });
                                  }
                                },

                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF091993),

                            foregroundColor: Colors.white,
                          ),

                          child: authState.isLoading
                              ? const SizedBox(
                                  height: 22,

                                  width: 22,

                                  child: CircularProgressIndicator(
                                    color: AppColors.white,

                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text("Create Account"),
                        ),
                      ),

                      SizedBox(height: size.height * 0.1),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          const Text("Already have an account?"),

                          TextButton(
                            onPressed: () {
                              if (!authState.isLoading) {
                                widget.onTogglePage?.call();
                              }
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.only(left: size.width * 0.01),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),

                            child: const Text(
                              "Log in",
                              style: TextStyle(color: Color(0xFF091993)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getSignupErrorMessage(String? code) {
    switch (code) {
      case "NETWORK_ERROR":
      case "NO_CONNECTION":
        return "No internet connection. Please check your network";

      case "PHONE_NUMBER_ALREADY_EXISTS":
      case "PHONE_TAKEN":
        return "Phone number is already registered";

      case "WEAK_PASSWORD":
        return "Password is too weak";

      case "PASSWORD_INVALID":
        return "Password must be at least 8 characters";

      case "INVALID_PHONE_NUMBER":
        return "Invalid phone number";

      case "VALIDATION_ERROR":
        return "Please check your details";

      default:
        return "Unable to create account. Please try again";
    }
  }
}
