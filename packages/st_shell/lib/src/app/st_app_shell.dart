import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';

import '../state/app_controller.dart';
import '../state/confirm_opts.dart';
import '../state/shell_config.dart';
import '../ui/st_denied_screen.dart';

class StAppShell extends ConsumerStatefulWidget {
  const StAppShell({super.key});
  @override
  ConsumerState<StAppShell> createState() => _StAppShellState();
}

class _StAppShellState extends ConsumerState<StAppShell> {
  @override
  Widget build(BuildContext context) {
    final s = ref.watch(appProvider);
    final ctrl = ref.read(appProvider.notifier);
    final roleColor = StColors.roleOf(s.role.name);

    ref.listen<String?>(appProvider.select((a) => a.toast), (prev, next) {
      if (next == null || next.isEmpty) return;
      final messenger = ScaffoldMessenger.of(context);
      messenger.hideCurrentSnackBar();
      messenger
          .showSnackBar(
            SnackBar(
              content: Text(next),
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              duration: const Duration(milliseconds: 2200), // not-motion
            ),
          )
          .closed
          .then((_) {
        if (mounted) ctrl.clearToast();
      });
    });

    return Theme(
      data: Theme.of(context)
          .copyWith(extensions: [StRoleTheme(role: roleColor)]),
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: AnimatedSwitcher(
                duration: AppMotion.md,
                switchInCurve: AppMotion.enter,
                switchOutCurve: AppMotion.exitCurve,
                transitionBuilder: (child, anim) => FadeTransition(
                  opacity: anim,
                  child: SlideTransition(
                    position: Tween<Offset>(
                            begin: const Offset(0.04, 0), end: Offset.zero)
                        .animate(anim),
                    child: child,
                  ),
                ),
                child: KeyedSubtree(
                  key: ValueKey('${s.current.id}-${s.stack.length}'),
                  // LC-5: the guard runs again on the current id; a refused id
                  // never reaches `buildScreen`.
                  child: ctrl.canOpen(s.current.id)
                      ? ref.watch(shellConfigProvider).buildScreen(s.current.id)
                      : const StDeniedScreen(),
                ),
              ),
            ),
            // LC-5: a refused navigation shows the denied screen over the
            // unchanged stack until Back (`clearDenied`).
            if (s.denied != null)
              const Positioned.fill(child: StDeniedScreen()),
            if (s.confirm != null) _ConfirmOverlay(opts: s.confirm!),
            if (s.sheet != null) _SheetOverlay(child: s.sheet!),
          ],
        ),
      ),
    );
  }
}

class _ConfirmOverlay extends ConsumerWidget {
  const _ConfirmOverlay({required this.opts});
  final ConfirmOpts opts;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.read(appProvider.notifier);
    final t = ref.watch(appProvider).t;
    return Material(
      color: Colors.black.withValues(alpha: 0.45),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: StCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(opts.title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w800)),
                  if (opts.body != null) ...[
                    const SizedBox(height: 8),
                    Text(opts.body!,
                        style: TextStyle(
                            color: Theme.of(context).hintColor, height: 1.4)),
                  ],
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: StBtn(
                          label: t('Cancel', 'বাতিল'),
                          variant: StBtnVariant.outline,
                          onTap: ctrl.closeConfirm,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: StBtn(
                          label: opts.ok,
                          variant: opts.danger
                              ? StBtnVariant.danger
                              : StBtnVariant.primary,
                          onTap: () {
                            final fn = opts.onOk;
                            ctrl.closeConfirm();
                            fn();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SheetOverlay extends ConsumerWidget {
  const _SheetOverlay({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.read(appProvider.notifier);
    return Material(
      color: Colors.black.withValues(alpha: 0.45),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * 0.85,
              maxWidth: 560),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: Theme.of(context).dividerColor,
                        borderRadius: BorderRadius.circular(99))),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                      onPressed: ctrl.closeSheet,
                      icon: const Icon(Icons.close)),
                ),
                Flexible(
                    child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                        child: child)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
