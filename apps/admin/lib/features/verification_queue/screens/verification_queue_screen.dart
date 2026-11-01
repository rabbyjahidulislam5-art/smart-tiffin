import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../controllers/verification_queue_providers.dart';
import 'verification_queue_text.dart';

/// NA-03 Supplier and rider verification queue (`decideApplication`):
/// Approve stays disabled until every check is ticked; Request information
/// and Reject need a written reason.
class VerificationQueueScreen extends ConsumerWidget {
  const VerificationQueueScreen({super.key});

  static const states = {
    StVariant.loading,
    StVariant.error,
    StVariant.empty,
    StVariant.offline,
  };

  static const checks = <String, StText>{
    'identity': VerificationQueueText.identity,
    'premises': VerificationQueueText.premises,
    'compliance': VerificationQueueText.compliance,
  };

  static StText statusText(ApplicationStatus st) => switch (st) {
    ApplicationStatus.pending => VerificationQueueText.pending,
    ApplicationStatus.infoRequested => VerificationQueueText.infoRequested,
    ApplicationStatus.approved => VerificationQueueText.approved,
    ApplicationStatus.rejected => VerificationQueueText.rejected,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    final filter = ref.watch(applicationFilterProvider);
    final selected =
        ref.watch(selectedApplicationProvider) ??
        stParamsOf(context, ref)['id'];
    return StScreen(
      title: s.tx(VerificationQueueText.title),
      eyebrow: s.tx(VerificationQueueText.eyebrow),
      dense: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StChipRow(
            options: [
              (v: 'all', l: s.tx(VerificationQueueText.filterAll)),
              for (final st in ApplicationStatus.values)
                (v: st.name, l: s.tx(statusText(st))),
            ],
            value: filter?.name ?? 'all',
            onChanged: (v) =>
                ref.read(applicationFilterProvider.notifier).state = v == 'all'
                ? null
                : ApplicationStatus.values.byName(v),
          ),
          const SizedBox(height: StSpace.sm),
          StAsyncView<List<ApplicationCase>>(
            value: ref.watch(applicationQueueProvider),
            supported: states,
            isEmpty: (l) => l.isEmpty,
            emptyMessage: VerificationQueueText.empty,
            onRetry: () => ref.invalidate(applicationQueueProvider),
            builder: (context, list) {
              ApplicationCase? current;
              for (final c in list) {
                if (c.id == selected) current = c;
              }
              final listView = Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final c in list)
                    _caseTile(context, ref, s, c, c.id == selected),
                ],
              );
              final detail = current == null
                  ? StNote(child: Text(s.tx(VerificationQueueText.select)))
                  : _decisionPanel(context, ref, s, current);
              return StResponsive(
                compact: (context) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    listView,
                    const SizedBox(height: StSpace.sm),
                    detail,
                  ],
                ),
                expanded: (context) => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: listView),
                    const SizedBox(width: StSpace.md),
                    Expanded(child: detail),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  static Widget _caseTile(
    BuildContext context,
    WidgetRef ref,
    AppState s,
    ApplicationCase c,
    bool selected,
  ) => Padding(
    padding: const EdgeInsets.only(bottom: StSpace.xs),
    child: StCard(
      key: ValueKey('application-${c.id}'),
      color: selected ? context.roleColor.withValues(alpha: 0.08) : null,
      onTap: () => ref.read(selectedApplicationProvider.notifier).state = c.id,
      child: Row(
        children: [
          StAvatar(name: c.name),
          const SizedBox(width: StSpace.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  c.name,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  '${c.owner} · ${c.area}',
                  style: const TextStyle(fontSize: StFont.label),
                ),
                Text(
                  s.tx(VerificationQueueText.submitted, [c.submittedAgo]),
                  style: TextStyle(
                    fontSize: StFont.caption,
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              StStatusChip(
                label: s.tx(
                  c.kind == ApplicationKind.cook
                      ? VerificationQueueText.cook
                      : VerificationQueueText.rider,
                ),
                tone: StTone.role,
              ),
              const SizedBox(height: StSpace.xxs),
              StStatusChip(
                label: s.tx(statusText(c.status)),
                tone: c.status == ApplicationStatus.pending
                    ? StTone.warning
                    : StTone.muted,
              ),
            ],
          ),
        ],
      ),
    ),
  );

  /// Decision panel of the selected application.
  static Widget _decisionPanel(
    BuildContext context,
    WidgetRef ref,
    AppState s,
    ApplicationCase c,
  ) {
    final draft = ref.watch(checklistDraftProvider(c.id));
    final checklist = {...c.checklist, ...draft};
    final allChecked = checklist.values.every((v) => v);
    final open =
        c.status == ApplicationStatus.pending ||
        c.status == ApplicationStatus.infoRequested;
    final repo = ref.read(applicationReviewRepositoryProvider);
    final actor = ref.read(actorProvider);
    void refresh() {
      ref.invalidate(applicationQueueProvider);
      ref.read(checklistDraftProvider(c.id).notifier).state = const {};
    }

    void reasonSheet(StText title, ApplicationDecision decision, StText done) {
      ref
          .read(appProvider.notifier)
          .showSheet(
            StReasonSheet(
              title: title,
              body: VerificationQueueText.reasonBody,
              commandName: VerificationQueueText.commandName,
              success: done,
              confirmLabel: title,
              minLength: 10,
              danger: decision == ApplicationDecision.reject,
              onSubmit: (reason) => repo.decideApplication(
                actor,
                RequestId.next('decide'),
                id: c.id,
                decision: decision,
                checklist: checklist,
                reason: reason,
              ),
              onDone: refresh,
            ),
          );
    }

    return StCard(
      child: StCommandScope(
        builder: (context, cmd) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              c.name,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: StFont.bodyLg,
              ),
            ),
            if (c.reason != null)
              Text(s.tx(VerificationQueueText.reason, [c.reason!])),
            const SizedBox(height: StSpace.xs),
            Text(
              s.tx(VerificationQueueText.checklist),
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            for (final e in VerificationQueueScreen.checks.entries)
              StToggle(
                value: checklist[e.key] ?? false,
                label: s.tx(e.value),
                onChanged: (on) {
                  if (!open) return;
                  final notifier = ref.read(
                    checklistDraftProvider(c.id).notifier,
                  );
                  notifier.state = {...notifier.state, e.key: on};
                },
              ),
            const SizedBox(height: StSpace.sm),
            if (!open)
              StNote(child: Text(s.tx(VerificationQueueText.decided)))
            else ...[
              StCommandButton(
                label: s.tx(VerificationQueueText.approve),
                icon: Icons.verified_rounded,
                variant: StBtnVariant.success,
                busy: cmd.busy,
                disabledReason: allChecked
                    ? null
                    : s.tx(VerificationQueueText.approveReason),
                onTap: () => cmd.run(
                  () => repo.decideApplication(
                    actor,
                    RequestId.next('decide'),
                    id: c.id,
                    decision: ApplicationDecision.approve,
                    checklist: checklist,
                  ),
                  name: VerificationQueueText.commandName,
                  success: VerificationQueueText.approvedDone,
                  onSuccess: refresh,
                ),
              ),
              const SizedBox(height: StSpace.xs),
              StCommandButton(
                label: s.tx(VerificationQueueText.requestInfo),
                icon: Icons.help_outline_rounded,
                variant: StBtnVariant.outline,
                onTap: () => reasonSheet(
                  VerificationQueueText.infoTitle,
                  ApplicationDecision.requestInfo,
                  VerificationQueueText.infoDone,
                ),
              ),
              const SizedBox(height: StSpace.xs),
              StCommandButton(
                label: s.tx(VerificationQueueText.reject),
                icon: Icons.block_rounded,
                variant: StBtnVariant.danger,
                onTap: () => reasonSheet(
                  VerificationQueueText.rejectTitle,
                  ApplicationDecision.reject,
                  VerificationQueueText.rejectedDone,
                ),
              ),
            ],
            const SizedBox(height: StSpace.xs),
            Text(
              s.tx(VerificationQueueText.audit),
              style: TextStyle(
                fontSize: StFont.caption,
                color: Theme.of(context).hintColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
