import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_item_provider.dart';
import '../providers/order_item_provider.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cartItemProvider = Provider.of<CartItemProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      'Rs. ${cartItemProvider.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .headline6!
                              .color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cartItemProvider: cartItemProvider),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cartItemProvider.itemCount,
              itemBuilder: (ctx, i) => CartItem(
                cartItemProvider.cartItems.values.toList()[i].id,
                cartItemProvider.cartItems.keys.toList()[i],
                cartItemProvider.cartItems.values.toList()[i].title,
                cartItemProvider.cartItems.values.toList()[i].price,
                cartItemProvider.cartItems.values.toList()[i].quantity,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cartItemProvider,
  }) : super(key: key);

  final CartItemProvider cartItemProvider;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: _isLoading ? Center(child: CircularProgressIndicator(),) : Text('Order Now'),
      onPressed: (widget.cartItemProvider.totalAmount <= 0 || _isLoading) ? null : () async {
        setState(() {
          _isLoading = true;
        });
        await Provider.of<OrderItemProvider>(context, listen: false)
            .addOrder(
          widget.cartItemProvider.cartItems.values.toList(),
          widget.cartItemProvider.totalAmount,
        );
        setState(() {
          _isLoading = false;
        });
        widget.cartItemProvider.clearCartItems();
      },
      style: TextButton.styleFrom(
          primary: Theme.of(context).primaryColor),
    );
  }
}
