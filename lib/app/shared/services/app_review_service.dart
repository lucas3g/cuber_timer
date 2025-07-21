import 'package:in_app_review/in_app_review.dart';
import 'package:injectable/injectable.dart';

import '../../core/data/clients/shared_preferences/adapters/shared_params.dart';
import '../../core/data/clients/shared_preferences/local_storage_interface.dart';
import '../../core/domain/entities/storage_keys.dart';

abstract class IAppReviewService {
  Future<void> askReviewApp();
  Future<bool> isRewardActive();
}

@Injectable(as: IAppReviewService)
class AppReviewService implements IAppReviewService {
  static const String _counterKey = 'REVIEW_COUNTER';
  static const String _rewardExpirationKey =
      StorageKeys.adFreeExpiration;

  final ILocalStorage localStorage;
  final InAppReview _inAppReview = InAppReview.instance;

  AppReviewService(this.localStorage);

  @override
  Future<void> askReviewApp() async {
    final current = await localStorage.getData(_counterKey) as int? ?? 0;
    final newCount = current + 1;

    if (newCount > 10) {
      return; // Do not ask for review if the count exceeds 10
    }

    await localStorage.setData(
      params: SharedParams(key: _counterKey, value: newCount),
    );

    if (newCount % 3 == 0) {
      if (await _inAppReview.isAvailable()) {
        await _inAppReview.requestReview();
      } else {
        await _inAppReview.openStoreListing();
      }

      final expiration =
          DateTime.now().add(const Duration(days: 7)).millisecondsSinceEpoch;

      await localStorage.setData(
        params: SharedParams(
          key: _rewardExpirationKey,
          value: expiration,
        ),
      );
    }
  }

  @override
  Future<bool> isRewardActive() async {
    final timestamp = await localStorage.getData(_rewardExpirationKey) as int?;
    if (timestamp == null) return false;
    final expiration = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return expiration.isAfter(DateTime.now());
  }
}
