import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../controllers/finance_roles_providers.dart';
import 'finance_roles_text.dart';

/// NF-15 Finance role permissions (`grantStaffRole`, `revokeStaffRole`).
class FinanceRolesScreen extends ConsumerStatefulWidget {
  const FinanceRolesScreen({super.key});

  static const states = {
    StVariant.loading,
    StVariant.error,
    StVariant.empty,
    StVariant.offline,
  };

  static const subRoles = <FinanceSubRole, StText>{
    FinanceSubRole.financeViewer: FinanceRolesText.financeViewer,
    FinanceSubRole.accountsOperator: FinanceRolesText.accountsOperator,
    FinanceSubRole.accountsManager: FinanceRolesText.accountsManager,
    FinanceSubRole.payoutApprover: FinanceRolesText.payoutApprover,
    FinanceSubRole.financialAuditor: FinanceRolesText.financialAuditor,
  };

  @override
  ConsumerState<FinanceRolesScreen> createState() => _FinanceRolesScreenState();
}

class _FinanceRolesScreenState extends ConsumerState<FinanceRolesScreen> {
  final _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _grant() async {
    final ok = await ref.read(grantFormProvider.notifier).submit();
    if (!ok || !mounted) return;
    _email.clear();
    ref.read(grantFormProvider.notifier).set((email: '', subRole: null));
    ref.invalidate(staffGrantsProvider);
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(appProvider);
    final form = ref.watch(grantFormProvider);
    final formCtrl = ref.read(grantFormProvider.notifier);
    final repo = ref.read(staffRoleRepositoryProvider);
    final actor = ref.read(actorProvider);
    String? err(String f) =>
        form.errorFor(f) == null ? null : s.tx(form.errorFor(f)!);
    return StScreen(
      title: s.tx(FinanceRolesText.title),
      eyebrow: s.tx(FinanceRolesText.eyebrow),
      dense: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StNote(child: Text(s.tx(FinanceRolesText.intro))),
          const SizedBox(height: StSpace.sm),
          StAsyncView<List<StaffGrant>>(
            value: ref.watch(staffGrantsProvider),
            supported: FinanceRolesScreen.states,
            isEmpty: (l) => l.isEmpty,
            emptyMessage: FinanceRolesText.noStaff,
            onRetry: () => ref.invalidate(staffGrantsProvider),
            builder: (context, staff) => StList(
              children: [
                for (final g in staff)
                  StRowTile(
                    icon: Icons.badge_outlined,
                    label: g.staffId == actor.id
                        ? '${g.name} (${s.tx(FinanceRolesText.you)})'
                        : g.name,
                    sub:
                        '${g.email} · ${s.tx(FinanceRolesScreen.subRoles[g.subRole]!)}',
                    right: g.status == GrantStatus.revoked
                        ? StStatusChip(
                            label: s.tx(FinanceRolesText.revoked),
                            tone: StTone.muted,
                          )
                        : StBtn(
                            label: s.tx(FinanceRolesText.revoke),
                            size: StBtnSize.sm,
                            variant: StBtnVariant.outline,
                            disabled: g.staffId == actor.id,
                            reason: g.staffId == actor.id
                                ? s.tx(FinanceRolesText.revokeSelf)
                                : null,
                            onTap: () => ref
                                .read(appProvider.notifier)
                                .showSheet(
                                  StReasonSheet(
                                    title: FinanceRolesText.revokeTitle,
                                    body: FinanceRolesText.revokeBody,
                                    commandName: FinanceRolesText.revokeName,
                                    success: FinanceRolesText.revokeDone,
                                    confirmLabel: FinanceRolesText.revoke,
                                    danger: true,
                                    onSubmit: (reason) => repo.revokeStaffRole(
                                      actor,
                                      RequestId.next('revoke'),
                                      staffId: g.staffId,
                                      reason: reason,
                                    ),
                                    onDone: () =>
                                        ref.invalidate(staffGrantsProvider),
                                  ),
                                ),
                          ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: StSpace.md),
          StSection(
            title: s.tx(FinanceRolesText.grantTitle),
            child: StCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (form.confirmed) ...[
                    StConfirmation(
                      message: s.tx(FinanceRolesText.grantDone),
                      dismissLabel: s.t('Dismiss', 'বন্ধ করুন'),
                      onDismissed: formCtrl.dismissConfirmation,
                    ),
                    const SizedBox(height: StSpace.xs),
                  ],
                  if (form.failed && form.errorKind != null) ...[
                    StCommandError(
                      name: FinanceRolesText.grantName,
                      kind: form.errorKind!,
                    ),
                    const SizedBox(height: StSpace.xs),
                  ],
                  StField(
                    label: s.tx(FinanceRolesText.email),
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    error: err('email'),
                    onChanged: (t) =>
                        formCtrl.update((v) => (email: t, subRole: v.subRole)),
                  ),
                  const SizedBox(height: StSpace.sm),
                  Text(
                    s.tx(FinanceRolesText.subRole),
                    style: const TextStyle(
                      fontSize: StFont.label,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: StSpace.gap6),
                  StChipRow(
                    options: [
                      for (final e in FinanceRolesScreen.subRoles.entries)
                        (v: e.key.name, l: s.tx(e.value)),
                    ],
                    value: form.values.subRole?.name ?? '',
                    onChanged: (r) => formCtrl.update(
                      (v) => (
                        email: v.email,
                        subRole: FinanceSubRole.values.byName(r),
                      ),
                    ),
                  ),
                  if (err('subRole') != null)
                    Text(
                      err('subRole')!,
                      style: const TextStyle(
                        color: StColors.danger,
                        fontSize: StFont.label,
                      ),
                    ),
                  const SizedBox(height: StSpace.sm),
                  StCommandButton(
                    label: s.tx(FinanceRolesText.grant),
                    icon: Icons.person_add_alt_rounded,
                    busy: form.submitting,
                    onTap: _grant,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
