import 'package:flutter/material.dart';
import 'package:st_design_system/st_design_system.dart';

import 'st_screen.dart';
import 'st_sheet_scope.dart';

/// Chrome of a sheet-form screen (NC-07, NC-09, NC-16, NS-07, NR-03): inside
/// the shell's bottom sheet it shows a title and the content; built outside a
/// sheet (deep link, test) it renders as a full `StScreen`.
class StSheetOrScreen extends StatelessWidget {
  const StSheetOrScreen({super.key, required this.title, required this.child, this.eyebrow});

  final String title;
  final String? eyebrow;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!StSheetScope.isSheet(context)) return StScreen(title: title, eyebrow: eyebrow, child: child);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (eyebrow != null)
          Text(
            eyebrow!.toUpperCase(),
            style: TextStyle(fontSize: StFont.micro, fontWeight: FontWeight.w700, color: context.roleColor),
          ),
        Text(title, style: const TextStyle(fontSize: StFont.heading, fontWeight: FontWeight.w800)),
        const SizedBox(height: StSpace.sm),
        child,
      ],
    );
  }
}
