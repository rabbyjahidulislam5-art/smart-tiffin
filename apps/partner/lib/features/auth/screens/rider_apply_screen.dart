import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

class RiderApplyScreen extends ConsumerStatefulWidget {
  const RiderApplyScreen({super.key});

  @override
  ConsumerState<RiderApplyScreen> createState() => _RiderApplyScreenState();
}

class _RiderApplyScreenState extends ConsumerState<RiderApplyScreen> {
  int step = 0;
  final name = TextEditingController();
  final dob = TextEditingController();
  String vehicle = 'Motorcycle';
  bool agree = false;
  String? err;

  @override
  void dispose() {
    name.dispose();
    dob.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = ref.read(appProvider.notifier);
    final t = ref.watch(appProvider).t;

    return Theme(
      data: Theme.of(context)
          .copyWith(extensions: [const StRoleTheme(role: StColors.rider)]),
      child: StScreen(
        title: t('Rider application', 'রাইডার আবেদন'),
        eyebrow: t('RIDER', 'রাইডার'),
        states: false,
        footer: StBtn(
          label:
              step < 7 ? t('Continue', 'চালিয়ে যান') : t('Submit', 'জমা দিন'),
          full: true,
          size: StBtnSize.lg,
          onTap: () {
            if (step == 0) {
              if (dob.text.startsWith('201')) {
                setState(
                    () => err = t('You must be 18+', 'আপনার বয়স ১৮+ হতে হবে'));
                return;
              }
            }
            if (step < 7) {
              setState(() {
                step++;
                err = null;
              });
              return;
            }
            if (!agree) {
              setState(() =>
                  err = t('Please accept the terms', 'শর্তাবলী মেনে নিন'));
              return;
            }
            final id = 'rider-${DateTime.now().millisecondsSinceEpoch}';
            ctrl.patchStore(
              (st) => st.copyWith(
                submitted: [
                  ...st.submitted,
                  Applicant(
                    id: id,
                    kind: 'Rider',
                    name: name.text.isEmpty ? 'New Rider' : name.text,
                    owner: name.text.isEmpty ? 'Rider' : name.text,
                    area: 'Dhaka',
                    cap: vehicle,
                    tier: 'Lunch shift',
                    ago: 'now',
                    docs: {
                      'nid': 'Pending',
                      'kitchen': 'Pending',
                      'hygiene': 'Pending'
                    },
                  ),
                ],
                myApp: id,
              ),
            );
            ctrl.reset('AU-11', {'id': id});
          },
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppReveal(
                index: 0,
                child: Text('${t('Step', 'ধাপ')} ${step + 1}/8',
                    style: const TextStyle(fontWeight: FontWeight.w800))),
            const SizedBox(height: 8),
            AppReveal(
              index: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                    value: (step + 1) / 8,
                    minHeight: 8,
                    color: StColors.rider,
                    backgroundColor: StColors.muted),
              ),
            ),
            const SizedBox(height: 16),
            if (step == 0) ...[
              AppReveal(
                  index: 2,
                  child: StField(
                      label:
                          t('Full name (as on NID)', 'পুরো নাম (NID অনুযায়ী)'),
                      controller: name)),
              const SizedBox(height: 12),
              AppReveal(
                  index: 3,
                  child: StField(
                      label: t('Date of birth', 'জন্ম তারিখ'),
                      controller: dob,
                      placeholder: 'YYYY-MM-DD')),
            ] else if (step == 3) ...[
              AppReveal(
                  index: 2,
                  child: Text(
                      t('How will you deliver?', 'কীভাবে ডেলিভারি করবেন?'),
                      style: const TextStyle(fontWeight: FontWeight.w700))),
              RadioGroup<String>(
                groupValue: vehicle,
                onChanged: (value) {
                  if (value != null) setState(() => vehicle = value);
                },
                child: Column(
                  children: [
                    for (final v in ['Motorcycle', 'Bicycle', 'Walker'])
                      RadioListTile<String>(value: v, title: Text(v)),
                  ],
                ),
              ),
            ] else if (step == 7) ...[
              AppReveal(
                index: 2,
                child: SwitchListTile(
                  value: agree,
                  onChanged: (v) => setState(() => agree = v),
                  title: Text(t('I agree to the Rider Terms and safety rules',
                      'আমি রাইডার শর্তাবলী ও নিরাপত্তা নিয়ম মানছি')),
                ),
              ),
            ] else
              AppReveal(
                index: 2,
                child: StNote(
                    child: Text(t(
                        'Continue through the 8-step rider application (sample).',
                        '৮ ধাপের রাইডার আবেদন চালিয়ে যান (নমুনা)।'))),
              ),
            if (err != null)
              Text(err!,
                  style: const TextStyle(
                      color: StColors.danger, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
