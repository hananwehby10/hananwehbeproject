import 'package:flutter/material.dart';
import 'home_screen.dart';

class FavoriteScreen extends StatefulWidget {
  final List<Map<String, dynamic>> favorites;
  final Function(Map<String, dynamic>) onRemoveFavorite;

  const FavoriteScreen({
    required this.favorites,
    required this.onRemoveFavorite,
    super.key,
  });

  @override
  FavoriteScreenState createState() => FavoriteScreenState();
}

class FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: widget.favorites.isEmpty
          ? const Center(
        child: Text(
          'No favorite items yet.',
          style: TextStyle(fontSize: 20),
        ),
      )
          : ListView.builder(
        itemCount: widget.favorites.length,
        itemBuilder: (context, index) {
          final favoriteItem = widget.favorites[index];
          return ListTile(
            title: Text(favoriteItem['item_name'] ?? ''),
            subtitle: Text('\$${favoriteItem['item_price'] ?? ''}'),
            leading: Image.network(
              '${favoriteItem['item_image'] ?? ''}',
            ),
            trailing: IconButton(
              icon: const Icon(Icons.favorite),
              color: Colors.red,
              onPressed: () {
                // Call the onRemoveFavorite callback
                widget.onRemoveFavorite(favoriteItem);

                // Trigger a rebuild
                setState(() {});
              },
            ),
          );
        },
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          } else if (index == 1) {
            // Stay on Favorites screen
          } else if (index == 2) {
            // Add functionality for Cart tab
          }
        },
      ),
    );
  }
}
