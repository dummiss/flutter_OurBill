import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart'; //日期格式化套件
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TransferEdit extends StatefulWidget {
  final List allDATA;
  final int index;
  final Map data;
  const TransferEdit(
    this.allDATA,
    this.index,
    this.data, {
    Key? key,
  }) : super(key: key);

  @override
  State<TransferEdit> createState() => _TransferEditState();
}

class _TransferEditState extends State<TransferEdit> {
  //form提交
  final GlobalKey<FormState> _addFormKey = GlobalKey<FormState>();
  final TextEditingController _transfermoneyController =
      TextEditingController();
  final TextEditingController _transnoteController = TextEditingController();

  final List transferList = [];
  var _transferAmount;
  var note;
  late String _remitter = '';
  late String _receiver = '';
  late String owner = widget.allDATA[widget.index]['member'][0];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    for (int i = 0; i < widget.allDATA[widget.index]['member'].length; i++) {
      transferList.add(0);
    }
    print(transferList);
  }

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
        initialDate: (_nowDate ?? DateTime.now()),
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

  void _forSubmitted() {
    var _form = _addFormKey.currentState;
    _form!.save();
    _setData(); // 存資料到SP
    Navigator.of(context)
      ..pop
      ..pop(); //清除路由stack
    (Navigator.popAndPushNamed(context, '/tabs',
        arguments: {'index': widget.index}));
  }

  //存資料進Ps裡
  Future<void> _setData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    widget.allDATA[widget.index]['list'].add({
      "type": "transfer",
      "billName": "$_remitter 付給 $_receiver",
      "date": formatDate(_nowDate ?? DateTime.now(), [yyyy, '-', mm, '-', dd]),
      "time": (_nowTime ?? TimeOfDay.now()).format(context),
      "remitter": _remitter,
      "receiver": _receiver,
      "Amount": _transferAmount,
      "transferList": transferList,
      "note": note,
    });
    String jsonGroupDATA = json.encode(widget.allDATA);
    prefs.setString('DATA', jsonGroupDATA);
    print(widget.allDATA[widget.index]['list']);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _addFormKey,
      child: Container(
        padding: const EdgeInsets.only(top: 10, right: 20, left: 20),
        height: 550,
        decoration: const BoxDecoration(),
        child: Center(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close)),
                  const Text(
                    '結清債務',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: const Color.fromARGB(255, 249, 179, 93),
                        shadowColor: const Color.fromARGB(200, 249, 179, 93),
                        shape: const StadiumBorder(), //外觀
                      ),
                      onPressed: _forSubmitted,
                      child: const Text(
                        '完成',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ))
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                onChanged: (v) {
                  _transfermoneyController.text = v;
                },
                onSaved: (v) {
                  _transferAmount = _transfermoneyController.text;
                },
               initialValue:_transfermoneyController.text='${widget.data['pay']}',
                textAlign: TextAlign.end,
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
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
                    prefixIconConstraints:
                        BoxConstraints(minHeight: 25, minWidth: 100) // 輸入框前綴圖標
                    ),
                keyboardType: TextInputType.number,
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
                        Text((_nowTime ?? TimeOfDay.now()).format(context)),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField(
                  value: widget.data['payer'],
                  onSaved: (value) {
                    _remitter = value.toString();
                    //test 整理成[0,0,0,200]格式
                    transferList[widget.allDATA[widget.index]['member']
                        .indexOf(value)] = double.parse(_transfermoneyController.text );
                    print('_transferAmount:$_transferAmount');
                    print('transferList:$transferList');
                  },
                  items: widget.allDATA[widget.index]['member']
                      .map<DropdownMenuItem<String>>((v) {
                    return DropdownMenuItem<String>(child: Text(v == owner ? '$v (我)' : v), value: v);
                  }).toList(),
                  onChanged: (value) {

                    print(value);
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Text(
                      '匯款人', //輸入框前綴文字
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    prefixIconConstraints:
                        BoxConstraints(minHeight: 25, minWidth: 100), // 輸入框前綴大小
                    hintText: '點擊選擇',
                  ),
                  icon: const Icon(
                    Icons.arrow_drop_down,
                  )),
              DropdownButtonFormField(
                  value: widget.data['receiver'],
                  onSaved: (value) {
                    _receiver = value.toString();
                    transferList[widget.allDATA[widget.index]['member']
                        .indexOf(value)] = -double.parse(_transfermoneyController.text );

                    print(transferList);
                  },
                  items: widget.allDATA[widget.index]['member']
                      .map<DropdownMenuItem<String>>((v) {
                    return DropdownMenuItem<String>(child: Text(v == owner ? '$v (我)' : v), value: v);
                  }).toList(),
                  onChanged: (value) {
                    print(value);
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Text(
                      '收款人', //輸入框前綴文字
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    prefixIconConstraints:
                        BoxConstraints(minHeight: 25, minWidth: 100), // 輸入框前綴大小
                    hintText: '點擊選擇',
                  ),
                  icon: const Icon(
                    Icons.arrow_drop_down,
                  )),
              TextFormField(
                onChanged: (v) {
                  _transnoteController.text = v;
                },
                onSaved: (v) {
                  note = _transnoteController.text;
                },
                controller: _transnoteController,
                decoration: const InputDecoration(
                    hintText: '點擊以編輯(選填)', // 輸入提示
                    prefixIcon: Text(
                      '備註', //輸入框前綴文字
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    prefixIconConstraints:
                        BoxConstraints(minHeight: 25, minWidth: 100) // 輸入框前綴大小
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
