import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';

import '../state/app_controller.dart';
import '../state/nav_entry.dart';
import 'st_sign_in_prompt.dart';

/// Shown instead of a signed-in-only customer screen opened by a guest
/// (requirement 5.4): no protected data is read; Sign in stores the current
/// screen and its parameters as the intent restored after sign-in.
class StSignInRequired extends ConsumerWidget {
  const StSignInRequired({super.key});

  static const title =
      StText('Sign in to continue', 'চালিয়ে যেতে সাইন ইন করুন');
  static const body = StText(
      'This page shows your own account. Sign in and you come straight back here.',
      'এই পাতায় আপনার নিজের অ্যাকাউন্ট দেখায়। সাইন ইন করলে সরাসরি এখানে ফিরবেন।');
  static const action = StText('Sign in', 'সাইন ইন');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    final role = context.roleColor;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: StSpace.xxl),
      child: Column(
        children: [
          Container(
            width: StSize.hero,
            height: StSize.hero,
            decoration: BoxDecoration(
                color: role.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(StRadius.card)),
            child: Icon(Icons.lock_outline_rounded,
                color: role, size: StSize.iconLg),
          ),
          const SizedBox(height: StSpace.sm),
          Text(s.tx(title),
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: StSpace.xxs),
          Text(s.tx(body),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: StFont.body, color: Theme.of(context).hintColor)),
          const SizedBox(height: StSpace.sm),
          StBtn(
            label: s.tx(action),
            icon: Icons.login_rounded,
            onTap: () => showSignInPrompt(ref,
                intent: NavEntry(s.current.id, s.current.params)),
          ),
        ],
      ),
    );
  }
}
