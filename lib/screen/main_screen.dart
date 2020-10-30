import 'package:flutter/material.dart';

import '../widget/fab_bottom_appbar.dart';
import 'dashboard_screen.dart';
import 'history_screen.dart';
import 'information_screen.dart';
import 'profile_screen.dart';
import 'scanner_screen.dart';

class MainScreen extends StatefulWidget {
  static const route_name = '/mainScreen';
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 0;

  void _selectedTab(int index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          new Offstage(
            offstage: _index != 0,
            child: new TickerMode(
              enabled: _index == 0,
              child: new MaterialApp(home: DashboardScreen()),
            ),
          ),
          new Offstage(
            offstage: _index != 1,
            child: new TickerMode(
              enabled: _index == 1,
              child: new MaterialApp(home: HistoryScreen()),
            ),
          ),
          new Offstage(
            offstage: _index != 2,
            child: new TickerMode(
              enabled: _index == 2,
              child: new MaterialApp(home: InformationScreen()),
            ),
          ),
          new Offstage(
            offstage: _index != 3,
            child: new TickerMode(
              enabled: _index == 3,
              child: new MaterialApp(home: ProfileScreen()),
            ),
          ),
        ],
      ),
      extendBody: false,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[900],
        elevation: 0,
        onPressed: () {
          Navigator.of(context).pushNamed(ScannerScreen.route_name);
        },
        child: Icon(
          Icons.camera_alt,
          size: 30,
          color: Colors.grey[200],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: FABBottomAppBar(
        backgroundColor: Colors.blue[900],
        centerItemText: 'Scan',
        color: Colors.grey[400],
        selectedColor: Colors.white,
        notchedShape: CircularNotchedRectangle(),
        onTabSelected: _selectedTab,
        items: [
          FABBottomAppBarItem(iconData: Icons.home, text: 'Home'),
          FABBottomAppBarItem(iconData: Icons.list, text: 'History'),
          FABBottomAppBarItem(iconData: Icons.notifications, text: 'Message'),
          FABBottomAppBarItem(iconData: Icons.person, text: 'Profile'),
        ],
      ),
    );
  }
}
