import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BillDebt extends StatefulWidget {
  int arguments;
  BillDebt(this.arguments, {Key? key}) : super(key: key);

  @override
  State<BillDebt> createState() => _BillDebtState();
}

class _BillDebtState extends State<BillDebt> {
  Map _groupDATA = {};
  List<dynamic> _allDATA = [];
  List _finalCount = [];
  List<Widget> _finalCountList = [];

  @override
  void initState() {
    super.initState();
    _loadDATA();
  }

  _loadDATA() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _allDATA = json.decode(_prefs.getString('DATA') ?? '');
    _groupDATA = json.decode(_prefs.getString('DATA') ?? '')[widget.arguments];
    print("_GroupDATA:$_groupDATA");
    _countdebt(_groupDATA);
    setState(() {});
  }

  _countdebt(_GroupDATA) {
    //計算出已付款及代付款的總額
    List<dynamic> payerTotal = [];
    List<dynamic> sharerTotal = [];
    _GroupDATA['list'].map((v) {
      List tmp1 = payerTotal;
      List tmp2 = sharerTotal;
      for (int i = 0; i < v['payer'].length; i++) {
        if (tmp1.length <= 3) {
          payerTotal.add(v['payer'][i]);
          sharerTotal.add(v['sharer'][i]);
        } else {
          payerTotal[i] = tmp1[i] + v['payer'][i];
          sharerTotal[i] = tmp2[i] + v['sharer'][i];
        }
      }
    }).toList();
    print('payerTotal:$payerTotal');
    print('sharerTotal:$sharerTotal');

    //最後每人負債總額
    for (int i = 0; i < _GroupDATA['member'].length; i++) {
      double count = payerTotal[i] - sharerTotal[i];
      if (i == 0) {
        _finalCount.add({_GroupDATA['member'][i] + '(我)': count});
      } else {
        _finalCount.add({_GroupDATA['member'][i]: count});
      }
    }
    print('finalCount:$_finalCount');

    for (int i = 0; i < _finalCount.length; i++) {
      _finalCount[i].forEach((key, value) {
        _finalCountList.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(key), Text(value.toString())],
        ));
        _finalCountList.add(const Divider(
          thickness: 1,
        ));
      });

      // _finalCount[i].map((key, value) {
      //   a.add(Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [Text(key), Text(value)],
      //   ));
      //   a.add(
      //     const Divider(
      //       thickness: 1,
      //     ),
      //   );
      // });
    }

    print('_finalCountWidget:$_finalCountList');
  }

  _finalCountWidget() {}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '結餘',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 20,
          ),
          Column(
            children: _finalCountList,
          ),

          Padding(
            padding: EdgeInsets.only(top: 30, bottom: 10),
            child: Text(
              '債務關係',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          //白色區塊
          Container(
              // margin: const EdgeInsets.only(top: 50, left: 10, right: 10),
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.black38,
                      blurRadius: 5,
                      offset: Offset(0, 3)), //偏移
                ],
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Column(children: [
                ListTile(
                  leading:
                      Container(width: 60, child: Center(child: Text('syuan'))),
                  title: Column(
                    children: [
                      Text(
                        '須支付',
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      Container(
                          width: 200,
                          child: Image.asset('images/debtArrow.png',
                              fit: BoxFit.fitWidth)),
                      Text(
                        '\$900',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                  trailing: Container(
                      width: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('milk'),
                          Icon(Icons.keyboard_arrow_right)
                        ],
                      )),
                )
              ]))
        ],
      ),
    );
  }
}
