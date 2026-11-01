import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

class IncidentLogScreen extends ConsumerWidget {
  const IncidentLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.read(appProvider.notifier);
    final t = ref.watch(appProvider).t;
    final rows = [
      ('#INC-14', t('Rider delay · Banani', 'রাইডার দেরি · বনানী'), t('Open', 'খোলা'), StTone.danger, meals[1].img, 'A-02'),
      ('#INC-13', t('Kitchen late pack', 'কিচেন দেরি প্যাক'), t('Resolved', 'সমাধান'), StTone.success, meals[2].img, 'A-02'),
      ('#DS-07', t('Missing item dispute', 'মিসিং আইটেম বিরোধ'), t('Review', 'পর্যালোচনা'), StTone.warning, meals[0].img, 'A-05'),
      ('#INC-12', t('Wrong address drop', 'ভুল ঠিকানা'), t('Resolved', 'সমাধান'), StTone.success, meals[4].img, 'A-02'),
      ('#INC-11', t('Cold meal complaint', 'ঠান্ডা খাবার অভিযোগ'), t('Closed', 'বন্ধ'), StTone.muted, meals[3].img, 'A-02'),
    ];
    return Theme(
      data: Theme.of(context).copyWith(extensions: [const StRoleTheme(role: StColors.admin)]),
      child: StScreen(
        title: t('Incident log', 'ঘটনা লগ'),
        actions: [
          StIconBtn(icon: Icons.filter_list, label: 'Filter', onTap: () => ctrl.toast(t('Showing all · last 7 days', 'সব · গত ৭ দিন'))),
        ],
        child: Column(
          children: [
            AppReveal(
              index: 0,
              child: StCard(
                child: Row(
                  children: [
                    Expanded(child: Text(t('5 open / recent', '৫ খোলা / সাম্প্রতিক'), style: const TextStyle(fontWeight: FontWeight.w800))),
                    StChip(tone: StTone.danger, child: Text(t('1 critical', '১ জরুরি'))),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            for (var i = 0; i < rows.length; i++)
              AppReveal(
                index: i + 1,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: StCard(
                    onTap: () => ctrl.go(rows[i].$6),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            rows[i].$5,
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
                              Text(rows[i].$1, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Theme.of(context).hintColor)),
                              Text(rows[i].$2, style: const TextStyle(fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                        StChip(tone: rows[i].$4, child: Text(rows[i].$3)),
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
