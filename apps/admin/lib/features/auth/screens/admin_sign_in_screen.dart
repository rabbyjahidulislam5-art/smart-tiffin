import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

class AdminSignInScreen extends ConsumerStatefulWidget {
  const AdminSignInScreen({super.key});
  @override
  ConsumerState<AdminSignInScreen> createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends ConsumerState<AdminSignInScreen> {
  int step = 0;
  int tries = 0;
  String err = '';
  final email = TextEditingController(text: 'nadia@smarttiffin.bd');
  final pw = TextEditingController();
  final code = TextEditingController();
  @override
  void dispose() {
    email.dispose();
    pw.dispose();
    code.dispose();
    super.dispose();
  }

  // LC-9: the granted role comes from StaffAuthRepository after the code
  // step, never from the interface (requirement 10.3, D-03 option A).
  Future<void> _grant() async {
    final ctrl = ref.read(appProvider.notifier);
    final t = ref.read(appProvider).t;
    final r = await ref
        .read(staffAuthRepositoryProvider)
        .verifyCredentials(email.text, pw.text);
    if (!mounted) return;
    switch (r) {
      case Ok(:final value):
        ctrl.setRole(value);
        ctrl.toast(value == StRole.accounting
            ? t('Accounts verified', 'অ্যাকাউন্টস যাচাইকৃত')
            : t('Admin verified', 'অ্যাডমিন যাচাইকৃত'));
        ctrl.reset(ref.read(shellConfigProvider).homeFor(value));
      case Err():
        setState(() => err = t('Sign-in could not be verified. Try again.',
            'সাইন ইন যাচাই করা যায়নি। আবার চেষ্টা করুন।'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = ref.watch(appProvider).t;
    final role = StColors.admin;
    final locked = tries >= 3;
    return Theme(
      data: Theme.of(context).copyWith(extensions: [StRoleTheme(role: role)]),
      child: StScreen(
        title: t('Admin secure sign-in', 'অ্যাডমিন নিরাপদ সাইন ইন'),
        eyebrow: 'RESTRICTED',
        states: false,
        back: false,
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Center(
              child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                      color: role.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(24)),
                  child: Icon(Icons.shield, color: role, size: 32))),
          const SizedBox(height: 8),
          Text(
              t('Admin accounts are invite-only and cannot be registered.',
                  'অ্যাডমিন অ্যাকাউন্ট শুধু আমন্ত্রণে, নিবন্ধন করা যায় না।'),
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).hintColor)),
          const SizedBox(height: 16),
          StCard(
              child: Column(children: [
            Row(children: [
              StChip(
                  tone: step == 0 ? StTone.role : StTone.success,
                  child: Text('1 · ${t('Password', 'পাসওয়ার্ড')}')),
              const SizedBox(width: 8),
              StChip(
                  tone: step == 1 ? StTone.role : StTone.muted,
                  child: Text('2 · ${t('Verification code', 'যাচাই কোড')}')),
            ]),
            const SizedBox(height: 12),
            if (step == 0) ...[
              StField(
                  label: t('Admin email', 'অ্যাডমিন ইমেইল'), controller: email),
              const SizedBox(height: 12),
              StField(
                  label: t('Password', 'পাসওয়ার্ড'),
                  controller: pw,
                  obscure: true),
              if (err.isNotEmpty)
                Text(err,
                    style: const TextStyle(
                        color: StColors.danger,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              StBtn(
                  label: t('Continue', 'চালিয়ে যান'),
                  full: true,
                  size: StBtnSize.lg,
                  onTap: () {
                    if (!email.text.endsWith('@smarttiffin.bd')) {
                      setState(() => err = t(
                          'This email is not an invited admin.',
                          'এই ইমেইল আমন্ত্রিত অ্যাডমিন নয়।'));
                      return;
                    }
                    if (pw.text.length < 8) {
                      setState(() =>
                          err = t('Minimum 8 characters', 'কমপক্ষে ৮ অক্ষর'));
                      return;
                    }
                    setState(() {
                      err = '';
                      step = 1;
                    });
                  }),
            ] else ...[
              Text(
                  t('Enter the 6-digit code sent to your admin email · sample 123456',
                      'অ্যাডমিন ইমেইলে পাঠানো ৬ অঙ্কের কোড · নমুনা ১২৩৪৫৬'),
                  style: TextStyle(
                      color: Theme.of(context).hintColor, fontSize: 13)),
              const SizedBox(height: 8),
              TextField(
                controller: code,
                enabled: !locked,
                keyboardType: TextInputType.number,
                maxLength: 6,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 10),
                decoration: InputDecoration(
                    counterText: '',
                    filled: true,
                    fillColor: Theme.of(context).brightness == Brightness.dark
                        ? StColors.darkMuted
                        : StColors.muted,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none)),
                onChanged: (_) => setState(() {}),
              ),
              if (err.isNotEmpty)
                Text(err,
                    style: const TextStyle(
                        color: StColors.danger,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              StBtn(
                  label: t('Verify & sign in', 'যাচাই ও সাইন ইন'),
                  full: true,
                  size: StBtnSize.lg,
                  disabled: locked || code.text.length != 6,
                  reason: locked
                      ? t('Locked — try later', 'লক — পরে চেষ্টা করুন')
                      : null,
                  onTap: () {
                    if (code.text == '123456') {
                      _grant();
                      return;
                    } // LC-9
                    final n = tries + 1;
                    setState(() {
                      tries = n;
                      code.clear();
                      err = n >= 3
                          ? t('Too many wrong codes. Locked for 15 minutes.',
                              'বারবার ভুল কোড। ১৫ মিনিট লক।')
                          : t('Wrong code. ${3 - n} attempts left.',
                              'ভুল কোড। আর ${3 - n} বার।');
                    });
                  }),
            ],
          ])),
          const SizedBox(height: 12),
          StNote(
              tone: StNoteTone.policy,
              child: Text(t(
                  'Not linked from guest, login or sign-up pages. Production uses a protected address.',
                  'গেস্ট, লগইন বা সাইন-আপ পেজ থেকে লিঙ্ক নেই। প্রোডাকশনে সুরক্ষিত ঠিকানা।'))),
        ]),
      ),
    );
  }
}
