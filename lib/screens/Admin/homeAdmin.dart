import 'package:flutter/material.dart';
import 'package:forestapp/screens/Admin/ForestDataScreen.dart';
import 'package:forestapp/screens/Admin/UserScreen.dart';

import '../../widgets/exit_popup.dart';
import 'HomeScreen.dart';
import 'MapScreen.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({Key? key}) : super(key: key);

  @override
  _HomeAdminState createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  int _selectedIndex = 0;

  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();

    _widgetOptions = <Widget>[
      HomeScreen(
        changeScreen: _changeIndex
      ),
      UserScreen(
        changeIndex: _changeIndex,
      ),
      ForestDataScreen(
        changeScreen: _changeIndex,
      ),
      MapScreen(
        latitude: 37.4220,
        longitude: -122.0841,
      ),
    ];
  }

  void _changeIndex( int index ) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showExitPopup(context),
      child: Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.black,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_sharp),
              label: 'Guard',
              backgroundColor: Colors.black,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.eco),
              label: 'Forest Data',
              backgroundColor: Colors.black,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'Maps',
              backgroundColor: Colors.black,
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.green,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

