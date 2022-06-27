import 'dart:ffi';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grouped_list/grouped_list.dart';
import "package:collection/collection.dart"; //引入groupby fn

import 'package:flutter_ourbill/data/json.dart';
import 'data/json.dart'; //假資料

class BillList extends StatefulWidget {
  int arguments;
  BillList(this.arguments, {Key? key}) : super(key: key);

  @override
  State<BillList> createState() => _BillListState();
}

class _BillListState extends State<BillList> {
  List<dynamic> _GroupDATA = [];
  List<dynamic> _ListDATA = [];

//  初始化：先從SP讀取資料
  @override
  void initState() {
    super.initState();
    _loadDATA();
  }

  _loadDATA() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _GroupDATA = json.decode(_prefs.getString('DATA') ?? '');
    _ListDATA =
        json.decode(_prefs.getString('DATA') ?? '')[widget.arguments]['list'];
    print("_ListDATA:$_ListDATA");
    setState(() {});
  }

  haveToPay(element) {
    double? count;
    count = element['sharer'][0] - element['payer'][0];
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        //使用套件照日期組數排序
        child: GroupedListView<dynamic, String>(
          elements: _ListDATA,
          groupBy: (element) => element['date'],
          useStickyGroupSeparators: true,
          groupComparator: (value1, value2) => value2.compareTo(value1),
          itemComparator: (item1, item2) =>
              item1['time'].compareTo(item2['time']),
          order: GroupedListOrder.ASC, //排序方式
          groupSeparatorBuilder: (String value) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          indexedItemBuilder: (c, element, index) {
            //滑動刪除
            return Dismissible(
                key: UniqueKey(), //每一個Dismissible都必須有專屬的key，讓Flutter能夠辨識
                onDismissed: (direction) async {
                  //滑動後要做的事
                  SharedPreferences _prefs =
                      await SharedPreferences.getInstance(); //更新SP
                  _ListDATA.removeAt(index);
                  _GroupDATA[widget.arguments]['list'] = _ListDATA;
                  String newDATA = json.encode(_GroupDATA);
                  _prefs.setString('DATA', newDATA);
                  setState(() {});
                },
                direction: DismissDirection.endToStart, //只能從右往左滑
                background: Container(
                  //樣式設計
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        Icon(
                          Icons.delete,
                          color: Colors.black45,
                        ),
                        Text(
                          '刪除',
                          style: (TextStyle(color: Colors.black45)),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                  color: Colors.black26,
                ),
                child: Card(
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
                              //到消費細節頁
                              Navigator.pushNamed(context, '/spendDetail',
                                  arguments: {
                                    'member': _GroupDATA[widget.arguments]['member'],
                                    'detail': element,
                                    'index': index
                                  });
                              print('element${element}');
                              print('index:$index');
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
                            title: Text(
                              element['billName'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            subtitle: Text(
                                element['totalAmount'] != null
                                    ? '\$' + element['totalAmount'].toString()
                                    : '沒有金額',
                                style: const TextStyle(fontSize: 12)),
                            trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  haveToPay(element) >= 0
                                      ? const Text('你待付',
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 10))
                                      : const Text('你代墊',
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 10)),
                                  Text(element['sharer'] != [] &&
                                          element['totalAmount'] != ''
                                      ? '\$' + haveToPay(element).abs().toString() //先轉絕對值，去除負數符號
                                      : '\$0')
                                ]),
                          )
                        ],
                      ),
                    )));
          },
        ));
  }
}
