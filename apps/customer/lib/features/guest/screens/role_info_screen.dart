import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

class RoleInfoScreen extends ConsumerWidget {
  const RoleInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    final ctrl = ref.read(appProvider.notifier);
    final t = s.t;
    final r = s.current.params['r'] ?? 'customer';

    final Color accent;
    final String titleEn;
    final String titleBn;
    final String hero;
    final List<(IconData, String, String)> steps;
    final String ctaEn;
    final String ctaBn;
    final String ctaTo;
    final bool apply;

    switch (r) {
      case 'supplier':
        accent = StColors.supplier;
        titleEn = 'Cook with Smart Tiffin';
        titleBn = 'স্মার্ট টিফিনে রান্না করুন';
        hero = StImg.thali;
        steps = [
          (Icons.soup_kitchen_outlined, 'Share your kitchen', 'আপনার কিচেন শেয়ার করুন'),
          (Icons.restaurant_menu_outlined, 'List daily meals', 'দৈনিক মেনু দিন'),
          (Icons.payments_outlined, 'Earn per tiffin sold', 'প্রতি টিফিনে আয় করুন'),
        ];
        ctaEn = 'Apply as cook';
        ctaBn = 'রাঁধুনি হিসেবে আবেদন';
        ctaTo = 'AU-09';
        apply = true;
      case 'rider':
        accent = StColors.rider;
        titleEn = 'Deliver with Smart Tiffin';
        titleBn = 'স্মার্ট টিফিনে ডেলিভারি করুন';
        hero = StImg.beef;
        steps = [
          (Icons.two_wheeler_outlined, 'Pick lunch & dinner shifts', 'লাঞ্চ ও ডিনার শিফট নিন'),
          (Icons.navigation_outlined, 'Navigate kitchen → door', 'কিচেন থেকে দরজা পর্যন্ত'),
          (Icons.account_balance_wallet_outlined, 'Cash out weekly', 'সাপ্তাহিক পেমেন্ট'),
        ];
        ctaEn = 'Apply as rider';
        ctaBn = 'রাইডার হিসেবে আবেদন';
        ctaTo = 'AU-10';
        apply = true;
      default:
        accent = StColors.customer;
        titleEn = 'How Smart Tiffin works';
        titleBn = 'স্মার্ট টিফিন কীভাবে কাজ করে';
        hero = StImg.heroTiffin;
        steps = [
          (Icons.search_rounded, 'Browse kitchens & meals', 'কিচেন ও খাবার দেখুন'),
          (Icons.calendar_month_rounded, 'Pick a plan that fits', 'মানানসই প্ল্যান বেছে নিন'),
          (Icons.delivery_dining_rounded, 'Get fresh tiffins daily', 'প্রতিদিন তাজা টিফিন পান'),
        ];
        ctaEn = 'Create free account';
        ctaBn = 'বিনামূল্যে অ্যাকাউন্ট খুলুন';
        ctaTo = 'AU-12';
        apply = false;
    }

    return Theme(
      data: Theme.of(context).copyWith(extensions: [StRoleTheme(role: accent)]),
      child: StScreen(
        title: t(titleEn, titleBn),
        eyebrow: t('INFO', 'তথ্য'),
        states: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppReveal(
              index: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Stack(
                  children: [
                    Image.asset(
                      hero,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(height: 180, color: accent),
                    ),
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black.withValues(alpha: 0.55)],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 16,
                      child: Text(
                        t(titleEn, titleBn),
                        style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800, height: 1.2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            for (var i = 0; i < steps.length; i++)
              AppReveal(
                index: i + 1,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: StCard(
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(color: accent.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(16)),
                          child: Center(
                            child: Text('${i + 1}', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: accent)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(t(steps[i].$2, steps[i].$3), style: const TextStyle(fontWeight: FontWeight.w800)),
                              const SizedBox(height: 2),
                              Icon(steps[i].$1, size: 18, color: Theme.of(context).hintColor),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 8),
            AppReveal(
              index: steps.length + 1,
              child: StBtn(
                label: t(ctaEn, ctaBn),
                full: true,
                size: StBtnSize.lg,
                icon: apply ? Icons.edit_note_rounded : Icons.person_add_alt_1_rounded,
                onTap: () => stOpen(ref, ctaTo), // Partner app hand-off (CUSTOMER_PUBLIC_AND_AUTH_SCREENS.md 2.3)
              ),
            ),
            const SizedBox(height: 8),
            AppReveal(
              index: steps.length + 2,
              child: StBtn(
                label: t('Back to home', 'হোমে ফিরুন'),
                full: true,
                variant: StBtnVariant.outline,
                onTap: () => ctrl.reset('P-01'),
              ),
            ),
            if (apply) ...[
              const SizedBox(height: 12),
              AppReveal(
                index: steps.length + 3,
                child: StNote(
                  child: Text(
                    t('Applications are reviewed in 1–3 business days.', 'আবেদন ১–৩ কর্মদিবসে পর্যালোচনা হয়।'),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
