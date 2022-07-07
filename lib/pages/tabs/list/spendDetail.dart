import 'package:flutter/material.dart';

import 'package:date_format/date_format.dart'; //日期格式化套件
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SpendDetail extends StatefulWidget {
  final arguments;
  SpendDetail({Key? key, this.arguments}) : super(key: key);
  /*
  arguments: {
    'allData': _AllDATA,
    'groupindex':widget.arguments,
    'member': _AllDATA[widget.arguments] ['member'],
    'detail': element,
    'elementIndex':index,
 });
  */

  @override
  State<SpendDetail> createState() => _SpendDetailState();
}

class _SpendDetailState extends State<SpendDetail> {
  bool _editCheck = false;
  //分帳用
  // final TextEditingController _totalPriceController =
  //     TextEditingController(); //紀錄金額控制器
  // final TextEditingController _billNameController = TextEditingController();
  // final TextEditingController _noteController = TextEditingController();
  // final TextEditingController _sharerController = TextEditingController();
  // final TextEditingController _payerController = TextEditingController();

  bool CheckboxValue = false; //checkbox

  late var _money = widget.arguments['detail']['totalAmount'];
  late String _categoryValue = widget.arguments['detail']['category'];
  late String _noteValue = widget.arguments['detail']['note'];
  late String _billNameValue = widget.arguments['detail']['billName'];
  late final int _peopleNum = widget.arguments['member'].length;
  late double _average;

  final List<Widget> payer = [];
  final List<Widget> sharer = [];
  List _payerMoney = [];
  List _sharerMoney = [];

  //初始化
  @override
  void initState() {
    super.initState();
    _creatwhiteArea(_editCheck);
    _countaverang(_money);
  }

  void _countaverang(_money) {
    setState(() {
      _average = (_money/ _peopleNum);
      if (_average.toString().split('.').length > 3) {
        _average.toStringAsFixed(2);
      }
    });
  }

