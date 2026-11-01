import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_shell/st_shell.dart';

class OperatingSettingsScreen extends ConsumerStatefulWidget {
  const OperatingSettingsScreen({super.key});
  @override
  ConsumerState<OperatingSettingsScreen> createState() => _OperatingSettingsScreenState();
}

class _OperatingSettingsScreenState extends ConsumerState<OperatingSettingsScreen> {
  bool lunch = true;
  bool dinner = true;
  bool autoAccept = false;
  late final TextEditingController maxTiffins;
  late final TextEditingController payout;

  @override
  void initState() {
    super.initState();
    maxTiffins = TextEditingController(text: '60');
    payout = TextEditingController(text: '01712-•••771');
  }

  @override
  void dispose() {
    maxTiffins.dispose();
    payout.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = ref.read(appProvider.notifier);
    final t = ref.watch(appProvider).t;
    final role = context.roleColor;
    return Theme(
      data: Theme.of(context).copyWith(extensions: [const StRoleTheme(role: StColors.supplier)]),
      child: StScreen(
        title: t('Operating settings', 'পরিচালনা সেটিংস'),
        states: false,
        footer: StBtn(
          label: t('Save settings', 'সেটিংস সংরক্ষণ'),
          full: true,
          size: StBtnSize.lg,
          icon: Icons.check_rounded,
          onTap: () {
            ctrl.toast(t('Saved', 'সংরক্ষিত'));
            ctrl.back();
          },
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppReveal(
              index: 0,
              child: StCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t('Shifts today', 'আজকের শিফট'), style: const TextStyle(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text(
                      lunch && dinner
                          ? t('Accepting lunch & dinner', 'লাঞ্চ ও ডিনার নিচ্ছে')
                          : lunch
                              ? t('Lunch only', 'শুধু লাঞ্চ')
                              : dinner
                                  ? t('Dinner only', 'শুধু ডিনার')
                                  : t('Both shifts off', 'দুই শিফট বন্ধ'),
                      style: TextStyle(fontSize: 12, color: role),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            AppReveal(
              index: 1,
              child: StList(
                children: [
                  StRowTile(
                    icon: Icons.wb_sunny_outlined,
                    label: t('Lunch shift', 'লাঞ্চ শিফট'),
                    sub: '10:00 – 12:30',
                    right: StToggle(value: lunch, onChanged: (v) => setState(() => lunch = v), label: 'Lunch'),
                  ),
                  StRowTile(
                    icon: Icons.nightlight_round,
                    label: t('Dinner shift', 'ডিনার শিফট'),
                    sub: '17:00 – 19:30',
                    right: StToggle(value: dinner, onChanged: (v) => setState(() => dinner = v), label: 'Dinner'),
                  ),
                  StRowTile(
                    icon: Icons.bolt_outlined,
                    label: t('Auto-accept new orders', 'নতুন অর্ডার স্বয়ংক্রিয়'),
                    sub: t('When online and under capacity', 'অনলাইন ও সক্ষমতার মধ্যে'),
                    right: StToggle(value: autoAccept, onChanged: (v) => setState(() => autoAccept = v), label: 'Auto'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            AppReveal(
              index: 2,
              child: StField(
                label: t('Max tiffins per day', 'দৈনিক সর্বোচ্চ টিফিন'),
                controller: maxTiffins,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(height: 12),
            AppReveal(
              index: 3,
              child: StField(
                label: t('Payout account (bKash)', 'পেআউট অ্যাকাউন্ট (বিকাশ)'),
                controller: payout,
              ),
            ),
            const SizedBox(height: 12),
            AppReveal(
              index: 4,
              child: StNote(
                tone: StNoteTone.policy,
                child: Text(t('Turning a shift off stops new orders. Already accepted meals must still be cooked.', 'শিফট বন্ধ করলে নতুন অর্ডার বন্ধ। গৃহীত খাবার এখনো রান্না করতে হবে।')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
