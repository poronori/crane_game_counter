import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:intl/intl.dart';

import '../model/data_model_share.dart';

class AddItemPageShare extends StatefulWidget {
  const AddItemPageShare({Key? key}) : super(key: key);

  @override
  State<AddItemPageShare> createState() => _AddItemPageShareState();
}

class _AddItemPageShareState extends State<AddItemPageShare> {

  String name = '';
  String count = '';
  String cost = '';
  String store = '';

  final _scrollController = ItemScrollController();

  // タップしたフォームインデックス
  int _focusIndex = 0;

  @override
  Widget build(BuildContext context) {
    // 画面サイズ
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    // キーボードサイズ
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    // タップしたフォームにスクロール
    if (keyboardHeight != 0) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (_scrollController.isAttached) {
          _scrollController.scrollTo(
            index: _focusIndex,
            duration: const Duration(milliseconds: 200),
            curve: Curves.ease,
          );
        }
      });
    }

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      child: Column(
        children: [
          // 画面下げるようバー
          Container(
            width: width * 0.08,
            height: height * 0.005,
            margin: const EdgeInsets.only(top: 8, bottom:10),
            decoration: const BoxDecoration(
              color: Color(0xFFA59E9E),
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
            ),
          ),
          // ×ボタン
          Container(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(
                Icons.close,
                color: const Color(0xFF090444),
                size: width * 0.06
              ),
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Form(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: constraints.maxHeight,
                    ),
                    child: Container(
                      // キーボード分上げる
                      padding: EdgeInsets.only(bottom: keyboardHeight),
                      margin: const EdgeInsets.only(left: 5, right: 5),
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  color: Colors.amber,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  color: Colors.blue,
                                ),
                              ),
                              labelText: '名前',
                            ),
                            onChanged: (value) {
                              name = value;
                            },
                          ),
                          const Text('コスト'),
                          TextFormField(
                            onChanged: (value) {
                              cost = value;
                            },
                          ),
                          const Text('カウント'),
                          TextFormField(
                            onChanged: (value) {
                              count = value;
                            },
                          ),
                          const Text('店名'),
                          TextFormField(
                            onChanged: (value) {
                              store = value;
                            },
                          ),
                          // 追加ボタン
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.orange,
                              onPrimary: Colors.black,
                              elevation: 16
                            ),
                            onPressed: _saved,
                            child: const Text('保存'),
                          ),
                        ],
                      ),
                      ),
                    ),
                  );
              }
            ),
          ),
        ],
      ),
    );
  }

  void _saved() async {
    UnitData data = UnitData(
      datetime: DateFormat('yyyy-mm-dd').format(DateTime.now()),
      name: name,
      cost: cost,
      count: count,
      store: store
    );
    await data.insertData();
  }
}
