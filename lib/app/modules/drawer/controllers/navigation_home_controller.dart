// filepath: lib/app/modules/navigation_home/controllers/navigation_home_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dpp/app/modules/navigation/views/widgets/home_drawer.dart';
import 'package:dpp/app/modules/home/views/app_home_screen.dart';
import 'package:dpp/app/modules/navigation/views/screens/help_screen.dart';
import 'package:dpp/app/modules/navigation/views/screens/feedback_screen.dart';
import 'package:dpp/app/modules/navigation/views/screens/invite_friend_screen.dart';
import 'package:dpp/app/services/base_client.dart';

// Define API status enum to manage network call states.
enum ApiCallStatus { loading, success, error }

class NavigationHomeController extends GetxController {
  // Reactive variable to hold the current drawer index.
  var drawerIndex = DrawerIndex.HOME.obs;
  // Reactive variable for the current screen view.
  var screenView = Rx<Widget>(const AppHomeScreen());
  
  // Reactive variable for API call state.
  var apiStatus = ApiCallStatus.loading.obs;
  // Optionally hold the API response data.
  var apiData = Rx<dynamic>(null);

  // Instance of BaseClient to make API calls.
  final BaseClient _client = BaseClient();

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  // Example API method: fetch data from a specific endpoint.
  void fetchData() async {
    apiStatus(ApiCallStatus.loading);
    try {
      var data = await _client.get("sample_endpoint"); // Replace with your endpoint
      apiData.value = data;
      apiStatus(ApiCallStatus.success);
      debugPrint("API data received: $data");
      // Process data or update screen view as needed.
    } catch (e) {
      apiStatus(ApiCallStatus.error);
      debugPrint("Error fetching API data: $e");
    }
  }

  // Method to change the index and update the view.
  void changeIndex(DrawerIndex newIndex) {
    if (drawerIndex.value != newIndex) {
      drawerIndex.value = newIndex;
      switch (newIndex) {
        case DrawerIndex.HOME:
          screenView.value = const AppHomeScreen();
          break;
        case DrawerIndex.Help:
          screenView.value = HelpScreen();
          break;
        case DrawerIndex.FeedBack:
          screenView.value = FeedbackScreen();
          break;
        case DrawerIndex.Invite:
          screenView.value = InviteFriend();
          break;
        default:
          break;
      }
    }
  }
}