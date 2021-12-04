import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(
  const MaterialApp(
    title: "Weather App",
    home: Home(),
  )
);

    class Home extends StatefulWidget {
      const Home({Key? key}) : super(key: key);

      @override
      _HomeState createState() => _HomeState();
    }

    class _HomeState extends State<Home> {

      String location = 'dhaka';
      var temp;
      var description;
      var currently;
      var humidity;
      var windSpeed;
      var city;
      
      Future getWeather (loc) async {
        http.Response response = await http.get(Uri.parse("https://api.openweathermap.org/data/2.5/weather?q=$loc&appid=4c1a196e2ea32da268dc3a9aaaf90996"));
        var result = jsonDecode(response.body);
        setState(() {
          temp = result['main']['temp'];
          description = result['weather'][0]['description'];
          currently = result['weather'][0]['main'];
          humidity = result['main']['humidity'];
          windSpeed = result['wind']['speed'];

        });
      }
      @override
      void initState(){
        super.initState();
        getWeather(location);
      }
      @override
      Widget build(BuildContext context) {
        return Scaffold(
          body: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height/2,
                width: MediaQuery.of(context).size.width,
                color: Colors.purple,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:  [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextField(

                        decoration: const InputDecoration(
                            label: Text('Inter Your Location'),
                            labelStyle: TextStyle(
                              color: Colors.white
                            ),
                            fillColor: Colors.white
                        ),
                        onSubmitted: (String value) {
                          setState(() {
                            location = value;
                            getWeather(value ?? location);
                          });
                        },
                      ),
                    ),
                     Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                              location.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          temp != null ? (temp-273).toStringAsFixed(2) + '\u00B0' + 'C'  : 'loading' ,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(20.0),
                    child: ListView(
                      children: [
                        ListTile(
                          leading: FaIcon(FontAwesomeIcons.thermometer),
                          title: Text('Temperature'),
                          trailing: Text(temp != null ? (temp-273).toStringAsFixed(2) + '\u00B0' + 'C'  : 'loading' ),
                        ),
                        ListTile(
                          leading: FaIcon(FontAwesomeIcons.cloud),
                          title: Text('Weather'),
                          trailing: Text(description != null ? description.toString() : 'loading'),
                        ),ListTile(
                          leading: FaIcon(FontAwesomeIcons.sun),
                          title: Text('Temper'),
                          trailing: Text(currently != null ? currently.toString()   : 'loading'),
                        ),ListTile(
                          leading: FaIcon(FontAwesomeIcons.wind),
                          title: Text('Humidity'),
                          trailing: Text(humidity != null ? humidity.toString()  : 'loading'),
                        ),


                      ],
                    ),
              ),
              )
            ],
          ),
        );
      }
    }
