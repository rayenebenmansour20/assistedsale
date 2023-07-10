import 'package:flutter/material.dart';
import 'package:flutter_datamaster/helper/shared_preference_helper.dart';
import 'package:flutter_datamaster/ui/home.dart';
import 'package:flutter_datamaster/ui/page/login.dart';

import '../../helper/routes.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    navigate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset("assets/images/datamasterlogo.png"),
      ),
    );
  }

  void navigate() {
    Future.delayed(const Duration(seconds: 3), () {
      SharedPreferenceHelper().getToken().then((value) {
        if (value == null) {
          PageNavigator(ctx: context).nextPage(page: const Login());
        } else {
          PageNavigator(ctx: context).nextPage(page: const Home());
        }
      });
    });
  }
}
