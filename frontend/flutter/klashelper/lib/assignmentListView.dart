import 'package:flutter/material.dart';

class AssignmentListView {
  bool _lights = true;
  int a = 1;
  List<Widget> getList(position) {
    List<Widget> list = <Widget>[
      new Divider(),
      new SwitchListTile(
        value: _lights,
        onChanged: setSwitchState,
        title: new Text(position.toString(),
            style: new TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0)),
        subtitle: new Text('마감기한', style: new TextStyle(fontSize: 10.0)),
        secondary: const Icon(Icons.lightbulb_outline),
      ),
      new Divider(),
      new ListTile(
        isThreeLine: true,
        title: new Text(position.toString() ,
            style: new TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0)),
        subtitle: new Text('데이터 센터 프로그래밍', style: new TextStyle(fontSize: 10.0)),
        trailing: new Text('\n마감기한', style: new TextStyle(fontSize: 10.0)),
      ),
      new Divider(),
      new SwitchListTile(
        isThreeLine: true,
        value: _lights,
        onChanged: setSwitchState,
        title: new Text(position.toString(),
            style: new TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0)),
        subtitle: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text('데이터 센터 프로그래밍', style: new TextStyle(
                fontWeight: FontWeight.w900, fontSize: 15.0, color: Colors.black)),
            new Text('\n마감 기한', style: new TextStyle(fontSize: 10.0)),
          ],
        ),
      ),
      new Divider(),
    ];
    return list;
  }

  void setSwitchState(bool value) {
    _lights = value;
  }
}
