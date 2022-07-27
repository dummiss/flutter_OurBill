import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart'; //日期格式化套件
import 'package:get/get.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/data_holder.dart';

class BillAdd extends StatefulWidget {
  final int? arguments; //接收tab傳過來的arguments:index參數

  const BillAdd({Key? key, this.arguments}) : super(key: key);
  @override
  State<BillAdd> createState() => _BillAddState();
}

class _BillAddState extends State<BillAdd> {
  final dataHolder = Get.find<DataHolder>();

  //分帳用
  final TextEditingController _totalPriceController =
      TextEditingController(); //紀錄金額控制器
  final TextEditingController _billNameController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _sharerController = TextEditingController();
  final TextEditingController _payerController = TextEditingController();

  bool checkBoxValue = false; //checkbox

  var _money = 0.0;
  late String _categoryValue;
  late String _noteValue;
  late String _billNameValue;
  late final int _peopleNum = dataFromSp['member'].length;
  late double _average = 0;

  void _countAverage(_money) {
    setState(() {
      _average = (double.parse(_money) / _peopleNum);
      if (_average.toString().split('.').length > 3) {
        _average.toStringAsFixed(2);
      }
    });
  }

  //初始化：先從SP讀取資料
  Map<String, dynamic> dataFromSp = {};
  @override
  void initState() {
    super.initState();
    _loadDATA();
  }

  final List<Widget> payer = [];
  final List<Widget> sharer = [];
  final List _payerMoney = [];
  final List _sharerMoney = [];

  //讀取資料
  Future<void> _loadDATA() async {
    dataHolder.loadDataFromSP();
    dataFromSp = dataHolder.data[widget.arguments!];
    debugPrint('ADD index:${widget.arguments}  dataFromSp: $dataFromSp');

    for (var name in dataFromSp['member']) {
      final payerTextField = TextFormField(
        controller: TextEditingController(),
        onSaved: (value) {
          value != ""
              ? _payerMoney.add(double.parse(value!))
              : _payerMoney.add(0);
        },
        decoration: InputDecoration(
            hintText: '請輸入金額', // 輸入提示
            prefixIcon: Text(
              name, //輸入框前綴文字
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
          controller: TextEditingController(),
          onSaved: (value) {
            value != ""
                ? _sharerMoney.add(double.parse(value!))
                : _sharerMoney.add(0);
          },
          decoration: InputDecoration(
              hintText: '請輸入金額', // 輸入提示
              prefixIcon: Text(
                name, //輸入框前綴文字
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
    for (var name in dataFromSp['member']) {
      if (checkBoxValue == true) {
        final sharerTextField = TextFormField(
            controller: TextEditingController()
              ..text = _average.toStringAsFixed(2),
            enabled: false,
            onSaved: (value) {
              value != ""
                  ? _sharerMoney.add(double.parse(value!))
                  : _sharerMoney.add(0);
            },
            decoration: InputDecoration(
                // 輸入提示
                prefixIcon: Text(
                  name, //輸入框前綴文字
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
            controller: TextEditingController(),
            onSaved: (value) {
              value != ""
                  ? _sharerMoney.add(double.parse(value!))
                  : _sharerMoney.add(0);
            },
            decoration: InputDecoration(
                hintText: '請輸入金額', // 輸入提示
                prefixIcon: Text(
                  name, //輸入框前綴文字
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
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2100));

    setState(() {
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
    dataHolder.data[widget.arguments!]['list'].add({
      "type": "bill",
      "date": formatDate(_nowDate ?? DateTime.now(), [yyyy, '-', mm, '-', dd]),
      "time": (_nowTime ?? TimeOfDay.now()).format(context),
      "billName": _billNameValue,
      "totalAmount": _money,
      "category": _categoryValue,
      "note": _noteValue,
      "payer": _payerMoney,
      "sharer": _sharerMoney,
    });
    dataHolder.saveDataToSP();
    debugPrint(
        "afterAddData['list'] :${dataHolder.data[widget.arguments!]['list']}");
  }

  //form提交
  final GlobalKey<FormState> _addFormKey = GlobalKey<FormState>();
  void _forSubmitted() {
    var _form = _addFormKey.currentState;

    _form!.save();
    _checkDebt();
  }

  //檢查金額
  _checkDebt() {
    num a = 0;
    for (var value in _payerMoney) {
      a += value;
    }
    if (a < _money || _money == 0) {
      _payerMoney.clear(); //重新清空
      _sharerMoney.clear();
      return showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title:
                    a < _money ? Text('付款總額 “少於” 總金額 $a') : const Text('請輸入金額'),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('確定'),
                  ),
                ],
              ));
    } else {
      _setData(); // 存資料到SP
      // Navigator.pop(context, true);
      (Navigator.popAndPushNamed(context, '/tabs',
          arguments: {'index': widget.arguments}));
      debugPrint("dataFormSp:${dataHolder.data}");
      // print(_groupName);
      // print(_member);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('新增紀錄'),
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
                      // onChanged: () {},
                      keyboardType: TextInputType.number,
                      onSaved: (v) {},
                      controller: _totalPriceController,
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
                      onChanged: (v) {
                        setState(() {
                          _money = double.parse(v);
                          _countAverage(v);
                          debugPrint(_money.toString());
                        });
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: _getDatePicker,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(formatDate(_nowDate ?? DateTime.now(),
                                  [yyyy, '-', mm, '-', dd])),
                              const Icon(Icons.arrow_drop_down),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: _getTimePicker,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text((_nowTime ?? TimeOfDay.now())
                                  .format(context)),
                              const Icon(Icons.arrow_drop_down),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField(
                        onSaved: (value) {
                          _categoryValue = value.toString();
                        },
                        items: _categoryItems.map((v) {
                          return DropdownMenuItem(child: Text(v), value: v);
                        }).toList(),
                        onChanged: (value) {
                          debugPrint(value.toString());
                        },
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
                          hintText: '點擊選擇',
                        ),
                        icon: const Icon(
                          Icons.arrow_drop_down,
                        )),
                    TextFormField(
                      onSaved: (v) {
                        _billNameValue = v ?? '';
                      },
                      controller: _billNameController,
                      decoration: const InputDecoration(
                          hintText: '點擊以編輯', // 輸入提示
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
                      onSaved: (v) {
                        _noteValue = v ?? '';
                      },
                      controller: _noteController,
                      decoration: const InputDecoration(
                          hintText: '點擊以編輯(選填)', // 輸入提示
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
                                                    value: checkBoxValue,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        checkBoxValue = value!;
                                                        updateSharer();
                                                        debugPrint(
                                                            '$value $_average');
                                                      });
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
                  ])),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _forSubmitted,
                          child: const Text('建立',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              )),
                          style: ElevatedButton.styleFrom(
                              primary: const Color.fromARGB(255, 249, 179, 93),
                              shadowColor:
                                  const Color.fromARGB(200, 249, 179, 93),
                              shape: const StadiumBorder(), //外觀
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 10)),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.popAndPushNamed(context, '/tabs',
                                arguments: {'index': widget.arguments});
                          },
                          child: const Text('取消',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              )),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.black12,
                              shadowColor: Colors.black38,
                              shape: const StadiumBorder(), //外觀
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 10)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ))),
    );
  }
}
