import 'subscription_plan.dart';

class AppGlobal {
  SubscriptionPlan plan;

  static late AppGlobal _instance;

  static AppGlobal get instance => _instance;

  factory AppGlobal({SubscriptionPlan plan = SubscriptionPlan.free}) {
    _instance = AppGlobal._internal(plan);

    return _instance;
  }

  AppGlobal._internal(this.plan);

  void setPlan(SubscriptionPlan planParam) => plan = planParam;
  bool get isPremium => plan != SubscriptionPlan.free;
}
