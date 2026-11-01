import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../controllers/policy_config_providers.dart';
import 'policy_config_text.dart';

/// NA-02 Business policy configuration (`publishPolicyVersion`): versioned,
/// effective-dated rules with a preview before publishing.
class PolicyConfigScreen extends ConsumerStatefulWidget {
  const PolicyConfigScreen({super.key});

  static const states = {
    StVariant.loading,
    StVariant.error,
    StVariant.empty,
    StVariant.offline,
  };

  @override
  ConsumerState<PolicyConfigScreen> createState() => _PolicyConfigScreenState();
}

class _PolicyConfigScreenState extends ConsumerState<PolicyConfigScreen> {
  final _value = TextEditingController();
  final _date = TextEditingController();

  @override
  void dispose() {
    _value.dispose();
    _date.dispose();
    super.dispose();
  }

  Future<void> _publish() async {
    final ok = await ref.read(policyFormProvider.notifier).submit();
    if (!ok || !mounted) return;
    _value.clear();
    _date.clear();
    ref
        .read(policyFormProvider.notifier)
        .update((v) => (key: v.key, value: '', effectiveFrom: ''));
    ref.invalidate(policyVersionsProvider);
  }

  void _preview() {
    final formCtrl = ref.read(policyFormProvider.notifier);
    final v = ref.read(policyFormProvider).values;
    if (formCtrl.validate(v).isNotEmpty) {
      formCtrl.submit();
      return;
    }
    final s = ref.read(appProvider);
    ref
        .read(appProvider.notifier)
        .showConfirm(
          ConfirmOpts(
            title: s.tx(PolicyConfigText.previewTitle),
            body: s.tx(PolicyConfigText.previewBody, [
              v.key,
              v.value.trim(),
              v.effectiveFrom.trim(),
            ]),
            ok: s.tx(PolicyConfigText.publish),
            onOk: _publish,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(appProvider);
    final form = ref.watch(policyFormProvider);
    final formCtrl = ref.read(policyFormProvider.notifier);
    String? err(String f) =>
        form.errorFor(f) == null ? null : s.tx(form.errorFor(f)!);
    return StScreen(
      title: s.tx(PolicyConfigText.title),
      eyebrow: s.tx(PolicyConfigText.eyebrow),
      dense: true,
      child: StAsyncView<List<PolicyVersion>>(
        value: ref.watch(policyVersionsProvider),
        supported: PolicyConfigScreen.states,
        isEmpty: (l) => l.isEmpty,
        emptyMessage: PolicyConfigText.empty,
        onRetry: () => ref.invalidate(policyVersionsProvider),
        builder: (context, versions) {
          final keys = <String>[];
          for (final v in versions) {
            if (!keys.contains(v.key)) keys.add(v.key);
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StNote(child: Text(s.tx(PolicyConfigText.intro))),
              const SizedBox(height: StSpace.sm),
              StList(
                children: [
                  for (final v in versions)
                    StRowTile(
                      icon: Icons.policy_outlined,
                      label: '${v.key} (${v.rule})',
                      sub: v.value.isEmpty
                          ? s.tx(PolicyConfigText.notConfigured)
                          : '${v.value} · ${s.tx(PolicyConfigText.effective, [v.effectiveFrom])} · ${s.tx(PolicyConfigText.author, [v.author])}',
                      right: StStatusChip(
                        label: s.tx(switch (v.status) {
                          PolicyStatus.draft => PolicyConfigText.draft,
                          PolicyStatus.published => PolicyConfigText.published,
                          PolicyStatus.superseded =>
                            PolicyConfigText.superseded,
                        }),
                        tone: switch (v.status) {
                          PolicyStatus.draft => StTone.muted,
                          PolicyStatus.published => StTone.success,
                          PolicyStatus.superseded => StTone.info,
                        },
                      ),
                    ),
                ],
              ),
              const SizedBox(height: StSpace.md),
              StSection(
                title: s.tx(PolicyConfigText.publishTitle),
                child: StCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (form.confirmed) ...[
                        StConfirmation(
                          message: s.tx(PolicyConfigText.success),
                          dismissLabel: s.t('Dismiss', 'বন্ধ করুন'),
                          onDismissed: formCtrl.dismissConfirmation,
                        ),
                        const SizedBox(height: StSpace.xs),
                      ],
                      if (form.failed && form.errorKind != null) ...[
                        StCommandError(
                          name: PolicyConfigText.commandName,
                          kind: form.errorKind!,
                        ),
                        const SizedBox(height: StSpace.xs),
                      ],
                      Text(
                        s.tx(PolicyConfigText.key),
                        style: const TextStyle(
                          fontSize: StFont.label,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: StSpace.gap6),
                      StChipRow(
                        options: [for (final k in keys) (v: k, l: k)],
                        value: form.values.key,
                        onChanged: (k) => formCtrl.update(
                          (v) => (
                            key: k,
                            value: v.value,
                            effectiveFrom: v.effectiveFrom,
                          ),
                        ),
                      ),
                      if (err('key') != null)
                        Text(
                          err('key')!,
                          style: const TextStyle(
                            color: StColors.danger,
                            fontSize: StFont.label,
                          ),
                        ),
                      const SizedBox(height: StSpace.sm),
                      StField(
                        label: s.tx(PolicyConfigText.value),
                        controller: _value,
                        error: err('value'),
                        onChanged: (t) => formCtrl.update(
                          (v) => (
                            key: v.key,
                            value: t,
                            effectiveFrom: v.effectiveFrom,
                          ),
                        ),
                      ),
                      const SizedBox(height: StSpace.sm),
                      StField(
                        label: s.tx(PolicyConfigText.date),
                        controller: _date,
                        keyboardType: TextInputType.datetime,
                        error: err('effectiveFrom'),
                        onChanged: (t) => formCtrl.update(
                          (v) => (key: v.key, value: v.value, effectiveFrom: t),
                        ),
                      ),
                      const SizedBox(height: StSpace.sm),
                      StCommandButton(
                        label: s.tx(PolicyConfigText.preview),
                        icon: Icons.visibility_outlined,
                        busy: form.submitting,
                        onTap: _preview,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
