import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_domain/st_domain.dart';

import 'app_state.dart';
import 'confirm_opts.dart';
import 'denied_request.dart';
import 'nav_entry.dart';
import 'shell_config.dart';
import 'st_store.dart';

// LC-1: the legacy automatic role switch (`roleOf` in `go`/`reset`) is removed.
// Every navigation is decided by `decideAccess`; a refusal sets `denied` and
// leaves the stack, the role and the sessions unchanged.

class AppController extends StateNotifier<AppState> {
  AppController(this.config)
      : super(AppState(role: config.initialRole, stack: [NavEntry(config.initialRoute)]));

  final StShellConfig config;

  void setLang(StLang l) => state = state.copyWith(lang: l);

  /// Sets the active role and records its session (DD-4).
  void setRole(StRole r) => state = state.copyWith(role: r, sessions: {...state.sessions, r});
  void setVariant(StVariant v) => state = state.copyWith(variant: v);
  void setThemeMode(StThemeMode m) => state = state.copyWith(themeMode: m);

  void patchStore(StStore Function(StStore) fn) =>
      state = state.copyWith(store: fn(state.store));

  /// The access decision for [id] in the current state.
  AccessDecision decide(String id) => decideAccess(
        screenId: id,
        activeRole: state.role,
        sessions: state.sessions,
        appRoles: config.roles,
        knownIds: config.knownIds.isEmpty ? {id} : config.knownIds,
      );

  bool canOpen(String id) => decide(id) is Allowed;

  void go(String id, [Map<String, String>? p]) {
    final decision = decide(id);
    if (decision is Denied) {
      state = state.copyWith(denied: DeniedRequest(id, decision.reason), clearSheet: true);
      return;
    }
    state = state.copyWith(
      stack: [...state.stack, NavEntry(id, p ?? const {})],
      variant: StVariant.normal,
      clearSheet: true,
      clearDenied: true,
    );
  }

  void reset(String id, [Map<String, String>? p]) {
    final decision = decide(id);
    if (decision is Denied) {
      state = state.copyWith(denied: DeniedRequest(id, decision.reason), clearSheet: true);
      return;
    }
    state = state.copyWith(
      stack: [NavEntry(id, p ?? const {})],
      variant: StVariant.normal,
      clearSheet: true,
      clearDenied: true,
    );
  }
  void back() {
    if (state.stack.length <= 1) {
      if (state.denied != null) clearDenied();
      return;
    }
    final popped = state.stack.last;
    final leavesSignIn = popped.id == 'AU-03' || popped.id == config.signInRoute;
    state = state.copyWith(
      stack: state.stack.sublist(0, state.stack.length - 1),
      variant: StVariant.normal,
      clearSheet: true,
      clearDenied: true,
      clearAfterLogin: leavesSignIn,
    );
  }

  /// Ends the active role's session only (DD-4), clears the saved intent and
  /// any overlay, and opens the app's sign-in screen (requirement 10.5).
  void signOut() {
    final sessions = {...state.sessions}..remove(state.role);
    state = state.copyWith(
      sessions: sessions,
      stack: [NavEntry(config.signInRoute)],
      variant: StVariant.normal,
      clearAfterLogin: true,
      clearDenied: true,
      clearSheet: true,
      clearConfirm: true,
    );
  }

  void clearDenied() => state = state.copyWith(clearDenied: true);

  void setOffline(bool v) => state = state.copyWith(offline: v);

  void showConfirm(ConfirmOpts o) => state = state.copyWith(confirm: o);
  void closeConfirm() => state = state.copyWith(clearConfirm: true);
  void showSheet(Widget w) => state = state.copyWith(sheet: w);
  void closeSheet() => state = state.copyWith(clearSheet: true);
  void setAfterLogin(NavEntry? e) => state = e == null
      ? state.copyWith(clearAfterLogin: true)
      : state.copyWith(afterLogin: e);
  void toast(String msg) => state = state.copyWith(toast: msg);
  void clearToast() => state = state.copyWith(clearToast: true);
}

final appProvider = StateNotifierProvider<AppController, AppState>((ref) {
  return AppController(ref.watch(shellConfigProvider));
});
