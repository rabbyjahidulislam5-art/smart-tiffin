import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';

import '../data/st_paged_list.dart';
import '../state/app_controller.dart';
import 'st_error_text.dart';

/// "Load more" footer of a paged list; nothing when the list is complete.
class StLoadMore<T> extends ConsumerWidget {
  const StLoadMore({super.key, required this.list, required this.onMore});

  final StPagedList<T> list;
  final VoidCallback onMore;

  static const more = StText('Load more', 'আরও দেখুন');
  static const loading = StText('Loading…', 'লোড হচ্ছে…');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (list.atEnd) return const SizedBox.shrink();
    final s = ref.watch(appProvider);
    final error = list.moreError;
    return Padding(
      padding: const EdgeInsets.only(top: StSpace.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (error != null) ...[
            Text(s.tx(StErrorText.message(error)),
                style: const TextStyle(
                    color: StColors.danger, fontSize: StFont.label)),
            const SizedBox(height: StSpace.xxs),
          ],
          StBtn(
            label: s.tx(list.loadingMore ? loading : more),
            variant: StBtnVariant.soft,
            disabled: list.loadingMore,
            onTap: onMore,
          ),
        ],
      ),
    );
  }
}
