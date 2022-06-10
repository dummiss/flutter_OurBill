List appData = [
  //範例
  {
    "group": "宜蘭行",
    "owner": "syuan",
    "member": [
      "syuan",
      "蘋果",
      "草莓",
      "牛奶",
    ],
    "list": [
      //map時先判斷type類型來決定返回什麼組件(用三元法)
      {
        "type": "bill",
        "date": "2022-05-26",
        "time": "下午01:50",
        "billName": "美而美早餐",
        "totalAmount": 800,
        "category": "餐飲",
        "note": "無",
        "payer": [
          {"syuan": 800},
          {"蘋果": 0},
          {"草莓": 0},
          {"牛奶": 0},
        ],
        "sharer": [
          {"syuan": 200},
          {"蘋果": 200},
          {"草莓": 200},
          {"牛奶": 200},
        ]
      },
      {
        "type": "transfer",
        "date": "2022-05-26",
        "time": "下午3:50",
        "amount": 200,
        "beneficiary": "syuan", //收款人
        "remitter": "蘋果", //匯款人
        "note": "已付清囉!",
      }
    ]
  },
  {
    "group": "台北行",
    "owner": "syuan",
    "member": [
      "syuan",
      "草莓",
      "牛奶",
    ],
    "list": [
      //map時先判斷type類型來決定返回什麼組件(用三元法)
      {
        "type": "bill",
        "date": "2022-05-26",
        "time": "下午01:50",
        "billName": "美而美早餐",
        "totalAmount": 800,
        "category": "餐飲",
        "note": "無",
        "payer": [
          {"syuan": 800},
          {"蘋果": 0},
          {"草莓": 0},
          {"牛奶": 0},
        ],
        "sharer": [
          {"syuan": 200},
          {"蘋果": 200},
          {"草莓": 200},
          {"牛奶": 200},
        ]
      },
      {
        "type": "transfer",
        "date": "2022-05-26",
        "time": "下午3:50",
        "amount": 200,
        "beneficiary": "syuan", //收款人
        "remitter": "蘋果", //匯款人
        "note": "已付清囉!",
      }
    ]
  },
];

List a = [
  {
    'group': '宜蘭行',
    'owner': 'syuan',
    'member': ['apple', 'milk', 'orange'],
  },
  {
    'group': '台北行',
    'owner': '宣萱',
    'member': ['apple', 'milk', 'orange'],
  },
];

List DataList = [
  {
    //0
    {'date': '2022/5/30'},
    [
      {'title': '晚餐', 'totalmoney': '800', 'pay': '200'},
      {'title': '早餐', 'totalmoney': '600', 'pay': '100'}
    ]
  },
  {
    //1
    {'date': '2022/5/25'},
    [
      {'title': '晚餐', 'totalmoney': '800', 'pay': '200'}
    ]
  },
  {
    //2
    {'date': '2022/5/20'},
    [
      {'title': '晚餐', 'totalmoney': '800', 'pay': '200'},
      {'title': '晚餐', 'totalmoney': '800', 'pay': '200'},
      {'title': '晚餐', 'totalmoney': '800', 'pay': '200'}
    ]
  },
];

/*
 {
    "group": groupname,
    "member": [
      //獲取member長度表示總人數
      {"owner": ownername},
      {key: name},
      {key: name},
      {key: name},
    ],
    "list": [
      //map時先判斷type類型來決定返回什麼組件(用三元法)
      {
        "type": "bill",
        "date": date,
        "time": time,
        "billName": billname,
        "totalAmount": totalAmount,
        "category": category,
        "note": note,
        "payer": [
          {name: amount},
          {name: amount},
        ],
        "sharer": [
          {name: amount},
          {name: amount},
        ]
      },
      {
        "type": "transfer",
        "date": date,
        "time": time,
        "amount": amount,
        "beneficiary": name, //收款人
        "remitter": name, //匯款人
        "note": note,
      },
*/

//  [{group: hehe, owner: syaun, member: {0: syaun, 1: 1, 2: 3, 3: 4}}, {group: hehe, owner: syaun, member: {0: syaun, 1: 1, 2: 3, 3: 4}}]

//
//  final dataKey = "DATAKEY";

// saveData
// (){
//   await prefs.setString(dataKey, 'Start');
// }
//
// getData(){
//   dataKey
// }

/*
import 'package:flutter/material.dart';
import '../pages/tabs/add.dart';
import '../pages/tabs/debt.dart';
import '../pages/tabs/list.dart';

//帳單清單頁面
class Tabs extends StatefulWidget {
  int? arguments; //接收群組的index參數
  Tabs({Key? key, this.arguments}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TabsState(arguments!);
}

class _TabsState extends State<Tabs> {
  int argument;
  _TabsState(this.argument);

  //底部導覽切換的頁面
  final _pages = <Widget>[
    BillDebt(),
    BillAdd(), //不跳轉
    BillList(),
  ];

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
    index == 1
        ? Navigator.pushNamed(context, '/add')
        : setState(() {
            print('arguments:${widget.arguments}'); //test
            _selectedIndex = index;
            tabsTitle = _titles[index];
          });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, //防止浮動btn跟著鍵盤移動
      appBar: AppBar(
        title: Text('$tabsTitle'),
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
              Navigator.pushNamed(context, '/add');
            },
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}


*/
