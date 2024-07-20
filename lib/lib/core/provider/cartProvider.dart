import 'package:egrocer/core/constant/apiAndParams.dart';
import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/model/cartData.dart';
import 'package:egrocer/core/webservices/cartApi.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum CartState {
  initial,
  loading,
  loaded,
  error,
}

class CartProvider extends ChangeNotifier {
  CartState cartState = CartState.initial;
  String message = '';
  late CartData cartData; // Initialize as late

  late double subTotal = 0.0;
  bool isOneOrMoreItemsOutOfStock = false;
  CartProvider() {
    cartData = CartData(
      status: '',
      message: '',
      total: '',
      data: Data(subTotal: '', cart: []),
    );
  }

  double? _discountedAmount;

  double? get discountedAmount => _discountedAmount;

  set discountedAmount(double? value) {
    _discountedAmount = value;
    print('discountedAmount set to: $_discountedAmount');
    notifyListeners();
  }

  Future<void> getCartListProvider({required BuildContext context}) async {
    cartState = CartState.loading;
    notifyListeners();

    try {
      Map<String, String> params = await Constant.getProductsDefaultParams();
      Map<String, dynamic> getData =
      await getCartListApi(context: context, params: params);

      if (getData[ApiAndParams.status].toString() == "1") {
        cartData = CartData.fromJson(getData);
        subTotal = double.parse(cartData.data.subTotal);
        await checkCartItemsStockStatus();
        cartState = CartState.loaded;
        Constant.deliveryAmount = cartData.data.cart
            .map((e) => e.productId)
            .toSet()
            .toList()
            .getDeliveryCharges();

        notifyListeners();
      } else {
        cartState = CartState.error;
        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      GeneralMethods.showSnackBarMsg(context, message);
      cartState = CartState.error;
      notifyListeners();
    }
  }

  Future setSubTotal(double newSubtotal) async {
    subTotal = newSubtotal;
    notifyListeners();
  }
// Inside CartProvider class
  double calculateDiscountedAmount(CartData cartData) {
    double totalDiscount = 0.0;
    double price = 0.0;

    // Print the cart data to inspect its contents
    print("Cart Data: ${cartData.data.cart}");

    // Check if the cart has any items
    if (cartData.data.cart.isEmpty) {
      print("Cart is empty.");
      return totalDiscount;
    } else {
      print("Cart contains ${cartData.data.cart.length} items.");
    }

    cartData.data.cart.forEach((cartItem) {
      price = double.tryParse(cartItem.price) ?? 0.0;
      double discountedPrice = double.tryParse(cartItem.discountedPrice) ?? 0.0;
      double qty = double.tryParse(cartItem.qty) ?? 0.0;
      double disc = price - discountedPrice;
      totalDiscount += disc * qty;

      print("CartItem: $cartItem, Price: $price, DiscountedPrice: $discountedPrice, Qty: $qty, Discount: $disc, Total Discount: $totalDiscount");
    });
    if (Constant.isPromoCodeApplied) {
      discountedAmount == 50; // Adding the fixed discount amount
    }
    print(Constant.isPromoCodeApplied);
    discountedAmount = totalDiscount - 50;
    print("DICOUNTEDL:$discountedAmount");
    print("PRICE:  $price");
    print("Total Discount Price: $totalDiscount");
    return totalDiscount;
  }


  Future removeItemFromCartList(
      {required int productId, required int variantId}) async {
    for (int i = 0; i < cartData.data.cart.length; i++) {
      Cart cartItem = cartData.data.cart[i];
      if (cartItem.productId == productId &&
          cartItem.productVariantId == variantId) {
        cartData.data.cart.remove(cartItem);
        Constant.deliveryAmount = cartData.data.cart
            .map((e) => e.productId)
            .toSet()
            .toList()
            .getDeliveryCharges();
        notifyListeners();
      }
    }
  }

  Future checkCartItemsStockStatus() async {
    isOneOrMoreItemsOutOfStock = false;
    for (int i = 0; i < cartData.data.cart.length; i++) {
      if (cartData.data.cart[i].status == 0) {
        isOneOrMoreItemsOutOfStock = true;
      }
    }
  }


}