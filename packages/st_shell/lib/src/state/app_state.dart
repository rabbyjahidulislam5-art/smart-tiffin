import 'package:flutter/material.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';

import 'confirm_opts.dart';
import 'denied_request.dart';
import 'nav_entry.dart';
import 'st_store.dart';

enum StLang { en, bn }

// LC-7: `StRole` moved to st_domain (`access/st_role.dart`); st_shell
// re-exports it so every `import 'package:st_shell/st_shell.dart'` keeps working.

enum StVariant { normal, empty, loading, error, offline, denied }

enum StThemeMode { light, dark, system }

enum AppStatus { pending, info, rejected, approved }

class AppState {
  const AppState({
    this.lang = StLang.en,
    this.role = StRole.customer,
    this.variant = StVariant.normal,
    this.themeMode = StThemeMode.light,
    this.stack = const [NavEntry('P-01')],
    this.store = const StStore(),
    this.confirm,
    this.sheet,
    this.afterLogin,
    this.toast,
    this.sessions = const {},
    this.denied,
    this.offline = false,
  });

  final StLang lang;
  final StRole role;
  final StVariant variant;
  final StThemeMode themeMode;
  final List<NavEntry> stack;
  final StStore store;
  final ConfirmOpts? confirm;
  final Widget? sheet;
  final NavEntry? afterLogin;
  final String? toast;

  /// LC-2: roles with a signed-in session.
  final Set<StRole> sessions;

  /// LC-2: last refused navigation.
  final DeniedRequest? denied;

  /// LC-2: simulated connectivity (mock phase).
  final bool offline;

  NavEntry get current => stack.last;

  /// LC-2: [role] when it has a session, otherwise null.
  StRole? get activeRole => sessions.contains(role) ? role : null;

  /// LC-2: English when the Bangla string is blank (requirement 12.6).
  String t(String en, String bn) => localized(lang == StLang.bn ? 'bn' : 'en', en, bn);

  /// Renders an [StText]; `{i}` placeholders get [args] (digits localized).
  String tx(StText text, [List<String> args = const []]) =>
      StText.fill(t(text.en, text.bn), [for (final a in args) digits(a)]);

  /// Bangla digits when the language is Bangla.
  String digits(String s) => lang == StLang.bn ? bnDigits(s) : s;

  /// Whole-taka label through `fmtBdt`.
  String money(int taka) => moneyLabel(taka, bn: lang == StLang.bn);

  /// Minor-unit label through `fmtBdtMinor`.
  String moneyMinor(int minor) => moneyLabelMinor(minor, bn: lang == StLang.bn);

  Color get roleColor => StColors.roleOf(role.name);
  AppState copyWith({
    StLang? lang,
    StRole? role,
    StVariant? variant,
    StThemeMode? themeMode,
    List<NavEntry>? stack,
    StStore? store,
    ConfirmOpts? confirm,
    bool clearConfirm = false,
    Widget? sheet,
    bool clearSheet = false,
    NavEntry? afterLogin,
    bool clearAfterLogin = false,
    String? toast,
    bool clearToast = false,
    Set<StRole>? sessions,
    DeniedRequest? denied,
    bool clearDenied = false,
    bool? offline,
  }) {
    return AppState(
      lang: lang ?? this.lang,
      role: role ?? this.role,
      variant: variant ?? this.variant,
      themeMode: themeMode ?? this.themeMode,
      stack: stack ?? this.stack,
      store: store ?? this.store,
      confirm: clearConfirm ? null : (confirm ?? this.confirm),
      sheet: clearSheet ? null : (sheet ?? this.sheet),
      afterLogin: clearAfterLogin ? null : (afterLogin ?? this.afterLogin),
      toast: clearToast ? null : (toast ?? this.toast),
      sessions: sessions ?? this.sessions,
      denied: clearDenied ? null : (denied ?? this.denied),
      offline: offline ?? this.offline,
    );
  }
}
