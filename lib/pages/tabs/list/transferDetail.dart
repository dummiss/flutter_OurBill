import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:date_format/date_format.dart'; //日期格式化套件

class TransferDetail extends StatefulWidget {
  final arguments;
  /*
    arguments: {
      'allData': _AllDATA,
      'groupindex':widget.arguments,
      'member': _AllDATA[widget.arguments]['member'],
      'detail': element,
      'elementIndex':index,
    });
  */
  const TransferDetail({Key? key, this.arguments}) : super(key: key);
  @override
  State<TransferDetail> createState() => _TransferDetailState();
}

class _TransferDetailState extends State<TransferDetail> {
  final GlobalKey<FormState> _addFormKey = GlobalKey<FormState>();
  bool _editCheck = false;
  final TextEditingController _transfermoneyController =
      TextEditingController();
  final TextEditingController _transnoteController = TextEditingController();
  late List _transferList ;
  late var _transferAmount = widget.arguments['detail']['Amount'];
  late String _note = widget.arguments['detail']['note'];
  late String _remitter = widget.arguments['detail']['remitter'];
  late String _receiver = widget.arguments['detail']['receiver'];

  //日期
  DateTime? _nowDate;
  _getDatePicker() async {
    _nowDate = DateTime.parse(widget.arguments['detail']['date']);
    DateTime? result = await showDatePicker(
        context: context,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
              primary: Color.fromARGB(255, 242, 187, 119),
            )),
            child: child!,
          );
        },
        initialDate: (_nowDate ?? DateTime.now()),
        firstDate: DateTime(2020),
        lastDate: DateTime(2100));

    setState(() {
      _nowDate = result;
      result == null ? null : _nowDate = result;
      debugPrint("_nowDate: $_nowDate");
    });
  }

