import 'package:in_app_review/in_app_review.dart';
import 'package:injectable/injectable.dart';

import '../../core/data/clients/shared_preferences/adapters/shared_params.dart';
import '../../core/data/clients/shared_preferences/local_storage_interface.dart';

abstract class IAppReviewService {
  Future<void> registerBeatRecord();
}

@Injectable(as: IAppReviewService)
class AppReviewService implements IAppReviewService {
  static const String _counterKey = 'REVIEW_COUNTER';

  final ILocalStorage localStorage;
  final InAppReview _inAppReview;

  AppReviewService(this.localStorage, [InAppReview? inAppReview])
      : _inAppReview = inAppReview ?? InAppReview.instance;

  @override
  Future<void> registerBeatRecord() async {
    final current = await localStorage.getData(_counterKey) as int? ?? 0;
    final newCount = current + 1;

    await localStorage.setData(
      params: SharedParams(key: _counterKey, value: newCount),
    );

    if (newCount % 3 == 0) {
      if (await _inAppReview.isAvailable()) {
        await _inAppReview.requestReview();
      } else {
        await _inAppReview.openStoreListing();
      }
    }
  }
}
