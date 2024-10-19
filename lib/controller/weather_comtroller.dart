import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/Services/api_service.dart';
import 'package:weather_app/model/weather_model.dart';

class WeatherController extends GetxController {
  final TextEditingController cityController = TextEditingController();
  final WeatherApiService _weatherApiService = WeatherApiService();

  // Observables (GetX)
  var cityName = ''.obs;
  var temperature = ''.obs;
  var condition = ''.obs;
  var windSpeed = ''.obs;
  var humidity = ''.obs;
  var favoriteLocations = <String>[].obs;
  var isFavorite = false.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchWeatherData('Delhi');
  }

  // Fetch weather data
  Future<void> fetchWeatherData(String city) async {
    isLoading(true);
    errorMessage('');
    try {
      WeatherData weatherData = await _weatherApiService.getWeatherData(city);

      cityName(weatherData.cityName);
      temperature(weatherData.temperature);
      condition(weatherData.condition);
      windSpeed(weatherData.windSpeed);
      humidity(weatherData.humidity);
    } catch (error) {
      errorMessage('An unexpected error occurred. Please try again.');
    } finally {
      isLoading(false);
    }
  }

  // Add to favorite locations
  void toggleFavorite() {
    isFavorite(!isFavorite.value);
    if (isFavorite.value) {
      favoriteLocations.add(cityName.value);
    } else {
      favoriteLocations.remove(cityName.value);
    }
  }
}
