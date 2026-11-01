import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_shell/st_shell.dart';

class VerificationDocsScreen extends ConsumerWidget {
  const VerificationDocsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.read(appProvider.notifier);
    final t = ref.watch(appProvider).t;
    final role = context.roleColor;
    final docs = [
      (t('National ID', 'জাতীয় পরিচয়পত্র'), StTone.success, t('Verified', 'যাচাইকৃত'), Icons.badge_outlined),
      (t('Kitchen inspection', 'কিচেন পরিদর্শন'), StTone.success, t('Checked', 'পরীক্ষিত'), Icons.home_work_outlined),
      (t('Hygiene certificate', 'স্বাস্থ্যবিধি সনদ'), StTone.warning, t('Expires in 20 days', '২০ দিনে মেয়াদ শেষ'), Icons.health_and_safety_outlined),
    ];
    return Theme(
      data: Theme.of(context).copyWith(extensions: [const StRoleTheme(role: StColors.supplier)]),
      child: StScreen(
        title: t('Verification', 'যাচাই'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppReveal(
              index: 0,
              child: StCard(
                child: Column(
                  children: [
                    Text(t('Kitchen trust score', 'কিচেন বিশ্বাস স্কোর'), style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                    Text('3 / 3', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: role)),
                    Text(t('All required documents on file', 'সব প্রয়োজনীয় কাগজ আছে'), style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            for (var i = 0; i < docs.length; i++)
              AppReveal(
                index: i + 1,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: StCard(
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(color: role.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16)),
                          child: Icon(docs[i].$4, color: role, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Text(docs[i].$1, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14))),
                        StChip(tone: docs[i].$2, child: Text(docs[i].$3)),
                      ],
                    ),
                  ),
                ),
              ),
            AppReveal(
              index: 4,
              child: StBtn(
                label: t('Upload renewal', 'নবায়ন আপলোড'),
                full: true,
                variant: StBtnVariant.soft,
                icon: Icons.upload_outlined,
                onTap: () => ctrl.toast(t('Renewal uploaded — pending admin review', 'নবায়ন আপলোড — অ্যাডমিন যাচাই অপেক্ষমাণ')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
