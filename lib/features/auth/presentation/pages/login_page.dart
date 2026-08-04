import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:veegil_pay/core/network/dio_provider.dart';
import 'package:veegil_pay/core/theme/app_colors.dart';
import 'package:veegil_pay/core/widgets/custom_textfield.dart';
import 'package:veegil_pay/features/auth/models/login_info.dart';
import 'package:veegil_pay/features/auth/provider/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:veegil_pay/features/auth/models/login_request.dart';
// import 'package:veegil_pay/core/widgets/horizontal_divider.dart';

class LoginPage extends ConsumerStatefulWidget {
  final Function()? onTogglePage;

  const LoginPage({super.key, this.onTogglePage});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  // final StorageService storageService = StorageService();
  final _formKey = GlobalKey<FormState>();

  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedLogin();
  }

  Future<void> _loadSavedLogin() async {
    final storage = ref.read(secureStorageProvider);

    final loginInfo = await storage.getLoginInfo();

    if (loginInfo == null) return;

    if (loginInfo.rememberMe) {
      setState(() {
        _phoneController.text = loginInfo.phoneNumber;
        _passwordController.text = loginInfo.password;
        _rememberMe = true;
      });
    }
  }

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
      // backgroundColor: const Color.fromARGB(255, 9, 25, 147),
      resizeToAvoidBottomInset: true,
      body: PopScope(
        canPop: false,
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          ClipPath(
                            clipper: WaveClipperOne(),
                            child: Container(
                              height: keyboardOpen
                                  ? size.height * 0.15
                                  : size.height * 0.27,
                              color: const Color.fromARGB(255, 9, 25, 147),
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.only(
                              left: size.width * 0.1,
                              top: size.height * 0.04,
                              right: size.width * 0.05,
                            ),

                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,

                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,

                                      children: [
                                        Text(
                                          "Log In",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: size.width * 0.10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                        const SizedBox(height: 8),

                                        SizedBox(
                                          width: size.width * 0.6,

                                          child: Text(
                                            "Experience effortless banking anytime, anywhere",
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: size.width * 0.038,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                SizedBox(
                                  height: keyboardOpen
                                      ? size.height * 0.05
                                      : size.height * 0.08,
                                ),

                                // if (!keyboardOpen)
                                //   Text("VeegilPay"),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.08),
                      // FORM
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.08,
                        ),

                        child: Form(
                          key: _formKey,

                          child: Column(
                            children: [
                              CustomTextfield(
                                hintText: "Account Number",
                                controller: _phoneController,
                                iconType: Icons.email_outlined,
                                textFieldName: 'Account number',
                                textInputType: TextInputType.number,

                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return "Account number is required";
                                  }

                                  if (value.length < 11) {
                                    return "Account number has to be 11 digits";
                                  }

                                  return null;
                                },

                                obscureText: false,
                              ),

                              const SizedBox(height: 8),

                              CustomTextfield(
                                hintText: "Password",
                                obscureText: true,
                                controller: _passwordController,
                                showPasswordToggle: true,
                                iconType: Icons.lock_clock_outlined,

                                textFieldName: 'Password',

                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return "Password is required";
                                  }

                                  if (value.length < 8) {
                                    return "Must be at least 8 characters";
                                  }

                                  return null;
                                },

                                textInputType: TextInputType.visiblePassword,
                              ),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,

                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: _rememberMe,
                                        onChanged: (value) async {
                                          final onChangedValue = value ?? false;

                                          setState(() {
                                            _rememberMe = onChangedValue;
                                          });
                                        },
                                        activeColor: const Color.fromARGB(
                                          255,
                                          9,
                                          25,
                                          147,
                                        ),

                                        shape: const CircleBorder(),

                                        visualDensity: VisualDensity.compact,
                                      ),

                                      const Text(
                                        "Remember me",
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),

                                  TextButton(
                                    onPressed: () {},

                                    child: const Text(
                                      "Forgot password?",
                                      style: TextStyle(
                                        color: Color(0xFF091993),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                height: 50,

                                child: ElevatedButton(
                                  onPressed: authState.isLoading
                                      ? null
                                      : () async {
                                          if (!_formKey.currentState!
                                              .validate()) {
                                            return;
                                          }

                                          final request = LogInRequest(
                                            phoneNumber: _phoneController.text
                                                .trim(),
                                            password: _passwordController.text
                                                .trim(),
                                          );

                                          final success = await ref
                                              .read(authProvider.notifier)
                                              .login(request);

                                          final storage = ref.read(
                                            secureStorageProvider,
                                          );
                                          if (success) {
                                            if (_rememberMe) {
                                              await storage.saveLoginInfo(
                                                LoginInfo(
                                                  phoneNumber: _phoneController
                                                      .text
                                                      .trim(),
                                                  password: _passwordController
                                                      .text
                                                      .trim(),
                                                  rememberMe: true,
                                                ),
                                              );
                                            }

                                            if (!_rememberMe) {
                                              await storage.clearLoginInfo();
                                            }
                                            
                                            if (!mounted) return;

                                            context.go('/dashboard');
                                          } else {
                                            await storage.clearLoginInfo();
                                            if (!mounted) return;

                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text("Login failed"),
                                              ),
                                            );
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
                                      : const Text("Login"),
                                ),
                              ),
                              // SizedBox(
                              //   width: double.infinity,

                              //   height: 50,

                              //   child: Consumer<AuthProvider>(
                              //     builder: (context, auth, child) {
                              //       return ElevatedButton(
                              //         onPressed: auth.isLoading
                              //             ? null
                              //             : () async {
                              //                 if (!_formKey.currentState!
                              //                     .validate()) {
                              //                   return;
                              //                 }

                              //                 final success = await auth.login(
                              //                   LoginRequest(
                              //                     email: _emailController.text
                              //                         .trim(),

                              //                     password:
                              //                         _passwordController.text,
                              //                   ),
                              //                 );

                              //                 if (!mounted) return;

                              //                 if (success) {
                              //                   if (_rememberMe) {
                              //                     await storageService
                              //                         .saveLoginInfo(
                              //                           _emailController.text,
                              //                           _passwordController
                              //                               .text,
                              //                           true,
                              //                         );
                              //                   } else {
                              //                     await storageService
                              //                         .clearLoginInfo();
                              //                   }

                              //                   if (!context.mounted) return;

                              //                   Navigator.pushNamedAndRemoveUntil(
                              //                     context,
                              //                     '/dashboard',
                              //                     (route) => false,
                              //                   );
                              //                 } else {
                              //                   print(
                              //                     "Login failed: ${auth.error}",
                              //                   );
                              //                   ScaffoldMessenger.of(
                              //                     context,
                              //                   ).showSnackBar(
                              //                     SnackBar(
                              //                       content: Text(
                              //                         "Error: ${auth.error}",
                              //                       ),
                              //                     ),
                              //                   );
                              //                 }
                              //               },

                              //         style: ElevatedButton.styleFrom(
                              //           backgroundColor: const Color.fromARGB(
                              //             255,
                              //             9,
                              //             25,
                              //             147,
                              //           ),

                              //           foregroundColor: Colors.white,
                              //         ),

                              //         child: auth.isLoading
                              //             ? SizedBox(
                              //                 width: 24,
                              //                 height: 24,
                              //                 child: CircularProgressIndicator(
                              //                   color: Color.fromARGB(
                              //                     255,
                              //                     9,
                              //                     25,
                              //                     147,
                              //                   ),
                              //                   strokeWidth:
                              //                       2, // Optional: makes the ring thinner
                              //                 ),
                              //               )
                              //             : const Text("Login"),
                              //       );
                              //     },
                              //   ),
                              // ),
                              SizedBox(height: size.height * 0.08),

                              // HorizontalDivider(textString: "OR"),
                              const SizedBox(height: 15),

                              // AuthTile(
                              //   authText: "Sign in with Google",
                              //   imageLink: "lib/assets/svgs/google.svg",
                              // ),
                              const SizedBox(height: 12),

                              // AuthTile(
                              //   authText: "Sign in with Apple",
                              //   imageLink: "lib/assets/svgs/apple.svg",
                              // ),
                              const SizedBox(height: 15),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,

                                children: [
                                  const Text("Don't have an account?"),

                                  TextButton(
                                    onPressed: widget.onTogglePage,

                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.only(
                                        left: size.width * 0.01,
                                      ),
                                      minimumSize: Size.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),

                                    child: const Text(
                                      "Sign up",
                                      style: TextStyle(
                                        color: Color(0xFF091993),
                                      ),
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
              );
            },
          ),
        ),
      ),
    );
  }
}
