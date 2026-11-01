import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_shell/st_shell.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _Account {
  const _Account(this.id, this.en, this.bn, this.role, this.to);
  final String id; final String en; final String bn; final String role; final String to;
}

const _accounts = [
  _Account('+880 1712-892401', 'Customer · Tanvir', 'গ্রাহক · তানভীর', 'customer', 'C-01'),
  _Account('rina@kitchen.bd', 'Cook · Rina', 'রাঁধুনি · রিনা', 'supplier', 'S-01'),
  _Account('rokon@rider.bd', 'Rider · Rokon', 'রাইডার · রোকন', 'rider', 'R-01'),
  _Account('nadia@smarttiffin.bd', 'Admin (invited) · Nadia', 'অ্যাডমিন · নাদিয়া', 'admin', 'A-01'),
  _Account('sultana@kitchen.bd', 'Applicant · Sultana', 'আবেদনকারী · সুলতানা', 'applicant', 'AU-11'),
];

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late final TextEditingController idCtrl = TextEditingController(text: '+880 1712-892401');
  late final TextEditingController pwCtrl = TextEditingController(text: 'demo-password');
  bool show = false;
  String? errId, errPw, errForm;

  @override
  void dispose() { idCtrl.dispose(); pwCtrl.dispose(); super.dispose(); }

  void enter(_Account acc) {
    // Requirement 10.2: an account whose role this app does not serve stays
    // on AU-03 with a message, and no role is set.
    final cfg = ref.read(shellConfigProvider);
    final usable = acc.role == 'applicant' ? cfg.knows('AU-11') : cfg.roles.contains(StRole.values.byName(acc.role));
    if (!usable) {
      setState(() => errForm = ref.read(appProvider).t('This account cannot use this app.', 'এই অ্যাকাউন্ট দিয়ে এই অ্যাপ ব্যবহার করা যাবে না।'));
      return;
    }
    final ctrl = ref.read(appProvider.notifier);
    ctrl.toast(ref.read(appProvider).t('Signed in', 'সাইন ইন হয়েছে'));
    if (acc.role == 'applicant') {
      ctrl.patchStore((s) => s.copyWith(myApp: 'sultana'));
      ctrl.reset('AU-11', {'id': 'sultana'});
      return;
    }
    final role = StRole.values.byName(acc.role);
    ctrl.setRole(role);
    final after = ref.read(appProvider).afterLogin;
    if (role == StRole.customer && after != null) {
      ctrl.setAfterLogin(null);
      ctrl.reset(after.id, after.params);
      return;
    }
    ctrl.reset(acc.to);
  }

  void submit() {
    final t = ref.read(appProvider).t;
    final id = idCtrl.text;
    final pw = pwCtrl.text;
    String? eId, ePw, eForm;
    final digits = id.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 11 && !id.contains('@')) eId = t('Enter a valid mobile number or email', 'সঠিক মোবাইল নম্বর বা ইমেইল দিন');
    if (pw.length < 8) ePw = t('Minimum 8 characters', 'কমপক্ষে ৮ অক্ষর');
    if (eId == null && ePw == null && pw == 'wrongpass') eForm = t('Wrong password. 2 attempts left before lock.', 'ভুল পাসওয়ার্ড। লক হওয়ার আগে আর ২ বার।');
    final acc = _accounts.cast<_Account?>().firstWhere(
      (a) => a!.id.replaceAll(' ', '') == id.replaceAll(' ', ''),
      orElse: () => null,
    );
    if (eId == null && ePw == null && eForm == null && acc == null) {
      eForm = t('No account found for this email or number.', 'এই ইমেইল বা নম্বরে কোনো অ্যাকাউন্ট নেই।');
    }
    setState(() { errId = eId; errPw = ePw; errForm = eForm; });
    if (eId != null || ePw != null || eForm != null || acc == null) return;
    enter(acc);
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(appProvider);
    final ctrl = ref.read(appProvider.notifier);
    final t = s.t;
    final role = context.roleColor;
    return StScreen(
      title: t('Sign in', 'সাইন ইন'),
      states: false,
      actions: [
        SegmentedButton<StLang>(
          segments: const [
            ButtonSegment(value: StLang.en, label: Text('English')),
            ButtonSegment(value: StLang.bn, label: Text('বাংলা')),
          ],
          selected: {s.lang},
          onSelectionChanged: (v) => ctrl.setLang(v.first),
          style: const ButtonStyle(visualDensity: VisualDensity.compact),
        ),
      ],
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Center(child: StLogoMark(size: 72)),
        const SizedBox(height: 8),
        const Text('Smart Tiffin', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
        Text(t('Sign in to continue', 'চালিয়ে যেতে সাইন ইন করুন'), textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).hintColor)),
        if (s.afterLogin != null) ...[const SizedBox(height: 12), StNote(child: Text(t('Sign in to continue where you left off.', 'যেখানে ছিলেন সেখান থেকে চালিয়ে যেতে সাইন ইন করুন।')))],
        const SizedBox(height: 16),
        StCard(child: Column(children: [
          StField(label: t('Email or Mobile Number', 'ইমেইল বা মোবাইল নম্বর'), controller: idCtrl, error: errId),
          const SizedBox(height: 12),
          StField(label: t('Password', 'পাসওয়ার্ড'), hint: t('Min. 8 chars', 'কমপক্ষে ৮'), controller: pwCtrl, obscure: !show, error: errPw),
          Align(alignment: Alignment.centerRight, child: IconButton(icon: Icon(show ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => show = !show))),
          if (errForm != null) Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(errForm!, style: const TextStyle(color: StColors.danger, fontSize: 12, fontWeight: FontWeight.w600))),
          Row(children: [
            Expanded(child: StBtn(label: t('Sign in', 'সাইন ইন'), full: true, size: StBtnSize.lg, icon: Icons.arrow_forward, onTap: submit)),
            const SizedBox(width: 8),
            StIconBtn(icon: Icons.fingerprint, label: 'Biometric', onTap: () {
              ctrl.showSheet(Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.fingerprint, size: 40, color: role),
                const SizedBox(height: 8),
                Text(t('Unlock with fingerprint', 'আঙুলের ছাপে আনলক'), style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                StBtn(label: t('Simulate scan', 'স্ক্যান অনুকরণ'), full: true, onTap: () { ctrl.closeSheet(); submit(); }),
              ]));
            }),
          ]),
          Align(alignment: Alignment.centerRight, child: TextButton(onPressed: () => ctrl.go('AU-04'), child: Text(t('Forgot Password?', 'পাসওয়ার্ড ভুলে গেছেন?'), style: TextStyle(color: role, fontWeight: FontWeight.w600, fontSize: 12)))),
        ])),
        const SizedBox(height: 12),
        StBtn(label: t('Continue with Google', 'গুগল দিয়ে চালিয়ে যান'), full: true, variant: StBtnVariant.outline, onTap: () {
          ctrl.showSheet(Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
            Text(t('Choose a Google account', 'গুগল অ্যাকাউন্ট বেছে নিন'), style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            ListTile(leading: const StAvatar(name: 'Tanvir'), title: const Text('tanvir@gmail.com'), subtitle: Text(t('Existing customer', 'বিদ্যমান গ্রাহক')),
              onTap: () { ctrl.closeSheet(); enter(_accounts[0]); }),
            ListTile(leading: const StAvatar(name: 'New'), title: const Text('new.user@gmail.com'), subtitle: Text(t('No Smart Tiffin account yet', 'এখনো অ্যাকাউন্ট নেই')),
              onTap: () { ctrl.closeSheet(); ctrl.go('AU-12', {'google': 'new.user@gmail.com'}); }),
          ]));
        }),
        const SizedBox(height: 12),
        Center(child: Wrap(children: [
          Text(t('New here?', 'নতুন?')),
          TextButton(onPressed: () => ctrl.go('AU-12'), child: Text(t('Create account', 'অ্যাকাউন্ট খুলুন'), style: TextStyle(color: role, fontWeight: FontWeight.w700))),
        ])),
        const SizedBox(height: 8),
        StCard(color: Theme.of(context).brightness == Brightness.dark ? StColors.darkMuted : StColors.muted.withValues(alpha: 0.4), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(t('Sample accounts (prototype)', 'নমুনা অ্যাকাউন্ট'), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Theme.of(context).hintColor)),
          const SizedBox(height: 8),
          Wrap(spacing: 6, runSpacing: 6, children: [
            for (final a in _accounts)
              ActionChip(label: Text(t(a.en, a.bn), style: const TextStyle(fontSize: 11)),
                backgroundColor: idCtrl.text == a.id ? role : null,
                labelStyle: TextStyle(color: idCtrl.text == a.id ? Colors.white : null, fontWeight: FontWeight.w700),
                onPressed: () { setState(() { idCtrl.text = a.id; errId = errPw = errForm = null; }); }),
          ]),
          const SizedBox(height: 6),
          Text(t('Password "wrongpass" shows the error state.', '"wrongpass" দিলে ত্রুটি দেখাবে।'), style: TextStyle(fontSize: 11, color: Theme.of(context).hintColor)),
        ])),
      ]),
    );
  }
}
