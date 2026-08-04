import 'package:flutter/material.dart';
import 'package:veegil_pay/features/auth/presentation/pages/sign_up_page.dart';
import 'login_page.dart';

class LogInOrSignUp extends StatefulWidget {
  final bool isLogin;

  const LogInOrSignUp({super.key, this.isLogin = true});

  @override
  State<LogInOrSignUp> createState() => _LogInOrSignUpState();
}

class _LogInOrSignUpState extends State<LogInOrSignUp> {
  late bool isLogin;
  // Change this to false to show the register page

  @override
  void initState() {
    super.initState();
    isLogin = widget.isLogin;
  }

  void togglePage() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLogin
        ? LoginPage(onTogglePage: togglePage)
        : SignUpPage(onTogglePage: togglePage);
  }
}
