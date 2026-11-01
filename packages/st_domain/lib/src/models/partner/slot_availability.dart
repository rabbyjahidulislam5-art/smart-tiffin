import '../../result/slot.dart';

/// Whether a slot accepts new orders.
class SlotAvailability {
  const SlotAvailability({required this.slot, required this.open});

  final Slot slot;
  final bool open;
}
