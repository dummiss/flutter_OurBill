import 'package:flutter/material.dart';

class TransferDetail extends StatefulWidget {
  final arguments;
  const TransferDetail({Key? key, this.arguments}) : super(key: key);

  @override
  State<TransferDetail> createState() => _TransferDetailState();
}

class _TransferDetailState extends State<TransferDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
