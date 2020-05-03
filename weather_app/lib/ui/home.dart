import 'dart:convert';

import 'package:weather_app/ui/city.dart';
import 'package:weather_app/util/utils.dart' as util;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String city;

  Future _goToNextScreen(BuildContext context) async{
    Map results = await Navigator.of(context).push(
      new MaterialPageRoute(
          builder: (BuildContext context){
            return new City();
          }
      )
    );
    if(results != null && results.containsKey('city')){
      city = results['city'];
      setState(() {
        updateTempWidget(results['city']);
      });
      print(results['city'].toString());
    }else{
      print('nothing');
    }
  }

  void showStuff() async{
    Map data = await getWeather(util.defaultCity);
    print(data.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text(
          'Weather App',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: ()=> _goToNextScreen(context),
          )
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Image.asset(
                'assets/images/umbrella.png',
                height: 1200,
                fit: BoxFit.fill,
            ),
          ),
          Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0, 50, 40, 0),
            child: Text(
              '${city == null ? util.defaultCity : city}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.w700
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Image.asset('assets/images/light_rain.png'),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.fromLTRB(60, 280, 0, 0),
            child: updateTempWidget('${city == null ? util.defaultCity : city}')
          )
        ],
      ),
    );
  }

  Future<Map> getWeather(String city) async{
    print(city);
    String apiUrl =
        'http://api.openweathermap.org/data/2.5/weather?q='
        '$city'
        '&appid=${util.appId}'
        '&units=${util.unit}';

    http.Response data = await http.get(apiUrl);

    return json.decode(data.body);
  }

  Widget updateTempWidget(String city){
    return FutureBuilder(
      future: getWeather(city == null ? util.defaultCity : city),
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
        if(snapshot.hasData){
          Map content = snapshot.data;
          return Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.fromLTRB(0, 180, 0, 0),
            child: new Column(
              children: [
                ListTile(
                  title: Text(
                    'Temp: ${content['main']['temp']} °C',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Colors.white
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Min: ${content['main']['temp_min']} °C',
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Colors.white
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Max: ${content['main']['temp_max']} °C',
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Colors.white
                    ),
                  ),
                )
              ],
            ),
          );
        }
        else{
          return Center(child: CircularProgressIndicator(),);
        }
      }
    );
  }
}