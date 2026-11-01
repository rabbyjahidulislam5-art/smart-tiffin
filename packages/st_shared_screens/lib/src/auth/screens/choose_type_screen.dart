import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_shell/st_shell.dart';

class ChooseTypeScreen extends ConsumerStatefulWidget {
  const ChooseTypeScreen({super.key});

  @override
  ConsumerState<ChooseTypeScreen> createState() => _ChooseTypeScreenState();
}

class _ChooseTypeScreenState extends ConsumerState<ChooseTypeScreen> {
  StRole r = StRole.customer;

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(appProvider);
    final ctrl = ref.read(appProvider.notifier);
    final t = s.t;
    final role = context.roleColor;
    final options = [
      (StRole.customer, 'Customer', 'গ্রাহক', 'Order & subscribe · instant access', 'অর্ডার ও সাবস্ক্রাইব · সাথে সাথে', Icons.restaurant_rounded),
      (StRole.supplier, 'Supplier (Cook)', 'সাপ্লায়ার (রাঁধুনি)', 'Apply to cook · admin approval', 'রান্নার আবেদন · অ্যাডমিন অনুমোদন', Icons.soup_kitchen_outlined),
      (StRole.rider, 'Rider', 'রাইডার', 'Apply to deliver · admin approval', 'ডেলিভারির আবেদন · অ্যাডমিন অনুমোদন', Icons.two_wheeler_outlined),
    ];

    return StScreen(
      title: t('Create account', 'অ্যাকাউন্ট খুলুন'),
      back: true,
      states: false,
      footer: StBtn(
        label: t('Continue', 'চালিয়ে যান'),
        full: true,
        size: StBtnSize.lg,
        icon: Icons.arrow_forward_rounded,
        onTap: () {
          final g = s.current.params['google'];
          if (r == StRole.customer) {
            stOpen(ref, g != null ? 'AU-08' : 'AU-07');
          } else {
            stOpen(ref, r == StRole.supplier ? 'AU-09' : 'AU-10');
          }
        },
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppReveal(
            index: 0,
            child: Text(t('How will you use Smart Tiffin?', 'আপনি কীভাবে স্মার্ট টিফিন ব্যবহার করবেন?'), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, height: 1.2)),
          ),
          if (s.current.params['google'] != null)
            AppReveal(
              index: 1,
              child: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text('${t('Signed in as', 'সাইন ইন:')} ${s.current.params['google']} (Google)', style: TextStyle(color: Theme.of(context).hintColor)),
              ),
            ),
          const SizedBox(height: 16),
          for (var i = 0; i < options.length; i++)
            AppReveal(
              index: i + 2,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: StCard(
                  onTap: () => setState(() => r = options[i].$1),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(color: StColors.roleOf(options[i].$1.name).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16)),
                        child: Icon(options[i].$6, color: StColors.roleOf(options[i].$1.name)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t(options[i].$2, options[i].$3), style: const TextStyle(fontWeight: FontWeight.w800)),
                            Text(t(options[i].$4, options[i].$5), style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                          ],
                        ),
                      ),
                      if (r == options[i].$1) Icon(Icons.check_circle_rounded, color: StColors.roleOf(options[i].$1.name)),
                    ],
                  ),
                ),
              ),
            ),
          AppReveal(
            index: 5,
            child: StNote(child: Text(t('Admin accounts are invite-only and cannot be registered here.', 'অ্যাডমিন অ্যাকাউন্ট শুধু আমন্ত্রণে, এখানে নিবন্ধন করা যায় না।'))),
          ),
          const SizedBox(height: 8),
          AppReveal(
            index: 6,
            child: Center(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(t('Already have an account?', 'অ্যাকাউন্ট আছে?')),
                  TextButton(
                    onPressed: () => ctrl.go('AU-03'),
                    child: Text(t('Sign in', 'সাইন ইন'), style: TextStyle(color: role, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
