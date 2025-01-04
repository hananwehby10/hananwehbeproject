import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final Function(Map<String, dynamic>) onRemoveFromCart;

  const CartScreen({
    super.key,
    required this.cartItems,
    required this.onRemoveFromCart,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    bool isCartEmpty = widget.cartItems.isEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: isCartEmpty
          ? const Center(
        child: Text(
          'Your cart is empty.',
          style: TextStyle(fontSize: 20),
        ),
      )
          : ListView.builder(
        itemCount: widget.cartItems.length,
        itemBuilder: (context, index) {
          final cartItem = widget.cartItems[index];
          final itemName = cartItem['item']['item_name'] ?? 'Unknown Item';
          final itemImage = cartItem['item']['item_image'] ?? '';
          final itemPrice = cartItem['item']['item_price'] ?? 0.0;
          final quantity = cartItem['quantity'] ?? 1;
          final totalPrice = cartItem['totalPrice'] ?? 0.0;

          return ListTile(
            title: Text(itemName),
            subtitle: Text('Quantity: $quantity\nTotal: \$${totalPrice.toStringAsFixed(2)}'),
            leading: itemImage.isNotEmpty
                ? Image.network(itemImage)
                : null,
            trailing: IconButton(
              icon: const Icon(Icons.remove_shopping_cart),
              color: Colors.red,
              onPressed: () {
                widget.onRemoveFromCart(cartItem);
                setState(() {});
              },
            ),
          );
        },
      ),
      bottomNavigationBar: isCartEmpty
          ? null // Hide the BottomAppBar when cart is empty
          : BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Proceeding to checkout')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                  ),
                  child: const Text('Checkout'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
