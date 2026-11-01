import '../../access/actor.dart';
import '../../result/repo_result.dart';
import '../../result/request_id.dart';

/// Favourite kitchens of the signed-in customer (NC-18).
abstract interface class FavouriteRepository {
  Future<RepoResult<Set<String>>> favourites(Actor actor);

  Future<RepoResult<Set<String>>> setFavourite(Actor actor, RequestId requestId, {required String kitchenId, required bool favourite});
}
