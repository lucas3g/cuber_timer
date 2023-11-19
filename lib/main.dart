import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl_standalone.dart';

import 'app/app_module.dart';
import 'app/app_widget.dart';

Future<void> main() async {
  await initializeDateFormatting(await findSystemLocale(), '');

  WidgetsFlutterBinding.ensureInitialized();

  MobileAds.instance.initialize();

  runApp(
    ModularApp(
      module: AppModule(),
      child: const AppWidget(),
    ),
  );
}
