import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_ourbill/data/json.dart';
import 'data/json.dart'; //假資料

class BillList extends StatefulWidget {
  int? index;
  BillList(this.index, {Key? key}) : super(key: key);

  @override
  State<BillList> createState() => _BillListState();
}

class _BillListState extends State<BillList> {
  var _DATA;
//  初始化：先從SP讀取資料
  @override
  void initState() {
    super.initState();
    _loadDATA();
  }

  _loadDATA() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      _DATA = json.decode(_prefs.getString('DATA') ?? '')[widget.index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ListView(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_DATA}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            Card(
              margin: const EdgeInsets.only(top: 5, bottom: 20),
              color: Colors.white,
              elevation: 6.0,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: SizedBox(
                height: 80,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ListTile(
                      onTap: () {
                        Navigator.pushNamed(context, '/spendDetail');
                      }, //點擊,
                      leading: Container(
                        padding: const EdgeInsets.only(right: 15.0),
                        decoration: const BoxDecoration(
                            border: Border(
                          right: BorderSide(
                            // 灰線條
                            color: Colors.black12,
                            width: 2.0,
                          ),
                        )),
                        child: const CircleAvatar(
                          backgroundColor: Colors.black26,
                        ),
                      ),
                      title: const Text(
                        '早餐',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: const Text('總額：\$800',
                          style: TextStyle(fontSize: 12)),
                      trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const [
                            Text('你待付', style: TextStyle(fontSize: 10)),
                            Text('\$200')
                          ]),
                    )
                  ],
                ),
              ),
            )
          ].toList(),
        ),
      ]),
    );
  }
}
