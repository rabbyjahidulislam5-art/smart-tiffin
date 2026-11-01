import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

class DisputeDetailScreen extends ConsumerWidget {
  const DisputeDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.read(appProvider.notifier);
    final t = ref.watch(appProvider).t;
    return Theme(
      data: Theme.of(context).copyWith(extensions: [const StRoleTheme(role: StColors.admin)]),
      child: StScreen(
        title: t('Dispute #DS-07', 'বিরোধ #DS-07'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppReveal(
              index: 0,
              child: StCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StChip(tone: StTone.warning, child: Text(t('MISSING ITEM', 'মিসিং আইটেম'))),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            meals[1].img,
                            width: 72,
                            height: 72,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(width: 72, height: 72, color: StColors.muted),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(t("Customer: Farhana · Kitchen: Maa's Kitchen", 'গ্রাহক: ফারহানা · কিচেন: মায়ের কিচেন'), style: const TextStyle(fontWeight: FontWeight.w700)),
                              const SizedBox(height: 4),
                              Text(t('Claimed: chicken piece missing from thali · asks ৳180 credit', 'দাবি: থালিতে মুরগি নেই · ৳১৮০ ক্রেডিট'), style: TextStyle(fontSize: 13, color: Theme.of(context).hintColor)),
                              Text('#TK-901 · Lunch today', style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            AppReveal(
              index: 1,
              child: StNote(
                tone: StNoteTone.policy,
                child: Text(t('Recording a credit decision does not move money until the credit policy is approved.', 'ক্রেডিট সিদ্ধান্ত রেকর্ড হলেও নীতি অনুমোদনের আগে টাকা যাবে না।')),
              ),
            ),
            const SizedBox(height: 16),
            AppReveal(
              index: 2,
              child: StBtn(
                label: t('Approve replacement credit', 'রিপ্লেসমেন্ট ক্রেডিট'),
                full: true,
                icon: Icons.check_circle_outline,
                onTap: () => ctrl.showConfirm(
                  ConfirmOpts(
                    title: t('Approve ৳180 replacement credit?', '৳১৮০ ক্রেডিট অনুমোদন?'),
                    body: t('Records a credit decision. No money moves until the credit policy is approved.', 'সিদ্ধান্ত রেকর্ড হবে। নীতি অনুমোদনের আগে টাকা যাবে না।'),
                    ok: t('Record decision', 'সিদ্ধান্ত রেকর্ড'),
                    onOk: () {
                      ctrl.toast(t('Credit decision recorded (pending policy)', 'ক্রেডিট সিদ্ধান্ত রেকর্ড (নীতি অপেক্ষমাণ)'));
                      ctrl.back();
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            AppReveal(
              index: 3,
              child: StBtn(
                label: t('Reject', 'প্রত্যাখ্যান'),
                full: true,
                variant: StBtnVariant.outline,
                icon: Icons.cancel_outlined,
                onTap: () => ctrl.showConfirm(
                  ConfirmOpts(
                    title: t('Reject dispute?', 'বিরোধ প্রত্যাখ্যান?'),
                    ok: t('Reject', 'প্রত্যাখ্যান'),
                    danger: true,
                    onOk: () => ctrl.back(),
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
