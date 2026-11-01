import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';

import '../state/app_controller.dart';

/// Status of a payout request (NS-03, NR-02): icon plus text, never colour
/// alone. Settled appears only after the transfer is confirmed.
class StPayoutStatusChip extends ConsumerWidget {
  const StPayoutStatusChip({super.key, required this.status});

  final PayoutStatus status;

  static const labels = <PayoutStatus, StText>{
    PayoutStatus.requested: StText('Requested', 'অনুরোধ করা'),
    PayoutStatus.underReview: StText('Under review', 'পর্যালোচনায়'),
    PayoutStatus.approved: StText('Approved', 'অনুমোদিত'),
    PayoutStatus.processing: StText('Processing', 'প্রক্রিয়াধীন'),
    PayoutStatus.settled: StText('Settled', 'নিষ্পন্ন'),
    PayoutStatus.failed: StText('Failed', 'ব্যর্থ'),
    PayoutStatus.rejected: StText('Rejected', 'প্রত্যাখ্যাত'),
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    final (tone, icon) = switch (status) {
      PayoutStatus.requested => (StTone.muted, Icons.schedule_rounded),
      PayoutStatus.underReview || PayoutStatus.approved => (
          StTone.info,
          Icons.fact_check_outlined
        ),
      PayoutStatus.processing => (StTone.warning, Icons.sync_rounded),
      PayoutStatus.settled => (StTone.success, Icons.check_circle_rounded),
      PayoutStatus.failed || PayoutStatus.rejected => (
          StTone.danger,
          Icons.error_outline_rounded
        ),
    };
    return StStatusChip(label: s.tx(labels[status]!), tone: tone, icon: icon);
  }
}
