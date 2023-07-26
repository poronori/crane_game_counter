import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';

import '../model/data_model_share.dart';

class EditItemPage extends StatefulWidget {

  UnitData data;
  EditItemPage({super.key, required this.data});

  @override
  State<EditItemPage> createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {

  String _date = '';
  String _storeName = '';
  String _name = '';
  String _cost = '';
  String _count = '';
  DateTime now = DateTime.now();

  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();

  Future<void> _selectDate(BuildContext context) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(_date),
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 2),
    );
    if (selected != null) {
      setState(() => _date = DateFormat('yyyy-MM-dd').format(selected));
    }
  }

  @override
  void initState() {
    super.initState();
    _date = widget.data.datetime;
    _storeName = widget.data.store;
    _name = widget.data.name;
    _cost = widget.data.cost;
    _count = widget.data.count;
  }

  @override
  Widget build(BuildContext context) {
    // 画面サイズ
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    // キーボードサイズ
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: height * 0.8,
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
          Expanded(
            child: Form (
              key: _formKey,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Container (
                  // キーボード分上げる
                  margin: const EdgeInsets.all(10),
                  padding: EdgeInsets.only(bottom: keyboardHeight),
                  child: Column(
                    children: [
                      // 日付
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: Row(
                          children: [
                            Text(
                              _date,
                              style: const TextStyle(fontSize: 18),
                            ),
                            IconButton(
                              icon: const Icon(Icons.date_range),
                              onPressed: () => _selectDate(context),
                            ),
                          ],
                        ),
                      ),

                      // 店名
                      SizedBox(
                        height: 80,
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
                          initialValue: _storeName,
                          onChanged: (value) {
                            _storeName = value;
                          },
                        ),
                      ),

                      // 名前
                      SizedBox(
                        height: 80,
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
                            labelText: '名前',
                          ),
                          initialValue: _name,
                          onChanged: (value) {
                            _name = value;
                          },
                        ),
                      ),

                      // 金額
                      SizedBox(
                        height: 80,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
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
                            labelText: '1プレイ料金',
                          ),
                          initialValue: _cost,
                          onChanged: (value) {
                            _cost = value;
                          },
                        ),
                      ),

                      // 回数
                      SizedBox(
                        height: 80,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
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
                            labelText: 'プレイ回数',
                          ),
                          initialValue: _count,
                          onChanged: (value) {
                            _count = value;
                          },
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // キャンセルボタン
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.grey,
                              elevation: 16,
                            ),
                            child: const Text('キャンセル'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          // 保存ボタン
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.black,
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
            ),
          ),
        ],
      ),
    );
  }

  void _saved() async {
    _formKey.currentState!.save();
    UnitData item = UnitData(
      datetime: _date,
      name: _name,
      cost: _cost,
      count: _count,
      store: _storeName,
    );
    Navigator.of(context).pop(item);
  }
}