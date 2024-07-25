import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool clicked = false;
  String currentCity = 'Kozhikode';
  Map<String, dynamic>? weatherData;

  @override
  void initState() {
    super.initState();
    fetchWeatherData(currentCity);
  }

  Future<void> fetchWeatherData(String city) async {
    const apiKey = '3332798dd8d3cfbb43b2452046eb151e';
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        weatherData = json.decode(response.body);
      });
    } else {

    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.only(top: 80, left: 30, right: 30),
        height: size.height,
        width: size.width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover, image: AssetImage('assets/bg.jpg'))),
        child: Stack(
          children: [
            if (clicked)
              Positioned(
                top: 70,
                left: 15,
                right: 15,
                child: SizedBox(
                  height: 50,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Search place',
                      hintStyle: TextStyle(color: Colors.white),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                    ),
                    onFieldSubmitted: (value) {
                      fetchWeatherData(value);
                      setState(() {
                        currentCity = value;
                        clicked = false;
                      });
                    },
                  ),
                ),
              ),
            SizedBox(
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.location_pin,
                        color: Colors.red,
                        size: 35,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentCity,
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            greetingMessage(),
                            style: GoogleFonts.poppins(
                                color: Colors.white, fontSize: 16),
                          )
                        ],
                      )
                    ],
                  ),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          clicked = !clicked;
                        });
                      },
                      icon: const Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 32,
                      )),
                ],
              ),
            ),
            Align(
                alignment: const Alignment(0, -0.6),
                child: weatherData != null
                    ? Image.network(
                        'https://openweathermap.org/img/wn/${weatherData!['weather'][0]['icon']}@2x.png')
                    : Container()),
            Align(
              alignment: const Alignment(0, 0),
              child: SizedBox(
                height: 130,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (weatherData != null)
                      Text(
                        '${weatherData!['main']['temp']}°C',
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 25),
                      ),
                    if (weatherData != null)
                      Text(
                        weatherData!['weather'][0]['description'],
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 22),
                      ),
                    if (weatherData != null)
                      Text(
                        '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
                        style: GoogleFonts.poppins(
                            color: Colors.white, fontSize: 15),
                      ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: const Alignment(0.0, 0.70),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.black.withOpacity(0.4)),
                height: 190,
                child: weatherData != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              weatherInfo(
                                  'Temp Max',
                                  '${weatherData!['main']['temp_max']}°C',
                                  'assets/engine_temp_light.png'),
                              weatherInfo(
                                  'Temp Min',
                                  '${weatherData!['main']['temp_min']}°C',
                                  'assets/th-removebg-preview (1).png'),
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              weatherInfo(
                                  'Sunrise',
                                  formatTime(weatherData!['sys']['sunrise']),
                                  'assets/th-removebg-preview (3).png'),
                              weatherInfo(
                                  'Sunset',
                                  formatTime(weatherData!['sys']['sunset']),
                                  'assets/th-removebg-preview (2).png'),
                            ],
                          ),
                        ],
                      )
                    : Container(),
              ),
            )
          ],
        ),
      ),
    );
  }

  String greetingMessage() {
    int hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  String formatTime(int timestamp) {
    final DateTime time = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }

  Widget weatherInfo(String label, String value, String assetPath) {
    return Row(
      children: [
        Image.asset(
          assetPath,
          height: 60,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 17),
            ),
            Text(
              value,
              style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 22),
            ),
          ],
        ),
      ],
    );
  }
}