//時間
  TimeOfDay? _nowTime;
  _getTimePicker() async {
    TimeOfDay? result = await showTimePicker(
      context: context,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
            primary: Color.fromARGB(255, 242, 187, 119),
          )),
          child: child!,
        );
      },
      initialTime: TimeOfDay.now(),
    );

    setState(() {
      result == null ? null : _nowTime = result;
      debugPrint("_nowTime: $_nowTime");
    });
  }

  //確定編輯btn
  _completeBtn() {
    return ElevatedButton(
      onPressed: _forSubmitted,
      child: const Text('編輯送出',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          )),
      style: ElevatedButton.styleFrom(
          primary: const Color.fromARGB(255, 249, 179, 93),
          shadowColor: const Color.fromARGB(200, 249, 179, 93),
          shape: const StadiumBorder(), //外觀
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10)),
    );
  }

  void _forSubmitted() {
    _transferList = [];
    for (int i = 0; i < widget.arguments['member'].length; i++) {
      _transferList.add(0);
    }
    //test 整理成[0,0,0,200]格式
    _transferList[widget.arguments['member'].indexOf(_remitter)] =
        double.parse(_transferAmount);
    //test 整理成[0,0,0,200]格式
    _transferList[widget.arguments['member'].indexOf(_receiver)] =
        -double.parse(_transferAmount);
    var _form = _addFormKey.currentState;
    _form?.save();

    _setData(); // 存資料到SP
    _editCheck = false;
    setState(() {});
  }

  //存資料進Ps裡
  Future<void> _setData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var a = widget.arguments['detail'];
    a["billName"] = "$_remitter 付給 $_receiver";
    a["date"] =
        formatDate(_nowDate ?? DateTime.now(), [yyyy, '-', mm, '-', dd]);
    a["time"] = (_nowTime ?? TimeOfDay.now()).format(context);
    a["remitter"] = _remitter;
    a["receiver"] = _receiver;
    a["Amount"] = _transferAmount;
    a["transferList"] = _transferList;
    a["note"] = _note;
    widget.arguments['allData'][widget.arguments['groupindex']]['list']
        [widget.arguments['elementIndex']] = a;
    String jsonGroupDATA = json.encode(widget.arguments['allData']);
    prefs.setString('DATA', jsonGroupDATA);
    print(
        'aaaa:${widget.arguments['allData'][widget.arguments['groupindex']]['list'][widget.arguments['elementIndex']]}');
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        centerTitle: true,
        title: const Text(
          '轉帳明細',
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete_forever,
              size: 30,
            ),
            tooltip: '刪除',
            onPressed: () {
              showDialog<String>( //刪除警示窗
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
                              Navigator.of(context) //清除路由stack
                                ..pop
                                ..pop()
                                ..pop();
                              (Navigator.popAndPushNamed(context, '/tabs',
                                  arguments: {
                                    'index': widget.arguments['groupindex']
                                  }));
                            },
                            child: const Text('確定'),
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
              _editCheck = true;
              setState(() {});
            },
          ),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
              child: Column(
            children: [
              Expanded(
                  child: ListView(children: [
                TextFormField(
                  onChanged: (v) {
                    _transferAmount = v;
                    print('_transferAmount:$_transferAmount');
                    print('elementIndex:${widget.arguments['elementIndex']}');
                  },
                  onSaved: (v) {
                    _transferAmount = v;
                  },
                  initialValue: _transferAmount,
                  enabled: _editCheck,
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
                  children: _editCheck
                      ? [
                          InkWell(
                            onTap: _getDatePicker,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(_nowDate == null
                                    ? widget.arguments['detail']['date']
                                    : formatDate(_nowDate!,
                                        [yyyy, '年', mm, '月', dd, '日'])),
                                const Icon(Icons.arrow_drop_down),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: _getTimePicker,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text((_nowTime?.format(context) ??
                                    widget.arguments['detail']['time'])),
                                const Icon(Icons.arrow_drop_down),
                              ],
                            ),
                          ),
                        ]
                      : [
                          Text('${widget.arguments['detail']['date']}'),
                          const SizedBox(
                            width: 17,
                          ),
                          Text('${widget.arguments['detail']['time']}'),
                        ],
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField(
                    value: _remitter,
                    onSaved: (value) {},
                    items: widget.arguments['member']
                        .map<DropdownMenuItem<String>>((v) {
                      return DropdownMenuItem<String>(child: Text(v), value: v);
                    }).toList(),
                    onChanged: _editCheck
                        ? (value) {
                            _remitter = value.toString();
                            print(value);
                          }
                        : null,
                    decoration: const InputDecoration(
                      prefixIcon: Text(
                        '匯款人', //輸入框前綴文字
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      prefixIconConstraints: BoxConstraints(
                          minHeight: 25, minWidth: 100), // 輸入框前綴大小
                      hintText: '點擊選擇',
                    ),
                    icon: const Icon(
                      Icons.arrow_drop_down,
                    )),
                DropdownButtonFormField(
                    value: _receiver,
                    onSaved: (value) {},
                    items: widget.arguments['member']
                        .map<DropdownMenuItem<String>>((v) {
                      return DropdownMenuItem<String>(child: Text(v), value: v);
                    }).toList(),
                    onChanged: _editCheck
                        ? (value) {
                            _receiver = value.toString();
                            print(value);
                          }
                        : null,
                    decoration: const InputDecoration(
                      prefixIcon: Text(
                        '收款人', //輸入框前綴文字
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      prefixIconConstraints: BoxConstraints(
                          minHeight: 25, minWidth: 100), // 輸入框前綴大小
                      hintText: '點擊選擇',
                    ),
                    icon: const Icon(
                      Icons.arrow_drop_down,
                    )),
                TextFormField(
                  onChanged: (v) {
                    _note = v;
                  },
                  onSaved: (v) {
                    _note = v!;
                  },
                  initialValue: _note,
                  enabled: _editCheck,
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
                const SizedBox(
                  height: 30,
                ),
                _editCheck
                    ? _completeBtn()
                    : const SizedBox(
                        width: 1,
                      ),
                // _editCheck ? _completeBtn() : null,
              ])),
            ],
          ))),
    );
  }
}
