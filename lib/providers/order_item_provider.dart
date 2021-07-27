import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../models/order_item.dart';
import '../models/cart_item.dart';

class OrderItemProvider with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse(
        'https://shop-app-29df4-default-rtdb.asia-southeast1.firebasedatabase.app/orders.json');
    final response = await http.get(url);
    final List<OrderItem> orderedItems = [];
    final resposeBody = json.decode(response.body);
    // print(resposeBody);
    if (resposeBody == null) {
      return;
    }
    resposeBody.forEach((orderId, orderData) {
      orderedItems.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          orderedDateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map(
                (cartItem) => CartItem(
                  id: cartItem['id'],
                  title: cartItem['title'],
                  quantity: cartItem['quantity'],
                  price: cartItem['price'],
                ),
              )
              .toList(),
        ),
      );
    });
    _orders = orderedItems.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse(
        'https://shop-app-29df4-default-rtdb.asia-southeast1.firebasedatabase.app/orders.json');
    final timestamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': cartProducts
              .map((cartProduct) => {
                    'id': cartProduct.id,
                    'title': cartProduct.title,
                    'quantity': cartProduct.quantity,
                    'price': cartProduct.price,
                  })
              .toList(),
        }));
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        orderedDateTime: timestamp,
        products: cartProducts,
      ),
    );
    notifyListeners();
  }
}
