import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';

import '../state/app_controller.dart';
import 'st_band.dart';
import 'st_fin_column.dart';
import 'st_money_text.dart';

/// Financial table (requirements 13.2, 13.6).
///
/// Compact band: exactly one card per row with the identifying field, the
/// amount and the status. Medium and wider: a table whose identifying column
/// is pinned while the other columns scroll horizontally.
class StFinTable<T> extends ConsumerWidget {
  const StFinTable({
    super.key,
    required this.rows,
    required this.idLabel,
    required this.idOf,
    required this.amountMinorOf,
    required this.statusOf,
    this.subtitleOf,
    this.columns = const [],
    this.amountLabel = const StText('Amount', 'পরিমাণ'),
    this.statusLabel = const StText('Status', 'অবস্থা'),
    this.onTap,
  });

  final List<T> rows;
  final StText idLabel;
  final String Function(T row) idOf;
  final int Function(T row) amountMinorOf;
  final Widget Function(T row) statusOf;
  final String Function(T row)? subtitleOf;
  final List<StFinColumn<T>> columns;
  final StText amountLabel;
  final StText statusLabel;
  final void Function(T row)? onTap;

  static const double _idWidth = 140;
  static const double _amountWidth = 120;
  static const double _statusWidth = 140;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final band = bandOf(MediaQuery.sizeOf(context).width);
    return band == StBand.compact ? _cards(context, ref) : _table(context, ref);
  }

  Widget _cards(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final row in rows)
          Padding(
            padding: const EdgeInsets.only(bottom: StSpace.xs),
            child: StCard(
              key: ValueKey('fin-card-${idOf(row)}'),
              onTap: onTap == null ? null : () => onTap!(row),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s.digits(idOf(row)), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: StFont.body)),
                        if (subtitleOf != null)
                          Text(subtitleOf!(row), style: TextStyle(fontSize: StFont.label, color: Theme.of(context).hintColor)),
                        const SizedBox(height: StSpace.xxs),
                        statusOf(row),
                      ],
                    ),
                  ),
                  const SizedBox(width: StSpace.xs),
                  Flexible(
                    child: StMoneyText.minor(
                      amountMinorOf(row),
                      align: Alignment.centerRight,
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: StFont.bodyLg),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _table(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    final hint = Theme.of(context).hintColor;
    final divider = Theme.of(context).dividerColor.withValues(alpha: 0.7);
    Widget header(String text, double width, {bool numeric = false}) => SizedBox(
          width: width,
          child: Text(
            text,
            textAlign: numeric ? TextAlign.right : TextAlign.left,
            style: TextStyle(fontSize: StFont.caption, fontWeight: FontWeight.w700, color: hint),
          ),
        );
    Widget line(T? row, Widget child) => Container(
          height: StSize.tapLg,
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: divider))),
          alignment: Alignment.centerLeft,
          child: row == null || onTap == null ? child : InkWell(onTap: () => onTap!(row), child: child),
        );
    final pinned = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        line(null, header(s.tx(idLabel), _idWidth)),
        for (final row in rows)
          line(
            row,
            SizedBox(
              width: _idWidth,
              child: Text(s.digits(idOf(row)), overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
      ],
    );
    final scrolling = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        line(
          null,
          Row(children: [
            for (final c in columns) header(s.tx(c.label), c.width, numeric: c.numeric),
            header(s.tx(amountLabel), _amountWidth, numeric: true),
            const SizedBox(width: StSpace.md),
            header(s.tx(statusLabel), _statusWidth),
          ]),
        ),
        for (final row in rows)
          line(
            row,
            Row(children: [
              for (final c in columns)
                SizedBox(
                  width: c.width,
                  child: Text(s.digits(c.cell(row)), overflow: TextOverflow.ellipsis, textAlign: c.numeric ? TextAlign.right : TextAlign.left),
                ),
              SizedBox(
                width: _amountWidth,
                child: StMoneyText.minor(amountMinorOf(row), align: Alignment.centerRight, style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: StSpace.md),
              SizedBox(width: _statusWidth, child: Align(alignment: Alignment.centerLeft, child: statusOf(row))),
            ]),
          ),
      ],
    );
    return StCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          pinned,
          const SizedBox(width: StSpace.sm),
          Expanded(child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: scrolling)),
        ],
      ),
    );
  }
}
