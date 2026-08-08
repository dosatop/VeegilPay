import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:veegil_pay/core/network/dio_provider.dart';
import 'package:veegil_pay/core/theme/app_colors.dart';
import 'package:veegil_pay/core/widgets/custom_textfield.dart';
import 'package:veegil_pay/core/widgets/overlay_pill.dart';
import 'package:veegil_pay/features/auth/models/login_info.dart';
import 'package:veegil_pay/features/auth/provider/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:veegil_pay/features/auth/models/login_request.dart';
import 'package:veegil_pay/features/auth/provider/saved_login_provider.dart';
import 'package:veegil_pay/features/profile/presentation/overlay_providerd.dart';

class LoginPage extends ConsumerStatefulWidget {
  final Function()? onTogglePage;

  const LoginPage({super.key, this.onTogglePage});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final message = ref.read(overlayMessageProvider);

      if (message != null) {
        showOverlayPill(context, message);

        ref.read(overlayMessageProvider.notifier).state = null;
      }
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final savedLogin = ref.watch(savedLoginProvider);
  
    final showPhoneNumberInput = savedLogin.phoneNumber == null;
   
    final authState = ref.watch(authProvider);

    final size = MediaQuery.of(context).size;
    final keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
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
                                            "Experience effortless banking.",
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
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.08),

                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.08,
                        ),

                        child: Form(
                          key: _formKey,

                          child: Column(
                            children: [
                              if (showPhoneNumberInput)
                                CustomTextfield(
                                  enabled: !authState.isLoading,
                                  hintText: "Account Number",
                                  controller: _phoneController,
                                  iconType: Icons.email_outlined,
                                  textFieldName: 'Account number',
                                  textInputType: TextInputType.number,

                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return "Account number is required";
                                    }

                                    if (value.length != 11) {
                                      return "Account number has to be exactly 11 digits";
                                    }

                                    return null;
                                  },

                                  obscureText: false,
                                ),

                              const SizedBox(height: 8),

                              CustomTextfield(
                                enabled: !authState.isLoading,
                                hintText: "Password",
                                obscureText: true,
                                controller: _passwordController,
                                showPasswordToggle: !authState.isLoading,
                                iconType: Icons.lock_clock_outlined,
                                forceObscure: authState.isLoading,

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

                              const SizedBox(height: 10),
                              SizedBox(
                                height: 20,
                                child: Center(
                                  child: _errorMessage != null
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                              const SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                height: 50,

                                child: ElevatedButton(
                                  onPressed: () async {
                                    FocusScope.of(context).unfocus();

                                    if (!_formKey.currentState!.validate()) {
                                      return;
                                    }

                                    setState(() {
                                      _errorMessage = null;
                                    });

                                    final request = LogInRequest(
                                      phoneNumber: showPhoneNumberInput
                                          ? _phoneController.text.trim()
                                          : savedLogin.phoneNumber!,
                                      password: _passwordController.text.trim(),
                                    );

                                    final error = await ref
                                        .read(authProvider.notifier)
                                        .login(request);

                                    if (!mounted) return;

                                    if (error == null) {
                                      final storage = ref.read(
                                        secureStorageProvider,
                                      );

                                      await storage.saveLoginInfo(
                                        LoginInfo(
                                          phoneNumber: request.phoneNumber,
                                        ),
                                      );

                                      await ref
                                          .read(savedLoginProvider.notifier)
                                          .loadSavedLogin();

                                      if (!mounted) return;

                                      showOverlayPill(
                                        context,
                                        "Login Successful",
                                      );

                                      context.go('/dashboard');
                                    } else {
                                      if (!mounted) return;

                                      setState(() {
                                        _errorMessage = getLoginErrorMessage(
                                          !showPhoneNumberInput &&
                                                  error.contains(
                                                    "INVALID_CREDENTIALS",
                                                  )
                                              ? "INVALID_PASSWORD"
                                              : error,
                                        );
                                      });
                                    }
                                  },

                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF091993),
                                    foregroundColor: Colors.white,
                                  ),

                                  child: ref.watch(authProvider).isLoading
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

                              SizedBox(height: size.height * 0.1),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,

                                children: [
                                  if (showPhoneNumberInput)
                                    Text("Don't have an account?"),

                                  TextButton(
                                    onPressed: () async {
                                      if (!authState.isLoading) {
                                        setState(() {
                                          _errorMessage = null;
                                        });

                                        final storage = ref.read(
                                          secureStorageProvider,
                                        );

                                        if (showPhoneNumberInput) {
                                          ref
                                              .read(savedLoginProvider.notifier)
                                              .clearSavedLogin();

                                          widget.onTogglePage?.call();
                                        } else {
                                          await storage.clearLoginInfo();

                                          ref
                                              .read(savedLoginProvider.notifier)
                                              .clearSavedLogin();

                                          _phoneController.clear();
                                          _passwordController.clear();
                                        }
                                      }
                                    },

                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.only(
                                        left: size.width * 0.01,
                                      ),
                                      minimumSize: Size.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),

                                    child: Text(
                                      showPhoneNumberInput
                                          ? "Sign up"
                                          : "Switch Account",
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

  String getLoginErrorMessage(String error) {
    switch (error) {
      case "NETWORK_ERROR":
        return "No internet connection. Please check your network";

      case "INVALID_CREDENTIALS":
        return "Incorrect account number or password";

      case "ACCOUNT_NOT_FOUND":
      case "USER_NOT_FOUND":
        return "Account not found";

      case "INVALID_PASSWORD":
      case "PASSWORD_INVALID":
        return "Incorrect password";

      case "UNAUTHORIZED":
        return "Session expired, please login again";

      default:
        return error.isNotEmpty ? error : "Unable to login. Please try again";
    }
  }
}
