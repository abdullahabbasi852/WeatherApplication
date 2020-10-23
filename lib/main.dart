import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';

void main () => runApp(
  MaterialApp(
    title: "Weather App",
    home: Home(),
  )
);
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var temp;
  var description;
  var currently;
  var location;
  var country;
  var humidity;
  var windSpeed;
  var sunrise;
  var sunset;

  Future getWeather () async {
    Position position = await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    var URL = "http://api.openweathermap.org/data/2.5/weather?lat="+position.latitude.toString()+"&lon="+position.longitude.toString()+"&units=metric&appid=2f5f6412c3022096d03d549c4dc30ea9";
    http.Response response = await http.get(URL);
    var results = jsonDecode(response.body);
    setState(() {
      this.temp = results['main']['temp'];
      this.location = results['name'];
      this.country = results['sys']['country'];
      this.description = results['weather'][0]['description'];
      this.currently = results['weather'][0]['main'];
      this.humidity = results['main']['humidity'];
      this.windSpeed = results['wind']['speed'];
      this.sunrise = results['sys']['sunrise'];
      this.sunset = results['sys']['sunset'];
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
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Weather App'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width,
            color: Colors.redAccent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    location != null ? location.toString() + ", " + country.toString() : "Loading",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                ),
                Text(
                  temp != null ? temp.toString() + "\u00B0C" : "Loading",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40.0,
                      fontWeight: FontWeight.w600
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    currently != null ? currently.toString() : "Loading",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
                padding: EdgeInsets.all(20.0),
                child: ListView(
                children: <Widget>[
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.sun),
                    title: Text("Sunrise"),
                    trailing: Text(sunrise != null ? DateTime.fromMillisecondsSinceEpoch(sunrise).toString() : "Loading"),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.sun),
                    title: Text("Sunset"),
                    trailing: Text(sunset != null ? DateTime.fromMillisecondsSinceEpoch(sunset).hour.toString() : "Loading"),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.cloudRain),
                    title: Text("Humidity"),
                    trailing: Text(humidity != null ? humidity.toString() + "%" : "Loading"),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.wind),
                    title: Text("Wind Speed"),
                    trailing: Text(windSpeed != null ? windSpeed.toString() + " m/s" : "Loading"),
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
