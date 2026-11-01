import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

class RiderSosScreen extends ConsumerWidget {
  const RiderSosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.read(appProvider.notifier);
    final t = ref.watch(appProvider).t;
    return Theme(
      data: Theme.of(context).copyWith(extensions: [const StRoleTheme(role: StColors.rider)]),
      child: StScreen(
        title: t('Emergency SOS', 'জরুরি SOS'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppReveal(
              index: 0,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: StColors.danger.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: StColors.danger.withValues(alpha: 0.3)),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.sos, size: 64, color: StColors.danger),
                    const SizedBox(height: 12),
                    Text(t('Need urgent help?', 'জরুরি সাহায্য দরকার?'), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800), textAlign: TextAlign.center),
                    const SizedBox(height: 8),
                    Text(
                      t('Your live location and active delivery will be shared with Smart Tiffin safety desk.', 'আপনার লাইভ লোকেশন ও চলমান ডেলিভারি সেফটি ডেস্কের সাথে শেয়ার হবে।'),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Theme.of(context).hintColor),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            AppReveal(
              index: 1,
              child: StCard(
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        meals[1].img,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(width: 48, height: 48, color: StColors.muted),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(t('Active bag · TK-911', 'চলমান ব্যাগ · TK-911'), style: const TextStyle(fontWeight: FontWeight.w800)),
                          Text(t(meals[1].en, meals[1].bn), style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor), maxLines: 1, overflow: TextOverflow.ellipsis),
                          Text(t('Banani → Dhanmondi', 'বনানী → ধানমন্ডি'), style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            AppReveal(
              index: 2,
              child: StBtn(
                label: t('Call Safety Desk', 'সেফটি ডেস্কে কল'),
                full: true,
                size: StBtnSize.lg,
                icon: Icons.phone,
                onTap: () => ctrl.showConfirm(
                  ConfirmOpts(
                    title: t('Call Safety Desk?', 'সেফটি ডেস্কে কল?'),
                    body: '+880 96•• (demo)',
                    ok: t('Call now', 'এখন কল'),
                    onOk: () => ctrl.toast(t('Calling…', 'কল হচ্ছে…')),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            AppReveal(
              index: 3,
              child: StBtn(
                label: t('Share live location', 'লাইভ লোকেশন শেয়ার'),
                full: true,
                variant: StBtnVariant.outline,
                icon: Icons.share_location,
                onTap: () => ctrl.toast(t('Location shared with safety desk', 'লোকেশন শেয়ার হয়েছে')),
              ),
            ),
            const SizedBox(height: 8),
            AppReveal(
              index: 4,
              child: StBtn(
                label: t('False alarm — go back', 'মিথ্যা অ্যালার্ম — ফিরে যান'),
                full: true,
                variant: StBtnVariant.soft,
                onTap: () => ctrl.back(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
