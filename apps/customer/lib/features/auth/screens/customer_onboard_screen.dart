import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

class CustomerOnboardScreen extends ConsumerStatefulWidget {
  const CustomerOnboardScreen({super.key});

  @override
  ConsumerState<CustomerOnboardScreen> createState() => _CustomerOnboardScreenState();
}

class _CustomerOnboardScreenState extends ConsumerState<CustomerOnboardScreen> {
  final addr = TextEditingController(text: 'House 42, Road 11, Block D, Banani');
  String plan = 'monthly-ld';

  @override
  void dispose() {
    addr.dispose();
    super.dispose();
  }

  void done() {
    final ctrl = ref.read(appProvider.notifier);
    ctrl.setRole(StRole.customer);
    ctrl.toast(ref.read(appProvider).t('Welcome to Smart Tiffin!', 'স্মার্ট টিফিনে স্বাগতম!'));
    final after = ref.read(appProvider).afterLogin;
    if (after != null) {
      ctrl.setAfterLogin(null);
      ctrl.reset(after.id, after.params);
    } else {
      ctrl.reset('C-01');
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = ref.watch(appProvider).t;
    final role = context.roleColor;

    return StScreen(
      title: t('Set up delivery', 'ডেলিভারি সেটআপ'),
      eyebrow: t('ONBOARDING', 'অনবোর্ডিং'),
      back: true,
      states: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppReveal(index: 0, child: StField(label: t('Delivery address', 'ডেলিভারি ঠিকানা'), controller: addr)),
          const SizedBox(height: 8),
          AppReveal(
            index: 1,
            child: Row(
              children: [
                Icon(Icons.place_rounded, size: 16, color: role),
                const SizedBox(width: 4),
                Text(t('Pin on map (sample · Banani)', 'ম্যাপে পিন (নমুনা · বনানী)'), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          AppReveal(
            index: 2,
            child: Text(t('Pick a starting plan', 'একটি প্ল্যান বেছে নিন'), style: const TextStyle(fontWeight: FontWeight.w800)),
          ),
          const SizedBox(height: 8),
          for (var i = 0; i < plans.length; i++)
            AppReveal(
              index: i + 3,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: StCard(
                  onTap: () => setState(() => plan = plans[i].id),
                  child: Row(
                    children: [
                      Icon(
                        plan == plans[i].id ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                        color: plan == plans[i].id ? role : Theme.of(context).hintColor,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t(plans[i].en, plans[i].bn), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                            Text(plans[i].meals, style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                          ],
                        ),
                      ),
                      Text('৳${fmtBdt(plans[i].price)}', style: TextStyle(fontWeight: FontWeight.w800, color: role)),
                    ],
                  ),
                ),
              ),
            ),
          AppReveal(
            index: plans.length + 3,
            child: StBtn(label: t('Finish & go home', 'শেষ করে হোমে যান'), full: true, size: StBtnSize.lg, onTap: done),
          ),
          AppReveal(
            index: plans.length + 4,
            child: TextButton(
              onPressed: done,
              child: Text(t('Skip for now', 'এখন বাদ দিন'), style: TextStyle(color: Theme.of(context).hintColor, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}
