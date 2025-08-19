import 'package:booking_restaurant_app/features/history/presentation/screens/provider/booking_provider.dart';
import 'package:booking_restaurant_app/features/home/domain/entities/restaurant_entity.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';

class DetailScreen extends StatefulWidget {
  final RestaurantEntity restaurant;

  const DetailScreen({super.key, required this.restaurant});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<String> _addressFuture;

  @override
  void initState() {
    super.initState();
    _addressFuture = getAddressFromLatLng(
      widget.restaurant.lat,
      widget.restaurant.lng,
    );
  }

  Future<String> getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return "${place.street}, ${place.subLocality}, ${place.locality}";
      }
    } catch (e) {
      print("Error getting address: $e");
    }
    return "Unknown Location";
  }

  bool isRestaurantOpen() {
    final now = TimeOfDay.now();
    final open = TimeOfDay(
      hour: int.parse(widget.restaurant.openTime.split(":")[0]),
      minute: int.parse(widget.restaurant.openTime.split(":")[1]),
    );
    final close = TimeOfDay(
      hour: int.parse(widget.restaurant.closeTime.split(":")[0]),
      minute: int.parse(widget.restaurant.closeTime.split(":")[1]),
    );

    final nowMinutes = now.hour * 60 + now.minute;
    final openMinutes = open.hour * 60 + open.minute;
    final closeMinutes = close.hour * 60 + close.minute;

    return nowMinutes >= openMinutes && nowMinutes <= closeMinutes;
  }

  @override
  Widget build(BuildContext context) {
    final bookingProvider = context.watch<BookingProvider>();

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Text(
          "${widget.restaurant.name} Restaurant",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                widget.restaurant.imageUrl,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.restaurant.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  FutureBuilder<String>(
                    future: _addressFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text(
                          "Loading address...",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        );
                      } else if (snapshot.hasError) {
                        return const Text(
                          "Unknown Location",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        );
                      } else {
                        return Text(
                          snapshot.data ?? "Unknown Location",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: Colors.grey[600],
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Open: ${widget.restaurant.openTime}  -  Close: ${widget.restaurant.closeTime}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isRestaurantOpen() ? Colors.green : Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          isRestaurantOpen() ? "Open" : "Closed",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      bookingProvider.bookedRestaurants.contains(
                        widget.restaurant.id,
                      )
                      ? Colors.grey
                      : Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  String address = await _addressFuture;

                  bookingProvider.toggleBooking(
                    id: widget.restaurant.id,
                    name: widget.restaurant.name,
                    imageUrl: widget.restaurant.imageUrl,
                    lat: widget.restaurant.lat,
                    lng: widget.restaurant.lng,
                    address: address,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Restaurant booked!")),
                  );
                  setState(() {});
                },
                child: Text(
                  bookingProvider.bookedRestaurants.contains(
                        widget.restaurant.id,
                      )
                      ? "Booked"
                      : "Book",
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
