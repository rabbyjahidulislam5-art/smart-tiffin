import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

class SupplierApplyScreen extends ConsumerStatefulWidget {
  const SupplierApplyScreen({super.key});

  @override
  ConsumerState<SupplierApplyScreen> createState() => _SupplierApplyScreenState();
}

class _SupplierApplyScreenState extends ConsumerState<SupplierApplyScreen> {
  int step = 0;
  final steps = const ['Personal', 'Kitchen', 'Operations', 'Payout', 'Documents', 'Agreement'];
  final stepsBn = const ['ব্যক্তিগত', 'কিচেন', 'পরিচালনা', 'পেআউট', 'কাগজপত্র', 'চুক্তি'];
  final name = TextEditingController();
  final phone = TextEditingController();
  final kitchen = TextEditingController();
  bool agree = false;
  String? err;

  @override
  void dispose() {
    name.dispose();
    phone.dispose();
    kitchen.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = ref.read(appProvider.notifier);
    final t = ref.watch(appProvider).t;

    return Theme(
      data: Theme.of(context).copyWith(extensions: [const StRoleTheme(role: StColors.supplier)]),
      child: StScreen(
        title: t('Kitchen application', 'কিচেন আবেদন'),
        eyebrow: t('COOK', 'রাঁধুনি'),
        states: false,
        footer: Row(
          children: [
            if (step > 0) Expanded(child: StBtn(label: t('Back', 'পেছনে'), variant: StBtnVariant.outline, onTap: () => setState(() => step--))),
            if (step > 0) const SizedBox(width: 8),
            Expanded(
              child: StBtn(
                label: step == steps.length - 1 ? t('Submit', 'জমা দিন') : t('Continue', 'চালিয়ে যান'),
                full: true,
                onTap: () {
                  if (step < steps.length - 1) {
                    setState(() => step++);
                    return;
                  }
                  if (!agree) {
                    setState(() => err = t('Please accept the terms', 'শর্তাবলী মেনে নিন'));
                    return;
                  }
                  final id = 'app-${DateTime.now().millisecondsSinceEpoch}';
                  ctrl.patchStore(
                    (st) => st.copyWith(
                      submitted: [
                        ...st.submitted,
                        Applicant(
                          id: id,
                          kind: 'Cook',
                          name: kitchen.text.isEmpty ? "New Kitchen" : kitchen.text,
                          owner: name.text.isEmpty ? 'Applicant' : name.text,
                          area: 'Dhaka',
                          cap: '30 tiffins/day',
                          tier: 'HomeChef',
                          ago: 'now',
                          docs: {'nid': 'Pending', 'kitchen': 'Pending', 'hygiene': 'Pending'},
                        ),
                      ],
                      myApp: id,
                    ),
                  );
                  ctrl.toast(t('Application submitted', 'আবেদন জমা হয়েছে'));
                  ctrl.reset('AU-11', {'id': id});
                },
              ),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppReveal(
              index: 0,
              child: Text('${t('Step', 'ধাপ')} ${step + 1}/${steps.length}: ${t(steps[step], stepsBn[step])}', style: const TextStyle(fontWeight: FontWeight.w800)),
            ),
            const SizedBox(height: 8),
            AppReveal(
              index: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(value: (step + 1) / steps.length, minHeight: 8, color: StColors.supplier, backgroundColor: StColors.muted),
              ),
            ),
            const SizedBox(height: 16),
            if (step == 0) ...[
              AppReveal(index: 2, child: StField(label: t('Full name (as on NID)', 'পুরো নাম (NID অনুযায়ী)'), controller: name)),
              const SizedBox(height: 12),
              AppReveal(index: 3, child: StField(label: t('Mobile number', 'মোবাইল নম্বর'), controller: phone, placeholder: '+880')),
            ] else if (step == 1) ...[
              AppReveal(index: 2, child: StField(label: t('Kitchen name', 'কিচেনের নাম'), controller: kitchen, placeholder: "Rina's Kitchen")),
              const SizedBox(height: 12),
              AppReveal(index: 3, child: StNote(child: Text(t('Service areas and kitchen photo come next in production.', 'সার্ভিস এলাকা ও কিচেনের ছবি পরবর্তী ধাপে।')))),
            ] else if (step == 5) ...[
              AppReveal(
                index: 2,
                child: SwitchListTile(
                  value: agree,
                  onChanged: (v) => setState(() => agree = v),
                  title: Text(t('I agree to the Partner Terms and food hygiene rules', 'আমি পার্টনার শর্তাবলী ও স্বাস্থ্যবিধি মানছি')),
                ),
              ),
              if (err != null) Text(err!, style: const TextStyle(color: StColors.danger, fontWeight: FontWeight.w600)),
              AppReveal(index: 3, child: const StPolicy()),
            ] else
              AppReveal(
                index: 2,
                child: StNote(child: Text(t('Sample multi-step application — fill required fields and continue.', 'নমুনা বহু-ধাপ আবেদন — প্রয়োজনীয় ঘর পূরণ করে চালিয়ে যান।'))),
              ),
          ],
        ),
      ),
    );
  }
}
