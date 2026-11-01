import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../screens/policy_config_text.dart';

/// NA-02 policy versions.
final policyVersionsProvider = FutureProvider.autoDispose<List<PolicyVersion>>(
  (ref) => stUnwrap(
    ref.watch(policyRepositoryProvider).versions(ref.watch(actorProvider)),
  ),
);

/// NA-02 publish form values.
typedef PolicyValues = ({String key, String value, String effectiveFrom});

/// NA-02 publish form (`publishPolicyVersion`).
final policyFormProvider =
    StateNotifierProvider.autoDispose<
      StFormController<PolicyValues>,
      StFormState<PolicyValues>
    >((ref) {
      final repo = ref.watch(policyRepositoryProvider);
      final actor = ref.watch(actorProvider);
      return StFormController<PolicyValues>(
        initial: (key: '', value: '', effectiveFrom: ''),
        validate: (v) {
          final date = latinDigits(v.effectiveFrom).trim();
          final okDate =
              RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(date) &&
              DateTime.tryParse(date) != null &&
              date.compareTo(ref.read(todayProvider)) > 0;
          return {
            if (v.key.isEmpty) 'key': PolicyConfigText.chooseKey,
            if (v.value.trim().length < 2) 'value': PolicyConfigText.valueShort,
            if (!okDate) 'effectiveFrom': PolicyConfigText.futureDate,
          };
        },
        command: (v, id) => repo.publishPolicyVersion(
          actor,
          id,
          key: v.key,
          value: v.value.trim(),
          effectiveFrom: latinDigits(v.effectiveFrom).trim(),
        ),
      );
    });
