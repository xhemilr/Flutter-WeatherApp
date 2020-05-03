import 'package:flutter/material.dart';
import 'package:weather_app/util/utils.dart' as util;

class City extends StatefulWidget {
  @override
  _CityState createState() => _CityState();
}

class _CityState extends State<City> {
  var _cityTextController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text('Select City',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          TextField(
            controller: _cityTextController,
          ),
          RaisedButton(
            onPressed: () {
              Navigator.pop(context, {
                'city': _cityTextController.text == null ? util.defaultCity : _cityTextController.text
              });
            },
            child: Text(
              'Submit'
            ),
          )
        ],
      )
    );
  }
}

