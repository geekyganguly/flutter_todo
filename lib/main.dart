import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:todo/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // load env
  await dotenv.load();

  // initialize supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'].toString(),
    anonKey: dotenv.env['SUPABASE_KEY'].toString(),
  );

  // initialize app
  runApp(const App());
}
