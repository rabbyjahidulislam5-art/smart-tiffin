import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

class RiderQueueScreen extends ConsumerWidget {
  const RiderQueueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.read(appProvider.notifier);
    final t = ref.watch(appProvider).t;
    final role = context.roleColor;
    final items = [
      ('#TK-912', 'Nusrat Jahan', 'Navana Tower, Gulshan 1', '1:30 PM', 'PRIORITY', meals[2].img, '৳50'),
      ('#TK-913', 'Farhan Kabir', 'Plot 7, Road 5, Dhanmondi', '1:45 PM', null, meals[4].img, '৳55'),
      ('#TK-914', 'Ayesha Rahman', 'Banani DOHS Gate', '2:00 PM', null, meals[1].img, '৳45'),
    ];
    return Theme(
      data: Theme.of(context).copyWith(extensions: [const StRoleTheme(role: StColors.rider)]),
      child: StScreen(
        title: t('Delivery Queue', 'ডেলিভারি কিউ'),
        child: Column(
          children: [
            AppReveal(
              index: 0,
              child: StCard(
                child: Row(
                  children: [
                    Expanded(child: Text(t('3 queued · next window 1:30 PM', '৩ কিউ · পরবর্তী ১:৩০'), style: const TextStyle(fontWeight: FontWeight.w800))),
                    StChip(tone: StTone.info, child: Text(t('Online', 'অনলাইন'))),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            for (var i = 0; i < items.length; i++)
              AppReveal(
                index: i + 1,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: StCard(
                    onTap: () => ctrl.go('R-10'),
                    child: Row(
                      children: [
                        Container(
                          width: 4,
                          height: 64,
                          decoration: BoxDecoration(color: role, borderRadius: BorderRadius.circular(4)),
                        ),
                        const SizedBox(width: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            items[i].$6,
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(width: 48, height: 48, color: StColors.muted),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row( // layout-ok
                                children: [
                                  Text(
                                    items[i].$1,
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Theme.of(context).hintColor),
                                  ),
                                  if (items[i].$5 != null) ...[
                                    const SizedBox(width: 6),
                                    StChip(tone: StTone.danger, child: Text(items[i].$5!)),
                                  ],
                                ],
                              ),
                              Text(items[i].$2, style: const TextStyle(fontWeight: FontWeight.w800)),
                              Text(
                                '${items[i].$3} · Est. ${items[i].$4}',
                                style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Text(items[i].$7, style: TextStyle(fontWeight: FontWeight.w800, color: role)),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
