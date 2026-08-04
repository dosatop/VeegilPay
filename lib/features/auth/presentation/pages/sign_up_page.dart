import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:veegil_pay/core/theme/app_colors.dart';
import 'package:veegil_pay/core/widgets/custom_textfield.dart';
import 'package:veegil_pay/features/auth/models/signup_request.dart';
import 'package:veegil_pay/features/auth/provider/auth_provider.dart';

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

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // ref.listen(authProvider, (previous, next) {
    //   next.whenOrNull(
    //     data: (_) {
    //       context.go('/dashboard');
    //     },

    //     error: (error, _) {
    //       ScaffoldMessenger.of(
    //         context,
    //       ).showSnackBar(SnackBar(content: Text(error.toString())));
    //     },
    //   );
    // });

    final size = MediaQuery.of(context).size;

    final keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      resizeToAvoidBottomInset: true,

      body: SafeArea(
        child: SingleChildScrollView(
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

                        if (!keyboardOpen)
                          const Text(
                            "Register to join seamless banking transactions",

                            style: TextStyle(
                              color: Colors.white70,

                              fontSize: 15,
                            ),
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
                        controller: _phoneController,

                        hintText: "Phone Number",

                        iconType: Icons.phone_android,

                        textFieldName: "Phone Number",

                        textInputType: TextInputType.phone,

                        obscureText: false,

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Phone number is required";
                          }

                          if (value.length < 11) {
                            return "Enter a valid phone number";
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 10),

                      CustomTextfield(
                        controller: _passwordController,

                        hintText: "Password",

                        iconType: Icons.lock_outline,

                        textFieldName: "Password",
                        showPasswordToggle: true,

                        obscureText: true,

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
                        controller: _confirmPasswordController,

                        hintText: "Confirm Password",

                        iconType: Icons.lock_outline,

                        textFieldName: "Confirm Password",

                        obscureText: true,
                        showPasswordToggle: true,

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

                      const SizedBox(height: 30),

                      SizedBox(
                        width: double.infinity,

                        height: 50,

                        child: ElevatedButton(
                          onPressed: authState.isLoading
                              ? null
                              : () async {
                                  if (!_formKey.currentState!.validate()) {
                                    return;
                                  }

                                  final request = SignupRequest(
                                    phoneNumber: _phoneController.text.trim(),

                                    password: _passwordController.text.trim(),
                                  );

                                  final success = await ref
                                      .read(authProvider.notifier)
                                      .signup(request);

                                  if (!mounted) return;

                                  if (success) {
                                    _phoneController.clear();
                                    _passwordController.clear();
                                    _confirmPasswordController.clear();

                                    // Navigate only after success
                                    context.go('/dashboard');
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

                      const SizedBox(height: 20),

                      TextButton(
                        onPressed: widget.onTogglePage,

                        child: const Text(
                          "Already have an account? Login",

                          style: TextStyle(color: Color(0xFF091993)),
                        ),
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
}
