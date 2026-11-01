import 'package:flutter/widgets.dart';

import 'st_band.dart';

/// Picks a builder for the current width band, falling back to the next
/// smaller band that has one (compact is required).
class StResponsive extends StatelessWidget {
  const StResponsive({super.key, required this.compact, this.medium, this.expanded, this.large});

  final WidgetBuilder compact;
  final WidgetBuilder? medium;
  final WidgetBuilder? expanded;
  final WidgetBuilder? large;

  @override
  Widget build(BuildContext context) {
    final band = bandOf(MediaQuery.sizeOf(context).width);
    final WidgetBuilder pick = switch (band) {
      StBand.large => large ?? expanded ?? medium ?? compact,
      StBand.expanded => expanded ?? medium ?? compact,
      StBand.medium => medium ?? compact,
      StBand.compact => compact,
    };
    return pick(context);
  }
}
