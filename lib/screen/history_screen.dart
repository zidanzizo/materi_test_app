import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../provider/auth.dart';

class HistoryScreen extends StatefulWidget {
  static const route_name = '/history';

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<dynamic> _userHistory = [];

  @override
  void initState() {
    getHistoryUser();
    super.initState();
  }

  void getHistoryUser() async {
    final history = await Provider.of<Auth>(context, listen: false).history();
    history.removeLast();
    _userHistory = history;
  }

  String dateTime(String dateTime) {
    var parsedDate = DateTime.parse(dateTime);
    String formattedDate = DateFormat.yMMMMEEEEd().format(parsedDate);
    return formattedDate;
  }

  String hourPick(String dateTime) {
    var parsedDate = DateTime.parse(dateTime);
    String formattedDate = DateFormat.Hm().format(parsedDate);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFFE7E7E7),
      appBar: AppBar(
        backgroundColor: Color(0xFF131E9E),
        title: Center(
          child: Text(
            'HISTORY',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      body: Container(
        width: deviceSize.width,
        color: Color(0xFFE7E7E7),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _userHistory.length,
                  itemBuilder: (context, index) => Card(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    elevation: 3,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${dateTime(_userHistory[index]['data_picking']['date_picking'])}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            'Picking No : ${_userHistory[index]['data_picking']['code']}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Line: ${_userHistory[index]['data_picking']['id']} line',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                '${hourPick(_userHistory[index]['data_picking']['date_picking'])}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.amber,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
