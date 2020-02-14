import 'package:flutter/material.dart';
import 'package:trip_trip/manager/constant.dart';
import 'package:trip_trip/manager/my_api_client.dart';
import 'dart:convert';

class HistoryTour {
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
  bool isHost;
  bool isKicked;
  HistoryTour.fromJson(Map<String, dynamic> json)
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
        avatar = json['avatar'],
        isHost = json['isHost'],
        isKicked = json['isKicked'];
}

class History extends StatefulWidget {
  History({Key key}) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<HistoryTour> _showHistoryTour = [];
  List<HistoryTour> _historyTour = [];

  var _searchController = TextEditingController();
  bool _isSearching = false;
  FocusNode _searchFocusNode = FocusNode();
  int _page = 1;
  int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    var uri = Uri.http(Constant.source_url, Constant.history_tour_list_path,
        {'pageIndex': _page.toString(), 'pageSize': _pageSize.toString()});
    var response = await MyAPIClient.client
        .get(uri, headers: {'Authorization': MyAPIClient.accessToken});
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      List<dynamic> list = jsonResponse['tours'];
      list.forEach((element) {
        HistoryTour historyTour = HistoryTour.fromJson(element);
        _historyTour.add(historyTour);
        setState(() {
          _showHistoryTour.add(historyTour);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: 'Create tour button in history',
        onPressed: null,
        child: Icon(Icons.add),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 70,
            padding: EdgeInsets.all(8),
            child: TextField(
              onTap: () {
                setState(() {
                  _isSearching = true;
                });
              },
              enableSuggestions: true,
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                labelText: 'Search',
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                suffixIcon: Visibility(
                  visible: _isSearching,
                  child: IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: () {
                      setState(() {
                        Future.delayed(Duration(milliseconds: 50)).then((_) {
                          setState(() {
                            _isSearching = false;
                          });
                          _searchFocusNode.unfocus();
                          _searchController.clear();
                        });
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: _showHistoryTour.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: <Widget>[
                        Image(
                            image: _showHistoryTour[index].avatar == null
                                ? AssetImage('Images/du_lich.jpg')
                                : NetworkImage(_showHistoryTour[index].avatar)),
                        ListTile(
                          dense: true,
                          leading: Icon(
                            Icons.location_on,
                            color: Colors.pink,
                          ),
                          title: Text(
                            _showHistoryTour[index].name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        )
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
