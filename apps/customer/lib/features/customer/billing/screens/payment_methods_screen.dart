import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_shell/st_shell.dart';

class PaymentMethodsScreen extends ConsumerStatefulWidget {
  const PaymentMethodsScreen({super.key});
  @override
  ConsumerState<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends ConsumerState<PaymentMethodsScreen> {
  String selected = 'bkash';

  @override
  Widget build(BuildContext context) {
    final ctrl = ref.read(appProvider.notifier);
    final t = ref.watch(appProvider).t;
    final methods = [
      ('bkash', 'bKash', '01XXX-XXX401', Icons.account_balance_wallet_outlined, true),
      ('nagad', 'Nagad', t('Not linked', 'লিংক নেই'), Icons.account_balance_wallet_outlined, false),
      ('card', t('Card', 'কার্ড'), '**** 4242', Icons.credit_card_rounded, true),
    ];
    return StScreen(
      title: t('Payment methods', 'পেমেন্ট মাধ্যম'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppReveal(
            index: 0,
            child: StNote(
              tone: StNoteTone.policy,
              child: Text(t('Default method is charged for subscription renewals.', 'সাবস্ক্রিপশন নবায়নে ডিফল্ট মাধ্যম চার্জ হয়।')),
            ),
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < methods.length; i++)
            AppReveal(
              index: i + 1,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  onTap: () {
                    if (!methods[i].$5) {
                      ctrl.toast(t('Link flow (sample)', 'লিংক (নমুনা)'));
                      return;
                    }
                    setState(() => selected = methods[i].$1);
                    ctrl.toast(t('Default method', 'ডিফল্ট মাধ্যম'));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: selected == methods[i].$1 ? StColors.customer : Theme.of(context).dividerColor,
                        width: selected == methods[i].$1 ? 2 : 1,
                      ),
                      color: selected == methods[i].$1 ? StColors.customer.withValues(alpha: 0.06) : Theme.of(context).cardColor,
                    ),
                    child: Row(
                      children: [
                        Icon(methods[i].$4, color: selected == methods[i].$1 ? StColors.customer : Theme.of(context).hintColor),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(methods[i].$2, style: const TextStyle(fontWeight: FontWeight.w700)),
                              Text(methods[i].$3, style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                            ],
                          ),
                        ),
                        if (selected == methods[i].$1)
                          StChip(tone: StTone.success, child: Text(t('Default', 'ডিফল্ট')))
                        else if (!methods[i].$5)
                          StChip(tone: StTone.muted, child: Text(t('Link', 'লিংক'))),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 8),
          AppReveal(
            index: 4,
            child: StBtn(
              label: t('Add payment method', 'পেমেন্ট মাধ্যম যোগ'),
              full: true,
              variant: StBtnVariant.outline,
              icon: Icons.add_rounded,
              onTap: () => ctrl.toast(t('Add method (sample)', 'মাধ্যম যোগ (নমুনা)')),
            ),
          ),
        ],
      ),
    );
  }
}
