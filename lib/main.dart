import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData.dark(),
      home: WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String description = '';
  double temperature = 0;
  String cityName = '';
  double wind = 0;
  int humidity = 0;
  int pressure = 0;

  void getLocation() async {
    print('inside Get Locaiton');
    Response response;
    Position position;
    try {
      position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      response = await http.get(
          'https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=f55b9a16a1e6e4bd7178f52aed5b4af9');
    } catch (e) {
      print(e.toString());
      setState(() {
        _passed = false;
        _isLoading = false;
      });
    }

    var data = jsonDecode(response.body);
    print(data);
    //description = data['weather'][0]['main'];
    if (data != null && !data.toString().contains('error')) {
      setState(() {
        temperature = data['main']['temp'] - 273;
        cityName = data['name'];
        description = data['weather'][0]['main'];
        wind = data['wind']['speed'];
        humidity = data['main']['humidity'];
        pressure = data['main']['pressure'];
      });
    } else
      setState(() {
        _passed = false;
        _isLoading = false;
      });

    if (position != null && !position.toString().contains('error'))
      setState(() {
        _passed = true;
        _isLoading = false;
      });
    else
      setState(() {
        _passed = false;
        _isLoading = false;
      });
  }

  bool _passed = false;
  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    try {
      getLocation();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _passed = false;
      });
    }
  }

  Color textColor = Colors.black;

  String getImage(String main) {
    switch (main) {
      case 'Thunderstorm':
      case 'Drizzle':
      case 'Rain':
        setState(() {
          textColor = Colors.white;
        });
        return 'images/rain.jpg';
        break;
      case 'Snow':
        setState(() {
          textColor = Colors.black;
        });
        return 'images/snow.jpg';
        break;
      case 'Clouds':
        setState(() {
          textColor = Colors.black;
        });
        return 'images/cloud.jpg';
        break;
      default:
        setState(() {
          textColor = Colors.white;
        });
        return 'images/clear.jpeg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : !_passed
                ? Center(child: Text('Something went wrong, try again later'))
                : Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(getImage(description)),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Text(
                                  cityName,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 50,
                                      color: textColor),
                                ),
                                Text(
                                  DateFormat.yMMMMEEEEd()
                                      .format(DateTime.now()),
                                  style: TextStyle(color: textColor),
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '${temperature.round()}°C',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 85,
                                      color: textColor),
                                ),
                                Text(
                                  description,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 40,
                                      color: textColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          flex: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Text(
                                      'Wind',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: textColor),
                                    ),
                                  ),
                                  Text(
                                    wind.toString(),
                                    style: TextStyle(
                                        fontSize: 20, color: textColor),
                                  ),
                                ],
                              ),
                              Container(
                                height: 70,
                                child: VerticalDivider(
                                  color: textColor.withOpacity(0.3),
                                  thickness: 2,
                                ),
                              ),
                              Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Humidity',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: textColor),
                                    ),
                                  ),
                                  Text(
                                    humidity.toString(),
                                    style: TextStyle(
                                        fontSize: 20, color: textColor),
                                  ),
                                ],
                              ),
                              Container(
                                height: 70,
                                child: VerticalDivider(
                                  color: textColor.withOpacity(0.3),
                                  thickness: 2,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Text(
                                      'Pressure',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: textColor),
                                    ),
                                  ),
                                  Text(
                                    pressure.toString(),
                                    style: TextStyle(
                                        fontSize: 20, color: textColor),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
