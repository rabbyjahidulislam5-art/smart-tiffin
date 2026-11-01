import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_shell/st_shell.dart';

import 'navigation/partner_app_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppMotion.personality = MotionPersonality.balanced;
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(
    ProviderScope(
      overrides: [shellConfigProvider.overrideWithValue(partnerAppConfig)],
      child: const SmartTiffinApp(),
    ),
  );
}
