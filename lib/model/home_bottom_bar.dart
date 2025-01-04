import 'package:flutter/material.dart';


class HomeBottomBar extends StatelessWidget {
  final VoidCallback onFavoritePressed;
  final VoidCallback onCartPressed;

  const HomeBottomBar({
    required this.onFavoritePressed,
    required this.onCartPressed,
     super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            spreadRadius: 1,
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.home, color: Color(0xFF651E17), size: 35),
          IconButton(
            onPressed: onFavoritePressed,
            icon: Icon(Icons.favorite_outline, color: Colors.grey, size: 35),
          ),
          IconButton(
            onPressed: onCartPressed,
            icon: Icon(Icons.shopping_cart, color: Colors.grey, size: 35),
          ),
        ],
      ),
    );
  }
}
