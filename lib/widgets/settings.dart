import 'package:flutter/material.dart';


class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text(
              'Temperature Units',
            ),
            isThreeLine: true,
            subtitle: Text(
              'Use metric measurements for temperature units.'
            ),
            trailing: Switch(
              value: true,
              onChanged: (_) {},
            ),
          )
        ],
      ),
    );
  }
}