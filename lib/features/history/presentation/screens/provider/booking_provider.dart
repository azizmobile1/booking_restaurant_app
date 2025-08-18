import 'package:booking_restaurant_app/features/history/data/models/booking_model.dart';
import 'package:flutter/material.dart';

class BookingProvider extends ChangeNotifier {
  final List<Booking> _bookingHistory = [];
  final Set<String> _bookedRestaurants = {};

  List<Booking> get bookingHistory => _bookingHistory;
  Set<String> get bookedRestaurants => _bookedRestaurants;

  void toggleBooking({
    required String id,
    required String name,
    required String imageUrl,
    required double lat,
    required double lng,
    required String address,
  }) {
    if (_bookedRestaurants.contains(id)) {
      _bookedRestaurants.remove(id);
      _bookingHistory.removeWhere((b) => b.name == name);
    } else {
      _bookedRestaurants.add(id);
      _bookingHistory.add(
        Booking(
          name: name,
          address: address,
          lat: lat,
          lng: lng,
          imageUrl: imageUrl,
        ),
      );
    }
    notifyListeners();
  }
}
