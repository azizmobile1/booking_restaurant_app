import 'package:booking_restaurant_app/features/history/presentation/screens/provider/booking_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookingProvider = context.watch<BookingProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Booking History",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 25,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: bookingProvider.bookingHistory.isEmpty
          ? const Center(
              child: Text(
                "No bookings yet",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bookingProvider.bookingHistory.length,
              itemBuilder: (context, index) {
                final booking = bookingProvider.bookingHistory[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  shadowColor: Colors.black26,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        booking.imageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      booking.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      booking.address,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    trailing: Icon(Icons.map, color: Colors.green),
                  ),
                );
              },
            ),
    );
  }
}
