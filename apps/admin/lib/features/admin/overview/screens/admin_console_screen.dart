import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_shell/st_shell.dart';

class AdminConsoleScreen extends ConsumerWidget {
  const AdminConsoleScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    final ctrl = ref.read(appProvider.notifier);
    final t = s.t;
    final role = context.roleColor;
    final pending = allApplicantsOf(s.store).where((a) => appStatusOf(s.store, a.id) == AppStatus.pending).length;
    return Theme(
      data: Theme.of(context).copyWith(extensions: [const StRoleTheme(role: StColors.admin)]),
      child: StScreen(
        title: t('Executive Console', 'এক্সিকিউটিভ কনসোল'),
        eyebrow: 'SMART TIFFIN ADMIN · SUPER ADMIN',
        back: false,
        actions: [
          StIconBtn(icon: Icons.notifications_none, label: 'Notifications', onTap: () => ctrl.go('SH-01')),
          const SizedBox(width: 8),
          GestureDetector(onTap: () => ctrl.go('A-19'), child: const StAvatar(name: 'Nadia Islam', size: 40)),
        ],
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          AppReveal(
            index: 0,
            child: Row(children: [
              Expanded(
                child: StStat(
                  label: t('Live orders', 'লাইভ অর্ডার'),
                  value: '48',
                  icon: Icons.receipt_long,
                  onTap: () => ctrl.go('A-10'),
                  sub: AppCountUp(value: 48, format: (v) => '+${(v * 0.12).round()} vs yesterday', style: TextStyle(fontSize: 11, color: StColors.success, fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(child: StStat(label: t('Incidents', 'ঘটনা'), value: '2', icon: Icons.warning_amber, onTap: () => ctrl.go('A-03'), sub: StChip(tone: StTone.danger, child: Text(t('Needs action', 'কর্ম দরকার'))))),
            ]),
          ),
          const SizedBox(height: 8),
          AppReveal(
            index: 1,
            child: Row(children: [
              Expanded(child: StStat(label: t('Pending apps', 'অপেক্ষমাণ আবেদন'), value: '$pending', icon: Icons.badge_outlined, onTap: () => ctrl.go('A-06'))),
              const SizedBox(width: 8),
              Expanded(child: StStat(label: t('Escrow', 'এস্ক্রো'), value: '৳2.4L', icon: Icons.account_balance)),
            ]),
          ),
          const SizedBox(height: 16),
          AppReveal(
            index: 2,
            child: StSection(
            title: t('Urgent Incidents', 'জরুরি ঘটনা'),
            action: t('Log History', 'লগ ইতিহাস'),
            onAction: () => ctrl.go('A-03'),
            child: Column(children: [
              StCard(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Row(children: [StChip(tone: StTone.danger, child: Text(t('RIDER DELAY', 'রাইডার দেরি'))), const Spacer(), Text('#INC-14', style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor))]),
                const SizedBox(height: 8),
                Text(t('Rahim offline mid-route · #TK-908', 'রহিম মাঝপথে অফলাইন · #TK-908'), style: const TextStyle(fontWeight: FontWeight.w700)),
                Text(t('6 customers affected · Banani cluster', '৬ গ্রাহক প্রভাবিত · বনানী'), style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                const SizedBox(height: 10),
                Row(children: [
                  Expanded(child: StBtn(label: t('Dispatch Backup Rider', 'ব্যাকআপ রাইডার'), variant: StBtnVariant.danger, icon: Icons.two_wheeler, onTap: () => ctrl.go('A-04'))),
                  const SizedBox(width: 8),
                  StBtn(label: t('Details', 'বিস্তারিত'), variant: StBtnVariant.outline, onTap: () => ctrl.go('A-02')),
                ]),
              ])),
              const SizedBox(height: 8),
              StCard(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Row(children: [StChip(tone: StTone.warning, child: Text(t('DISPUTE', 'বিরোধ'))), const Spacer(), Text('#DS-07', style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor))]),
                const SizedBox(height: 8),
                Text(t("Missing item claim · Maa's Kitchen", 'মিসিং আইটেম · মায়ের কিচেন'), style: const TextStyle(fontWeight: FontWeight.w700)),
                Text(t('Customer asks ৳180 credit', 'গ্রাহক ৳১৮০ ক্রেডিট চান'), style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                const SizedBox(height: 10),
                Row(children: [
                  Expanded(child: StBtn(label: t('Review credit (৳180)', 'ক্রেডিট পর্যালোচনা'), icon: Icons.check_circle_outline, onTap: () => ctrl.go('A-05'))),
                  const SizedBox(width: 8),
                  StBtn(label: t('Call', 'কল'), variant: StBtnVariant.outline, icon: Icons.phone, onTap: () => ctrl.showConfirm(ConfirmOpts(title: t("Call Maa's Kitchen?", 'কল?'), body: '+880 1913-667788', ok: t('Call', 'কল'), onOk: () => ctrl.toast(t('Calling…', 'কল হচ্ছে…'))))),
                ]),
              ])),
            ]),
          ),
          ),
          const SizedBox(height: 16),
          AppReveal(
            index: 3,
            child: StSection(
            title: t('Applications', 'আবেদন'),
            action: '$pending ${t('Pending', 'অপেক্ষমাণ')}',
            onAction: () => ctrl.go('A-06'),
            child: Column(children: [
              for (final a in allApplicantsOf(s.store).take(3))
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: StCard(onTap: () => ctrl.go('A-07', {'id': a.id}), child: Row(children: [
                    Container(width: 44, height: 44, decoration: BoxDecoration(color: role.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16)), child: Icon(a.kind == 'Rider' ? Icons.two_wheeler : Icons.soup_kitchen, color: role)),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [Flexible(child: Text(a.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14), overflow: TextOverflow.ellipsis)), Text('  ${a.ago}', style: TextStyle(fontSize: 11, color: Theme.of(context).hintColor))]),
                      Text('${a.owner} · ${a.area}', style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                    ])),
                  ])),
                ),
              StBtn(label: t('Review applications', 'আবেদন পর্যালোচনা'), full: true, variant: StBtnVariant.soft, icon: Icons.description_outlined, onTap: () => ctrl.go('A-06')),
            ]),
          ),
          ),
          const SizedBox(height: 16),
          AppReveal(
            index: 4,
            child: StSection(
            title: t('Treasury', 'ট্রেজারি'),
            child: Row(children: [
              Expanded(
                child: StBtn(
                  label: t('Ledger', 'লেজার'),
                  full: true,
                  variant: StBtnVariant.outline,
                  icon: Icons.download,
                  onTap: () => ctrl.showConfirm(ConfirmOpts(
                    title: t('Export audit ledger (CSV)?', 'লেজার এক্সপোর্ট?'),
                    ok: t('Export', 'এক্সপোর্ট'),
                    onOk: () => ctrl.toast(t('Export prepared (sample file)', 'এক্সপোর্ট প্রস্তুত (নমুনা)')),
                  )),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: StBtn(
                  label: t('Escrow rules', 'এস্ক্রো নিয়ম'),
                  full: true,
                  variant: StBtnVariant.outline,
                  icon: Icons.shield_outlined,
                  onTap: () => ctrl.go('A-16', {'s': 'escrow'}),
                ),
              ),
            ]),
          ),
          ),
          const SizedBox(height: 8),
          AppReveal(
            index: 5,
            child: StBtn(label: t('Command centre', 'কমান্ড সেন্টার'), full: true, icon: Icons.dashboard_customize_outlined, onTap: () => ctrl.go('NA-01')),
          ),
          const SizedBox(height: 8),
          AppReveal(
            index: 6,
            child: StBtn(label: t('Reports', 'রিপোর্ট'), full: true, variant: StBtnVariant.soft, onTap: () => ctrl.go('A-14')),
          ),
        ]),
      ),
    );
  }
}
