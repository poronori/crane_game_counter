import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sale_manager/model/data_model.dart';

class DataList extends StatefulWidget {
  final List<DataModel> dataList;

  const DataList({Key? key, required this.dataList}) : super(key: key);

  @override
  State<DataList> createState() => _DataList();
}

class _DataList extends State<DataList> {

  int id = 0;
  String text = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: ListView.builder(
        padding: const EdgeInsets.all(5),
        itemCount: widget.dataList.length,
        itemBuilder: (context, index) {
          final _data = widget.dataList[index];

          id = _data.id!;
          text = _data.text;

          final Widget _listItem = Dismissible(
            key: Key(id.toString()),
            onDismissed: (direction) {
              DataModel.deleteData(id);
            },
            child: Card(
              child: ListTile(
                leading: Text(id.toString()),
                title: Text(text),
              ),
            ),
          );
          return _listItem;
        },
      ),
    );
  }
}
