import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../pages/tabs/add.dart';
import '../pages/tabs/debt.dart';
import '../pages/tabs/list.dart';

//帳單清單頁面
class Tabs extends StatefulWidget {
  int? arguments; //接收groupList傳過來的arguments:index參數
  Tabs({Key? key, this.arguments}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TabsState(arguments!);
}

class _TabsState extends State<Tabs> {
  int arguments;

  var _pages = <Widget>[];

  //底部導覽切換的頁面
  _TabsState(this.arguments) {
    _pages = <Widget>[
      BillDebt(arguments),
      BillAdd(), //不跳轉
      BillList(arguments),
    ];
  }

  // 底部導航欄要顯示的所有子項
  final List<BottomNavigationBarItem> bottomNavBarItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.people),
      label: '債務關係',
    ),
    const BottomNavigationBarItem(
      icon: Icon(
        Icons.add,
        color: Color.fromARGB(255, 255, 199, 130),
      ),
      label: '',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.list_alt),
      label: '分帳列表',
    ),
  ];

  //切換
  int _selectedIndex = 2;
  var tabsTitle = '記錄總覽';
  final List<String> _titles = [('債務'), (''), ('記錄總覽')];

  void _onItemTapped(int index) {
    //問ari 要怎麼藉由這種方式讓建立玩可以重新刷新，這次先把回上一頁取消，直接傳路由的方式刷新
    index == 1
        ? (Navigator.pushReplacementNamed(context, '/add',
            arguments: arguments)) //直接刪除「前1個」 route，push到新 route，stack就不會有這層
        : setState(() {
            print('tabs index:$arguments'); //test
            _selectedIndex = index;
            tabsTitle = _titles[index];
          });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, //防止浮動btn跟著鍵盤移動
      appBar: AppBar(
        title: Text(tabsTitle),
      ),
      body: _pages[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white70, //背景顏色
        iconSize: 35,
        selectedIconTheme:
            const IconThemeData(color: Color.fromARGB(255, 242, 187, 119)),
        selectedItemColor: const Color.fromARGB(255, 242, 187, 119),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: bottomNavBarItems,
        currentIndex: _selectedIndex, //預設初始Item
        onTap: _onItemTapped, //點選觸發_onItemTapped方法
      ),
      floatingActionButton: Container(
          height: 80,
          width: 80,
          margin: const EdgeInsets.only(top: 30),
          child: FloatingActionButton(
            child: const Icon(
              Icons.add,
              size: 50,
            ),
            backgroundColor: const Color.fromARGB(255, 242, 187, 119),
            foregroundColor: Colors.white,
            focusColor: const Color.fromARGB(255, 242, 187, 119),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/add',
                  arguments: arguments);
            },
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
