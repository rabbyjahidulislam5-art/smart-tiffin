import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';

import '../state/app_controller.dart';
import '../state/app_state.dart';
import '../state/shell_config.dart';
import 'st_app_shell.dart';

class SmartTiffinApp extends ConsumerWidget {
  const SmartTiffinApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    final role = StColors.roleOf(s.role.name);
    final platformDark =
        WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
    final useDark = switch (s.themeMode) {
      StThemeMode.dark => true,
      StThemeMode.light => false,
      StThemeMode.system => platformDark,
    };
    final theme = useDark ? StTheme.dark(role: role) : StTheme.light(role: role);
    final overlay = StTheme.overlayFor(useDark ? Brightness.dark : Brightness.light, theme.scaffoldBackgroundColor);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlay,
      child: MaterialApp(
        title: ref.watch(shellConfigProvider).appTitle,
        debugShowCheckedModeBanner: false,
        theme: theme,
        locale: s.lang == StLang.bn ? const Locale('bn') : const Locale('en'),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('bn')],
        home: const StAppShell(),
      ),
    );
  }
}
