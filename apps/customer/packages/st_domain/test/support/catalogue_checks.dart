import 'package:st_domain/st_domain.dart';

import 'command_catalogue.dart';
import 'repo_check.dart';

Actor _actor(StRole role) => Actor(role, id: 'demo-${role.name}');

/// Catalogue-driven checks (Properties 3, 12, 13, 14): role refusal before
/// any change, guest refusal, failure injection, idempotent commands.
List<RepoCheck> catalogueChecks() => [
      for (final entry in commandCatalogue)
        for (final m in entry.methods) ...[
          if (entry.gated)
            (
              name:
                  '${entry.repository}.${m.name}: a role outside the allowed set is refused before any change',
              run: () async {
                final allowed = m.roles ?? entry.allowedRoles;
                for (final role
                    in StRole.values.where((r) => !allowed.contains(r))) {
                  final repo = entry.create(MockBehavior.instant());
                  final before = await entry.observe(repo);
                  final r =
                      await m.call(repo, _actor(role), RequestId.next('cat'));
                  if (r.errorOrNull?.kind != RepoErrorKind.permissionDenied)
                    return false;
                  if (await entry.observe(repo) != before) return false;
                }
                return true;
              },
            ),
          if (entry.gated && entry.signedInOnly)
            (
              name: '${entry.repository}.${m.name}: a guest is refused',
              run: () async {
                final repo = entry.create(MockBehavior.instant());
                final role = (m.roles ?? entry.allowedRoles).first;
                final r =
                    await m.call(repo, Actor(role), RequestId.next('cat'));
                return r.errorOrNull?.kind == RepoErrorKind.permissionDenied;
              },
            ),
          (
            name:
                '${entry.repository}.${m.name}: an injected failure returns Err',
            run: () async {
              final b = MockBehavior.instant();
              final repo = entry.create(b);
              b.failNext(RepoErrorKind.temporarilyUnavailable);
              final r = await m.call(
                  repo,
                  _actor((m.roles ?? entry.allowedRoles).first),
                  RequestId.next('cat'));
              return r.errorOrNull?.kind ==
                  RepoErrorKind.temporarilyUnavailable;
            },
          ),
          if (m.isCommand)
            (
              name:
                  '${entry.repository}.${m.name}: a repeated request id returns the first outcome without a second change',
              run: () async {
                final repo = entry.create(MockBehavior.instant());
                final actor = _actor((m.roles ?? entry.allowedRoles).first);
                final id = RequestId.next('cat');
                final first = await m.call(repo, actor, id);
                final after1 = await entry.observe(repo);
                final second = await m.call(repo, actor, id);
                final after2 = await entry.observe(repo);
                return first == second && after1 == after2;
              },
            ),
        ],
    ];
