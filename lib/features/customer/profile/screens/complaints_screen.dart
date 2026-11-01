import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

class ComplaintsScreen extends ConsumerWidget {
  const ComplaintsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.read(appProvider.notifier);
    final t = ref.watch(appProvider).t;
    final tickets = [
      (t('Missing item in lunch', 'লাঞ্চে আইটেম নেই'), t('Open · #TK-911', 'খোলা · #TK-911'), StTone.warning, t('Open', 'খোলা'), meals[1].img),
      (t('Late dinner delivery', 'ডিনার দেরি'), t('Resolved · #TK-880', 'সমাধান · #TK-880'), StTone.success, t('Resolved', 'সমাধান'), meals[0].img),
      (t('Wrong spice level', 'ভুল ঝাল'), t('In review · #TK-865', 'পর্যালোচনা · #TK-865'), StTone.info, t('Review', 'পর্যালোচনা'), meals[2].img),
      (t('Cold packaging', 'ঠান্ডা প্যাকিং'), t('Closed · #TK-840', 'বন্ধ · #TK-840'), StTone.muted, t('Closed', 'বন্ধ'), meals[3].img),
    ];
    return StScreen(
      title: t('Complaints', 'অভিযোগ'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppReveal(
            index: 0,
            child: StNote(child: Text(t('Open a ticket for missing items, delays, or taste issues.', 'মিসিং আইটেম, দেরি বা স্বাদের সমস্যার জন্য টিকেট খুলুন।'))),
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < tickets.length; i++)
            AppReveal(
              index: i + 1,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: StCard(
                  onTap: () => ctrl.go('SH-07'),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.asset(
                          tickets[i].$5,
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
                            Text(tickets[i].$1, style: const TextStyle(fontWeight: FontWeight.w700)),
                            Text(tickets[i].$2, style: TextStyle(color: Theme.of(context).hintColor, fontSize: 12)),
                          ],
                        ),
                      ),
                      StChip(tone: tickets[i].$3, child: Text(tickets[i].$4)),
                    ],
                  ),
                ),
              ),
            ),
          const SizedBox(height: 8),
          AppReveal(
            index: tickets.length + 1,
            child: StBtn(
              label: t('New complaint', 'নতুন অভিযোগ'),
              full: true,
              size: StBtnSize.lg,
              icon: Icons.add_rounded,
              onTap: () => ctrl.go('SH-06'),
            ),
          ),
          const SizedBox(height: 8),
          AppReveal(
            index: tickets.length + 2,
            child: StBtn(
              label: t('Chat with support', 'সাপোর্ট চ্যাট'),
              full: true,
              variant: StBtnVariant.soft,
              onTap: () => ctrl.go('SH-02', {'who': 'Support'}),
            ),
          ),
        ],
      ),
    );
  }
}
