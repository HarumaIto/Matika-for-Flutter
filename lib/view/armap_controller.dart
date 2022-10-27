import 'package:flutter/material.dart';
import 'package:matika/view/armap_view.dart';

class ARMapController extends StatefulWidget {
  const ARMapController({super.key});

  @override
  State<ARMapController> createState() => _ARMapControllerState();
}

class _ARMapControllerState extends State<ARMapController> {
  int _pageIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const ARMapView(),
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
            icon: Icon(Icons.people),
            activeIcon: Icon(Icons.people_outline),
            label: 'ユーザー'
          ),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}