import 'package:flutter/material.dart';
import 'package:matika/view/armap_page.dart';
import 'package:matika/view/reservation_page.dart';
import 'package:matika/view/user_page.dart';

class ARMapController extends StatefulWidget {
  const ARMapController({super.key});

  @override
  State<ARMapController> createState() => _ARMapControllerState();
}

class _ARMapControllerState extends State<ARMapController> {
  int _pageIndex = 0;

  final _pages = [
    const ARMapPage(),
    const ReservationPage(),
    const UserPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _pageIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            activeIcon: Icon(Icons.map_outlined),
            label: 'ARマップ'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_calendar),
            activeIcon: Icon(Icons.edit_calendar_outlined),
            label: '予約'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            activeIcon: Icon(Icons.person_outline),
            label: 'マイページ'
          )
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}