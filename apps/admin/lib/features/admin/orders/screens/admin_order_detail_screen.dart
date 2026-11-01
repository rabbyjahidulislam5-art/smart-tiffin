import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

class AdminOrderDetailScreen extends ConsumerWidget {
  const AdminOrderDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.read(appProvider.notifier);
    final t = ref.watch(appProvider).t;
    final id = ref.watch(appProvider).current.params['id'] ?? '#TK-911';
    final isIncident = id.contains('908');
    return Theme(
      data: Theme.of(context).copyWith(extensions: [const StRoleTheme(role: StColors.admin)]),
      child: StScreen(
        title: id,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppReveal(
              index: 0,
              child: StCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            isIncident ? meals[4].img : meals[1].img,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(width: 80, height: 80, color: StColors.muted),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isIncident
                                    ? t('Lunch · Beef Kala Bhuna ×6 (cluster)', 'লাঞ্চ · গরুর কালা ভুনা ×৬')
                                    : t('Lunch · Classic Bengali Thali ×2', 'লাঞ্চ · বাংলা থালি ×২'),
                                style: const TextStyle(fontWeight: FontWeight.w700),
                              ),
                              Text(
                                isIncident ? "Maa's Kitchen → Banani cluster" : "Rina's Kitchen → Tanvir Ahmed",
                                style: TextStyle(fontSize: 13, color: Theme.of(context).hintColor),
                              ),
                              Text(
                                isIncident
                                    ? t('Rider: Rahim (offline) · prepaid', 'রাইডার: রহিম (অফলাইন)')
                                    : t('Rider: Rokon Talukder · prepaid bKash', 'রাইডার: রকন · বিকাশ প্রিপেইড'),
                                style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor),
                              ),
                              const SizedBox(height: 6),
                              StChip(
                                tone: isIncident ? StTone.danger : StTone.info,
                                child: Text(isIncident ? t('Incident', 'ঘটনা') : t('On route', 'পথে')),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row( // layout-ok
                      children: [
                        Text(t('Escrow', 'এস্ক্রো'), style: TextStyle(color: Theme.of(context).hintColor)),
                        const Spacer(),
                        Text(isIncident ? '৳1,440' : '৳360', style: const TextStyle(fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            AppReveal(
              index: 1,
              child: StSection(
                title: t('Timeline', 'টাইমলাইন'),
                child: StCard(
                  child: StTimeline(
                    current: isIncident ? 2 : 3,
                    steps: [
                      (label: t('Paid', 'পরিশোধিত'), sub: '11:02 AM', icon: Icons.payments_outlined),
                      (label: t('Accepted by cook', 'রাঁধুনি গ্রহণ'), sub: '11:08 AM', icon: Icons.soup_kitchen_outlined),
                      (label: t('Packed', 'প্যাকড'), sub: '12:20 PM', icon: Icons.inventory_2_outlined),
                      (label: isIncident ? t('Rider offline', 'রাইডার অফলাইন') : t('On route', 'পথে'), sub: '12:41 PM', icon: Icons.two_wheeler),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            AppReveal(
              index: 2,
              child: StList(
                children: [
                  StRowTile(icon: Icons.person_outline, label: isIncident ? 'Cluster · 6 customers' : 'Tanvir Ahmed', sub: t('Customer', 'গ্রাহক'), onTap: () => ctrl.go('A-09', {'id': 'u2'})),
                  StRowTile(icon: Icons.soup_kitchen_outlined, label: isIncident ? "Maa's Kitchen" : "Rina's Kitchen", sub: t('Cook', 'রাঁধুনি'), onTap: () => ctrl.go('A-09', {'id': isIncident ? 'u4' : 'u3'})),
                  StRowTile(icon: Icons.two_wheeler, label: isIncident ? 'Rahim (offline)' : 'Rokon Talukder', sub: t('Rider', 'রাইডার'), onTap: () => ctrl.go('A-09', {'id': 'u5'})),
                ],
              ),
            ),
            const SizedBox(height: 12),
            AppReveal(
              index: 3,
              child: StBtn(
                label: t('Reassign rider', 'রাইডার পরিবর্তন'),
                full: true,
                variant: StBtnVariant.soft,
                icon: Icons.swap_horiz,
                onTap: () => ctrl.go('A-04'),
              ),
            ),
            const SizedBox(height: 8),
            AppReveal(
              index: 4,
              child: StBtn(
                label: isIncident ? t('Open incident #INC-14', 'ঘটনা #INC-14') : t('Open incident', 'ঘটনা খুলুন'),
                full: true,
                variant: isIncident ? StBtnVariant.danger : StBtnVariant.outline,
                icon: Icons.warning_amber_outlined,
                onTap: () => ctrl.go('A-02'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
