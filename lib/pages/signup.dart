import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:todo/services.dart';
import 'package:todo/router.gr.dart';
import 'package:flutter_form_validators/form_validators.dart';

@RoutePage()
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isButtonLoading = false;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 100.0),
                const Image(
                  height: 100.0,
                  width: 100.0,
                  image: AssetImage('assets/logo.png'),
                ),
                const SizedBox(height: 60.0),
                const Text(
                  'Create a new account',
                  style: TextStyle(fontSize: 18.0),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.always,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: email,
                          autofocus: true,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            isDense: true,
                            labelText: 'Email',
                          ),
                          validator: FormValidators.compose([
                            FormValidators.required(),
                            FormValidators.email(),
                          ]),
                        ),
                        const SizedBox(height: 14.0),
                        TextFormField(
                          controller: password,
                          obscureText: !_isPasswordVisible,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            isDense: true,
                            labelText: 'Password',
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                          validator: FormValidators.compose([
                            FormValidators.required(),
                            FormValidators.minLength(8),
                          ]),
                        ),
                        const SizedBox(height: 14.0),
                        TextFormField(
                            controller: confirmPassword,
                            obscureText: !_isPasswordVisible,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              isDense: true,
                              labelText: 'Confirm Password',
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                            ),
                            validator: FormValidators.compose([
                              FormValidators.required(),
                              (value) => value != password.text
                                  ? 'Value must be same as above'
                                  : null
                            ])),
                        const SizedBox(height: 14.0),
                        FilledButton(
                          style: FilledButton.styleFrom(
                            elevation: 6,
                            minimumSize: const Size.fromHeight(50),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            disabledBackgroundColor:
                                Theme.of(context).colorScheme.primary,
                          ),
                          onPressed: _isButtonLoading
                              ? null
                              : () async {
                                  setState(() {
                                    _isButtonLoading = true;
                                  });

                                  if (_formKey.currentState!.validate()) {
                                    try {
                                      await AuthService()
                                          .signup(email.text, password.text);
                                      if (context.mounted) {
                                        context.router
                                          ..popUntilRoot()
                                          ..replace(const HomeRoute());
                                      }
                                    } on AuthException catch (e) {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(e.message),
                                          ),
                                        );
                                      }
                                    }
                                  }

                                  setState(() {
                                    _isButtonLoading = false;
                                  });
                                },
                          child: _isButtonLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'CREATE ACCOUNT',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                Wrap(
                  spacing: 4.0,
                  children: [
                    const Text('Already have an account?'),
                    InkWell(
                      child: const Text(
                        'LOGIN',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        context.router
                          ..popUntilRoot()
                          ..replace(const SignInRoute());
                      },
                    ),
                  ],
                )
                // TextButton(
                //   onPressed: () {},
                //   child: const Text('Register'),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
