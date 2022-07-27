import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart'; //日期格式化套件
import 'package:get/get.dart';

import '../../../data/data_holder.dart';

class TransferEdit extends StatefulWidget {
  final List allDataFromPreviousPage;
  final int index;
  final Map singleDebtDetail;
  const TransferEdit(
    this.allDataFromPreviousPage,
    this.index,
    this.singleDebtDetail, {
    Key? key,
  }) : super(key: key);

  @override
  State<TransferEdit> createState() => _TransferEditState();
}

class _TransferEditState extends State<TransferEdit> {
  //GetX
  final dataHolder = Get.find<DataHolder>();
  //form提交
  final GlobalKey<FormState> addFormKey = GlobalKey<FormState>();
  final TextEditingController transferMoneyController = TextEditingController();
  final TextEditingController transNoteController = TextEditingController();

  final List transferList = [];
  late String transferAmount = '';
  late String note = '';
  late String remitter = '';
  late String receiver = '';
  late String owner = widget.allDataFromPreviousPage[widget.index]['member'][0];

  @override
  void initState() {
    super.initState();

    for (int i = 0;
        i < widget.allDataFromPreviousPage[widget.index]['member'].length;
        i++) {
      transferList.add(0);
    }
    debugPrint('$transferList');
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
    var _form = addFormKey.currentState;
    _form!.save();
    _setData(); // 存資料到SP
    Navigator.of(context)
      ..pop
      ..pop(); //清除路由stack
    (Navigator.popAndPushNamed(context, '/tabs',
        arguments: {'index': widget.index}));
  }

  //存資料進Ps裡fn
  Future<void> _setData() async {
    dataHolder.data[widget.index]['list'].add({
      "type": "transfer",
      "billName": "$remitter 付給 $receiver",
      "date": formatDate(_nowDate ?? DateTime.now(), [yyyy, '-', mm, '-', dd]),
      "time": (_nowTime ?? TimeOfDay.now()).format(context),
      "remitter": remitter,
      "receiver": receiver,
      "Amount": transferAmount,
      "transferList": transferList,
      "note": note,
    });
    dataHolder.saveDataToSP();
    debugPrint('afterSaveData:${dataHolder.data}');
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: addFormKey,
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
                  transferMoneyController.text = v;
                },
                onSaved: (v) {
                  transferAmount = transferMoneyController.text;
                },
                initialValue: transferMoneyController.text =
                    '${widget.singleDebtDetail['payAmount']}',
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
                  value: widget.singleDebtDetail['payer'],
                  onSaved: (value) {
                    remitter = value.toString();
                    //test 整理成[0,0,0,200]格式
                    transferList[widget.allDataFromPreviousPage[widget.index]
                                ['member']
                            .indexOf(value)] =
                        double.parse(transferMoneyController.text);
                    debugPrint('_transferAmount:$transferAmount');
                    debugPrint('transferList:$transferList');
                  },
                  items: widget.allDataFromPreviousPage[widget.index]['member']
                      .map<DropdownMenuItem<String>>((v) {
                    return DropdownMenuItem<String>(
                        child: Text(v == owner ? '$v (我)' : v), value: v);
                  }).toList(),
                  onChanged: (value) {
                    debugPrint('$value');
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
                  value: widget.singleDebtDetail['receiver'],
                  onSaved: (value) {
                    receiver = value.toString();
                    transferList[widget.allDataFromPreviousPage[widget.index]
                                ['member']
                            .indexOf(value)] =
                        -double.parse(transferMoneyController.text);

                    debugPrint('$transferList');
                  },
                  items: widget.allDataFromPreviousPage[widget.index]['member']
                      .map<DropdownMenuItem<String>>((v) {
                    return DropdownMenuItem<String>(
                        child: Text(v == owner ? '$v (我)' : v), value: v);
                  }).toList(),
                  onChanged: (value) {
                    debugPrint('$value');
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
                  transNoteController.text = v;
                },
                onSaved: (v) {
                  note = transNoteController.text;
                },
                controller: transNoteController,
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
