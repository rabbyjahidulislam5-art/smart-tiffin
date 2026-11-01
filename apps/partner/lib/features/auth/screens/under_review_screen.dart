import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

class UnderReviewScreen extends ConsumerWidget {
  const UnderReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    final ctrl = ref.read(appProvider.notifier);
    final t = s.t;
    final id = s.current.params['id'] ?? s.store.myApp ?? 'sultana';
    final status = appStatusOf(s.store, id);
    final all = allApplicantsOf(s.store);
    final app = all.cast<Applicant?>().firstWhere((a) => a!.id == id, orElse: () => all.isNotEmpty ? all.first : null);
    final (tone, en, bn) = switch (status) {
      AppStatus.approved => (StTone.success, 'Approved', 'অনুমোদিত'),
      AppStatus.rejected => (StTone.danger, 'Rejected', 'প্রত্যাখ্যাত'),
      AppStatus.info => (StTone.warning, 'More info needed', 'আরও তথ্য দরকার'),
      AppStatus.pending => (StTone.info, 'Under review', 'পর্যালোচনাধীন'),
    };

    return StScreen(
      title: t('Application status', 'আবেদনের অবস্থা'),
      states: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppReveal(
            index: 0,
            child: StCard(
              child: Column(
                children: [
                  StChip(tone: tone, child: Text(t(en, bn))),
                  const SizedBox(height: 12),
                  Text(app?.name ?? id, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                  Text(app?.kind ?? '', style: TextStyle(color: Theme.of(context).hintColor)),
                  if (s.store.info[id] != null) ...[
                    const SizedBox(height: 8),
                    StNote(tone: StNoteTone.warning, child: Text(s.store.info[id]!)),
                  ],
                  if (s.store.reasons[id] != null) ...[
                    const SizedBox(height: 8),
                    StNote(tone: StNoteTone.warning, child: Text(s.store.reasons[id]!)),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (status == AppStatus.approved)
            AppReveal(
              index: 1,
              child: StBtn(
                label: t('Open dashboard', 'ড্যাশবোর্ড খুলুন'),
                full: true,
                size: StBtnSize.lg,
                onTap: () {
                  final role = (app?.kind == 'Rider') ? StRole.rider : StRole.supplier;
                  ctrl.setRole(role);
                  ctrl.reset(ref.read(shellConfigProvider).homeFor(role));
                },
              ),
            ),
          if (status == AppStatus.info)
            AppReveal(
              index: 1,
              child: StBtn(
                label: t('Update application', 'আবেদন আপডেট'),
                full: true,
                onTap: () => ctrl.go(app?.kind == 'Rider' ? 'AU-10' : 'AU-09'),
              ),
            ),
          const SizedBox(height: 8),
          AppReveal(
            index: 2,
            child: StBtn(
              label: t('Sign out', 'সাইন আউট'),
              full: true,
              variant: StBtnVariant.outline,
              onTap: ctrl.signOut, // LC-8
            ),
          ),
        ],
      ),
    );
  }
}
