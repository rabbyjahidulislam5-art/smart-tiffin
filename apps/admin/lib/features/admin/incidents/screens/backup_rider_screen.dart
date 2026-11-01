import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_shell/st_shell.dart';

class BackupRiderScreen extends ConsumerStatefulWidget {
  const BackupRiderScreen({super.key});
  @override
  ConsumerState<BackupRiderScreen> createState() => _BackupRiderScreenState();
}

class _BackupRiderScreenState extends ConsumerState<BackupRiderScreen> {
  String? sel;

  @override
  Widget build(BuildContext context) {
    final ctrl = ref.read(appProvider.notifier);
    final t = ref.watch(appProvider).t;
    final role = context.roleColor;
    final riders = [
      ('Rokon Talukder', 'Banani · 0.8 km', '4.9 ★'),
      ('Sabbir Hasan', 'Mohakhali · 1.4 km', '4.7 ★'),
      ('Mitu Akter', 'Gulshan · 2.1 km', '4.8 ★'),
      ('Karim Uddin', 'Tejgaon · 2.6 km', '4.6 ★'),
    ];
    return Theme(
      data: Theme.of(context).copyWith(extensions: [const StRoleTheme(role: StColors.admin)]),
      child: StScreen(
        title: t('Choose backup rider', 'ব্যাকআপ রাইডার'),
        footer: StBtn(
          label: t('Dispatch', 'পাঠান'),
          full: true,
          size: StBtnSize.lg,
          variant: StBtnVariant.danger,
          disabled: sel == null,
          reason: t('Select a rider', 'রাইডার নির্বাচন করুন'),
          onTap: () => ctrl.showConfirm(
            ConfirmOpts(
              title: t('Send $sel to #TK-908?', '$sel-কে পাঠাবেন?'),
              ok: t('Dispatch', 'পাঠান'),
              onOk: () {
                ctrl.toast(t('Request sent — waiting for rider to accept', 'অনুরোধ পাঠানো — রাইডারের অপেক্ষা'));
                ctrl.back();
              },
            ),
          ),
        ),
        child: Column(
          children: [
            AppReveal(
              index: 0,
              child: StNote(
                tone: StNoteTone.warning,
                child: Text(t('Backup for #TK-908 · Banani cluster (6 drops)', '#TK-908 এর ব্যাকআপ · বনানী (৬ ড্রপ)')),
              ),
            ),
            const SizedBox(height: 12),
            for (var i = 0; i < riders.length; i++)
              AppReveal(
                index: i + 1,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    onTap: () => setState(() => sel = riders[i].$1),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: sel == riders[i].$1 ? role : Theme.of(context).dividerColor, width: sel == riders[i].$1 ? 2 : 1),
                        color: sel == riders[i].$1 ? role.withValues(alpha: 0.06) : Theme.of(context).cardColor,
                      ),
                      child: Row(
                        children: [
                          StAvatar(name: riders[i].$1),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(riders[i].$1, style: const TextStyle(fontWeight: FontWeight.w700)),
                                Text(riders[i].$2, style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                              ],
                            ),
                          ),
                          StChip(tone: StTone.warning, child: Text(riders[i].$3)),
                        ],
                      ),
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
