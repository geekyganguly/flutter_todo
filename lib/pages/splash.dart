import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:todo/services.dart';
import 'package:todo/router.gr.dart';

@RoutePage()
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 2000), () {
      final Session? session = supabase.auth.currentSession;
      context.router.replace(
        session != null ? const HomeRoute() : const SignInRoute(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                height: 100.0,
                width: 100.0,
                image: AssetImage('assets/logo.png'),
              ),
              Padding(
                padding: EdgeInsets.all(60),
                child: LinearProgressIndicator(
                  minHeight: 6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
