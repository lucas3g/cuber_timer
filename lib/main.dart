import 'package:flutter/material.dart';

import 'app/app_widget.dart';
import 'app/di/dependency_injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureDependencies();

  runApp(const AppWidget());
}
