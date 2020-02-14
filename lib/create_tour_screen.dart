import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trip_trip/widgets.dart';
import 'manager/constant.dart';

class CreateTourScreen extends StatefulWidget {
  CreateTourScreen({Key key}) : super(key: key);

  @override
  _CreateTourScreenState createState() => _CreateTourScreenState();
}

class _CreateTourScreenState extends State<CreateTourScreen> {
  bool _isPrivate = false;
  var _createTourFormKey = GlobalKey<FormState>();
  var _tourNameController = TextEditingController();
  var _startDateController = TextEditingController();
  var _endDateController = TextEditingController();
  var _adultsController = TextEditingController();
  var _childrenController = TextEditingController();
  var _minCostController = TextEditingController();
  var _maxCostController = TextEditingController();

  Future<String> datePicker() async {
    await showDatePicker(
      firstDate: DateTime(2000),
      initialDate: DateTime.now(),
      lastDate: DateTime(2200),
      context: context,
    ).then((value) {
      return DateFormat('dd/MM/yyyy').format(value);
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          'Create Tour',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Form(
          key: _createTourFormKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            children: <Widget>[
              TextFormField(
                controller: _tourNameController,
                validator: (value) {
                  if (value.isEmpty) return Constant.tour_name_edittext_error;
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Tour name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _startDateController,
                      validator: (value) {
                        if (value.isEmpty)
                          return Constant.start_day_edittext_error;
                        return null;
                      },
                      readOnly: true,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: 'Start date',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                        icon: Icon(
                          Icons.calendar_today,
                          color: Colors.red,
                        ),
                        onPressed: null),
                  ),
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _endDateController,
                      validator: (value) {
                        if (value.isEmpty)
                          return Constant.end_day_edittext_error;
                        return null;
                      },
                      textAlign: TextAlign.center,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: 'End date',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                        icon: Icon(
                          Icons.calendar_today,
                          color: Colors.red,
                        ),
                        onPressed: null),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      controller: _adultsController,
                      validator: (value) {
                        if (value.isEmpty)
                          return Constant.adults_edittext_error;
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: 'Adults',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _childrenController,
                      validator: (value) {
                        if (value.isEmpty)
                          return Constant.children_edittext_error;
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: 'Children',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      controller: _minCostController,
                      validator: (value) {
                        if (value.isEmpty)
                          return Constant.min_cost_edittext_error;
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: 'Min cost',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _maxCostController,
                      validator: (value) {
                        if (value.isEmpty)
                          return Constant.max_cost_edittext_error;
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: 'Max cost',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                leading: Checkbox(
                    value: _isPrivate,
                    onChanged: (value) {
                      setState(() {
                        _isPrivate = value;
                      });
                    }),
                title: Text('This is your private trip?'),
              ),
              gradientButton('Create tour', () {
                if (!_createTourFormKey.currentState.validate()) return;
                var request = {
                  'name': _tourNameController.text,
                };
              }),
            ],
          ),
        ),
      ),
    );
  }
}
