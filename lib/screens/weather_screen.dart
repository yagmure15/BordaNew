import 'package:flutter/material.dart';
import 'package:bordatech/utils/hex_color.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WeatherScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WeatherScreenState();
  }
}

class _WeatherScreenState extends State {
  var temp;
  var description;
  var currently;
  var humidity;
  var windSpeed;

  Future getWeather() async {
    http.Response response = await http.get(
      Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?q=Istanbul&units=metric&appid=0abff55c1aebc2edb5e8ba63282a31ab"),
    );
    var results = jsonDecode(response.body);

    setState(() {
      this.temp = results["main"]["temp"];
      this.description = results["weather"][0]["description"];
      this.currently = results["weather"][0]["main"];
      this.humidity = results["main"]["humidity"];
      this.windSpeed = results["wind"]["speed"];
    });
  }

  @override
  void initState() {
    super.initState();
    this.getWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Image.asset('assets/return.png'),
        ),
        title: Text('Weather Forecast'),
        backgroundColor: bordaGreen,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width,
            color: bordaSoftGreen,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    bottom: 20,
                  ),
                  child: Text(
                    "Currently in Izmir",
                    style: TextStyle(
                      fontSize: 25,
                      color: bordaOrange,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Text(
                  temp != null ? temp.toString() + "\u00B0" + " C" : "Loading",
                  style: TextStyle(
                    color: bordaOrange,
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 20,
                  ),
                  child: Text(
                    currently != null ? currently.toString() : "Loading",
                    style: TextStyle(
                      fontSize: 16,
                      color: bordaOrange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: ListView(
                children: <Widget>[
                  ListTile(
                    leading: FaIcon(
                      FontAwesomeIcons.thermometerHalf,
                      color: bordaOrange,
                    ),
                    title: Text(
                      "Temperature",
                      style: TextStyle(
                        color: bordaGreen,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    trailing: Text(
                      temp != null
                          ? temp.toString() + "\u00B0" + " C"
                          : "Loading",
                      style: TextStyle(
                        color: bordaOrange,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: FaIcon(
                      FontAwesomeIcons.cloud,
                      color: bordaOrange,
                    ),
                    title: Text(
                      "Description",
                      style: TextStyle(
                        color: bordaGreen,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    trailing: Text(
                      description != null ? description.toString() : "Loading",
                      style: TextStyle(
                        color: bordaOrange,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: FaIcon(
                      FontAwesomeIcons.sun,
                      color: bordaOrange,
                    ),
                    title: Text(
                      "Humidity",
                      style: TextStyle(
                        color: bordaGreen,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    trailing: Text(
                      humidity != null ? humidity.toString() : "Loading",
                      style: TextStyle(
                        color: bordaOrange,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: FaIcon(
                      FontAwesomeIcons.wind,
                      color: bordaOrange,
                    ),
                    title: Text(
                      "Wind Speed",
                      style: TextStyle(
                        color: bordaGreen,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    trailing: Text(
                      windSpeed != null ? windSpeed.toString() : "Loading",
                      style: TextStyle(
                        color: bordaOrange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
