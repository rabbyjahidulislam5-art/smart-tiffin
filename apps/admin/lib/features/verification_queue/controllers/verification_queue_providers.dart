import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

/// NA-03 status filter (null = all).
final applicationFilterProvider = StateProvider.autoDispose<ApplicationStatus?>(
  (ref) => ApplicationStatus.pending,
);

/// NA-03 queue for the filter.
final applicationQueueProvider =
    FutureProvider.autoDispose<List<ApplicationCase>>((ref) {
      final status = ref.watch(applicationFilterProvider);
      return stUnwrap(
        ref
            .watch(applicationReviewRepositoryProvider)
            .queue(ref.watch(actorProvider), status: status),
      );
    });

/// NA-03 selected application id.
final selectedApplicationProvider = StateProvider.autoDispose<String?>(
  (ref) => null,
);

/// NA-03 checklist edits per application. Not auto-disposed, so the state
/// survives navigating away and back (APPROVAL_WORKFLOWS.md acceptance).
final checklistDraftProvider = StateProvider.family<Map<String, bool>, String>(
  (ref, id) => const {},
);
