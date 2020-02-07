import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:trip_trip/manager/constant.dart';
import 'dart:convert' as convert;
import 'manager/my_api_client.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() {
    return _MainScreenState();
  }
}

class Tour {
  int id;
  int status;
  String name;
  String minCost;
  String maxCost;
  String startDate;
  String endDate;
  int adults;
  int childs;
  bool isPrivate;
  String avatar;
  Tour.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        status = json['status'],
        name = json['name'],
        minCost = json['minCost'],
        maxCost = json['maxCost'],
        startDate = json['startDate'],
        endDate = json['endDate'],
        adults = json['adults'],
        childs = json['childs'],
        isPrivate = json['isPrivate'],
        avatar = json['avatar'];
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  List<Widget> _tabs = <Widget>[
    Asistant(),
    Text(
      'Index 0: Home',
    ),
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

class Asistant extends StatefulWidget {
  Asistant({Key key}) : super(key: key);

  @override
  _AsistantState createState() => _AsistantState();
}

List<Tour> _tourList = [];

class _AsistantState extends State<Asistant> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    var response = await MyAPIClient.client.get(Constant.get_tour_list_url,
        headers: {'Authorization': MyAPIClient.accessToken});
    var jsonResponse = convert.jsonDecode(response.body);
    // var total = jsonResponse['total'];
    // var count = int.parse(total);
    var list = jsonResponse['tours'];
    for (int i = 0; i < 10; i++) {
      var tour = Tour.fromJson(list[i]);
      print(list[i]);
      setState(() {
        _tourList.add(tour);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        key: PageStorageKey('Assistant'),
        itemCount: _tourList.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image(
                    image: NetworkImage(_tourList[index].avatar == null
                        ? 'https://dulichviet.com.vn/images/bandidau/images/CH%C3%82U%20%C3%81/Indonesia/Indonesia%202017/du-lich-indonesia-den-tanah-lot-dao-bali_du-lich-viet.jpg'
                        : _tourList[index].avatar),
                    fit: BoxFit.cover,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.location_on,
                      color: Colors.pink,
                    ),
                    title: Text(
                      _tourList[index].name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.calendar_today,
                      color: Colors.pink,
                    ),
                    title: Text(
                      DateFormat('dd/MM/yyyy').format(DateTime(
                              1970,
                              1,
                              1,
                              0,
                              0,
                              0,
                              int.parse(_tourList[index].startDate == null
                                  ? "0"
                                  : _tourList[index].startDate))) +
                          " - " +
                          DateFormat('dd/MM/yyyy').format(DateTime(
                              1970,
                              1,
                              1,
                              0,
                              0,
                              0,
                              int.parse(_tourList[index].endDate == null
                                  ? "0"
                                  : _tourList[index].endDate))),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.people,
                      color: Colors.black,
                    ),
                    title: Text(
                      _tourList[index].adults.toString() + " adults",
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.attach_money,
                      color: Colors.yellow,
                    ),
                    title: Text(
                      NumberFormat.currency(
                                  locale: 'vi_VN', name: 'VND', symbol: '')
                              .format(int.parse(_tourList[index].minCost)) +
                          '- ' +
                          NumberFormat.currency(locale: 'vi_VN', name: 'VND')
                              .format(int.parse(_tourList[index].minCost)),
                      style: TextStyle(color: Colors.yellow),
                    ),
                  ),
                ],
              ));
        });
  }
}
