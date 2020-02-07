import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:trip_trip/manager/my_api_client.dart';
import 'dart:convert' as convert;
import 'manager/constant.dart';

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

class Asistant extends StatefulWidget {
  Asistant({Key key}) : super(key: key);

  @override
  _AsistantState createState() => _AsistantState();
}

class _AsistantState extends State<Asistant> {
  var _searchController = TextEditingController();
  void _scrollListener() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      setState(() {
        _scrollingUp = true;
      });
    }
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      setState(() {
        _scrollingUp = false;
      });
    }
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      getData();
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
    setState(() {
      _scrollController.addListener(_scrollListener);
    });
  }

  List<Tour> _showTourList = [];
  List<Tour> _tourList = [];
  void getData() async {
    var uri = Uri.http(Constant.source_url, Constant.tour_list_path,
        {"pageNum": _page.toString(), "rowPerPage": _pagesize.toString()});
    var response = await MyAPIClient.client
        .get(uri, headers: {'Authorization': MyAPIClient.accessToken});
    var jsonResponse = convert.jsonDecode(response.body);
    // var total = jsonResponse['total'];
    // var count = int.parse(total);
    List<dynamic> list = jsonResponse['tours'];
    for (int i = 0; i < list.length; i++) {
      var tour = Tour.fromJson(list[i]);
      print(list[i]);
      _tourList.add(tour);
      setState(() {
        _showTourList.add(tour);
      });
    }

    _page++;
  }

  int _page = 0;
  int _pagesize = 10;
  bool _scrollingUp = true;
  ScrollController _scrollController = ScrollController();
  FocusNode _searchFocusNode = FocusNode();
  bool _isSearching = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Visibility(
            visible: _scrollingUp,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onTap: () {
                  setState(() {
                    _isSearching = true;
                  });
                },
                onChanged: (value) {
                  setState(() {
                    _showTourList.clear();
                  });

                  _tourList.forEach((element) {
                    if (element.name
                        .toLowerCase()
                        .trim()
                        .contains(value.toLowerCase().trim())) {
                      setState(() {
                        _showTourList.add(element);
                      });
                    }
                  });
                },
                focusNode: _searchFocusNode,
                controller: _searchController,
                decoration: InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: Visibility(
                      visible: _isSearching,
                      child: IconButton(
                          icon: Icon(Icons.cancel),
                          onPressed: () {
                            Future.delayed(Duration(milliseconds: 50))
                                .then((_) {
                              setState(() {
                                _isSearching = false;
                                _showTourList.clear();
                                _showTourList.addAll(_tourList);
                              });
                              _searchFocusNode.unfocus();
                              _searchController.clear();
                            });
                          }),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                key: PageStorageKey('Assistant'),
                controller: _scrollController,
                itemCount: _showTourList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Image(
                            image: _showTourList[index].avatar == null
                                ? AssetImage('Images/du_lich.jpg')
                                : NetworkImage(_showTourList[index].avatar),
                            fit: BoxFit.cover,
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.location_on,
                              color: Colors.pink,
                            ),
                            title: Text(
                              _showTourList[index].name,
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
                                      int.parse(
                                          _showTourList[index].startDate == null
                                              ? "0"
                                              : _showTourList[index]
                                                  .startDate))) +
                                  " - " +
                                  DateFormat('dd/MM/yyyy').format(DateTime(
                                      1970,
                                      1,
                                      1,
                                      0,
                                      0,
                                      0,
                                      int.parse(
                                          _showTourList[index].endDate == null
                                              ? "0"
                                              : _showTourList[index].endDate))),
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.people,
                              color: Colors.black,
                            ),
                            title: Text(
                              _showTourList[index].adults.toString() +
                                  " adults",
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.attach_money,
                              color: Colors.yellow,
                            ),
                            title: Text(
                              NumberFormat.currency(
                                          locale: 'vi_VN',
                                          name: 'VND',
                                          symbol: '')
                                      .format(int.parse(
                                          _showTourList[index].minCost)) +
                                  '- ' +
                                  NumberFormat.currency(
                                          locale: 'vi_VN', name: 'VND')
                                      .format(int.parse(
                                          _showTourList[index].minCost)),
                              style: TextStyle(color: Colors.yellow),
                            ),
                          ),
                        ],
                      ));
                }),
          )
        ],
      ),
    );
  }
}