  //讀取資料
  _creatwhiteArea(_editCheck) {
    payer.clear();
    sharer.clear();
    for (int i = 0; i < widget.arguments['member'].length; i++) {
      final payerTextField = TextFormField(
        initialValue: widget.arguments['detail']['payer'][i].toString(),
        enabled: _editCheck,
        onSaved: (value) {
          value != ""
              ? _payerMoney.add(double.parse(value!))
              : _payerMoney.add(0);
        },
        decoration: InputDecoration(
            hintText: '請輸入金額', // 輸入提示
            prefixIcon: Text(
              widget.arguments['member'][i], //輸入框前綴文字
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
            prefixIconConstraints:
                const BoxConstraints(minHeight: 20, minWidth: 100) // 輸入框前綴大小
            ),
      );
      final sharerTextField = TextFormField(
          initialValue: widget.arguments['detail']['sharer'][i].toString(),
          enabled: _editCheck,
          onSaved: (value) {
            value != ""
                ? _sharerMoney.add(double.parse(value!))
                : _sharerMoney.add(0);
          },
          decoration: InputDecoration(
              hintText: '請輸入金額', // 輸入提示
              prefixIcon: Text(
                widget.arguments['member'][i], //輸入框前綴文字
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
              prefixIconConstraints:
                  const BoxConstraints(minHeight: 20, minWidth: 100) // 輸入框前綴大小
              ));
      payer.add(payerTextField);
      sharer.add(sharerTextField);
    }
    setState(() {});
  }

  updateSharer() {
    sharer.clear();
    for (int i = 0; i < widget.arguments['member'].length; i++) {
      if (CheckboxValue == true) {
        final sharerTextField = TextFormField(
            controller: TextEditingController()..text = "$_average",
            enabled: false,
            onSaved: (value) {
              value != ""
                  ? _sharerMoney.add(double.parse(value!))
                  : _sharerMoney.add(0);
            },
            decoration: InputDecoration(
                // 輸入提示
                prefixIcon: Text(
                  widget.arguments['member'][i], //輸入框前綴文字
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                prefixIconConstraints: const BoxConstraints(
                    minHeight: 20, minWidth: 100) // 輸入框前綴大小
                ));
        sharer.add(sharerTextField);
      } else {
        final sharerTextField1 = TextFormField(
            // initialValue: widget.arguments['detail']['sharer'][i].toString(),
            enabled: true,
            onSaved: (value) {
              value != ""
                  ? _sharerMoney.add(double.parse(value!))
                  : _sharerMoney.add(0);
            },
            decoration: InputDecoration(
                hintText: '請輸入金額', // 輸入提示
                prefixIcon: Text(
                  widget.arguments['member'][i], //輸入框前綴文字
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                prefixIconConstraints: const BoxConstraints(
                    minHeight: 20, minWidth: 100) // 輸入框前綴大小
                ));
        sharer.add(sharerTextField1);
      }
    }
    return sharer;
  }

  //類別選項
  final List _categoryItems = ['食物', '飲料', '交通', '住宿', '購物', '其他'];

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

  //  存資料進Ps裡
  Future<void> _setData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var a = widget.arguments['detail'];
    widget.arguments['detail'] = {
      "type": "bill",
      "date":  formatDate(_nowDate ?? DateTime.now(), [yyyy, '-', mm, '-', dd]),
      "time": (_nowTime ?? TimeOfDay.now()).format(context),
      "billName": _billNameValue,
      "totalAmount": _money,
      "category": _categoryValue,
      "note": _noteValue,
      "payer": _payerMoney,
      "sharer": _sharerMoney,
    };
    widget.arguments['allData'][widget.arguments['groupindex']]['list']
    [widget.arguments['elementIndex']]=widget.arguments['detail'];
    String jsonGroupDATA = json.encode(widget.arguments['allData']); //轉json
    prefs.setString('DATA', jsonGroupDATA);

    print("jsonGroupDATA:${ widget.arguments['allData'][widget.arguments['groupindex']]['list']
    [widget.arguments['elementIndex']]}");

  }

  //form提交
  final GlobalKey<FormState> _addFormKey = GlobalKey<FormState>();
  void _forSubmitted() {
    var _form = _addFormKey.currentState;
    _form!.save();
    _setData(); // 存資料到SP
    _editCheck = false;
    setState((){});
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
                  child: const Text('CANCEL'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle:true,
        title: const Text(
          '消費明細',
        ),
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
              _creatwhiteArea(_editCheck);
              setState(() {});
            },
          ),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
              key: _addFormKey, //設置globalKey，用於後面獲取FormState
              child: Column(
                children: [
                  Expanded(
                      child: ListView(children: [
                    TextFormField(
                      onChanged: (v) {
                        setState(() {
                          _money =  int.parse(v);
                          _countaverang(_money);
                          print(_money);
                        });
                      },
                      enabled: _editCheck,
                      initialValue: widget.arguments['detail']['totalAmount'].toString(),
                      onSaved: (v) {
                        _money = v;
                      },
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.w700),
                      decoration: const InputDecoration(
                          hintText: '點擊以編輯', // 輸入提示
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
                        value: widget.arguments['detail']['category'] == 'null'
                            ? null
                            : widget.arguments['detail']['category'],
                        onSaved: (value) {
                          _categoryValue = value.toString();
                        },
                        items: _categoryItems.map((v) {
                          return DropdownMenuItem(child: Text(v), value: v);
                        }).toList(),
                        onChanged: _editCheck
                            ? (value) {
                                _categoryValue = value.toString();
                              }
                            : null,
                        decoration: const InputDecoration(
                          prefixIcon: Text(
                            '類別', //輸入框前綴文字
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          prefixIconConstraints: BoxConstraints(
                              minHeight: 25, minWidth: 100), // 輸入框前綴大小
                        ),
                        icon: const Icon(
                          Icons.arrow_drop_down,
                        )),
                    TextFormField(
                      initialValue: widget.arguments['detail']['billName'],
                      enabled: _editCheck,
                      onSaved: (v) {
                        _billNameValue = v ?? '';
                      },
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
                      initialValue: widget.arguments['detail']['note'],
                      enabled: _editCheck,
                      onSaved: (v) {
                        _noteValue = v ?? '';
                      },
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
                        margin:
                            const EdgeInsets.only(top: 50, left: 10, right: 10),
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
                              margin:
                                  const EdgeInsets.only(right: 20, left: 20),
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.black26, width: 1))),
                              padding:
                                  const EdgeInsets.only(top: 20, bottom: 20),
                              child: Column(
                                children: [
                                  Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Expanded(
                                          flex: 2,
                                          child: Text(
                                            '付款人',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: Column(
                                            children: payer,
                                          ),
                                        ),
                                      ]),
                                ],
                              )),
                          Container(
                              margin:
                                  const EdgeInsets.only(right: 20, left: 20),
                              padding:
                                  const EdgeInsets.only(top: 20, bottom: 20),
                              child: Column(
                                children: [
                                  Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Expanded(
                                          flex: 2,
                                          child: Text(
                                            '分帳人',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                            flex: 5,
                                            child: Column(
                                              children: [
                                                Row(children: [
                                                  const Text('平分'),
                                                  Checkbox(
                                                    value: CheckboxValue,
                                                    onChanged: (value) {
                                                      _editCheck
                                                          ? setState(() {
                                                              _countaverang(_money);
                                                              CheckboxValue =
                                                                  value!;
                                                              _countaverang(_money);
                                                              updateSharer();
                                                              debugPrint(
                                                                  '$value $_average');
                                                            })
                                                          : null;
                                                    },
                                                  ),
                                                ]),
                                                Column(
                                                  children: sharer,
                                                )
                                              ],
                                            ))
                                      ]),
                                ],
                              )),
                        ])),
                    const SizedBox(
                      height: 30,
                    ),
                    _editCheck
                        ? _completeBtn()
                        : const SizedBox(
                            width: 1,
                          ),
                  ])),
                ],
              ))),
    );
  }
}
