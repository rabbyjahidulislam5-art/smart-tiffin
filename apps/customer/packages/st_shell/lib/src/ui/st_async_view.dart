import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';

import '../state/app_controller.dart';
import '../state/app_state.dart';
import 'st_error_text.dart';
import 'st_offline_banner.dart';
import 'st_screen_state.dart';
import 'st_status_panel.dart';
import 'st_unavailable_panel.dart';

/// Maps an [AsyncValue] from a repository-backed controller to the screen
/// states the screen's spec lists (design "Screen-state pattern").
///
/// The global `AppState.variant` override is still handled by `StScreen`.
class StAsyncView<T> extends ConsumerWidget {
  const StAsyncView({
    super.key,
    required this.value,
    required this.builder,
    required this.supported,
    this.isEmpty,
    this.onRetry,
    this.emptyMessage,
    this.emptyAction,
  });

  final AsyncValue<T> value;
  final Widget Function(BuildContext context, T data) builder;
  final Set<StVariant> supported;
  final bool Function(T data)? isEmpty;
  final VoidCallback? onRetry;
  final StText? emptyMessage;
  final ({StText label, VoidCallback onTap})? emptyAction;

  static const _offlineTitle = StText("You're offline", 'আপনি অফলাইনে');
  static const _offlineSub = StText('Check your connection.', 'ইন্টারনেট সংযোগ দেখুন।');
  static const _emptyDefault = StText('Nothing here yet', 'এখানে এখনো কিছু নেই');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offline = ref.watch(appProvider.select((s) => s.offline));
    final data = value.valueOrNull;
    final state = resolveScreenState(
      loading: value.isLoading,
      hasError: value.hasError,
      isEmpty: data != null && (isEmpty?.call(data) ?? false),
      offline: offline,
      supported: supported,
    );
    switch (state) {
      case StResolvedState.loading:
        return const StSkeleton();
      case StResolvedState.offline:
        return StStatusPanel(icon: Icons.wifi_off_rounded, title: _offlineTitle, sub: _offlineSub, onRetry: onRetry);
      case StResolvedState.error:
        final err = value.error;
        final kind = err is RepoError ? err.kind : RepoErrorKind.internalError;
        if (StErrorText.isUnavailable(kind)) return const StUnavailablePanel();
        return StStatusPanel(
          icon: Icons.warning_amber_rounded,
          title: StErrorText.message(kind),
          onRetry: StErrorText.canRetry(kind) ? onRetry : null,
        );
      case StResolvedState.empty:
        return StStatusPanel(icon: Icons.inbox_outlined, title: emptyMessage ?? _emptyDefault, action: emptyAction);
      case StResolvedState.data:
        final body = builder(context, data as T);
        if (!showsOfflineBanner(offline: offline, supported: supported)) return body;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [const StOfflineBanner(), body],
        );
    }
  }
}
