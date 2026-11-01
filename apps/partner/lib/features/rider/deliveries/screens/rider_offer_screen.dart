import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

class RiderOfferScreen extends ConsumerWidget {
  const RiderOfferScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.read(appProvider.notifier);
    final t = ref.watch(appProvider).t;
    final role = context.roleColor;
    return Theme(
      data: Theme.of(context).copyWith(extensions: [const StRoleTheme(role: StColors.rider)]),
      child: StScreen(
        title: t('New Offer', 'নতুন অফার'),
        back: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppReveal(
              index: 0,
              child: StCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row( // layout-ok
                      children: [
                        StChip(tone: StTone.danger, child: Text(t('NEW', 'নতুন'))),
                        const SizedBox(width: 8),
                        Text('#TK-912', style: TextStyle(fontWeight: FontWeight.w700, color: Theme.of(context).hintColor)),
                        const Spacer(),
                        Text('৳55', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: role)),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            meals[2].img,
                            width: 72,
                            height: 72,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(width: 72, height: 72, color: StColors.muted),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(t(meals[2].en, meals[2].bn), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                              Text('1× · ${t('Lunch', 'লাঞ্চ')}', style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(t('Pickup', 'পিকআপ'), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Theme.of(context).hintColor)),
                    Text("Rina's Kitchen · Moghbazar", style: const TextStyle(fontWeight: FontWeight.w700)),
                    Text('1.2 km away · ready now', style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                    const SizedBox(height: 12),
                    Text(t('Drop-off', 'ড্রপ-অফ'), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Theme.of(context).hintColor)),
                    const Text('Nusrat Jahan · Navana Tower, Gulshan 1', style: TextStyle(fontWeight: FontWeight.w700)),
                    Text('3.8 km · Est. 1:30 PM', style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: role.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(16)),
                      child: Row(
                        children: [
                          AppProgressRing(value: 0.35, size: 36, stroke: 4, color: role, child: Icon(Icons.timer_outlined, size: 16, color: role)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              t('Accept within 45 seconds', '৪৫ সেকেন্ডের মধ্যে গ্রহণ করুন'),
                              style: TextStyle(fontWeight: FontWeight.w700, color: role),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            AppReveal(
              index: 1,
              child: StBtn(
                label: t('Accept offer', 'অফার গ্রহণ'),
                full: true,
                size: StBtnSize.lg,
                icon: Icons.check_circle_outline,
                onTap: () {
                  ctrl.patchStore((st) => st.copyWith(riderStep: 0));
                  ctrl.toast(t('Offer accepted', 'অফার গৃহীত'));
                  ctrl.go('R-01');
                },
              ),
            ),
            const SizedBox(height: 8),
            AppReveal(
              index: 2,
              child: StBtn(
                label: t('Decline', 'প্রত্যাখ্যান'),
                full: true,
                variant: StBtnVariant.outline,
                onTap: () => ctrl.showConfirm(
                  ConfirmOpts(
                    title: t('Decline this offer?', 'অফার প্রত্যাখ্যান?'),
                    body: t('It will go to the next available rider.', 'পরবর্তী রাইডারের কাছে যাবে।'),
                    ok: t('Decline', 'প্রত্যাখ্যান'),
                    danger: true,
                    onOk: () {
                      ctrl.toast(t('Offer declined', 'অফার প্রত্যাখ্যান'));
                      ctrl.go('R-01');
                    },
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
