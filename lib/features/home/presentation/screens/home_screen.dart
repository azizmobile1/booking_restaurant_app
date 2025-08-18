import 'package:booking_restaurant_app/features/history/data/models/booking_model.dart';
import 'package:booking_restaurant_app/features/history/presentation/screens/provider/booking_provider.dart';
import 'package:booking_restaurant_app/features/home/presentation/bloc/restaurant_bloc.dart';
import 'package:booking_restaurant_app/features/home/presentation/bloc/restaurant_event.dart';
import 'package:booking_restaurant_app/features/home/presentation/bloc/restaurant_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'menu_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Booking> bookingHistory = [];
  Set<String> bookedRestaurants = {};

  @override
  void initState() {
    super.initState();
    context.read<RestaurantBloc>().add(LoadRestaurants());
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.menu),
                        SizedBox(width: 35),
                        Icon(Icons.location_on, color: Colors.green),
                        SizedBox(width: 5),
                        Text(
                          "Agrabad 435, Chittagong",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const CircleAvatar(
                      backgroundImage: NetworkImage(
                        "https://media.istockphoto.com/id/1300845620/vector/user-icon-flat-isolated-on-white-background-user-symbol-vector-illustration.jpg?s=612x612&w=0&k=20&c=yBeyba0hUkh14_jgv1OKqIH0CCSWU_4ckRkAoy2p73o=",
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search",
                    prefixIcon: const Icon(Icons.search),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  height: 180,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildHorizontalImage(
                        "https://thumbs.dreamstime.com/b/unhealthy-fast-food-delivery-menu-featuring-assorted-burgers-cheeseburgers-nuggets-french-fries-soda-high-calorie-low-356045884.jpg",
                      ),
                      const SizedBox(width: 10),
                      _buildHorizontalImage(
                        "https://www.wildfrontierstravel.com/media/cache/page_image_large/upload/cc/2364a0d7/dreamstimemaximum_197215327.jpeg",
                      ),
                      const SizedBox(width: 10),
                      _buildHorizontalImage(
                        "https://media.istockphoto.com/id/1164983166/photo/traditional-georgian-cuisine-background-khinkali-phali-chahokhbili-lobio-cheese-eggplant.jpg?s=612x612&w=0&k=20&c=QeQ3SGIwmBh-uOdZf8APuOU_CFoS_z7kUj6pezzZjYs=",
                      ),
                    ],
                  ),
                ),
              ),

              _buildSectionHeader(
                "Today New Arrival",
                "Best of today’s food list update",
              ),
              SizedBox(
                height: 220,
                child: BlocBuilder<RestaurantBloc, RestaurantState>(
                  builder: (context, state) {
                    if (state is RestaurantLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is RestaurantLoaded) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.restaurants.length,
                        itemBuilder: (context, index) {
                          final restaurant = state.restaurants[index];
                          return Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              top: 8,
                              bottom: 8,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        MenuScreen(restaurant: restaurant),
                                  ),
                                );
                              },
                              child: Container(
                                width: 160,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 6,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(12),
                                      ),
                                      child: Image.network(
                                        restaurant.imageUrl,
                                        height: 120,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            restaurant.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          FutureBuilder<String>(
                                            future: getAddressFromLatLng(
                                              restaurant.lat,
                                              restaurant.lng,
                                            ),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return Text(
                                                  "Loading...",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey,
                                                  ),
                                                );
                                              } else if (snapshot.hasError) {
                                                return Text(
                                                  "Unknown Location",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey,
                                                  ),
                                                );
                                              } else {
                                                return Text(
                                                  snapshot.data ??
                                                      "Unknown Location",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else if (state is RestaurantError) {
                      return Center(child: Text(state.message));
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),

              _buildSectionHeader(
                "Explore Restaurant",
                "Check your city Near by Restaurant",
              ),
              BlocBuilder<RestaurantBloc, RestaurantState>(
                builder: (context, state) {
                  if (state is RestaurantLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is RestaurantLoaded) {
                    return Column(
                      children: state.restaurants.map((restaurant) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    restaurant.imageUrl,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        restaurant.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      FutureBuilder<String>(
                                        future: getAddressFromLatLng(
                                          restaurant.lat,
                                          restaurant.lng,
                                        ),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Text(
                                              "Loading...",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            );
                                          } else if (snapshot.hasError) {
                                            return Text(
                                              "Unknown Location",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            );
                                          } else {
                                            return Text(
                                              snapshot.data ??
                                                  "Unknown Location",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        context
                                            .watch<BookingProvider>()
                                            .bookedRestaurants
                                            .contains(restaurant.id)
                                        ? Colors.grey
                                        : Colors.green,
                                  ),
                                  onPressed: () async {
                                    String address = await getAddressFromLatLng(
                                      restaurant.lat,
                                      restaurant.lng,
                                    );

                                    context
                                        .read<BookingProvider>()
                                        .toggleBooking(
                                          id: restaurant.id,
                                          name: restaurant.name,
                                          imageUrl: restaurant.imageUrl,
                                          lat: restaurant.lat,
                                          lng: restaurant.lng,
                                          address: address,
                                        );
                                  },
                                  child: Text(
                                    context
                                            .watch<BookingProvider>()
                                            .bookedRestaurants
                                            .contains(restaurant.id)
                                        ? "Booked"
                                        : "Book",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  } else if (state is RestaurantError) {
                    return Center(child: Text(state.message));
                  }
                  return const SizedBox.shrink();
                },
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
          const Text(
            "See All",
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalImage(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Image.network(url, fit: BoxFit.cover, width: 300, height: 180),
    );
  }
}
