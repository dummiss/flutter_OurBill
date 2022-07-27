import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/data_holder.dart';

class GroupAdd extends StatefulWidget {
  const GroupAdd({Key? key}) : super(key: key);

  @override
  State<GroupAdd> createState() => _GroupAddState();
}

class _GroupAddState extends State<GroupAdd> {
  final userNameController = TextEditingController();

  String? groupName = '';
  final List<dynamic> members = []; //存成員名

  final dataHolder = Get.find<DataHolder>();

  //新成員init
  final List<Widget> _newMemberTextFormField = [];

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
        members.add(value.toString()); //把成員暱稱存進list
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
                  debugPrint('$_newMemberTextFormField');
                },
              );
            },
          )),
    );
  }

  //"建立"button
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
    members.clear(); //清除成員
    _form!.save();
    _renewData();
    dataHolder.saveDataToSP(); // 存資料到SP
    Navigator.pop(context, true);
  }

  //更新dataHolder資料
  _renewData() {
    dataHolder.data.add({
      "group": groupName,
      "owner": userNameController.text,
      "member": members,
      "list": [],
    });
    debugPrint("dataHolder.data:${dataHolder.data}");
  }

  //創建群組widget組合
  List<Widget> _createGroup() {
    return [
      TextFormField(

        onChanged: (value) {
          userNameController.text = value;
        },
        onSaved: (value) {
          members.add(value);
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
          groupName = value;
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
        controller: userNameController,
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
