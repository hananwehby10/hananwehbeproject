import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'items_widget.dart';
import 'single_item_screen.dart';
import 'favorite_screen.dart';
import 'cart_screen.dart';

const String _baseURL = 'http://hananmobile.atwebpages.com';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Map<String, dynamic>> _categories = [];
  final List<Map<String, dynamic>> _items = [];
  final List<Map<String, dynamic>> _favorites = [];
  final List<Map<String, dynamic>> _cartItems = [];
  bool _isLoading = true;
  bool _categoriesLoaded = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _searchController.addListener(() {
      _updateItems(_tabController.index + 1);
    });
  }

  void _addToCart(Map<String,dynamic> item){
    setState(() {
      _cartItems.add(item);
    });
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      _updateItems(_tabController.index + 1);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[200],
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 15),
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : _categoriesLoaded
              ? _buildContent()
              : Center(child: CircularProgressIndicator()),
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
                  favorites: _favorites,
                  onRemoveFavorite: (item) {
                    setState(() {
                      _favorites.remove(item);
                    });
                  },
                ),
              ),
            );
          } else if (index == 2) {
            // Navigate to Cart screen and pass favorites (or actual cart items)
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CartScreen(
                  cartItems:_cartItems,  // Replace with actual cart items if necessary
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

  Widget _buildContent() {
    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {},
                child: Icon(
                  Icons.sort_rounded,
                  color: Colors.white.withAlpha(128),
                  size: 35,
                ),
              ),
              // Removed the cart icon from the body since it's in the bottom navigation
            ],
          ),
        ),
        const SizedBox(height: 30),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: const Text(
            "It's a Great Day for Coffee",
            style: TextStyle(
              color: Color(0xFF651E17),
              fontSize: 30,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          width: MediaQuery.of(context).size.width,
          height: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextFormField(
            controller: _searchController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Find your coffee",
              hintStyle: TextStyle(
                color: Colors.black.withAlpha(128),
              ),
              prefixIcon: Icon(
                Icons.search,
                size: 30,
                color: Colors.black.withAlpha(128),
              ),
            ),
          ),
        ),
        TabBar(
          controller: _tabController,
          labelColor: Color(0xFF651E17),
          unselectedLabelColor: Colors.white.withAlpha(128),
          isScrollable: true,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(
              width: 3,
              color: Color(0xFF651E17),
            ),
            insets: EdgeInsets.symmetric(horizontal: 16),
          ),
          labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          labelPadding: EdgeInsets.symmetric(horizontal: 20),
          tabs: _categories.map((category) {
            return Tab(text: category['name'].toString());
          }).toList(),
        ),
        SizedBox(height: 10),
        Center(
          child: ItemsWidget(
            key: Key(_tabController.index.toString()),
            catId: _tabController.index + 1,
            items: _items,
            updateItems: _updateItems,
            onItemSelected: _handleItemSelected,
            onAddToCart: _addToCart,
          ),
        ),
      ],
    );
  }

  void _handleItemSelected(Map<String, dynamic> selectedItem) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SingleItemScreen(item: selectedItem, favorites: _favorites),
      ),
    );
  }

  void _fetchCategories() async {
    try {
      final url = Uri.parse('$_baseURL/getCategory.php');
      final response = await http.get(url).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final jsonResponse = convert.jsonDecode(response.body);
        final List<Map<String, dynamic>> categories = List.from(jsonResponse);

        setState(() {
          _categories.clear();
          _categories.addAll(categories);

          _tabController = TabController(length: _categories.length, vsync: this, initialIndex: 0);
          _tabController.addListener(_handleTabSelection);

          _categoriesLoaded = true;
          _isLoading = false;
          _updateItems(1);
        });
      } else {
        _handleFetchError();
      }
    } catch (e) {
      _handleFetchError();
    }
  }

  void _updateItems(int categoryId) {
    String searchQuery = _searchController.text.toLowerCase();

    List<Map<String, dynamic>> filteredItems = _items.where((item) {
      return item['item_name'].toLowerCase().contains(searchQuery);
    }).toList();

    setState(() {
      _items.clear();
      _items.addAll(filteredItems);
    });
  }

  void _handleFetchError() {
    setState(() {
      _isLoading = false;
    });
  }
}
