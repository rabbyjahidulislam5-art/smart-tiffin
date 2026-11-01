import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

class IncidentDetailScreen extends ConsumerWidget {
  const IncidentDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.read(appProvider.notifier);
    final t = ref.watch(appProvider).t;
    return Theme(
      data: Theme.of(context).copyWith(extensions: [const StRoleTheme(role: StColors.admin)]),
      child: StScreen(
        title: t('Incident #INC-14', 'ঘটনা #INC-14'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppReveal(
              index: 0,
              child: StCard(
                child: Row(
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
                          Text(t('Lunch cluster · Banani', 'লাঞ্চ ক্লাস্টার · বনানী'), style: const TextStyle(fontWeight: FontWeight.w800)),
                          Text('#TK-908 … #TK-913', style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                        ],
                      ),
                    ),
                    StChip(tone: StTone.danger, child: Text(t('OPEN', 'খোলা'))),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            AppReveal(
              index: 1,
              child: StCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t('Summary', 'সারাংশ'), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Theme.of(context).hintColor)),
                    Text(t('Rahim went offline mid-route while carrying #TK-908 lunch for Banani cluster.', 'রহিম #TK-908 নিয়ে মাঝপথে অফলাইন।'), style: const TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    Text(t('Affected', 'প্রভাবিত'), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Theme.of(context).hintColor)),
                    Text('6 ${t('customers', 'গ্রাহক')} · delayed ~18 min'),
                    const SizedBox(height: 12),
                    Text(t('Opened', 'খোলা'), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Theme.of(context).hintColor)),
                    const Text('Today · 12:41 PM'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            AppReveal(
              index: 2,
              child: StList(
                children: [
                  StRowTile(
                    icon: Icons.phone,
                    label: t('Call rider Rahim', 'রহিমকে কল'),
                    onTap: () => ctrl.showConfirm(
                      ConfirmOpts(
                        title: t('Call Rahim?', 'রহিমকে কল?'),
                        body: '+880 1822-998877',
                        ok: t('Call', 'কল'),
                        onOk: () => ctrl.toast(t('Calling…', 'কল হচ্ছে…')),
                      ),
                    ),
                  ),
                  StRowTile(icon: Icons.chat_bubble_outline, label: t('Message affected customers', 'গ্রাহকদের বার্তা'), onTap: () => ctrl.go('SH-02', {'who': '6 customers'})),
                  StRowTile(icon: Icons.receipt_long_outlined, label: t('Open related order', 'সম্পর্কিত অর্ডার'), onTap: () => ctrl.go('A-11', {'id': 'TK-908'})),
                ],
              ),
            ),
            const SizedBox(height: 12),
            AppReveal(
              index: 3,
              child: StBtn(
                label: t('Dispatch Backup Rider', 'ব্যাকআপ রাইডার পাঠান'),
                full: true,
                variant: StBtnVariant.danger,
                icon: Icons.two_wheeler,
                onTap: () => ctrl.go('A-04'),
              ),
            ),
            const SizedBox(height: 8),
            AppReveal(
              index: 4,
              child: StBtn(
                label: t('Mark resolved', 'সমাধান চিহ্নিত'),
                full: true,
                variant: StBtnVariant.outline,
                onTap: () {
                  ctrl.toast(t('Incident marked resolved', 'ঘটনা সমাধান'));
                  ctrl.back();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
