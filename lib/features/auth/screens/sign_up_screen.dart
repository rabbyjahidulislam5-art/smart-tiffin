import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_shell/st_shell.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final name = TextEditingController();
  final phone = TextEditingController();
  final pw = TextEditingController();
  Map<String, String> e = {};

  @override
  void dispose() {
    name.dispose();
    phone.dispose();
    pw.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = ref.read(appProvider.notifier);
    final t = ref.watch(appProvider).t;

    return StScreen(
      title: t('Create account', 'অ্যাকাউন্ট খুলুন'),
      eyebrow: t('CUSTOMER', 'গ্রাহক'),
      back: true,
      states: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppReveal(
            index: 0,
            child: Text(
              t('Join Smart Tiffin for daily homestyle meals.', 'প্রতিদিন ঘরোয়া খাবারের জন্য স্মার্ট টিফিনে যোগ দিন।'),
              style: TextStyle(color: Theme.of(context).hintColor, height: 1.35),
            ),
          ),
          const SizedBox(height: 14),
          AppReveal(index: 1, child: StField(label: t('Full name', 'পুরো নাম'), controller: name, error: e['name'])),
          const SizedBox(height: 12),
          AppReveal(index: 2, child: StField(label: t('Mobile number', 'মোবাইল নম্বর'), controller: phone, error: e['phone'], placeholder: '+880')),
          const SizedBox(height: 12),
          AppReveal(index: 3, child: StField(label: t('Password', 'পাসওয়ার্ড'), controller: pw, obscure: true, error: e['pw'])),
          const SizedBox(height: 16),
          AppReveal(
            index: 4,
            child: StBtn(
              label: t('Send verification code', 'যাচাই কোড পাঠান'),
              full: true,
              size: StBtnSize.lg,
              onTap: () {
                final x = <String, String>{};
                if (name.text.trim().length < 2) x['name'] = t('Enter your name', 'নাম দিন');
                if (phone.text.replaceAll(RegExp(r'\D'), '').length < 11) x['phone'] = t('Enter a valid number', 'সঠিক নম্বর দিন');
                if (pw.text.length < 8) x['pw'] = t('Minimum 8 characters', 'কমপক্ষে ৮ অক্ষর');
                setState(() => e = x);
                if (x.isEmpty) ctrl.go('AU-05', {'flow': 'signup'});
              },
            ),
          ),
          const SizedBox(height: 10),
          AppReveal(
            index: 5,
            child: Text(
              t('By signing up you agree to the Terms of Service & Meal Hygiene Guidelines.', 'সাইন আপ করে আপনি শর্তাবলী ও খাদ্য স্বাস্থ্যবিধি মেনে নিচ্ছেন।'),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: Theme.of(context).hintColor, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}
