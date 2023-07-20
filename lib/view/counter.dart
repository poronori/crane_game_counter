import 'package:crane_game_counter/main.dart';
import 'package:crane_game_counter/models/item_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class Counter extends StatefulWidget {
  const Counter({Key? key}) : super(key: key);

  @override
  State<Counter> createState() => _CounterState();
}

/// 画面を切り替えても値を保持する
class _CounterState extends State<Counter> with AutomaticKeepAliveClientMixin {
  // 入力パラメータ
  // 日付
  String _date = DateFormat('yyyy/MM/dd').format(DateTime.now());
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
  int _selectedValue = 1;
  // ラジオボタンの入力フォームフラグ
  bool _formFlg = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _costController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> _selectDate(BuildContext context) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 2),
    );
    if (selected != null) {
      setState(() => _date = DateFormat('yyyy/MM/dd').format(selected));
    }
  }

  @override
  bool get wantKeepAlive => true; // 値を保持する

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
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
                      onSaved: (value) {
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
              onSaved: (value) {
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
                  child: const Text('-', style: TextStyle(fontSize: 40)),
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
                          image: AssetImage('asset/buttonImage.jpg'),
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
    );
  }

  void _saved() {
    _formKey.currentState!.save();
    // 結果保存用
    final _item = ItemList(
      date: _date,
      name: _name,
      cost: _cost,
      count: _count,
      storeName: _storeName,
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
              });
              context.read(itemProvider).addItem(_item);
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
