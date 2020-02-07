import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:trip_trip/history_screen.dart';
import 'package:trip_trip/travel_assistant.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() {
    return _MainScreenState();
  }
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  List<Widget> _tabs = <Widget>[
    Asistant(),
    History(),
    Container(),
    Container(),
    Container(),
  ];
  final PageStorageBucket bucket = PageStorageBucket();
  List<String> _tabNames = <String>[
    'Assistant',
    'My tour',
    'Explore',
    'Notifications',
    'Setting'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _tabNames[_selectedIndex],
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: PageStorage(
        bucket: bucket,
        child: IndexedStack(
          children: _tabs,
          index: _selectedIndex,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.assistant_photo),
            title: Text(_tabNames[0]),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            title: Text(_tabNames[1]),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            title: Text(_tabNames[2]),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            title: Text(
              _tabNames[3],
              style: TextStyle(fontSize: 11),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text(_tabNames[4]),
          ),
        ],
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        onTap: (value) => setState(() => _selectedIndex = value),
      ),
    );
  }
}
