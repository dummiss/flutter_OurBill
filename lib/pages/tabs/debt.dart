import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
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
  List _finalCount0 = [{}];
  List<Widget> _finalCountList = [];
  List<Widget> _ListTileWidget = [];
  bool isInit = false;
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
    setState(() {
      isInit = true;
    });
  }

  _countdebt(_GroupDATA) {
    //計算出已付款及待付款的總額
    List<dynamic> payerTotal = [];
    List<dynamic> sharerTotal = [];
    _GroupDATA['list'].map((v) {
      List tmp1 = payerTotal;
      List tmp2 = sharerTotal;
      for (int i = 0; i < v['payer'].length; i++) {
        if (tmp1.length <= v['payer'].length-1) {
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

    //已付款-待付款＝最後每人負債總額
    for (int i = 0; i < _GroupDATA['member'].length; i++) {
      double count = payerTotal[i] - sharerTotal[i];
      if (i == 0) {
        _finalCount0[0]
            .putIfAbsent(_GroupDATA['member'][i] + '(我)', () => count);
      } else {
        _finalCount0[0].putIfAbsent(_GroupDATA['member'][i], () => count);
      }
    }
    print('finalCount:$_finalCount0');

    //結餘widget list
    _finalCount0[0].forEach((key, value) {
      _finalCountList.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(key), Text(value.toString())],
      ));
      _finalCountList.add(const Divider(
        thickness: 1,
      ));
    });

    //分帳
    var _finalCount = _finalCount0; //複製一份、避免跟上面衝突
    var bigCreditor; //最大債主
    var bigDebtor; //最大負債人
    var debt = 0; //紀錄比較債務金額
    var splitDebt = <String, dynamic>{}; //紀錄最終分帳方式

    checkDebt() {
      num a = 0;
      _finalCount[0].forEach((key, value) {
        a += value.abs();
      });
      print('絕對值總和:$a');
      return a;
    }

    while (checkDebt() > 0) {
      //找出最大的債主與負債人
      _finalCount[0].forEach((key, value) {
        if (value > debt) {
          bigCreditor = key;
        } else if (value < debt) {
          bigDebtor = key;
        }
        print('bigCreditor：$bigCreditor 、bigDebtor：$bigDebtor');
      });

      //找出最大債主與負債人中金額最小者
      var debtAmount = min(_finalCount[0][bigCreditor] as num,
          -(_finalCount[0][bigDebtor]) as num);

      print(debtAmount);

      //最大債主向最大負債人收款，記錄到debt物件
      if (splitDebt.containsKey(bigCreditor)) {
        splitDebt[bigCreditor][bigDebtor] = debtAmount;
      } else {
        splitDebt[bigCreditor] = {};
        splitDebt[bigCreditor][bigDebtor] =
            debtAmount; //若尚未在splitDebt建立該人相關帳務，需定義第二層的物件，記錄對另一人的債務收付
      }

      //最大債務人向最大債主付款，記錄到splitDebt
      if (splitDebt.containsKey(bigDebtor)) {
        splitDebt[bigDebtor][bigCreditor] = -debtAmount;
      } else {
        splitDebt[bigDebtor] = {};
        splitDebt[bigDebtor][bigCreditor] =
            -debtAmount; //若尚未在splitDebt內建立該人相關帳務，需定義第二層的物件，記錄對另一人的債務收付
      }
      //收付款後，更新餘額
      _finalCount[0][bigCreditor] -= debtAmount;
      _finalCount[0][bigDebtor] += debtAmount;
      print(splitDebt);
    }

    // 債務關係widget list

    // <String, Map<String, double>>
    // <String, ListTile>
    //測試中
    // textWidgets = splitDebt
    //     .map(
    //       (key, value) {
    //         final subMap = value as Map<String, double>;
    //         var a;
    //         String str = '';
    //         subMap.forEach((key, value) {
    //           str += '$key: $value';
    //         });
    //         final t = Text('Leading Key: $Key, SubMap: $str');
    //         return MapEntry(key, t);
    //       },
    //     )
    //     .values
    //     .toList();

    splitDebt.forEach((key, value) {
      value.forEach((key2, value2) {
        if(value2>0){
         _ListTileWidget.add(ListTile(
            leading: Container(width: 60, child: Center(child: Text(key2))),
            title: Column(
              children: [
                const Text(
                  '須支付',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                Container(
                    width: 150,
                    child: Image.asset('images/debtArrow.png',
                        fit: BoxFit.fitWidth)),
                Text(
                  value2.abs().toString(),
                  style: const TextStyle(fontWeight: FontWeight.w700),
                )
              ],
            ),
            trailing: Container(
                width: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [Text(key), Icon(Icons.keyboard_arrow_right)],
                )),
          ));
        }

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return isInit
        ? Padding(
            padding: const EdgeInsets.all(30.0),
            child: SingleChildScrollView(
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
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                  //白色區塊
                  Container(
                      // margin: const EdgeInsets.only(top: 50, left: 10, right: 10),
                    padding: EdgeInsets.only(top:15,bottom: 15),
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
                      child: Column(
                        children: _ListTileWidget,
                      ))
                ],
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
