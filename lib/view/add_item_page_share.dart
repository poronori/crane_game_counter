import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:intl/intl.dart';

import '../model/data_model_share.dart';

class AddItemPageShare extends StatefulWidget {
  const AddItemPageShare({Key? key}) : super(key: key);

  @override
  State<AddItemPageShare> createState() => _AddItemPageShareState();
}

class _AddItemPageShareState extends State<AddItemPageShare> with AutomaticKeepAliveClientMixin {
  // 入力パラメータ
  // 日付
  String _date = DateFormat('yyyy-MM-dd').format(DateTime.now());
  // 店名
  String? _storeName;
  // 名前
  String? _name;
  // 金額
  int _cost = 100;
  // カウント
  int _count = 0;
  // 現在日時
  DateTime now = DateTime.now();

    // 選択済みの値を保持する
  int _selectedValue = 100;
  // ラジオボタンの入力フォームフラグ
  bool _formFlg = false;

  final ItemScrollController _scrollController = ItemScrollController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _costController = TextEditingController();

  // タップしたフォームインデックス
  int _focusIndex = 0;

  Future<void> _selectDate(BuildContext context) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 2),
    );
    if (selected != null) {
      setState(() => _date = DateFormat('yyyy-MM-dd').format(selected));
    }
  }

  @override
  bool get wantKeepAlive => true; // 値を保持する

  @override
  Widget build(BuildContext context) {
    // 画面サイズ
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    // キーボードサイズ
    //final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    // タップしたフォームにスクロール
    /*
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
    */

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
            margin: const EdgeInsets.only(top: 8, bottom: 10),
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
              icon: Icon(Icons.close,
                  color: const Color(0xFF090444), size: width * 0.06),
            ),
          ),
          SingleChildScrollView(
            child: LayoutBuilder(builder: (context, constraints) {
              return Form(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: constraints.maxHeight,
                  ),
                  child: Container(
                    // キーボード分上げる
                    //padding: EdgeInsets.only(bottom: keyboardHeight),
                    margin: const EdgeInsets.only(left: 5, right: 5),
                    child: Column(
                      // 中央揃え
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            // 日付
                            Text(
                              _date,
                              style: const TextStyle(fontSize: 18),
                            ),
                            IconButton(
                              icon: const Icon(Icons.date_range),
                              onPressed: () => _selectDate(context),
                            ),

                            // 店名
                            Expanded(
                              child: SizedBox(
                                width: 200,
                                child: TextFormField(
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
                                    labelText: '店名',
                                  ),
                                  onChanged: (value) {
                                    _storeName = value;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),

                        // 名前入力フォーム
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _nameController,
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
                            _name = value;
                          },
                        ),

                        // 金額入力フォーム
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // 100円
                            Row(
                              children: [
                                Radio(
                                  groupValue: _selectedValue,
                                  value: 100,
                                  onChanged: (int? value) {
                                    setState(() {
                                      _selectedValue = value!;
                                      _cost = 100;
                                      _formFlg = false;
                                    });
                                  },
                                ),
                                const Text('100円'),
                              ],
                            ),

                            // 200円
                            Row(
                              children: [
                                Radio(
                                  groupValue: _selectedValue,
                                  value: 200,
                                  onChanged: (int? value) {
                                    setState(() {
                                      _selectedValue = value!;
                                      _cost = 200;
                                      _formFlg = false;
                                    });
                                  },
                                ),
                                const Text('200円'),
                              ],
                            ),

                            // 任意入力
                            Row(
                              children: [
                                Radio(
                                  groupValue: _selectedValue,
                                  value: 0,
                                  onChanged: (int? value) {
                                    setState(() {
                                      _selectedValue = value!;
                                      _formFlg = true;
                                    });
                                  },
                                ),
                                SizedBox(
                                  width: 100,
                                  child: _costForm(),
                                ),
                                const Text('円'),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // マイナスボタン
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.red,
                                  onPrimary: Colors.black,
                                  shape: const CircleBorder(
                                    side: BorderSide(
                                        color: Colors.black,
                                        width: 1,
                                        style: BorderStyle.solid),
                                  ),
                                  fixedSize: const Size(50, 50)),
                              child: const Text('-',
                                  style: TextStyle(fontSize: 40)),
                              onPressed: () {
                                setState(() {
                                  if (_count > 0) {
                                    _count--;
                                  }
                                });
                              },
                            ),

                            // カウントボタン
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                onPrimary: Colors.black,
                                shape: const CircleBorder(
                                  side: BorderSide(
                                      color: Colors.black,
                                      width: 1,
                                      style: BorderStyle.solid),
                                ),
                              ),
                              child: Stack(
                                children: <Widget>[
                                  const ClipOval(
                                    child: Image(
                                      width: 200,
                                      image:
                                          AssetImage('images/rennai_kaeruka.png'),
                                      fit: BoxFit.scaleDown,
                                    ),
                                  ),
                                  Container(
                                    width: 100,
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(_count.toString(),
                                        textAlign: TextAlign.right,
                                        style: const TextStyle(fontSize: 60)),
                                  )
                                ],
                              ),
                              onPressed: () {
                                setState(() {
                                  _count++;
                                });
                              },
                            ),
                            const SizedBox(width: 50),
                          ],
                        ),

                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // キャンセルボタン
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.orange,
                                onPrimary: Colors.black,
                                elevation: 16,
                              ),
                              child: const Text('キャンセル'),
                              onPressed: () {
                                setState(() {
                                  _count = 0;
                                });
                              },
                            ),

                            // 保存ボタン
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.orange,
                                onPrimary: Colors.black,
                                elevation: 16,
                              ),
                              onPressed: _saved,
                              child: const Text('保存'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  void _saved() async {
    // 結果保存用
    UnitData item = UnitData(
      datetime: _date,
      name: _name ?? '名前なし',
      cost: _cost.toString(),
      count: _count.toString(),
      store: _storeName ?? '不明',
    );

    showDialog<Widget>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('確認'),
        content: const Text('保存しました'),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('キャンセル'),
          ),
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () {
              setState(() {
                _nameController.text = '';
                _count = 0;
                item.insertData();
              });
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  // 金額入力フォーム
  Widget _costForm() {
    return TextFormField(
      enabled: _formFlg, // ラジオボタンが押されたら活性化
      controller: _costController,
      keyboardType: TextInputType.number,
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
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
        ),
        labelText: '金額',
      ),
      onSaved: (value) {
        if (_formFlg) {
          _cost = int.parse(value!);
        }
      },
    );
  }
}
