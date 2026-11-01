import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/app_controller.dart';

/// Prints money only through `fmtBdt` / `fmtBdtMinor` with localized digits,
/// scaled down instead of clipped when space is short (requirement 13.2).
class StMoneyText extends ConsumerWidget {
  /// Whole taka.
  const StMoneyText(int taka, {super.key, this.style, this.align = Alignment.centerLeft})
      : _amount = taka,
        _minor = false;

  /// Integer minor units (paisa).
  const StMoneyText.minor(int minor, {super.key, this.style, this.align = Alignment.centerLeft})
      : _amount = minor,
        _minor = true;

  final int _amount;
  final bool _minor;
  final TextStyle? style;
  final AlignmentGeometry align;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    final label = _minor ? s.moneyMinor(_amount) : s.money(_amount);
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: align,
      child: Text(label, maxLines: 1, style: style),
    );
  }
}
