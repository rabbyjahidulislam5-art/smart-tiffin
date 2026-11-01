import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';

import '../state/app_controller.dart';
import 'st_error_text.dart';

/// Error, offline and empty panel in the legacy `StStateView` look. The Retry
/// control disables itself after one activation until the panel is rebuilt
/// with new input (requirement 11.5).
class StStatusPanel extends ConsumerStatefulWidget {
  const StStatusPanel({super.key, required this.icon, required this.title, this.sub, this.onRetry, this.action});

  final IconData icon;
  final StText title;
  final StText? sub;
  final VoidCallback? onRetry;
  final ({StText label, VoidCallback onTap})? action;

  @override
  ConsumerState<StStatusPanel> createState() => _StStatusPanelState();
}

class _StStatusPanelState extends ConsumerState<StStatusPanel> {
  bool _retrying = false;

  @override
  void didUpdateWidget(covariant StStatusPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    _retrying = false;
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(appProvider);
    final role = context.roleColor;
    final retry = widget.onRetry;
    final action = widget.action;
    final sub = widget.sub;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: StSpace.xxl),
      child: Column(
        children: [
          Container(
            width: StSize.hero,
            height: StSize.hero,
            decoration: BoxDecoration(color: role.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(StRadius.card)),
            child: Icon(widget.icon, color: role, size: StSize.iconLg),
          ),
          const SizedBox(height: StSpace.sm),
          Text(s.tx(widget.title), textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700)),
          if (sub != null) ...[
            const SizedBox(height: StSpace.xxs),
            Text(s.tx(sub), textAlign: TextAlign.center, style: TextStyle(fontSize: StFont.body, color: Theme.of(context).hintColor)),
          ],
          if (retry != null) ...[
            const SizedBox(height: StSpace.sm),
            StBtn(
              label: s.tx(StErrorText.retry),
              variant: StBtnVariant.soft,
              disabled: _retrying,
              onTap: () {
                setState(() => _retrying = true);
                retry();
              },
            ),
          ],
          if (action != null) ...[
            const SizedBox(height: StSpace.sm),
            StBtn(label: s.tx(action.label), onTap: action.onTap),
          ],
        ],
      ),
    );
  }
}
