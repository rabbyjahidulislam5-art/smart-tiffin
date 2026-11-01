import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_shell/st_shell.dart';

/// Guest footer navigation of P-01, P-02 and P-03. Moved here from three
/// identical private copies (`_GuestNav`), code unchanged.
class GuestNav extends ConsumerWidget {
  const GuestNav({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    final ctrl = ref.read(appProvider.notifier);
    final t = s.t;
    final role = context.roleColor;
    final tabs = [
      ('P-01', 'Home', 'হোম', Icons.home_rounded),
      ('P-02', 'Menu', 'মেনু', Icons.restaurant_rounded),
      ('P-03', 'Plans', 'প্ল্যান', Icons.calendar_month_rounded),
      ('AU-03', 'Account', 'অ্যাকাউন্ট', Icons.person_rounded),
    ];
    return Row(
      children: [
        for (final tab in tabs)
          Expanded(
            child: InkWell(
              onTap: () => tab.$1 == 'AU-03' ? ctrl.go(tab.$1) : ctrl.reset(tab.$1),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(tab.$4, color: s.current.id == tab.$1 ? role : Theme.of(context).hintColor),
                  Text(
                    t(tab.$2, tab.$3),
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: s.current.id == tab.$1 ? role : Theme.of(context).hintColor),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
