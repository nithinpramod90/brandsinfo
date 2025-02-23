import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CustomBottomNavBar extends StatefulWidget {
  final Function(int) onTap;
  final int currentIndex;

  const CustomBottomNavBar({
    super.key,
    required this.onTap,
    required this.currentIndex,
  });

  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
      onTap: widget.onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.chart_bar),
          label: 'Analytics',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.briefcase),
          label: 'Business',
        ),
      ],
    );
  }
}
