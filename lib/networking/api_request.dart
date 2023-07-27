import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:zartek_task/models/restaurant_data_model.dart';
import 'package:zartek_task/utils/constants.dart';

class ApiManagement {
 static Future<List<RestaurantData>?> getDishes(BuildContext context) async {
    try {
      var url = Uri.parse(ApiConstants.apiEndPoint);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<RestaurantData> model = restaurantDataFromJson(response.body);
        // print(response.body);
        return model;
      } else {if(context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to retrieve data. Please try again later.'),
          ),
        );
      }
      }
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Network connection error. Please check your internet connection and try again.'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An unexpected error occurred. Please try again later.'),
        ),
      );
    }
    return null;
  }
}
