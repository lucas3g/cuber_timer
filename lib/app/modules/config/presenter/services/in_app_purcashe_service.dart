abstract class IInAppPurchaseService {
  Future<bool> buyAdRemoval();
  Future<bool> checkAdRemovalStatus();
}
