import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavigation({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (int index) {

        onTap(index);

        if (index == 0) {
          Navigator.pushNamed(context, '/main');
        } else if (index == 1) {
          Navigator.pushNamed(context, '/homepage');
        } else if (index == 2) {
          Navigator.pushNamed(context, '/calendar');
        }
      },
      selectedItemColor: Colors.deepPurple,
      unselectedItemColor: Colors.black,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',

        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'Tasks',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Calendar',
        ),

      ],
    );
  }
}
