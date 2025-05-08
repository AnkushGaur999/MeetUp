import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/presentation/bloc/auth/auth_bloc.dart';
import 'package:meet_up/presentation/pages/widgets/auth_form_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpState();
}

class _SignUpState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _ageEditingController = TextEditingController();

  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _numberEditingController =
      TextEditingController();

  final TextEditingController _passwordEditingController =
      TextEditingController();
  final TextEditingController _confirmPasswordEditingController =
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
          "Sign Up",
          style: TextStyle(
            color: Colors.blue.shade800,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
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
                "Please Enter All The Details",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600,
                ),
              ),

              SizedBox(height: 10),

              AuthFormField(
                controller: _nameEditingController,
                hint: "Enter full name",
                keyboardType: TextInputType.name,
              ),

              AuthFormField(
                controller: _ageEditingController,
                hint: "Enter age",
                keyboardType: TextInputType.number,
                maxLength: 2,
              ),

              AuthFormField(
                controller: _emailEditingController,
                hint: "Enter email address",
                keyboardType: TextInputType.emailAddress,
              ),

              AuthFormField(
                controller: _numberEditingController,
                hint: "Enter mobile number",
                keyboardType: TextInputType.number,
                maxLength: 10,
              ),

              AuthFormField(
                controller: _passwordEditingController,
                hint: "Enter new password",
              ),

              AuthFormField(
                controller: _confirmPasswordEditingController,
                hint: "Enter confirm password",
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

                  if (state is SignUpLoadingState) {
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

                  if (state is SignUpLoadedState) {
                    context.pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.data.message!)),
                    );

                  }
                  if (state is SignUpFailedState) {
                    context.pop();
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.message)));
                  }
                },
                child: ElevatedButton(
                  onPressed: () => _validate(),
                  child: Text("Sign Up"),
                ),
              ),

              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  void _validate() {
    if (_formKey.currentState!.validate()) {
      if (_passwordEditingController.text !=
          _confirmPasswordEditingController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "New password and Confirm Password should are not matched",
            ),
          ),
        );
        return;
      }

      context.read<AuthBloc>().add(
        UserSignUpEvent(
          phone: _numberEditingController.text,
          password: _passwordEditingController.text,
          name: _nameEditingController.text,
          email: _emailEditingController.text,
          age: int.tryParse(_ageEditingController.text)!,
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameEditingController.dispose();
    _ageEditingController.dispose();
    _emailEditingController.dispose();
    _numberEditingController.dispose();
    _passwordEditingController.dispose();
    _confirmPasswordEditingController.dispose();
  }
}
