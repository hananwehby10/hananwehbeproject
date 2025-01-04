import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'favorite_screen.dart';
import 'cart_screen.dart';


class SingleItemScreen extends StatefulWidget {
  final Map<String, dynamic>? item;
  final List<Map<String, dynamic>> favorites;

  const SingleItemScreen({
    super.key,
    required this.item,
    required this.favorites,
  });

  @override
  SingleItemScreenState createState() => SingleItemScreenState();
}

class SingleItemScreenState extends State<SingleItemScreen> {
  bool isFavorite = false;
  int quantity = 1;
  List<Map<String, dynamic>> _cartItems = [];  // Example cart items

  @override
  void initState() {
    super.initState();
    isFavorite = widget.favorites.contains(widget.item);
  }

  @override
  Widget build(BuildContext context) {
    double itemPrice = double.tryParse(widget.item?['item_price'] ?? '') ?? 0.0;
    double totalPrice = itemPrice * quantity;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double scaleFactor = screenWidth / 375; // Reference width for scaling

    return Scaffold(
      backgroundColor: Colors.brown[200],
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.03, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.05),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                Center(
                  child: Image.network(
                    '${widget.item?['item_image'] ?? ''}',
                    width: screenWidth / 1.5,
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.05, right: screenWidth * 0.08),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "BEST COFFEE",
                        style: TextStyle(
                          color: Color(0xFF651E17),
                          letterSpacing: 2 * scaleFactor,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        widget.item?['item_name'] ?? 'Item Name Not Available',
                        style: TextStyle(
                          fontSize: 22 * scaleFactor,
                          letterSpacing: 1 * scaleFactor,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: screenWidth,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.all(screenWidth * 0.03),
                              width: screenWidth * 0.25,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (quantity > 1) {
                                          quantity--;
                                        }
                                      });
                                    },
                                    child: Icon(
                                      CupertinoIcons.minus,
                                      size: 16 * scaleFactor,
                                      color: Color(0xFF651E17),
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * 0.03),
                                  Text(
                                    quantity.toString(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16 * scaleFactor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * 0.03),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        quantity++;
                                      });
                                    },
                                    child: Icon(
                                      CupertinoIcons.plus,
                                      size: 16 * scaleFactor,
                                      color: Color(0xFF651E17),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              "\$ ${totalPrice.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 18 * scaleFactor,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF651E17),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        widget.item?['item_description'] ?? 'Description Not Available',
                        style: TextStyle(
                          fontSize: 16 * scaleFactor,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      GestureDetector(
                        onTap: () {
                          // Handle adding to cart
                          setState(() {
                            _cartItems.add({
                              'item': widget.item!,
                              'quantity': quantity,
                              'totalPrice': totalPrice,
                            });  // Add item to cart
                          });
                        },
                        child: Container(
                          width: screenWidth,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.02,
                                  horizontal: screenWidth * 0.08,
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xFF651E17),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Text(
                                  "Add to Cart",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18 * scaleFactor,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isFavorite = !isFavorite;

                                    if (isFavorite) {
                                      widget.favorites.add(widget.item!);
                                    } else {
                                      widget.favorites.remove(widget.item);
                                    }
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(screenWidth * 0.04),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF651E17),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Icon(
                                    isFavorite ? Icons.favorite : Icons.favorite_outline,
                                    color: Colors.white,
                                    size: 24 * scaleFactor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            // Handle Home tab (optional, since this is the current screen)
          } else if (index == 1) {
            // Navigate to Favorites screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FavoriteScreen(
                  favorites: widget.favorites,
                  onRemoveFavorite: (item) {
                    setState(() {
                      widget.favorites.remove(item);
                    });
                  },
                ),
              ),
            );
          } else if (index == 2) {
            // Navigate to Cart screen and pass cart items
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CartScreen(
                  cartItems: _cartItems,
                  onRemoveFromCart: (item) {
                    setState(() {
                      _cartItems.remove(item);
                    });
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
