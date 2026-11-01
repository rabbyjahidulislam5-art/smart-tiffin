import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../controllers/cod_providers.dart';
import 'cod_text.dart';

/// NR-03 COD cash collection (sheet; `recordCodCollection`): the exact cash
/// tendered, confirmed by the customer, becomes a company liability.
class CodCollectionSheetScreen extends ConsumerStatefulWidget {
  const CodCollectionSheetScreen({super.key});

  static const states = {
    StVariant.loading,
    StVariant.error,
    StVariant.empty,
    StVariant.offline,
  };

  @override
  ConsumerState<CodCollectionSheetScreen> createState() =>
      _CodCollectionSheetScreenState();
}

class _CodCollectionSheetScreenState
    extends ConsumerState<CodCollectionSheetScreen> {
  final _amount = TextEditingController();

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  Future<void> _record() async {
    final ok = await ref.read(codCollectionFormProvider.notifier).submit();
    if (!ok || !mounted) return;
    _amount.clear();
    ref.invalidate(codCollectionsProvider);
    ref.invalidate(codLiabilityProvider);
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(appProvider);
    final form = ref.watch(codCollectionFormProvider);
    final formCtrl = ref.read(codCollectionFormProvider.notifier);
    final preselect = stParamsOf(context, ref)['id'];
    String? err(String f) =>
        form.errorFor(f) == null ? null : s.tx(form.errorFor(f)!);
    return StSheetOrScreen(
      title: s.tx(CodText.collectTitle),
      eyebrow: s.tx(CodText.eyebrow),
      child: StAsyncView<List<CodCollection>>(
        value: ref.watch(codCollectionsProvider),
        supported: CodCollectionSheetScreen.states,
        isEmpty: (list) =>
            !list.any((c) => c.status == CodStatus.toCollect) &&
            !form.confirmed,
        emptyMessage: CodText.nothingToCollect,
        onRetry: () => ref.invalidate(codCollectionsProvider),
        builder: (context, list) {
          final open = [
            for (final c in list)
              if (c.status == CodStatus.toCollect) c,
          ];
          final selected = form.values.collectionId.isNotEmpty
              ? form.values.collectionId
              : (preselect ?? (open.length == 1 ? open.first.id : ''));
          (String, String, bool) withSel(
            ({String collectionId, String amount, bool acknowledged}) v,
          ) => (
            v.collectionId.isEmpty ? selected : v.collectionId,
            v.amount,
            v.acknowledged,
          );
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StNote(child: Text(s.tx(CodText.collectNote))),
              const SizedBox(height: StSpace.sm),
              for (final c in open)
                Padding(
                  padding: const EdgeInsets.only(bottom: StSpace.xs),
                  child: StCard(
                    key: ValueKey('cod-${c.id}'),
                    color: selected == c.id
                        ? context.roleColor.withValues(alpha: 0.08)
                        : null,
                    onTap: () => formCtrl.update(
                      (v) => (
                        collectionId: c.id,
                        amount: v.amount,
                        acknowledged: v.acknowledged,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          selected == c.id
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                          color: context.roleColor,
                        ),
                        const SizedBox(width: StSpace.xs),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                s.digits(c.orderRef),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                c.customerRef,
                                style: const TextStyle(fontSize: StFont.label),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          s.tx(CodText.expectedAmount, [
                            s.moneyMinor(c.expectedMinor),
                          ]),
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
              if (err('collection') != null)
                Text(
                  err('collection')!,
                  style: const TextStyle(
                    color: StColors.danger,
                    fontSize: StFont.label,
                  ),
                ),
              if (form.confirmed) ...[
                StConfirmation(
                  message: s.tx(CodText.recorded),
                  dismissLabel: s.t('Dismiss', 'বন্ধ করুন'),
                  onDismissed: formCtrl.dismissConfirmation,
                ),
                const SizedBox(height: StSpace.xs),
                StBtn(
                  label: s.tx(CodText.toRemit),
                  variant: StBtnVariant.soft,
                  icon: Icons.upload_rounded,
                  onTap: () => stOpen(ref, 'NR-04'),
                ),
                const SizedBox(height: StSpace.xs),
              ],
              if (form.failed && form.errorKind != null) ...[
                StCommandError(name: CodText.recordName, kind: form.errorKind!),
                const SizedBox(height: StSpace.xs),
              ],
              if (open.isNotEmpty) ...[
                StField(
                  label: s.tx(CodText.amountLabel),
                  controller: _amount,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  error: err('amount'),
                  onChanged: (t) => formCtrl.update((v) {
                    final (id, _, ack) = withSel(v);
                    return (collectionId: id, amount: t, acknowledged: ack);
                  }),
                ),
                StToggle(
                  value: form.values.acknowledged,
                  label: s.tx(CodText.acknowledged),
                  onChanged: (on) => formCtrl.update((v) {
                    final (id, amount, _) = withSel(v);
                    return (collectionId: id, amount: amount, acknowledged: on);
                  }),
                ),
                if (err('acknowledged') != null)
                  Text(
                    err('acknowledged')!,
                    style: const TextStyle(
                      color: StColors.danger,
                      fontSize: StFont.label,
                    ),
                  ),
                const SizedBox(height: StSpace.sm),
                StCommandButton(
                  label: s.tx(CodText.record),
                  icon: Icons.payments_rounded,
                  busy: form.submitting,
                  onTap: _record,
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
