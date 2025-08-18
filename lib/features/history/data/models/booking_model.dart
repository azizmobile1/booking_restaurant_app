// booking_model.dart
class Booking {
  final String name;
  final String address;
  final double lat;
  final double lng;
  final String imageUrl;

  Booking({
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
    required this.imageUrl,
  });
}

List<Booking> bookingHistory = [];
