import 'dart:io';
import 'package:crane_game_counter/main.dart';
import 'package:crane_game_counter/view/edit_item_page.dart';
import 'package:crane_game_counter/models/item_list.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:crane_game_counter/view/add_item_page.dart';

class ResultList extends StatefulWidget {
  const ResultList({Key? key}) : super(key: key);

  @override
  State<ResultList> createState() => _ResultListState();
}

class _ResultListState extends State<ResultList> {
  // 表示項目
  String _date = ''; // 日付
  String? _name = ''; // 景品名
  String _cost = ''; // プレイ料金
  String _count = ''; // プレイ回数
  String _amount = ''; // 合計金額
  String? _storeName = ''; // 店名

  @override
  Widget build(BuildContext context) {
    final _picker = ImagePicker();
    File? _image;

    // アイテムリストの取得
    final _itemList = context.read(itemProvider).getItemList();

    // その日最後のアイテムindex
    final _indexesLastItem = <int>[];
    for (var i = 1; i < _itemList.length; i++) {
      if (_itemList[i - 1].date != _itemList[i].date) {
        _indexesLastItem.add(i - 1);
      }
    }
    _indexesLastItem.add(_itemList.length - 1);

    // 画像の取得
    Future<void> _insertImage() async {
      final image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          _image = File(image.path);
        });
      }
    }

    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(5),
        child: ListView.builder(
          padding: const EdgeInsets.all(5),
          itemCount: _itemList.length,
          itemBuilder: (context, index) {
            final _item = _itemList[index];
            // 表示項目を取得
            _date = _item.date;
            _name = _item.name;
            _cost = _item.cost.toString();
            _count = _item.count.toString();
            _amount = _item.amount.toString();
            _storeName = _item.storeName;
            _image = _item.image;

            // 日付を跨ぐか判定
            var isFirst = index == 0;
            var isLast = false;
            for (final lastIndex in _indexesLastItem) {
              if (lastIndex == index) {
                isLast = true;
              } else if ((lastIndex + 1) == index) {
                isFirst = true;
              }
            }

            // アイテムリスト表示
            final Widget _listItem = Dismissible(
              key: Key(_name!),
              onDismissed: (direction) {
                context.read(itemProvider).removeItem(_item); // スワイプで削除
              },
              child: Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.only(left: 5, right: 2),
                  // 写真
                  leading: GestureDetector(
                    // タップ時の処理
                    onTap: () => _insertImage,
                    child: (_image != null)
                        ? Image.file(_image!, fit: BoxFit.cover)
                        : Container(
                            height: 200,
                            width: 50,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.blue)),
                          ),
                  ),

                  // 景品名
                  title: Text(
                    _name ?? '', // nullの場合は空文字
                    style: const TextStyle(fontSize: 30),
                    overflow: TextOverflow.ellipsis, // 名前が長すぎる場合は切る
                  ),

                  // 店名、プレイ料金、手数
                  subtitle: Row(
                    children: [
                      SizedBox(
                        width: 80,
                        child: Text(_storeName ?? '',
                            overflow: TextOverflow.ellipsis),
                      ),
                      Container(
                        width: 40,
                        alignment: Alignment.centerRight,
                        child: Text('$_cost円', overflow: TextOverflow.ellipsis),
                      ),
                      Container(
                        width: 40,
                        alignment: Alignment.centerRight,
                        child:
                            Text('$_count手', overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),

                  // 合計金額
                  trailing: Container(
                    width: 100,
                    alignment: Alignment.centerRight, // 右寄せ
                    child: Text(
                      '$_amount円',
                      style: const TextStyle(fontSize: 30),
                    ),
                  ),

                  // タップ時操作
                  onTap: () {
                    Navigator.of(context).push<MaterialPageRoute<Widget>>(
                        MaterialPageRoute(
                            builder: (context) =>
                                EditItemPage(item: _item)));
                  },
                ),
              ),
            );

            // その日の最初のアイテムは日付表示
            if (isFirst) {
              return Column(
                children: [
                  Container(
                      margin: const EdgeInsets.only(top: 20, bottom: 8),
                      child: Container(
                          padding: const EdgeInsets.only(
                              top: 3, bottom: 4, left: 18, right: 18),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey[800]!.withOpacity(0.35),
                          ),
                          child: Text(
                            _date,
                            style: const TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ))),
                  _listItem,
                ],
              );
            } else {
              return _listItem;
            }
          },
        ),
      ),

      // アイテム追加ボタン
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
            builder: (context) => const AddItemPage(),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
