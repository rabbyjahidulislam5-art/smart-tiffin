import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_shell/st_shell.dart';

import 'partner_handoff_text.dart';

/// Supplier and rider applications continue in the Partner app (5.6). The
/// current screen stays beneath the sheet.
class PartnerHandoffSheet extends StatelessWidget {
  const PartnerHandoffSheet({super.key, required this.supplier});

  final bool supplier;

  @override
  Widget build(BuildContext context) => StHandoffSheet(
        icon: supplier ? Icons.storefront_rounded : Icons.two_wheeler_rounded,
        title: PartnerHandoffText.title,
        body: supplier ? PartnerHandoffText.supplierBody : PartnerHandoffText.riderBody,
        openLabel: PartnerHandoffText.open,
      );
}

/// Opens [PartnerHandoffSheet] over the current screen.
void showPartnerHandoff(WidgetRef ref, {required bool supplier}) =>
    ref.read(appProvider.notifier).showSheet(PartnerHandoffSheet(supplier: supplier));
