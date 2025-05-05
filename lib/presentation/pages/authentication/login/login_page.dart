import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/config/routes/app_routes.dart';
import 'package:meet_up/presentation/bloc/auth/auth_bloc.dart';
import 'package:meet_up/presentation/pages/widgets/auth_form_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController _numberEditingController =
      TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();

  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Login",
          style: TextStyle(
            color: Colors.blue.shade800,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/app_icon.png"),

                SizedBox(height: 10),

                Text(
                  "MeetUp",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                SizedBox(height: 20),

                Text(
                  "Enter Your Register Mobile Number And Password",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600,
                  ),
                ),

                SizedBox(height: 20),

                AuthFormField(
                  controller: _numberEditingController,
                  hint: "Enter Register Mobile Number",
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                ),

                AuthFormField(
                  controller: _passwordEditingController,
                  hint: "Enter Password",
                  obscureText: _obscureText,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: _togglePasswordVisibility,
                  ),
                ),

                SizedBox(height: 20),

                BlocListener<AuthBloc, AuthStates>(
                  listener: (context, state) {
                    if (state is LoginLoadingState) {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Center(
                              child: Text(
                                "Loading",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                            content: SizedBox(
                              height: 36,
                              width: 36,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [CircularProgressIndicator()],
                              ),
                            ),
                          );
                        },
                      );
                    }

                    if (state is LoginLoadedState) {
                      context.pop();
                      context.goNamed(AppRoutes.dashboard);
                    }
                    if (state is LoginFailedState) {
                      context.pop();
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.message)));
                    }
                  },
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(
                          UserLoginEvent(
                            phone: _numberEditingController.text,
                            password: _passwordEditingController.text,
                          ),
                        );
                      }
                    },
                    child: Text("Login"),
                  ),
                ),

                SizedBox(height: 20),

                RichText(
                  text: TextSpan(
                    text: "Don't have account? ",
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: "Sign Up",
                        style: TextStyle(
                          color: Colors.blue.shade900,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap = () {
                                context.pushNamed(AppRoutes.signUp);
                              },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _numberEditingController.dispose();
    _passwordEditingController.dispose();
  }
}
