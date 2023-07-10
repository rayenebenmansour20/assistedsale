import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helper/constant.dart';
import '../../helper/responsive.dart';
import '../../state/auth_provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticationProvider>(context);

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/shopping-box.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Align(
            alignment: isLargeScreen(context)
                ? Alignment.centerRight
                : Alignment.center,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
              child: Container(
                padding: const EdgeInsets.all(0),
                height: height,
                width: isLargeScreen(context) ? width / 3 : width,
                margin: EdgeInsets.symmetric(
                  horizontal:
                      isLargeScreen(context) ? height * 0.12 : height * 0.032,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xffF6F6F6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height / 6,
                      ),
                      Center(
                        child: Image.asset(
                          'assets/images/datamasterlogo.png',
                          fit: BoxFit.contain,
                          height: 70,
                        ),
                      ),
                      SizedBox(height: height * 0.1),
                      const SizedBox(height: 6.0),
                      Center(
                        child: Container(
                          height: 43.0,
                          width: 364,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            color: Colors.white,
                          ),
                          child: TextFormField(
                            controller: _emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entre votre email';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              suffixIcon: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: ColorFiltered(
                                      colorFilter: const ColorFilter.mode(
                                          Colors.white, BlendMode.srcIn),
                                      child: Image.asset(AppIcons.emailIcon),
                                    ),
                                  ),
                                ],
                              ),
                              contentPadding:
                                  const EdgeInsets.only(top: 16.0, left: 16),
                              hintText: 'Entrer votre email',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.040),
                      const SizedBox(height: 6.0),
                      Center(
                        child: Container(
                          height: 45.0,
                          width: 364,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            color: Colors.white,
                          ),
                          child: TextFormField(
                            controller: _passwordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entre votre mot de passe';
                              }
                              return null;
                            },
                            obscureText: _obscureText,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: IconButton(
                                icon: Icon(
                                  _obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.blue,
                                ),
                                onPressed: _togglePasswordVisibility,
                              ),
                              suffixIcon: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          border: Border.all(
                                            width: 10,
                                            color: Colors.blue,
                                          )),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: ColorFiltered(
                                      colorFilter: const ColorFilter.mode(
                                          Colors.white, BlendMode.srcIn),
                                      child: Image.asset(AppIcons.lockIcon),
                                    ),
                                  ),
                                ],
                              ),
                              contentPadding: const EdgeInsets.only(top: 16.0),
                              hintText: 'Enter Password',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.05),
                      Consumer<AuthenticationProvider>(
                        builder: (context, auth, child) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (auth.resMessage != '') {
                              showMessage(
                                  message: auth.resMessage, context: context);

                              ///Clear the response message to avoid duplicate
                              auth.clear();
                            }
                          });
                          return Material(
                            borderRadius: BorderRadius.circular(4.0),
                            child: InkWell(
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  if (_emailController.text.isEmpty ||
                                      _passwordController.text.isEmpty) {
                                    showMessage(
                                        message: auth.resMessage,
                                        context: context);
                                  } else {
                                    auth.loginUser(
                                        context: context,
                                        email: _emailController.text,
                                        password: _passwordController.text);
                                  }
                                }
                              },
                              child: Center(
                                child: Ink(
                                  height: 43,
                                  width: 364,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4.0),
                                    color: Colors.blue,
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Se connecter',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Copyright 2023',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Image.asset(
                              'assets/images/datamasterpetitlogo.png', // replace with your logo image path
                              width: 100,
                              height: 100,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
        /*
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                authProvider.loginUser(
                  context: context,
                  email: _emailController.text,
                  password: _passwordController.text,
                );
              },
              child: const Text('Log In'),
            ),
          ],
        ),*/
      ),
    );
  }
}
