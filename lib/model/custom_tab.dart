import 'package:flutter/material.dart';

class CustomTabBar extends StatelessWidget {
  final List<Map<String, dynamic>> categories;
  final TabController tabController;

  const CustomTabBar({
    required this.categories,
    required this.tabController,
    super.key,  // Use super.key for the key parameter
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),  // Added vertical space before TabBar
        Container(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  tabController.animateTo(index);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: tabController.index == index
                            ? Color(0xFF651E17)
                            : Colors.transparent,
                        width: 3,
                      ),
                    ),
                  ),
                  child: Text(
                    categories[index]['name'].toString(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: tabController.index == index
                          ? Color(0xFF651E17)
                          : Colors.white.withAlpha(128),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        SizedBox(height: 10),  // Optional additional spacing after TabBar
      ],
    );
  }
}
