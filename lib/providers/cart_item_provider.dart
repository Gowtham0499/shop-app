import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';

class CartItemProvider with ChangeNotifier {
  Map<String, CartItem> _cartItems = {};

  Map<String, CartItem> get cartItems {
    return {..._cartItems};
  }

  int get itemCount {
    return _cartItems.length;
  }

  double get totalAmount {
    var total = 0.0;
    _cartItems.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
     });
    return total;
  }

  void addCartItem(
    String productId,
    double price,
    String title,
  ) {
    if (_cartItems.containsKey(productId)) {
      _cartItems.update(
          productId,
          (existingProduct) => CartItem(
                id: existingProduct.id,
                title: existingProduct.title,
                quantity: existingProduct.quantity + 1,
                price: existingProduct.price,
              ));
    } else {
      _cartItems.putIfAbsent(
          productId,
          () => CartItem(
                id: DateTime.now().toString(),
                title: title,
                quantity: 1,
                price: price,
              ));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _cartItems.remove(productId);
    notifyListeners();
  }

  void clearCartItems() {
    _cartItems = {};
    notifyListeners();
  }
}
