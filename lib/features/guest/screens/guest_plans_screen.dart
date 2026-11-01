import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';
import '../widgets/guest_nav.dart';

const _plansPromptBody = StText(
  'Plans unlock after you create a free customer account.',
  'বিনামূল্যে গ্রাহক অ্যাকাউন্ট খুললে প্ল্যান পাবেন।',
  source: StTextSource.doc,
);

class GuestPlansScreen extends ConsumerWidget {
  const GuestPlansScreen({super.key});

  void protect(WidgetRef ref, BuildContext context, String id,
          [Map<String, String>? p]) =>
      showSignInPrompt(ref,
          intent: NavEntry(id, p ?? {}), body: _plansPromptBody);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    final ctrl = ref.read(appProvider.notifier);
    final t = s.t;
    final role = context.roleColor;

    return StScreen(
      title: t('Meal plans', 'খাবারের প্ল্যান'),
      eyebrow: t('GUEST', 'অতিথি'),
      back: false,
      states: false,
      footer: const GuestNav(),
      actions: [
        StBtn(
          label: t('Sign in', 'সাইন ইন'),
          size: StBtnSize.sm,
          variant: StBtnVariant.soft,
          icon: Icons.login_rounded,
          onTap: () => ctrl.go('AU-03'),
        ),
      ],
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
                    StImg.heroTiffin,
                    height: 148,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Container(height: 148, color: role),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.15),
                            Colors.black.withValues(alpha: 0.55)
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t('Save with a plan', 'প্ল্যানে সাশ্রয় করুন'),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800)),
                        Text(
                          t('Homestyle lunches & dinners across Dhaka.',
                              'ঢাকা জুড়ে ঘরোয়া লাঞ্চ ও ডিনার।'),
                          style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          AppReveal(
            index: 1,
            child: StNote(
              child: Text(t('Browse freely. Subscribe after sign-in.',
                  'দেখুন মুক্তভাবে। সাবস্ক্রাইব করতে সাইন ইন করুন।')),
            ),
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < plans.length; i++)
            AppReveal(
              index: i + 2,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: StCard(
                  onTap: () =>
                      protect(ref, context, 'C-11', {'plan': plans[i].id}),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                                color: role.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(16)),
                            child:
                                Icon(Icons.calendar_month_rounded, color: role),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(t(plans[i].en, plans[i].bn),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 15)),
                                Text(plans[i].meals,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(context).hintColor)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Text('BDT ${plans[i].price}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18,
                                  color: role)),
                          const Spacer(),
                          StBtn(
                            label: t('Choose', 'বেছে নিন'),
                            size: StBtnSize.sm,
                            onTap: () => protect(
                                ref, context, 'C-11', {'plan': plans[i].id}),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          AppReveal(
            index: plans.length + 2,
            child: StCard(
              onTap: () => ctrl.go('P-04', {'r': 'customer'}),
              child: Row(
                children: [
                  Icon(Icons.help_outline_rounded, color: role),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      t('How subscriptions work',
                          'সাবস্ক্রিপশন কীভাবে কাজ করে'),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded,
                      color: Theme.of(context).hintColor),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
