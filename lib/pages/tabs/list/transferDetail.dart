import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TransferDetail extends StatefulWidget {
  final arguments;
  /*
    arguments: {
      'allData': _AllDATA,
      'groupindex':widget.arguments,
      'member': _AllDATA[widget.arguments]['member'],
      'detail': element,
    });
  */
  const TransferDetail({Key? key, this.arguments}) : super(key: key);

  @override
  State<TransferDetail> createState() => _TransferDetailState();
}

class _TransferDetailState extends State<TransferDetail> {
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
              showDialog<String>(
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
                              widget.arguments['allData']
                                      [widget.arguments['groupindex']]['list']
                                  .removeWhere((item) =>
                                      item['billName'] ==
                                      widget.arguments['detail']
                                          ['billName']); //刪掉有跟這個內容相同的東西
                              String newDATA =
                                  json.encode(widget.arguments['allData']);
                              _prefs.setString('DATA', newDATA);
                              // Navigator.of(context).popUntil(ModalRoute.withName("/tab"));                              // Navigator.of(context).popUntil((route) => route.isFirst);
                              Navigator.restorablePushNamedAndRemoveUntil(context,'/tabs', ModalRoute.withName('/groupList'),arguments: {'index': widget.arguments['groupindex']});
                            //   (Navigator.popAndPushNamed(context, '/tabs',
                            //       arguments: {'index': widget.arguments['groupindex']}));
                            },
                            child: Text('確定'),
                          ),
                        ],
                      ));
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
              // handle the press
            },
          ),
        ],
        title: const Text('轉帳明細'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
              child: Column(
            children: [
              Expanded(
                  child: ListView(children: [
                TextFormField(
                  enabled: false,
                  controller: TextEditingController()
                    ..text = '${widget.arguments['detail']['Amount']}',
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
                  enabled: false,
                  controller: TextEditingController()
                    ..text = "${widget.arguments['detail']['remitter']}",
                  decoration: const InputDecoration(
                      prefixIcon: Text(
                        '匯款人', //輸入框前綴文字
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
                  enabled: false,
                  controller: TextEditingController()
                    ..text = "${widget.arguments['detail']['receiver']}",
                  decoration: const InputDecoration(
                      prefixIcon: Text(
                        '收款人', //輸入框前綴文字
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
                  enabled: false,
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
              ])),
            ],
          ))),
    );
  }
}
