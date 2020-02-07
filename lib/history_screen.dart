import 'package:flutter/material.dart';

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
  var _searchController = TextEditingController();
  bool _isSearching = false;
  FocusNode _searchFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
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
          )
        ],
      ),
    );
  }
}
