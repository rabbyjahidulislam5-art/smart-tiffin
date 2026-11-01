import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final v = TextEditingController();
  var channel = 'phone';
  String? e;

  @override
  void dispose() {
    v.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = ref.read(appProvider.notifier);
    final t = ref.watch(appProvider).t;

    return StScreen(
      title: t('Forgot password', 'পাসওয়ার্ড ভুলে গেছেন'),
      back: true,
      states: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppReveal(
            index: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                meals[1].img,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                color: Colors.black.withValues(alpha: 0.2),
                colorBlendMode: BlendMode.darken,
                errorBuilder: (_, __, ___) => Container(height: 120, color: StColors.muted),
              ),
            ),
          ),
          const SizedBox(height: 14),
          AppReveal(
            index: 1,
            child: StNote(
              child: Text(t("We'll send a 6-digit code to your phone or email.", 'আপনার ফোন বা ইমেইলে ৬ অঙ্কের কোড যাবে।')),
            ),
          ),
          const SizedBox(height: 12),
          AppReveal(
            index: 2,
            child: StSegmented(
              value: channel,
              onChanged: (v) => setState(() => channel = v),
              options: [
                (v: 'phone', l: t('Phone', 'ফোন')),
                (v: 'email', l: t('Email', 'ইমেইল')),
              ],
            ),
          ),
          const SizedBox(height: 14),
          AppReveal(
            index: 3,
            child: StField(
              label: channel == 'phone' ? t('Mobile number', 'মোবাইল নম্বর') : t('Email', 'ইমেইল'),
              controller: v,
              error: e,
              placeholder: channel == 'phone' ? '+880 17…' : 'you@example.com',
            ),
          ),
          const SizedBox(height: 16),
          AppReveal(
            index: 4,
            child: StBtn(
              label: t('Send code', 'কোড পাঠান'),
              full: true,
              size: StBtnSize.lg,
              onTap: () {
                if (v.text.trim().length < 6) {
                  setState(() => e = t('Enter your registered number or email', 'নিবন্ধিত নম্বর বা ইমেইল দিন'));
                  return;
                }
                ctrl.go('AU-05', {'flow': 'reset'});
              },
            ),
          ),
          const SizedBox(height: 8),
          AppReveal(
            index: 5,
            child: TextButton(
              onPressed: () => ctrl.go('AU-03'),
              child: Text(t('Back to sign in', 'সাইন ইনে ফিরুন'), style: const TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}
