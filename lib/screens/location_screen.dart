import 'package:flutter/material.dart';
import 'package:clima_prod/utilities/constants.dart';
import 'package:clima_prod/services/weather.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:clima_prod/screens/city_screen.dart';


class LocationScreen extends StatefulWidget {
  LocationScreen({this.locationWeather});
  final locationWeather;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weather = WeatherModel();

  late String tempView;
  late String weatherIcon;
  late int temperature;
  late String cityName;

  @override
  void initState() {
    super.initState();
    UpdateUI(widget.locationWeather);
  }

  void UpdateUI(weatherData) {
    setState(() {
      if(weatherData == null) {
        temperature = 0;
        cityName = '';
        weatherIcon = 'Error';
        return;
      }
      double temp = weatherData['main']['temp'];
      temperature = temp.toInt();
      tempView = weather.getMessage(temperature);
      var condition = weatherData['weather'][0]['id'];
      weatherIcon = weather.getWeatherIcon(condition);
      cityName = weatherData['name'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.8),
              BlendMode.dstATop,
            ),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () async {
                      var weatherData = await WeatherModel().getLocationWeather();
                      UpdateUI(weatherData);
                    },
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                   TextButton(

                     onPressed: () async {
                        var typedName = await Navigator.push(context as BuildContext, MaterialPageRoute(builder: (context) {
                           return CityScreen();
                         }),
                       );
                        if (typedName != null) {
                          var weatherData = await WeatherModel().getCityWeather(typedName);
                          UpdateUI (weatherData);
                        };
                     },
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Expanded( // Use Expanded to make temperature and weather icon area take up more space
                child: Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '$temperature°',
                        style: kTempTextStyle,
                      ),
                      Text(
                        '$weatherIcon',
                        style: kConditionTextStyle,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  "$tempView time in ${cityName}!",
                  textAlign: TextAlign.right,
                  textScaleFactor: 0.75,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
