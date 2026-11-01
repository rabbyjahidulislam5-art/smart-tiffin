import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_shell/st_shell.dart';

class LanguagePickScreen extends ConsumerWidget {
  const LanguagePickScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    final ctrl = ref.read(appProvider.notifier);
    final t = s.t;
    final role = context.roleColor;

    return StScreen(
      title: t('Choose language', 'ভাষা বেছে নিন'),
      eyebrow: t('WELCOME', 'স্বাগতম'),
      back: false,
      states: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppReveal(
            index: 0,
            child: Text(
              t('Pick how you want to read the app.', 'অ্যাপ কোন ভাষায় পড়তে চান বেছে নিন।'),
              style: TextStyle(color: Theme.of(context).hintColor, height: 1.4),
            ),
          ),
          const SizedBox(height: 16),
          for (var i = 0; i < StLang.values.length; i++)
            AppReveal(
              index: i + 1,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: StCard(
                  onTap: () => ctrl.setLang(StLang.values[i]),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(color: role.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(16)),
                        child: Icon(Icons.language_rounded, color: role),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          StLang.values[i] == StLang.en ? 'English' : 'বাংলা',
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                        ),
                      ),
                      if (s.lang == StLang.values[i]) Icon(Icons.check_circle_rounded, color: role),
                    ],
                  ),
                ),
              ),
            ),
          const SizedBox(height: 8),
          AppReveal(
            index: 3,
            child: StBtn(
              label: t('Continue', 'চালিয়ে যান'),
              full: true,
              size: StBtnSize.lg,
              onTap: () => ctrl.reset('P-01'),
            ),
          ),
        ],
      ),
    );
  }
}
