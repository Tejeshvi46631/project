import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseAnalyticsService {
  // Firebase Analytics instance
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // Optional: Provide an observer for navigation
  FirebaseAnalyticsObserver get analyticsObserver => FirebaseAnalyticsObserver(analytics: _analytics);

  /// Log app opened event
  Future<void> logAppOpened() async {
    await _analytics.logAppOpen();
    print("Add data to Firebase");
  }

  /// Logs a sign-up event.
  Future<void> logSignUp({
    Map<String, Object>? parameters,
  }) {

    return _analytics.logSignUp(
      signUpMethod: 'sign_up',
      parameters: parameters
    );
  }

  /// Log screen view
  Future<void> logScreenView({required String screenName, String? screenClass}) async {
    await _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass ?? screenName,
    );
  }

  /// Log product view
  Future<void> logViewItem({required String itemId, required String itemName, double? price, String? category}) async {
    /*await _analytics.logViewItem(
      itemId: itemId,
      itemName: itemName,
      currency: price,
      itemCategory: category,
    );*/
  }

  /// Log add to cart
  Future<void> logAddToCart({required String itemId, required String itemName, double? price, String? category}) async {
   /* await _analytics.logAddToCart(
      itemId: itemId,
      itemName: itemName,
      price: price,
      itemCategory: category,
    );*/
  }

  /// Log purchase
  Future<void> logPurchase({required String transactionId, required double value, String? currency, List<AnalyticsEventItem>? items}) async {
    await _analytics.logPurchase(
      transactionId: transactionId,
      value: value,
      currency: currency ?? 'USD',
      items: items,
    );
  }

  /// Log search
  Future<void> logSearch({required String searchTerm}) async {
    await _analytics.logSearch(searchTerm: searchTerm);
  }

  /*/// Log search View
  Future<void> logSearchView({String? searchTerm, Map<String, Object>? parameters}) async {
    await _analytics.logViewSearchResults(searchTerm: searchTerm!, parameters: parameters);
  }*/

  /// Log custom event
  Future<void> logCustomEvent({required String eventName, Map<String, Object>? parameters}) async {
    await _analytics.logEvent(name: eventName, parameters: parameters);
  }
}
