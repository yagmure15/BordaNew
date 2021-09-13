import 'dart:developer';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:bordatech/utils/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

class WeatherScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WeatherScreenState();
  }
}

class _WeatherScreenState extends State<WeatherScreen> {
  var temp;
  var description;
  var currently;
  var humidity;
  var windSpeed;
  var feelsLike;
  var tempMin;
  var tempMax;
  var imageUrl;
  var iconInfo;
  var iconUrl;
  var locality;
  var minTempForecast = new List.filled(7, "", growable: false);
  var maxTempForecast = new List.filled(7, "", growable: false);
  var iconAbbr = new List.filled(7, "", growable: false);

  Future<Position> getPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        forceAndroidLocationManager: true);
    return position;
  }

  Future<Placemark> getPlacemark(double latitude, double longitude) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    return placemarks[0];
  }

  Future getData(double latitude, double longitude) async {
    //https://api.openweathermap.org/data/2.5/onecall?lat=33.44&lon=-94.04&exclude=hourly,daily&appid={API key}

    String api = 'http://api.openweathermap.org/data/2.5/onecall';
    String appId = '0abff55c1aebc2edb5e8ba63282a31ab';
    String url =
        '$api?lat=$latitude&lon=$longitude&units=metric&exclude=minutely,hourly,alerts&appid=$appId';

    http.Response response = await http.get(Uri.parse(url));

    var results = jsonDecode(response.body);
    // You can set the value of an attribute with the setState((){}) inside of a method
    setState(() {
      this.temp = results["current"]["temp"];
      this.description = results["current"]["weather"][0]["description"];
      this.currently = results["current"]["weather"][0]["main"];
      this.humidity = results["current"]["humidity"];
      this.windSpeed = results["current"]["wind_speed"];
      this.feelsLike = results["current"]["feels_like"];
      this.tempMin = results["daily"][0]["temp"]["min"];
      this.tempMax = results["daily"][0]["temp"]["max"];
      this.iconInfo = results["current"]["weather"][0]["icon"];
      this.iconUrl = "http://openweathermap.org/img/wn/" + '$iconInfo' + ".png";

      for (var i = 0; i < 7; i++) {
        this.minTempForecast[i] = results["daily"][i]["temp"]["min"].toString();
        this.maxTempForecast[i] = results["daily"][i]["temp"]["max"].toString();
        this.iconAbbr[i] = results["daily"][i]["weather"][0]["main"];
      }
    });
  }

  String getBackground() {
    String tempUrl = "";
    if (currently == "Clear") {
      tempUrl = "assets/clear.jpg";
    } else if (currently == "Clouds") {
      tempUrl = "assets/clouds.jpg";
    } else if (currently == "Snow") {
      tempUrl = "assets/snow.jpg";
    } else if (currently == "Rain" || currently == "Drizzle") {
      tempUrl = "assets/rain.jpg";
    } else if (currently == "Thunderstorm") {
      tempUrl = "assets/thunderstorm.jpg";
    } else {
      tempUrl = "assets/fog.jpg";
    }
    return tempUrl;
  }

  IconData getCurrentIcon(var condition) {
    if (condition == "Clear") {
      return WeatherIcons.day_sunny;
    } else if (condition == "Clouds") {
      return WeatherIcons.cloudy;
    } else if (condition == "Snow") {
      return WeatherIcons.snow;
    } else if (condition == "Rain" || condition == "Drizzle") {
      return WeatherIcons.rain;
    } else if (condition == "Thunderstorm") {
      return WeatherIcons.thunderstorm;
    } else {
      return WeatherIcons.fog;
    }
  }

  /*
  This is just initializing the statet with super keyword parent-inheritance and then calling the methods with "then" keyword
  which set the return value into then e.g. then((value){and then do something})  ---> if not getData().then((variable) => null) kind of thing
  */
  @override
  void initState() {
    super.initState();
    getPosition().then((position) {
      getPlacemark(position.latitude, position.longitude).then((data) {
        getData(position.latitude, position.longitude).then((value) {
          setState(() {
            locality = data.administrativeArea;
          });
        });
      });
    });
  }

  Widget forecastElement(daysFromNow, abbr, minTemperature, maxTemperature) {
    var now = new DateTime.now();
    var oneDayFromNow = now.add(new Duration(days: daysFromNow));
    return Padding(
      padding: const EdgeInsets.only(
        top: 5,
        left: 20.0,
      ),
      child: Container(
        decoration: BoxDecoration(
          //color: Color.fromRGBO(205, 212, 228, 0.2),
          color: Colors.black38,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Text(
                new DateFormat.E().format(oneDayFromNow),
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
              Text(
                new DateFormat.MMMd().format(oneDayFromNow),
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: FaIcon(
                  getCurrentIcon(abbr),
                  //WeatherIcons.day_sunny,
                  color: bordaOrange,
                ),
              ),
              Text(
                'High: ' + maxTemperature.toString() + ' °C',
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
              Text(
                'Low: ' + minTemperature.toString() + ' °C',
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.9), BlendMode.dstATop),
            image: AssetImage(getBackground()),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(height: 8),
            Card(
              color: Colors.black12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 2.5, horizontal: 20),
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: MediaQuery.of(context).size.height / 4,
                //width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: 10,
                        top: 15,
                      ),
                      child: Text(
                        locality != "" ? locality.toString() : "Loading",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Text(
                      temp != ""
                          ? temp.toString() + "\u00B0" + " C"
                          : "Loading",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        currently != "" ? currently.toString() : "Loading",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Column(
                        children: <Widget>[
                          FaIcon(
                            getCurrentIcon(currently),
                            color: bordaOrange,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Card(
                      color: Colors.black26,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: Container(
                        //width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                FaIcon(
                                  WeatherIcons.hot,
                                  //FontAwesomeIcons.thermometerFull,
                                  color: bordaOrange,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Feels Like",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  feelsLike != ""
                                      ? feelsLike.toString() + "\u00B0" + " C"
                                      : "Loading",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                FaIcon(
                                  WeatherIcons.day_cloudy,
                                  color: bordaOrange,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Description",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  description != ""
                                      ? description.toString()
                                      : "Loading",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                FaIcon(
                                  //getIcon(),
                                  WeatherIcons.humidity,
                                  color: bordaOrange,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Humidity",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  humidity != ""
                                      ? "%" + humidity.toString()
                                      : "Loading",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Card(
                      color: Colors.black26,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: Container(
                        //width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                FaIcon(
                                  FontAwesomeIcons.wind,
                                  color: bordaOrange,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Wind",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  windSpeed != ""
                                      ? windSpeed.toString() + " km/h"
                                      : "Loading",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                FaIcon(
                                  FontAwesomeIcons.thermometerQuarter,
                                  color: bordaOrange,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Min. Temp.",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  tempMin != ""
                                      ? tempMin.toString() + "\u00B0" + " C"
                                      : "Loading",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                FaIcon(
                                  FontAwesomeIcons.thermometerThreeQuarters,
                                  color: bordaOrange,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Max. Temp.",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  tempMax != ""
                                      ? tempMax.toString() + "\u00B0" + " C"
                                      : "Loading",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  /* Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    //crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Icon(
                        Icons.navigate_next_outlined,
                        size: 30.0,
                        color: bordaOrange,
                      )
                    ],
                  ), */
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: <Widget>[
                        for (var i = 0; i < 7; i++)
                          forecastElement(i + 1, iconAbbr[i],
                              minTempForecast[i], maxTempForecast[i]),
                        SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
