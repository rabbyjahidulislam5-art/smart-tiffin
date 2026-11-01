import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';

import '../nav/st_open.dart';
import '../state/app_controller.dart';
import 'st_host_entry.dart';

/// The registry-added entries of a host, in the legacy `StList` look.
class StHostEntryList extends ConsumerWidget {
  const StHostEntryList({super.key, required this.entries});

  final List<StHostEntry> entries;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    final current = s.current.params;
    return StList(
      children: [
        for (final e in entries)
          StRowTile(
            key: ValueKey('host-entry-${e.id}'),
            icon: e.icon ?? Icons.arrow_forward_rounded,
            label: s.tx(e.label),
            sub: e.sub == null ? null : s.tx(e.sub!),
            onTap: () => stOpen(ref, e.id, {
              ...e.params,
              for (final k in e.forward)
                if (current[k] != null) k: current[k]!,
              for (final r in e.rename.entries)
                if (current[r.key] != null) r.value: current[r.key]!,
            }),
          ),
      ],
    );
  }
}
