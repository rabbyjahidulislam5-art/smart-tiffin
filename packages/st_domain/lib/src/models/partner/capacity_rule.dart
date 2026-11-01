import '../../result/slot.dart';

/// Daily limit of one meal slot, with what obligations and orders already use.
class CapacityRule {
  const CapacityRule({
    required this.slot,
    required this.maxPortions,
    required this.committed,
    required this.open,
    required this.version,
  });

  final Slot slot;
  final int maxPortions;
  final int committed;

  /// False when the slot is closed for new orders.
  final bool open;
  final int version;

  bool get full => committed >= maxPortions;

  CapacityRule copyWith({int? maxPortions, bool? open, int? version}) => CapacityRule(
        slot: slot,
        maxPortions: maxPortions ?? this.maxPortions,
        committed: committed,
        open: open ?? this.open,
        version: version ?? this.version,
      );
}
