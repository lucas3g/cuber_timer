import 'dart:async';

abstract class IInAppPurchaseService {
  Future<void> buyAdRemoval();

  Stream<String> get purchaseStatusStream;
}
