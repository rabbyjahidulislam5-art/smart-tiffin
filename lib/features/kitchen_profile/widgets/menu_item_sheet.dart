import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../../kitchen_discovery/widgets/kitchen_photo.dart';
import '../screens/kitchen_profile_text.dart';

/// NC-03 Select sheet: quantity and "Add to order" (browse mode). A guest
/// gets the sign-in prompt with [intent] and the cart is not touched. The
/// one-kitchen cart of C-05 is kept: a meal from another kitchen asks before
/// it replaces the cart. Price and availability are confirmed at checkout.
class MenuItemSheet extends ConsumerStatefulWidget {
  const MenuItemSheet({
    super.key,
    required this.item,
    required this.kitchen,
    required this.intent,
  });

  final MenuItem item;
  final KitchenSummary kitchen;
  final NavEntry intent;

  @override
  ConsumerState<MenuItemSheet> createState() => _MenuItemSheetState();
}

class _MenuItemSheetState extends ConsumerState<MenuItemSheet> {
  static const _maxQty = 10;
  int _qty = 1;

  Meal? _meal(String id) {
    for (final m in meals) {
      if (m.id == id) return m;
    }
    return null;
  }

  void _add() {
    final ctrl = ref.read(appProvider.notifier);
    final s = ref.read(appProvider);
    if (ref.read(actorProvider).isGuest) {
      showSignInPrompt(
        ref,
        intent: widget.intent,
        body: KitchenProfileText.addPrompt,
      );
      return;
    }
    final qty = _qty;
    final mealId = widget.item.mealId;
    final added = s.tx(KitchenProfileText.added);
    void commit() {
      ctrl.patchStore((st) => st.copyWith(cart: qty, cartMeal: mealId));
      ctrl.closeSheet();
      ctrl.toast(added);
      ctrl.go('C-07');
    }

    final store = s.store;
    final cartKitchen = _meal(store.cartMeal)?.kitchen;
    if (store.cart > 0 &&
        cartKitchen != null &&
        cartKitchen != widget.kitchen.nameEn) {
      ctrl.closeSheet();
      ctrl.showConfirm(
        ConfirmOpts(
          title: s.tx(KitchenProfileText.replaceTitle),
          body: s.tx(KitchenProfileText.replaceBody),
          ok: s.tx(KitchenProfileText.replaceOk),
          onOk: commit,
        ),
      );
      return;
    }
    commit();
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(appProvider);
    final ctrl = ref.read(appProvider.notifier);
    final item = widget.item;
    final meal = _meal(item.mealId);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            KitchenPhoto(img: meal?.img ?? '', icon: Icons.restaurant_rounded),
            const SizedBox(width: StSpace.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    StCatalogueText.meal(s, item.mealId),
                    style: const TextStyle(
                      fontSize: StFont.heading,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  StMoneyText.minor(item.priceMinor),
                ],
              ),
            ),
          ],
        ),
        if (meal != null) ...[
          const SizedBox(height: StSpace.sm),
          Text(s.t(meal.desc, meal.descBn)),
        ],
        const SizedBox(height: StSpace.sm),
        Text(
          s.tx(KitchenProfileText.portionNote),
          style: TextStyle(
            fontSize: StFont.caption,
            color: Theme.of(context).hintColor,
          ),
        ),
        const SizedBox(height: StSpace.sm),
        Row(
          children: [
            Expanded(child: Text(s.tx(KitchenProfileText.quantity))),
            StIconBtn(
              icon: Icons.remove_rounded,
              label: s.tx(KitchenProfileText.less),
              onTap: () {
                if (_qty > 1) setState(() => _qty--);
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: StSpace.sm),
              child: Semantics(
                liveRegion: true,
                child: Text(
                  s.digits('$_qty'),
                  key: const ValueKey('menu-qty'),
                  style: const TextStyle(
                    fontSize: StFont.bodyLg,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            StIconBtn(
              icon: Icons.add_rounded,
              label: s.tx(KitchenProfileText.more),
              onTap: () {
                if (_qty < _maxQty) setState(() => _qty++);
              },
            ),
          ],
        ),
        const SizedBox(height: StSpace.md),
        StBtn(
          key: ValueKey('add-${item.id}'),
          label: s.tx(KitchenProfileText.addToOrder),
          icon: Icons.add_shopping_cart_rounded,
          full: true,
          disabled: s.offline,
          reason: s.offline ? s.tx(KitchenProfileText.offlineOrder) : null,
          onTap: _add,
        ),
        const SizedBox(height: StSpace.xs),
        StBtn(
          label: s.tx(KitchenProfileText.close),
          variant: StBtnVariant.outline,
          full: true,
          onTap: ctrl.closeSheet,
        ),
      ],
    );
  }
}
