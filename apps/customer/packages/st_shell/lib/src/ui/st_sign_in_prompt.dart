import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';

import '../state/app_controller.dart';
import '../state/nav_entry.dart';

/// Default body of the sign-in sheet (legacy P-01 and P-02 copies).
const signInPromptBody = StText(
  'Create a free account or sign in to subscribe and track deliveries.',
  'সাবস্ক্রাইব ও ট্র্যাক করতে অ্যাকাউন্ট খুলুন বা সাইন ইন করুন।',
  source: StTextSource.doc,
);

/// Opens the "Sign in to continue" sheet for a protected action (LC-10).
///
/// This is the body of the three private `protect()` copies of P-01, P-02
/// and P-03, which are textually equal after parameterizing their body text.
/// Sign in (AU-03) and Create account (AU-12) store [intent] as the
/// post-login intent; the protected action itself is never run here.
void showSignInPrompt(WidgetRef ref, {required NavEntry intent, StText body = signInPromptBody}) {
  final ctrl = ref.read(appProvider.notifier);
  final t = ref.read(appProvider).t;
  ctrl.showSheet(
    Builder(
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(t('Sign in to continue', 'চালিয়ে যেতে সাইন ইন করুন'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(t(body.en, body.bn), style: TextStyle(color: Theme.of(context).hintColor, height: 1.4)),
          const SizedBox(height: 16),
          StBtn(
            label: t('Sign in', 'সাইন ইন'),
            full: true,
            size: StBtnSize.lg,
            onTap: () {
              ctrl.setAfterLogin(intent);
              ctrl.closeSheet();
              ctrl.go('AU-03');
            },
          ),
          const SizedBox(height: 8),
          StBtn(
            label: t('Create account', 'অ্যাকাউন্ট খুলুন'),
            full: true,
            variant: StBtnVariant.outline,
            onTap: () {
              ctrl.setAfterLogin(intent);
              ctrl.closeSheet();
              ctrl.go('AU-12');
            },
          ),
        ],
      ),
    ),
  );
}
