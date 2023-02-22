import 'package:auction_app/pages/signup_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../auth/auth_service.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';
import '../utils/helper_functions.dart';
import 'launcher_page.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';

  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String errMsg = '';
  bool _isObscure = true;
  late UserProvider userProvider;

  @override
  void didChangeDependencies() {
    userProvider = Provider.of<UserProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset("images/login.svg"),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 36.0, vertical: 8.0),
                        child: TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.email),
                              hintText: 'Enter Your Email',
                              labelText: 'Enter Your Email',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: const BorderSide(
                                      color: Colors.blue, width: 1))),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email is required';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 36.0, vertical: 8.0),
                        child: TextFormField(
                          obscureText: _isObscure,
                          controller: _passwordController,
                          decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.password),
                              labelText: 'Enter your password',
                              hintText: 'Enter your password',
                              suffixIcon: IconButton(
                                  icon: Icon(_isObscure
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      _isObscure = !_isObscure;
                                    });
                                  }),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: const BorderSide(
                                    color: Colors.blue,
                                    width: 1,
                                  ))),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password is required';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 36.0, vertical: 8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            _authenticate();
                          },
                          child: Text(
                            "Login".toUpperCase(),
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      RichText(
                          text: TextSpan(children: [
                        const TextSpan(
                          text: 'Don\'t have an account??',
                          style: TextStyle(color: Colors.red),
                        ),
                        TextSpan(
                          text: '\tSingUp',
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Navigator.pushNamed(
                                context, SignUpPage.routeName),
                        ),
                      ])),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'OR',
                        style: TextStyle(color: Colors.red),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Sign In with',
                        style: TextStyle(color: Colors.red),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          _signInWithGoogleAccount(userProvider);
                        },
                        child: Card(
                          elevation: 10,
                          shadowColor: Colors.red,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'images/google.png',
                                  height: 20,
                                  width: 20,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Text(
                                  'Google',
                                  style: TextStyle(
                                      fontSize: 22, color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void _authenticate() async {
    if (_formKey.currentState!.validate()) {
      EasyLoading.show(status: 'Please wait', dismissOnTap: false);
      final email = _emailController.text;
      final password = _passwordController.text;
      try {
        if (await AuthService.login(email, password)) {
          if (await userProvider.doesUserExist(AuthService.currentUser!.uid)) {
            EasyLoading.dismiss();
            if (mounted)
              Navigator.pushReplacementNamed(context, LauncherPage.routeName);
          } else {
            EasyLoading.dismiss();
            if (mounted) showMsg(context, 'Please sign up first');
          }
        }
        EasyLoading.dismiss();
      } on FirebaseAuthException catch (error) {
        EasyLoading.dismiss();
        showMsg(context, 'Please sign up first');
      }
    }
  }

  void _signInWithGoogleAccount(UserProvider userProvider) async {
    try {
      final credential = await AuthService.signInWithGoogle();

      final userExists = await userProvider.doesUserExist(credential.user!.uid);
      if (!userExists) {
        EasyLoading.show(status: 'Redirecting user...');
        final userModel = UserModel(
          userId: credential.user!.uid,
          email: credential.user!.email!,
          userCreationTime: Timestamp.fromDate(
              AuthService.currentUser!.metadata.creationTime!),
          displayName: credential.user!.displayName,
          phone: credential.user!.phoneNumber,
        );
        await userProvider.addUser(userModel).then(
              (value) => Navigator.pushReplacementNamed(
                context,
                LauncherPage.routeName,
              ),
            );
        EasyLoading.dismiss();
      } else {
        if (mounted) {
          Navigator.pushReplacementNamed(
            context,
            LauncherPage.routeName,
          );
        }
      }
    } catch (error) {
      EasyLoading.dismiss();
      rethrow;
    }
  }
}
