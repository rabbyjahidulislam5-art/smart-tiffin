import '../../access/actor.dart';
import '../../models/finance/journal.dart';
import '../../models/finance/period.dart';
import '../../result/repo_result.dart';
import '../../result/request_id.dart';
import '../../result/st_page.dart';

/// General ledger and period close (NF-11, NF-12), accounting only.
abstract interface class LedgerRepository {
  Future<RepoResult<StPage<Journal>>> journals(Actor actor, {String? account, String? cursor});

  Future<RepoResult<Journal>> reverseJournal(Actor actor, RequestId requestId, {required String journalId, required String reason});

  Future<RepoResult<List<Period>>> periods(Actor actor);

  Future<RepoResult<Period>> closePeriod(Actor actor, RequestId requestId, {required String periodId});

  Future<RepoResult<Period>> reopenPeriod(Actor actor, RequestId requestId, {required String periodId, required String reason});
}
