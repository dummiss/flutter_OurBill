import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GroupList extends StatefulWidget {
  const GroupList({Key? key}) : super(key: key);

  @override
  State<GroupList> createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {
  //初始化：先從SP讀取資料
  var _DATA;
  @override
  void initState() {
    super.initState();
    _loadDATA();
  }

  _loadDATA() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      _DATA = json.decode(_prefs.getString('DATA') ?? '[]');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, //移除回到上一頁icon
        actions: <Widget>[
          //新增
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/groupAdd').then((value) =>
                  value == true
                      ? _loadDATA()
                      : null); //接收下一頁的回傳值，讓下一頁回到上一頁能刷新頁面
            },
          ),
        ],
        title: const Text('群組總覽'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView.builder(
            itemCount: (_DATA != null ? _DATA.length : 0),
            itemBuilder: (context, index) {
              final item = _DATA[index];
              return Dismissible(
                  //滑動刪除
                  key: UniqueKey(), //每一個Dismissible都必須有專屬的key，讓Flutter能夠辨識
                  onDismissed: (direction) async {
                    //滑動後要做的事
                    SharedPreferences _prefs =
                        await SharedPreferences.getInstance(); //更新SP
                    _DATA.removeAt(index);
                    String newDATA = json.encode(_DATA);
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
                    color: const Color.fromARGB(255, 249, 179, 93),
                  ),
                  child: Card(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    color: const Color.fromARGB(200, 255, 226, 190),
                    elevation: 6.0,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: SizedBox(
                      height: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ListTile(
                            onTap: () {
                              Navigator.pushNamed(context, '/tabs',
                                  arguments: index); //把index傳到下一頁，知道是資料的第幾個
                            }, //點擊,
                            leading: const CircleAvatar(
                              backgroundColor: Colors.black26,
                            ),
                            title: Container(
                              padding: const EdgeInsets.only(left: 5),
                              height: 50,
                              alignment: Alignment.topLeft,
                              child: Text(
                                '${_DATA[index]['group']}',
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                            trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Icon(
                                    Icons.keyboard_arrow_right,
                                    size: 30,
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    width: 50,
                                    child: Row(
                                      children: [
                                        const Icon(Icons.people),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                            '${_DATA[index]['member'].length}'),
                                      ],
                                    ),
                                  )
                                ]),
                          )
                        ],
                      ),
                    ),
                  ));
            }),
      ),
    );
  }
}
