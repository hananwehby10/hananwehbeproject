import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'single_item_screen.dart';


const String _baseURL = 'http://hananmobile.atwebpages.com';

class ItemsWidget extends StatefulWidget {
  final int catId;
  final List<Map<String, dynamic>> items;
  final Function(int) updateItems;
  final Function(Map<String, dynamic>) onItemSelected;
  final Function(Map<String, dynamic>) onAddToCart;

  const ItemsWidget({
    super.key,
    required this.catId,
    required this.items,
    required this.updateItems,
    required this.onItemSelected,
    required this.onAddToCart,
  });

  @override
  ItemsWidgetState createState() => ItemsWidgetState();
}

class ItemsWidgetState extends State<ItemsWidget> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : LayoutBuilder(
      builder: (context, constraints) {
        // Determine number of columns based on screen width
        int crossAxisCount = 2;
        double aspectRatio = 145 / 220;

        if (constraints.maxWidth > 600) {
          // For larger screens (e.g., tablets), use 3 columns
          crossAxisCount = 3;
          aspectRatio = 1.0;
        }

        return GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: aspectRatio,
          ),
          itemBuilder: (context, index) {
            final item = widget.items[index];
            return HoverableItem(
              item: item,
              onItemSelected: widget.onItemSelected,
              onAddToCart: widget.onAddToCart,
            );
          },
        );
      },
    );
  }

  void _fetchData() async {
    try {
      final url = Uri.parse('$_baseURL/getItems.php?cat_id=${widget.catId}');
      final response = await http.get(url).timeout(const Duration(seconds: 5));

      widget.items.clear();

      if (response.statusCode == 200) {
        final jsonResponse = convert.jsonDecode(response.body);

        for (var row in jsonResponse) {
          widget.items.add({
            'item_id': row['item_id'],
            'item_name': row['item_name'],
            'item_price': row['price'],
            'item_description': row['description'],
            'item_image': '$_baseURL/images/getImage.php?item_id=${row['item_id']}',
          });
        }

        setState(() {
          _isLoading = false;
        });

        widget.updateItems(widget.catId);
      } else {
        _handleFetchError();
      }
    } catch (e) {
      _handleFetchError();
    }
  }


  void _handleFetchError() {
    setState(() {
      _isLoading = false;
    });
  }
}

class HoverableItem extends StatefulWidget {
  final Map<String, dynamic> item;
  final Function(Map<String, dynamic>) onItemSelected;
  final Function(Map<String, dynamic>) onAddToCart;

  const HoverableItem({
     super.key,
    required this.item,
    required this.onItemSelected,
    required this.onAddToCart,
  });
  @override
  HoverableItemState createState() => HoverableItemState();
}

class HoverableItemState extends State<HoverableItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          isHovered = false;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 13),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(127),
              spreadRadius: 1,
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                widget.onItemSelected(widget.item);
              },
              child: Container(
                margin: EdgeInsets.all(10),
                child: Image.network(
                  '${widget.item['item_image']}',
                  width: 120,
                  height: 120,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item['item_name'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF651E17),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      widget.item['item_description'] ?? 'No description available',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF651E17),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "\$${widget.item['item_price']}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF651E17),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.onItemSelected(widget.item);
                      // Navigate to SingleItemScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SingleItemScreen(
                            item: widget.item,
                            favorites: [],  // Pass the favorites list here if needed
                          ),
                        ),
                      );
                    },
                    child: AnimatedScale(
                      duration: Duration(milliseconds: 200),
                      scale: isHovered ? 1.2 : 1.0,
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.add,
                          size: 20,
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
