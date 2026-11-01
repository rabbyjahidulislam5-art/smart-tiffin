import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_shell/st_shell.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final code = TextEditingController();
  String? err;

  @override
  void dispose() {
    code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(appProvider);
    final ctrl = ref.read(appProvider.notifier);
    final t = s.t;
    final role = context.roleColor;

    return StScreen(
      title: t('Enter code', 'কোড দিন'),
      back: true,
      states: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppReveal(
            index: 0,
            child: Text(
              t('Sent to +880 1712-892401 · Sample code 123456', '+880 1712-892401 এ পাঠানো · নমুনা কোড ১২৩৪৫৬'),
              style: TextStyle(color: Theme.of(context).hintColor, height: 1.35),
            ),
          ),
          const SizedBox(height: 16),
          AppReveal(
            index: 1,
            child: TextField(
              controller: code,
              keyboardType: TextInputType.number,
              maxLength: 6,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: 12),
              decoration: InputDecoration(
                counterText: '',
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.dark ? StColors.darkMuted : StColors.muted,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
              ),
              onChanged: (_) => setState(() => err = null),
            ),
          ),
          if (err != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(err!, style: const TextStyle(color: StColors.danger, fontSize: 12, fontWeight: FontWeight.w600)),
            ),
          const SizedBox(height: 14),
          AppReveal(
            index: 2,
            child: StBtn(
              label: t('Verify', 'যাচাই করুন'),
              full: true,
              size: StBtnSize.lg,
              onTap: () {
                final flow = s.current.params['flow'] ?? 'reset';
                if (code.text == '000000') {
                  setState(() => err = t('Code expired. Request a new one.', 'কোডের মেয়াদ শেষ। নতুন কোড নিন।'));
                  return;
                }
                if (code.text.length != 6) {
                  setState(() => err = t('Enter all 6 digits', '৬টি অঙ্ক দিন'));
                  return;
                }
                if (flow == 'reset') {
                  ctrl.go('AU-06');
                } else if (flow == 'signup') {
                  ctrl.go('AU-08');
                } else {
                  ctrl.go('AU-11');
                }
              },
            ),
          ),
          AppReveal(
            index: 3,
            child: TextButton(
              onPressed: () => ctrl.toast(t('New code sent (sample)', 'নতুন কোড পাঠানো হয়েছে (নমুনা)')),
              child: Text(t('Resend code', 'আবার কোড পাঠান'), style: TextStyle(color: role, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}
