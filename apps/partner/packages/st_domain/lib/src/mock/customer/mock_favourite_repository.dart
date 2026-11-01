import '../../access/actor.dart';
import '../../access/st_role.dart';
import '../../repositories/customer/favourite_repository.dart';
import '../../result/repo_error.dart';
import '../../result/repo_result.dart';
import '../../result/request_id.dart';
import '../mock_behavior.dart';
import '../mock_repository_base.dart';
import 'customer_fixtures.dart';

/// Favourites never change a kitchen's public rating.
class MockFavouriteRepository extends MockRepositoryBase implements FavouriteRepository {
  MockFavouriteRepository({MockBehavior? behavior}) : super(behavior);

  static const roles = {StRole.customer};

  final Set<String> _favourites = {'rinas-kitchen'};

  @override
  Future<RepoResult<Set<String>>> favourites(Actor actor) => guardRead(actor, roles, 'favourites', () => Ok(Set.unmodifiable(_favourites)));

  @override
  Future<RepoResult<Set<String>>> setFavourite(Actor actor, RequestId requestId, {required String kitchenId, required bool favourite}) =>
      guardCommand(actor, roles, 'setFavourite', requestId, () {
        if (!publishedKitchens.any((k) => k.id == kitchenId)) return MockRepositoryBase.fail(RepoErrorKind.notAvailable);
        if (favourite) {
          _favourites.add(kitchenId);
        } else {
          _favourites.remove(kitchenId);
        }
        return Ok(Set.unmodifiable(_favourites));
      });
}
