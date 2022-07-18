import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class GroupAdd extends StatefulWidget {
  const GroupAdd({Key? key}) : super(key: key);

  @override
  State<GroupAdd> createState() => _GroupAddState();
}

class _GroupAddState extends State<GroupAdd> {
  final _userName = TextEditingController(); //"我的暱稱"控制器
  //TODO: 沒有初始值建議給型別, 或給初始值
  var _groupName;

  List newData = [];
  final List<dynamic> _members = []; //存成員名

  //sp
  //TODO: 沒用到的宣告就刪掉
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var _DATA;

  //初始化：先從SP讀取資料
  @override
  void initState() {
    super.initState();
    _loadDATA();
  }

  //TODO: void
  _loadDATA() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      _DATA = (_prefs.getString('DATA') ?? "");
    });
  }

  //新成員init
  //TODO: 加final
  List<Widget> _newMemberTextFormField = [];

  //新成員add方法
  void _add() {
    _newMemberTextFormField.add(addMemberTextField());
  }

  //新成員TextFormField widget
  int randomKey = 0;

  TextFormField addMemberTextField() {
    randomKey++; //避免key重複
    final key = Key(randomKey.toString());

    return TextFormField(
      key: key,
      onSaved: (value) {
        _members.add(value.toString()); //把成員暱稱存進list
      },
      decoration: InputDecoration(
          hintText: '請輸入成員暱稱',
          suffixIcon: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              setState(
                () {
                  //新成員delete
                  _newMemberTextFormField
                      .removeWhere((item) => item.key == key);
                  //TODO: debugPrint
                  print(_newMemberTextFormField);
                },
              );
            },
          )),
    );
  }

  //"建立"button
  //TODO: Add return type
  _createButton() {
    return ElevatedButton(
      onPressed: _forSubmitted,
      child: const Text('建立',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          )),
      style: ElevatedButton.styleFrom(
          primary: const Color.fromARGB(255, 249, 179, 93),
          shadowColor: const Color.fromARGB(200, 249, 179, 93),
          shape: const StadiumBorder(), //外觀
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10)),
    );
  }

  //form提交
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  void _forSubmitted() {
    var _form = _formKey.currentState;
    _members.clear(); //清除成員
    _form!.save();
    _setData(); // 存資料到SP
    Navigator.pop(context, true);
  }

  //  存資料進Ps裡
  Future<void> _setData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //TODO: 小駝峰 dataMap
    var DATAmap = json.decode(prefs.getString('DATA') ?? '[]');
    DATAmap.add({
      "group": _groupName,
      "owner": _userName.text,
      "member": _members,
      "list": [],
    });
    //TODO: debugPrint
    print("DATAmap :$DATAmap ");
    String DATA = json.encode(DATAmap);
    //TODO: debugPrint
    print("DATA:$DATA");
    //顯示測試用
    setState(() {
      prefs.setString('DATA', DATA);
      _DATA = DATA;
    });
  }

  //創建群組widget組合
  List<Widget> _createGroup() {
    return [
      TextFormField(
        onChanged: (value) {
          _userName.text = value;
        },
        onSaved: (value) {
          _members.add(value);
        },
        decoration: const InputDecoration(
            hintText: '點擊以編輯', // 輸入提示
            helperText: '你在此群組的暱稱',
            prefixIcon: Text(
              '我的暱稱',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            prefixIconConstraints:
                BoxConstraints(minHeight: 25, minWidth: 100) // 輸入框前綴圖標
            ),
      ),
      const SizedBox(
        height: 10, //margin
      ),
      TextFormField(
        onSaved: (value) {
          _groupName = value;
        },
        decoration: const InputDecoration(
            hintText: '點擊以編輯', // 輸入提示
            prefixIcon: Text(
              '群組名稱', //輸入框前綴文字
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            prefixIconConstraints:
                BoxConstraints(minHeight: 25, minWidth: 100) // 輸入框前綴大小
            ),
      ),
      const SizedBox(
        height: 70, //margin
      ),
      const Text(
        '群組成員',
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
      ),
      TextFormField(
        readOnly: true,
        controller: _userName,
        decoration: const InputDecoration(
            suffixIcon: Text(
              '管理員',
              style: TextStyle(
                  color: Colors.black26,
                  fontWeight: FontWeight.w700,
                  fontSize: 15),
            ),
            suffixIconConstraints: BoxConstraints(minHeight: 25, minWidth: 50)),
      ),
      Column(
        children: _newMemberTextFormField,
      ),
      Row(
        children: [
          IconButton(
              onPressed: () {
                setState(() {
                  _add();
                });
              },
              icon: const Icon(
                Icons.add_circle,
                color: Color.fromARGB(255, 249, 179, 93),
                size: 30.0,
              )),
          const Text(
            '新增成員',
            style: TextStyle(color: Colors.black38),
          )
        ],
      ),
    ];
  }

//  畫面渲染
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('建立群組'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
              key: _formKey, //設置globalKey，用於後面獲取FormState
              child: Column(
                children: [
                  Expanded(child: ListView(children: _createGroup())),
                  Row(
                    children: [Expanded(child: _createButton())],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  // Text("DATA:$_DATA"),
                ],
              ))),
    );
  }
}
