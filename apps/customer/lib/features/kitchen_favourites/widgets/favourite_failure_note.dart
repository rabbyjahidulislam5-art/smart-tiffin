import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_shell/st_shell.dart';

import '../controllers/kitchen_favourites_providers.dart';
import '../screens/kitchen_favourites_text.dart';

/// Inline error of the last failed favourite change; the heart has already
/// reverted to the confirmed value.
class FavouriteFailureNote extends ConsumerWidget {
  const FavouriteFailureNote({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kind = ref.watch(favouriteFailureProvider);
    if (kind == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: StSpace.sm),
      child: StCommandError(
        name: KitchenFavouritesText.commandName,
        kind: kind,
      ),
    );
  }
}
