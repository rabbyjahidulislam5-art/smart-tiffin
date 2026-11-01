import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../screens/kitchen_profile_text.dart';

/// One permitted, moderated review (DEC-013): author, stars, text and age.
class ReviewTile extends ConsumerWidget {
  const ReviewTile({super.key, required this.review});

  final KitchenReview review;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    final r = review;
    final hint = Theme.of(context).hintColor;
    return Padding(
      padding: const EdgeInsets.only(bottom: StSpace.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.account_circle_outlined, color: hint),
          const SizedBox(width: StSpace.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      r.author,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(width: StSpace.xs),
                    Semantics(
                      label: s.tx(KitchenProfileText.stars, ['${r.rating}']),
                      excludeSemantics: true,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (var i = 0; i < 5; i++)
                            Icon(
                              i < r.rating
                                  ? Icons.star_rounded
                                  : Icons.star_border_rounded,
                              size: StSize.iconXs,
                              color: StColors.warning,
                            ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      s.digits(r.ago),
                      style: TextStyle(fontSize: StFont.caption, color: hint),
                    ),
                  ],
                ),
                Text(s.t(r.textEn, r.textBn)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
