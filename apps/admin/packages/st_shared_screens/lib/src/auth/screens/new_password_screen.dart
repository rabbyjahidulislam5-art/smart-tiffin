import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_shell/st_shell.dart';

class NewPasswordScreen extends ConsumerStatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  ConsumerState<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends ConsumerState<NewPasswordScreen> {
  final a = TextEditingController();
  final b = TextEditingController();
  String? err;

  @override
  void dispose() {
    a.dispose();
    b.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = ref.read(appProvider.notifier);
    final t = ref.watch(appProvider).t;

    return StScreen(
      title: t('New password', 'নতুন পাসওয়ার্ড'),
      back: true,
      states: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppReveal(
            index: 0,
            child: StNote(child: Text(t('Choose a strong password (8+ characters).', 'শক্তিশালী পাসওয়ার্ড বেছে নিন (৮+ অক্ষর)।'))),
          ),
          const SizedBox(height: 14),
          AppReveal(
            index: 1,
            child: StField(label: t('New password', 'নতুন পাসওয়ার্ড'), controller: a, obscure: true),
          ),
          const SizedBox(height: 12),
          AppReveal(
            index: 2,
            child: StField(label: t('Confirm password', 'পাসওয়ার্ড নিশ্চিত করুন'), controller: b, obscure: true, error: err),
          ),
          const SizedBox(height: 16),
          AppReveal(
            index: 3,
            child: StBtn(
              label: t('Save & sign in', 'সংরক্ষণ ও সাইন ইন'),
              full: true,
              size: StBtnSize.lg,
              onTap: () {
                if (a.text.length < 8) {
                  setState(() => err = t('Minimum 8 characters', 'কমপক্ষে ৮ অক্ষর'));
                  return;
                }
                if (a.text != b.text) {
                  setState(() => err = t("Passwords don't match", 'পাসওয়ার্ড মিলছে না'));
                  return;
                }
                ctrl.toast(t('Password updated', 'পাসওয়ার্ড আপডেট হয়েছে'));
                ctrl.reset('AU-03');
              },
            ),
          ),
        ],
      ),
    );
  }
}
