import 'package:flutter/material.dart';

class SpendDetail extends StatefulWidget {
  int? data;
  SpendDetail({Key? key}) : super(key: key);

  @override
  State<SpendDetail> createState() => _SpendDetailState();
}

class _SpendDetailState extends State<SpendDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                  enabled: false,
                  controller: TextEditingController()..text = "money",
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
                  children: [
                    Text('2020-2-20'),
                    Text('11:20 pm'),
                  ],
                ),
                const SizedBox(height: 10),
                TextFormField(
                  enabled: false,
                  controller: TextEditingController()..text = "billname",
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
                  enabled: false,
                  controller: TextEditingController()..text = "category",
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
                  enabled: false,
                  controller: TextEditingController()..text = "note",
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
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: Column(
                                          // children: payer,
                                          ),
                                    ),
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
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        flex: 5,
                                        child: Column(
                                            // children: sharer,
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
