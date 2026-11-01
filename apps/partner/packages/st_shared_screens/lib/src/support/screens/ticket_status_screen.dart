import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

class TicketStatusScreen extends ConsumerWidget {
  const TicketStatusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.read(appProvider.notifier);
    final t = ref.watch(appProvider).t;
    final others = [
      (t('Wrong spice level', 'ভুল ঝাল'), 'ST-T-861', t('Resolved', 'সমাধান'), StTone.success, meals[2].img),
      (t('Missing item in lunch', 'লাঞ্চে আইটেম নেই'), 'ST-T-852', t('Closed', 'বন্ধ'), StTone.muted, meals[0].img),
    ];
    return StScreen(
      title: t('Ticket status', 'টিকেট স্ট্যাটাস'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppReveal(
            index: 0,
            child: StCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.asset(
                          meals[1].img,
                          width: 52,
                          height: 52,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(width: 52, height: 52, color: StColors.muted),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('ST-T-884', style: TextStyle(fontWeight: FontWeight.w800)),
                            Text(t('Order / delivery · Rider delay report', 'অর্ডার / ডেলিভারি · রাইডার দেরি'), style: const TextStyle(fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      StChip(tone: StTone.warning, child: Text(t('In review', 'পর্যালোচনায়'))),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(t('Opened today · average reply under 2 hours', 'আজ খোলা · গড় উত্তর ২ ঘণ্টার মধ্যে'), style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          AppReveal(
            index: 1,
            child: StCard(
              child: StTimeline(
                current: 1,
                steps: [
                  (label: t('Submitted', 'জমা'), sub: '12:50', icon: Icons.check_circle_outline),
                  (label: t('In review', 'পর্যালোচনা'), sub: null, icon: Icons.hourglass_top),
                  (label: t('Resolved', 'সমাধান'), sub: null, icon: Icons.verified_outlined),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          AppReveal(
            index: 2,
            child: StBtn(
              label: t('Chat about this', 'এ নিয়ে চ্যাট'),
              full: true,
              variant: StBtnVariant.soft,
              icon: Icons.chat_bubble_outline,
              onTap: () => ctrl.go('SH-02', {'who': 'Support · ST-T-884'}),
            ),
          ),
          const SizedBox(height: 8),
          if (ref.watch(shellConfigProvider).knows('SH-06'))
          AppReveal(
            index: 3,
            child: StBtn(
              label: t('New report', 'নতুন রিপোর্ট'),
              full: true,
              variant: StBtnVariant.outline,
              onTap: () => ctrl.go('SH-06'),
            ),
          ),
          const SizedBox(height: 16),
          AppReveal(index: 4, child: Text(t('Earlier tickets', 'আগের টিকেট'), style: const TextStyle(fontWeight: FontWeight.w800))),
          const SizedBox(height: 8),
          for (var i = 0; i < others.length; i++)
            AppReveal(
              index: i + 5,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: StCard(
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          others[i].$5,
                          width: 44,
                          height: 44,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(width: 44, height: 44, color: StColors.muted),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(others[i].$1, style: const TextStyle(fontWeight: FontWeight.w700)),
                            Text(others[i].$2, style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                          ],
                        ),
                      ),
                      StChip(tone: others[i].$4, child: Text(others[i].$3)),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
