/// A per-date change to the weekly pattern: skip the date or use another item.
class ScheduleException {
  const ScheduleException({required this.date, this.skip = false, this.menuItemId});

  final String date;
  final bool skip;
  final String? menuItemId;
}
