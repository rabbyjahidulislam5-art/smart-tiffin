import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

class LiveTrackingScreen extends ConsumerWidget {
  const LiveTrackingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    final ctrl = ref.read(appProvider.notifier);
    final t = s.t;
    final meal = meals[1];

    return StScreen(
      title: t('Live tracking', 'লাইভ ট্র্যাকিং'),
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
                      meal.img,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(width: 56, height: 56, color: StColors.muted),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('TK-911', style: TextStyle(fontWeight: FontWeight.w800)),
                        Text(t(meal.en, meal.bn), maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text(t('ETA · 11 min', 'ETA · ১১ মিনিট'), style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                      ],
                    ),
                  ),
                  StChip(tone: s.store.gps ? StTone.success : StTone.danger, child: Text(s.store.gps ? t('GPS OK', 'GPS ঠিক') : t('GPS lost', 'GPS নেই'))),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          AppReveal(
            index: 1,
            child: StCard(
              child: Column(
                children: [
                  Container(
                    height: 180,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark ? StColors.darkMuted : StColors.muted,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.near_me, size: 40, color: StColors.success.withValues(alpha: 0.8)),
                        const SizedBox(height: 8),
                        Text(t('Live map (sample)', 'লাইভ ম্যাপ (নমুনা)'), style: const TextStyle(fontWeight: FontWeight.w700)),
                        Text(t('Banani → Dhanmondi Road 4', 'বনানী → ধানমন্ডি রোড ৪'), style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  StTimeline(
                    current: 2,
                    steps: [
                      (label: t('Picked up', 'পিকআপ'), sub: '11:28', icon: Icons.soup_kitchen_outlined),
                      (label: t('En route', 'পথে'), sub: '11:35', icon: Icons.two_wheeler),
                      (label: t('Nearby', 'কাছে'), sub: null, icon: Icons.location_on_outlined),
                      (label: t('Delivered', 'ডেলিভারড'), sub: null, icon: Icons.home_outlined),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          AppReveal(
            index: 2,
            child: StCard(
              child: Row(
                children: [
                  const StAvatar(name: 'Rokon Talukder'),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Rokon Talukder', style: TextStyle(fontWeight: FontWeight.w700)),
                        Text(t('Honda Shine · on the way', 'Honda Shine · পথে'), style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  StIconBtn(
                    icon: Icons.phone,
                    label: 'Call',
                    bg: StColors.success,
                    fg: Colors.white,
                    onTap: () => ctrl.showConfirm(
                      ConfirmOpts(
                        title: t('Call Rokon?', 'রোকনকে কল?'),
                        body: '+880 1811-223344 · ${t('Sample — no real call is placed', 'নমুনা — আসল কল হবে না')}',
                        ok: t('Call', 'কল'),
                        onOk: () => ctrl.toast(t('Calling Rokon…', 'রোকনকে কল হচ্ছে…')),
                      ),
                    ),
                  ),
                  StIconBtn(icon: Icons.chat_bubble_outline, label: 'Chat', onTap: () => ctrl.go('SH-02', {'who': 'Rokon Talukder'})),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          AppReveal(
            index: 3,
            child: StBtn(
              label: t('Order detail', 'অর্ডার বিবরণ'),
              full: true,
              variant: StBtnVariant.outline,
              onTap: () => ctrl.go('C-17', {'id': 'TK-911'}),
            ),
          ),
          const SizedBox(height: 8),
          AppReveal(
            index: 4,
            child: StBtn(
              label: t('Report a problem', 'সমস্যা জানান'),
              full: true,
              variant: StBtnVariant.ghost,
              onTap: () => ctrl.go('SH-06'),
            ),
          ),
        ],
      ),
    );
  }
}
