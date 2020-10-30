import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../provider/auth.dart';

class InformationScreen extends StatefulWidget {
  static const route_name = '/info';

  @override
  _InformationScreenState createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
  Map<String, dynamic> _userInfomation;
  List<dynamic> _userInfo = [];

  @override
  void initState() {
    getInfoUser();
    super.initState();
  }

  void getInfoUser() async {
    _userInfomation =
        await Provider.of<Auth>(context, listen: false).information();
    _userInfo = _userInfomation['data'];
  }

  String dateTime(String dateTime) {
    var parsedDate = DateTime.parse(dateTime);
    String formattedDate = DateFormat.yMMMMEEEEd().add_Hm().format(parsedDate);
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
            'INFORMATION',
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
              SizedBox(
                height: deviceSize.height * 0.8,
                child: ListView.builder(
                  itemCount: _userInfo.length,
                  itemBuilder: (context, index) => Card(
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
                            '${_userInfo[index]['title']}',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            '${_userInfo[index]['description']}',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${dateTime(_userInfo[index]['created_at'])}',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'By ${_userInfo[index]['by']}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.blue,
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
