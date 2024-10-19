import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/controller/weather_comtroller.dart';
import 'package:weather_app/screen/favourite_screen.dart';
import 'package:weather_app/utils/colors.dart';

import 'widget/fade_widget.dart';

class WeatherScreen extends StatelessWidget {
  final WeatherController weatherController = Get.put(WeatherController());

  WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dun,
      appBar: AppBar(
        backgroundColor: dun,
        title: Obx(() => weatherController.cityName.isNotEmpty
            ? Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Colors.black,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    weatherController.cityName.value,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              )
            : const Text(
                'Weather App',
                style: TextStyle(color: Colors.white),
              )),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Get.to(() => FavoritesScreen(
                    favoriteLocations: weatherController.favoriteLocations,
                    temperature: weatherController.temperature.value,
                  ));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: weatherController.cityController,
                decoration: InputDecoration(
                  labelText: 'Enter city name',
                  labelStyle: const TextStyle(color: Colors.white),
                  fillColor: Colors.white,
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      weatherController.fetchWeatherData(
                          weatherController.cityController.text);
                    },
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                  ),
                ),
              ),
              SizedBox(height: 16.0.h),
              Obx(() => weatherController.isLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(
                      color: roseWood,
                    ))
                  : FadeInWidget(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Obx(() => IconButton(
                                        icon: Icon(
                                          weatherController.isFavorite.value
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color:
                                              weatherController.isFavorite.value
                                                  ? Colors.red
                                                  : null,
                                        ),
                                        onPressed: () {
                                          weatherController.toggleFavorite();
                                        },
                                      )),
                                ],
                              ),
                              weatherController.errorMessage.isNotEmpty
                                  ? Padding(
                                      padding: EdgeInsets.all(8.0.sp),
                                      child: Text(
                                        weatherController.errorMessage.value,
                                        style: const TextStyle(
                                          color: chreey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  : Container(),
                              Text(
                                weatherController.cityName.value,
                                style: TextStyle(
                                    fontSize: 28.sp,
                                    fontWeight: FontWeight.bold,
                                    color: chreey),
                              ),
                              SizedBox(height: 8.0.h),
                              Lottie.asset(
                                _getWeatherImagePath(
                                    weatherController.condition.value),
                                height: 190,
                              ),
                              SizedBox(height: 8.0.h),
                              Text(
                                '${weatherController.temperature.value}°C',
                                style: TextStyle(
                                  fontSize: 32.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 30.0.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildInfoWidget(
                                    icon: Icons.speed,
                                    value:
                                        '${weatherController.windSpeed.value} m/s',
                                  ),
                                  _buildInfoWidget(
                                    icon: Icons.cloud,
                                    value: weatherController.condition.value,
                                  ),
                                  _buildInfoWidget(
                                    icon: Icons.water,
                                    value: weatherController.humidity.value,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
              SizedBox(height: 16.0.h),
            ],
          ),
        ),
      ),
    );
  }

  // Info widget for windspeed, condition, and humidity
  Widget _buildInfoWidget({required IconData icon, required String value}) {
    return Column(
      children: [
        Icon(
          icon,
          size: 40,
          color: chreey,
        ),
        SizedBox(height: 8.0.h),
        Text(
          value,
          style: TextStyle(fontSize: 16.sp),
        ),
      ],
    );
  }

  // Get weather image path based on condition
  String _getWeatherImagePath(String condition) {
    if (condition.toLowerCase().contains('cloud')) {
      return 'assets/images/cloud.json';
    } else if (condition.toLowerCase().contains('rain')) {
      return 'assets/images/rainy.json';
    } else {
      return 'assets/images/sunny.json';
    }
  }
}
