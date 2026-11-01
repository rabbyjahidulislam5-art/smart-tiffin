import 'package:flutter_test/flutter_test.dart';
import 'package:st_shell/st_shell.dart';

import 'pump_st_app.dart';

/// Widths of the four bands (compact, medium, expanded, large).
const stMatrixWidths = <double>[360, 720, 1024, 1440];

/// Defines the 16 combinations (4 widths x en/bn x light/dark) for [id] and
/// asserts no exception (overflow included) and no placeholder screen.
void stMatrixTest(
  String family, {
  required StShellConfig config,
  required String id,
  Map<String, String> params = const {},
  List<StRole>? sessions,
}) {
  for (final w in stMatrixWidths) {
    for (final lang in StLang.values) {
      for (final theme in const [StThemeMode.light, StThemeMode.dark]) {
        testWidgets('$family $id w${w.toInt()} ${lang.name} ${theme.name}', (
          tester,
        ) async {
          await pumpStApp(
            tester,
            config: config,
            start: id,
            params: params,
            sessions: sessions,
            lang: lang,
            theme: theme,
            width: w,
            height: 900,
          );
          expect(tester.takeException(), isNull);
          expect(find.byType(StUnbuiltScreen), findsNothing);
        });
      }
    }
  }
}
