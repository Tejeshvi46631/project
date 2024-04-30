import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FacebookAnalytics {
  static FacebookAppEvents? facebookAppEvents;
  static void initFbAppEvents() {
    facebookAppEvents ??= FacebookAppEvents();
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        facebookAppEvents?.setUserID(FirebaseAuth.instance.currentUser!.uid);
        facebookAppEvents?.setUserData(
            phone: FirebaseAuth.instance.currentUser?.phoneNumber,
            firstName: FirebaseAuth.instance.currentUser?.displayName);
      }
    } catch (e) {}
  }

  static void viewContent(
      {required String id, String? type, Map<String, dynamic>? content}) {
    facebookAppEvents?.logViewContent(id: id, type: type, content: content);
  }

  static void addToWishlist(
      {required String id,
      required String type,
      required String currency,
      required double price,
      Map<String, dynamic>? content}) {
    facebookAppEvents?.logAddToWishlist(
        id: id, type: type, currency: currency, price: price, content: content);
  }

  static void addToCart(
      {required String id,
      required String type,
      required String currency,
      required double price,
      Map<String, dynamic>? content}) {
    facebookAppEvents?.logAddToCart(
        id: id, type: type, currency: currency, price: price, content: content);
  }

  static void initiateCheckout(
      {required double totalPrice,
      String? currency,
      int? numItems,
      String? contentType,
      String? contentId}) {
    facebookAppEvents?.logInitiatedCheckout(
        totalPrice: totalPrice,
        currency: currency,
        numItems: numItems,
        contentId: contentId,
        contentType: contentType);
  }

  static void purchaseSuccess(
      {required double amount,
      required String currency,
      Map<String, dynamic>? parameters}) {
    facebookAppEvents?.logPurchase(
        amount: amount, currency: currency, parameters: parameters);
  }

  static void logout() {
    facebookAppEvents?.clearUserID();
    facebookAppEvents?.clearUserData();
  }

  static void pushNotificationOpen(Map<String, dynamic> payload) {
    facebookAppEvents?.logPushNotificationOpen(payload: payload);
  }

  static void rated() {
    facebookAppEvents?.logRated();
  }

  static void completedRegistration() {
    facebookAppEvents?.logCompletedRegistration(registrationMethod: 'phone');
  }

  static void customEvent(
      {required String name, Map<String, dynamic>? parameters}) {
    facebookAppEvents?.logEvent(name: name, parameters: parameters);
  }
}
