import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:st_customer_app/features/kitchen_discovery/controllers/kitchen_discovery_providers.dart';
import 'package:st_customer_app/features/kitchen_favourites/screens/kitchen_favourites_text.dart';
import 'package:st_customer_app/features/kitchen_profile/screens/kitchen_profile_text.dart';
import 'package:st_customer_app/navigation/customer_app_config.dart';
import 'package:st_customer_app/navigation/customer_manifest.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';
import 'package:st_test_kit/st_test_kit.dart';

// Widget and flow tests of NC-01, NC-02, NC-03 and NC-18 (tasks 20.11 and
// 20.12). Written in this session; not run (no Flutter toolchain here).
void main() {
  StScreenSpec spec(String id) =>
      customerManifest.firstWhere((s) => s.id == id);
  const rinas = {'kitchen': 'rinas-kitchen'};

  group('NC-01', () {
    stStandardScreenTests(config: customerAppConfig, spec: spec('NC-01'));
  });
  group('NC-02', () {
    stStandardScreenTests(
      config: customerAppConfig,
      spec: spec('NC-02'),
      params: rinas,
    );
  });
  group('NC-03', () {
    stStandardScreenTests(
      config: customerAppConfig,
      spec: spec('NC-03'),
      params: rinas,
    );
  });
  group('NC-18', () {
    stStandardScreenTests(
      config: customerAppConfig,
      spec: spec('NC-18'),
      sessions: [StRole.customer],
    );
  });

  MockFavouriteRepository favourites(ProviderContainerLike c) =>
      c.read(favouriteRepositoryProvider) as MockFavouriteRepository;

  Future<void> signInAsCustomer(WidgetTester tester) async {
    await tester.enterText(find.byType(TextField).first, '+880 1712-892401');
    await tester.tap(find.widgetWithText(StBtn, 'Sign in').first);
    await stPumpFrames(tester);
  }

  for (final host in ['P-02', 'C-01', 'C-04']) {
    testWidgets('a guest opens NC-01 from $host', (tester) async {
      final c = await pumpStApp(
        tester,
        config: customerAppConfig,
        start: host,
        sessions: const [],
      );
      final flow = StFlowRunner(tester, c)..expectAt(host);
      await flow.tapKey(const ValueKey('host-entry-NC-01'));
      flow.expectAt('NC-01');
      expect(find.byType(StUnbuiltScreen), findsNothing);
    });
  }

  testWidgets(
    'NC-01 a guest heart opens the sign-in prompt and writes nothing',
    (tester) async {
      final c = await pumpStApp(
        tester,
        config: customerAppConfig,
        start: 'NC-01',
        sessions: const [],
      );
      await tester.tap(find.byKey(const ValueKey('favourite-maas-kitchen')));
      await stPumpFrames(tester);
      expect(c.read(appProvider).sheet, isNotNull);
      expect(stCurrentId(c), 'NC-01');
      expect(favourites(c).calls.contains('setFavourite'), isFalse);
    },
  );

  testWidgets(
    'flow guest heart > AU-03 > customer sign-in > NC-01 with the same query and kitchen id',
    (tester) async {
      final c = await pumpStApp(
        tester,
        config: customerAppConfig,
        start: 'NC-01',
        sessions: const [],
      );
      const query = KitchenQuery(zone: 'Banani', verifiedOnly: true);
      c.read(kitchenQueryProvider.notifier).set(query);
      await stPumpFrames(tester);
      final flow = StFlowRunner(tester, c)..expectAt('NC-01');
      await flow.tapKey(const ValueKey('favourite-maas-kitchen'));
      await tester.tap(find.widgetWithText(StBtn, 'Sign in').last);
      await stPumpFrames(tester);
      flow.expectAt('AU-03');
      await signInAsCustomer(tester);
      flow.expectAt('NC-01');
      expect(c.read(appProvider).current.params['kitchen'], 'maas-kitchen');
      expect(c.read(kitchenQueryProvider), query);
      expect(favourites(c).calls.contains('setFavourite'), isFalse);
    },
  );

  testWidgets('NC-01 a cancelled sign-in keeps the query and runs no action', (
    tester,
  ) async {
    final c = await pumpStApp(
      tester,
      config: customerAppConfig,
      start: 'NC-01',
      sessions: const [],
    );
    c
        .read(kitchenQueryProvider.notifier)
        .set(const KitchenQuery(sort: KitchenSort.rating));
    await stPumpFrames(tester);
    await tester.tap(find.byKey(const ValueKey('favourite-rinas-kitchen')));
    await stPumpFrames(tester);
    c.read(appProvider.notifier).closeSheet();
    await stPumpFrames(tester);
    expect(stCurrentId(c), 'NC-01');
    expect(c.read(kitchenQueryProvider).sort, KitchenSort.rating);
    expect(c.read(appProvider).afterLogin, isNull);
    expect(favourites(c).calls.contains('setFavourite'), isFalse);
  });

  testWidgets('NC-01 a refused sign-in returns with the query kept', (
    tester,
  ) async {
    final c = await pumpStApp(
      tester,
      config: customerAppConfig,
      start: 'NC-01',
      sessions: const [],
    );
    const query = KitchenQuery(zone: 'Gulshan');
    c.read(kitchenQueryProvider.notifier).set(query);
    await stPumpFrames(tester);
    await tester.tap(find.byKey(const ValueKey('favourite-maas-kitchen')));
    await stPumpFrames(tester);
    await tester.tap(find.widgetWithText(StBtn, 'Sign in').last);
    await stPumpFrames(tester);
    await tester.enterText(find.byType(TextField).first, 'rina@kitchen.bd');
    await tester.tap(find.widgetWithText(StBtn, 'Sign in').first);
    await stPumpFrames(tester);
    expect(stCurrentId(c), 'AU-03');
    c.read(appProvider.notifier).back();
    await stPumpFrames(tester);
    expect(stCurrentId(c), 'NC-01');
    expect(c.read(kitchenQueryProvider), query);
    expect(favourites(c).calls.contains('setFavourite'), isFalse);
  });

  testWidgets('NC-01 keeps the scroll offset across a kitchen visit', (
    tester,
  ) async {
    final c = await pumpStApp(
      tester,
      config: customerAppConfig,
      start: 'NC-01',
      sessions: const [],
      height: 600,
    );
    final vertical = find.byWidgetPredicate(
      (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
    );
    await tester.drag(vertical.first, const Offset(0, -300));
    await stPumpFrames(tester);
    final saved = c.read(stScrollOffsetsProvider)['NC-01'] ?? 0;
    expect(saved, greaterThan(0));
    c.read(appProvider.notifier).go('NC-02', const {'kitchen': 'maas-kitchen'});
    await stPumpFrames(tester);
    c.read(appProvider.notifier).back();
    await stPumpFrames(tester);
    expect(stCurrentId(c), 'NC-01');
    expect(c.read(stScrollOffsetsProvider)['NC-01'], saved);
  });

  testWidgets(
    'NC-01 a query longer than 60 characters shows the helper and no request',
    (tester) async {
      final c = await pumpStApp(
        tester,
        config: customerAppConfig,
        start: 'NC-01',
        sessions: const [],
      );
      await tester.enterText(find.byType(TextField).first, 'x' * 61);
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('Use at most 60 characters.'), findsOneWidget);
      expect(c.read(kitchenQueryProvider).q, isEmpty);
    },
  );

  testWidgets(
    'NC-01 supplier and rider entries open the Partner hand-off over NC-01',
    (tester) async {
      final c = await pumpStApp(
        tester,
        config: customerAppConfig,
        start: 'NC-01',
        sessions: const [],
      );
      final flow = StFlowRunner(tester, c);
      await flow.tapKey(const ValueKey('handoff-supplier'));
      expect(find.byType(StHandoffSheet), findsOneWidget);
      flow.expectAt('NC-01');
      c.read(appProvider.notifier).closeSheet();
      await stPumpFrames(tester);
      await flow.tapKey(const ValueKey('handoff-rider'));
      expect(find.byType(StHandoffSheet), findsOneWidget);
      flow.expectAt('NC-01');
    },
  );

  testWidgets('NC-01 shows the bottom navigation in the compact band', (
    tester,
  ) async {
    await pumpStApp(tester, config: customerAppConfig, start: 'NC-01');
    expect(find.byType(StUnbuiltScreen), findsNothing);
    expect(tester.takeException(), isNull);
  });

  for (final id in ['NC-02', 'NC-03']) {
    testWidgets(
      '$id an absent and an unpublished kitchen show the same panel',
      (tester) async {
        for (final k in ['no-such-kitchen', 'sultana']) {
          await pumpStApp(
            tester,
            config: customerAppConfig,
            start: id,
            params: {'kitchen': k},
            sessions: const [],
          );
          expect(find.byType(StUnavailablePanel), findsOneWidget);
        }
      },
    );
  }

  testWidgets(
    'NC-02 a kitchen not accepting orders disables Subscribe with the reason',
    (tester) async {
      final c = await pumpStApp(
        tester,
        config: customerAppConfig,
        start: 'NC-02',
        params: const {'kitchen': 'dhaka-tiffin'},
      );
      final btn = tester.widget<StBtn>(find.byKey(const ValueKey('subscribe')));
      expect(btn.disabled, isTrue);
      expect(btn.reason, stTx(c, KitchenProfileText.subscribeBlocked));
    },
  );

  testWidgets('NC-02 a guest Subscribe keeps the kitchen id through sign-in', (
    tester,
  ) async {
    final c = await pumpStApp(
      tester,
      config: customerAppConfig,
      start: 'NC-02',
      params: rinas,
      sessions: const [],
    );
    await tester.tap(find.byKey(const ValueKey('subscribe')));
    await stPumpFrames(tester);
    expect(c.read(appProvider).sheet, isNotNull);
    expect(stCurrentId(c), 'NC-02');
    await tester.tap(find.widgetWithText(StBtn, 'Sign in').last);
    await stPumpFrames(tester);
    expect(c.read(appProvider).afterLogin?.id, 'NC-02');
    expect(c.read(appProvider).afterLogin?.params['kitchen'], 'rinas-kitchen');
    await signInAsCustomer(tester);
    expect(stCurrentId(c), 'NC-02');
    expect(c.read(appProvider).current.params['kitchen'], 'rinas-kitchen');
  });

  testWidgets(
    'NC-03 a guest Add to order opens the sign-in prompt without a cart change',
    (tester) async {
      final c = await pumpStApp(
        tester,
        config: customerAppConfig,
        start: 'NC-03',
        params: const {'kitchen': 'maas-kitchen'},
        sessions: const [],
      );
      final before = c.read(appProvider).store.cart;
      await tester.tap(find.byKey(const ValueKey('select-mk-biryani')));
      await stPumpFrames(tester);
      await tester.tap(find.byKey(const ValueKey('add-mk-biryani')));
      await stPumpFrames(tester);
      expect(stCurrentId(c), 'NC-03');
      expect(c.read(appProvider).store.cart, before);
      expect(c.read(appProvider).sheet, isNotNull);
    },
  );

  testWidgets('NC-03 a customer adds a meal and reaches the cart (C-07)', (
    tester,
  ) async {
    final c = await pumpStApp(
      tester,
      config: customerAppConfig,
      start: 'NC-03',
      params: const {'kitchen': 'maas-kitchen'},
    );
    await tester.tap(find.byKey(const ValueKey('select-mk-biryani')));
    await stPumpFrames(tester);
    await tester.tap(find.byKey(const ValueKey('add-mk-biryani')));
    await stPumpFrames(tester);
    final confirm = c.read(appProvider).confirm;
    if (confirm != null) {
      c.read(appProvider.notifier).closeConfirm();
      confirm.onOk();
      await stPumpFrames(tester);
    }
    expect(stCurrentId(c), 'C-07');
    expect(c.read(appProvider).store.cartMeal, 'biryani');
  });

  testWidgets('NC-03 reviews load more without duplicate rows', (tester) async {
    final c = await pumpStApp(
      tester,
      config: customerAppConfig,
      start: 'NC-03',
      params: const {'kitchen': 'maas-kitchen', 'tab': 'reviews'},
      sessions: const [],
    );
    expect(find.text('Tanvir'), findsOneWidget);
    final more = find.text(stTx(c, StLoadMore.more));
    await tester.ensureVisible(more);
    await tester.tap(more);
    await stPumpFrames(tester);
    expect(find.text('Tanvir'), findsOneWidget);
    expect(find.text('Habib'), findsOneWidget);
  });

  testWidgets('NC-18 a guest gets the sign-in panel and no favourite is read', (
    tester,
  ) async {
    final c = await pumpStApp(
      tester,
      config: customerAppConfig,
      start: 'NC-18',
      sessions: const [],
    );
    expect(find.byType(StSignInRequired), findsOneWidget);
    expect(favourites(c).calls, isEmpty);
    await tester.tap(find.text(stTx(c, StSignInRequired.action)));
    await stPumpFrames(tester);
    expect(c.read(appProvider).sheet, isNotNull);
  });

  testWidgets('NC-18 lists the favourite kitchen and the heart removes it', (
    tester,
  ) async {
    final c = await pumpStApp(
      tester,
      config: customerAppConfig,
      start: 'NC-18',
    );
    expect(
      find.byKey(const ValueKey('favourite-row-rinas-kitchen')),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const ValueKey('favourite-rinas-kitchen')));
    await stPumpFrames(tester);
    expect(favourites(c).calls.where((x) => x == 'setFavourite').length, 1);
    expect(find.text(stTx(c, KitchenFavouritesText.empty)), findsOneWidget);
  });

  testWidgets(
    'NC-18 a failed favourite change reverts the heart and names the command',
    (tester) async {
      final b = MockBehavior.instant();
      final c = await pumpStApp(
        tester,
        config: customerAppConfig,
        start: 'NC-18',
        behavior: b,
      );
      b.failNext(RepoErrorKind.temporarilyUnavailable);
      await tester.tap(find.byKey(const ValueKey('favourite-rinas-kitchen')));
      await stPumpFrames(tester);
      expect(find.byType(StCommandError), findsOneWidget);
      expect(
        find.byKey(const ValueKey('favourite-row-rinas-kitchen')),
        findsOneWidget,
      );
      expect(c.read(appProvider).current.id, 'NC-18');
    },
  );

  testWidgets('flow C-24 > NC-18 > NC-02', (tester) async {
    final c = await pumpStApp(tester, config: customerAppConfig, start: 'C-24');
    final flow = StFlowRunner(tester, c)..expectAt('C-24');
    await flow.tapKey(const ValueKey('host-entry-NC-18'));
    flow.expectAt('NC-18');
    await flow.tapKey(const ValueKey('favourite-row-rinas-kitchen'));
    flow.expectAt('NC-02');
  });

  testWidgets('flow NC-01 > NC-02 > NC-03', (tester) async {
    final c = await pumpStApp(
      tester,
      config: customerAppConfig,
      start: 'NC-01',
      sessions: const [],
    );
    final flow = StFlowRunner(tester, c)..expectAt('NC-01');
    await flow.tapKey(const ValueKey('kitchen-maas-kitchen'));
    flow.expectAt('NC-02');
    await flow.tapKey(const ValueKey('view-menu'));
    flow.expectAt('NC-03');
    expect(c.read(appProvider).current.params['kitchen'], 'maas-kitchen');
  });

  testWidgets('flow C-06 > NC-03 passes the kitchen on', (tester) async {
    final c = await pumpStApp(
      tester,
      config: customerAppConfig,
      start: 'C-06',
      params: const {'kitchen': "Rina's Kitchen"},
    );
    final flow = StFlowRunner(tester, c)..expectAt('C-06');
    await flow.tapKey(const ValueKey('host-entry-NC-03'));
    flow.expectAt('NC-03');
    expect(c.read(appProvider).current.params['kitchen'], "Rina's Kitchen");
    expect(find.byType(StUnavailablePanel), findsNothing);
  });
}
