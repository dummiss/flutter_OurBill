import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:date_format/date_format.dart'; //日期格式化套件

class SpendDetail extends StatefulWidget {
  final arguments;
  SpendDetail({Key? key, this.arguments}) : super(key: key);
  /*
  arguments: {
    'allData': _AllDATA,
    'groupindex':widget.arguments,
    'member': _AllDATA[widget.arguments] ['member'],
    'detail': element,
 });
  */

  @override
  State<SpendDetail> createState() => _SpendDetailState();
}

class _SpendDetailState extends State<SpendDetail> {
  bool _editCheck = false;

  @override
  void initState() {
    super.initState();
    print(
        'widget.arguments:${widget.arguments != null ? widget.arguments['detail'] : 'no detail'}');
    print('member:${widget.arguments['member']}');
  }

  _delet() {
    return showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('確定要刪除嗎？'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('CANCEL'),
            ),
            ElevatedButton(
              onPressed: () async {
                SharedPreferences _prefs =
                await SharedPreferences.getInstance(); //更新SP
                widget.arguments['allData'][widget.arguments['groupindex']]
                ['list']
                    .removeWhere((item) =>
                item['billName'] ==
                    widget.arguments['detail']
                    ['billName']); //刪掉有跟這個內容相同的東西
                String newDATA = json.encode(widget.arguments['allData']);
                _prefs.setString('DATA', newDATA);
                Navigator.of(context)
                  ..pop
                  ..pop()
                  ..pop();
                (Navigator.popAndPushNamed(context, '/tabs',
                    arguments: {'index': widget.arguments['groupindex']}));
              },
              child: const Text('確定'),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete_forever,
              size: 30,
            ),
            tooltip: '刪除',
            onPressed: () {
              _delet();
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.edit_note,
              size: 32,
              color: Color.fromARGB(255, 249, 179, 93),
            ),
            tooltip: '編輯',
            onPressed: () {
              _editCheck = true;
            },
          ),
        ],
        title: const Text('消費明細'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
              child: Column(
                children: [
                  Expanded(
                      child: ListView(children: [
                        TextFormField(
                          enabled: _editCheck ? true : false,
                          controller: TextEditingController()
                            ..text = '${widget.arguments['detail']['totalAmount']}',
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w700),
                          decoration: const InputDecoration(
                              hintStyle: TextStyle(
                                  color: Colors.black26,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal),
                              prefixIcon: Text(
                                'TWD',
                                style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              prefixIconConstraints: BoxConstraints(
                                  minHeight: 25, minWidth: 100) // 輸入框前綴圖標
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('${widget.arguments['detail']['date']}'),
                            Text('${widget.arguments['detail']['time']}'),
                          ],
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          enabled: _editCheck ? true : false,
                          controller: TextEditingController()
                            ..text = "${widget.arguments['detail']['billName']}",
                          decoration: const InputDecoration(
                              prefixIcon: Text(
                                '名稱', //輸入框前綴文字
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              prefixIconConstraints: BoxConstraints(
                                  minHeight: 25, minWidth: 100) // 輸入框前綴大小
                          ),
                        ),
                        TextFormField(
                          enabled: _editCheck ? true : false,
                          controller: TextEditingController()
                            ..text = widget.arguments['detail']['category'] == 'null'
                                ? '沒有選擇'
                                : widget.arguments['detail']['category'],
                          decoration: const InputDecoration(
                              prefixIcon: Text(
                                '類別', //輸入框前綴文字
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              prefixIconConstraints: BoxConstraints(
                                  minHeight: 25, minWidth: 100) // 輸入框前綴大小
                          ),
                        ),
                        TextFormField(
                          enabled: _editCheck ? true : false,
                          controller: TextEditingController()
                            ..text = widget.arguments['detail']['note'],
                          decoration: const InputDecoration(
                              prefixIcon: Text(
                                '備註', //輸入框前綴文字
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              prefixIconConstraints: BoxConstraints(
                                  minHeight: 25, minWidth: 100) // 輸入框前綴大小
                          ),
                        ),
                        //白色區塊
                        Container(
                            margin: const EdgeInsets.only(top: 50, left: 10, right: 10),
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
                              Container(
                                  margin: const EdgeInsets.only(right: 20, left: 20),
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.black26, width: 1))),
                                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                                  child: Column(
                                    children: [
                                      Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Expanded(
                                              flex: 2,
                                              child: Text(
                                                '付款人',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: widget.arguments['member'] !=
                                                    null
                                                    ? (widget.arguments['member']
                                                as List) //強制轉型
                                                    .map((item) => Text(
                                                  item,
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      height: 1.6),
                                                ))
                                                    .toList()
                                                    : [],
                                                // children: payer,
                                              ),
                                            ),
                                            Expanded(
                                                flex: 2,
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: widget.arguments['detail']
                                                  ['payer'] !=
                                                      null
                                                      ? (widget.arguments['detail']
                                                  ['payer'] as List) //強制轉型
                                                      .map((item) => Text(
                                                    item.toString(),
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        height: 1.6),
                                                  ))
                                                      .toList()
                                                      : [],
                                                ))
                                          ]),
                                    ],
                                  )),
                              Container(
                                  margin: const EdgeInsets.only(right: 20, left: 20),
                                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                                  child: Column(
                                    children: [
                                      Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Expanded(
                                              flex: 2,
                                              child: Text(
                                                '分帳人',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children:
                                                widget.arguments['member'] != null
                                                    ? (widget.arguments['member']
                                                as List) //強制轉型
                                                    .map((item) => Text(item,
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        height: 1.6)))
                                                    .toList()
                                                    : [],
                                                // children: payer,
                                              ),
                                            ),
                                            Expanded(
                                                flex: 2,
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: widget.arguments['detail']
                                                  ['sharer'] !=
                                                      null
                                                      ? (widget.arguments['detail']
                                                  ['sharer'] as List) //強制轉型
                                                      .map((item) => Text(
                                                    item.toString(),
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        height: 1.6),
                                                  ))
                                                      .toList()
                                                      : [],
                                                ))
                                          ]),
                                    ],
                                  )),
                            ])),
                      ])),
                ],
              ))),
    );
  }
}
