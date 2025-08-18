import 'package:booking_restaurant_app/features/home/domain/usecases/get_restaurants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'restaurant_event.dart';
import 'restaurant_state.dart';

class RestaurantBloc extends Bloc<RestaurantEvent, RestaurantState> {
  final GetRestaurants getRestaurants;

  RestaurantBloc(this.getRestaurants) : super(RestaurantInitial()) {
    on<LoadRestaurants>((event, emit) async {
      emit(RestaurantLoading());
      try {
        final restaurants = await getRestaurants();
        if (restaurants.isEmpty) {
          emit(RestaurantError("Restoranlar topilmadi."));
        } else {
          emit(RestaurantLoaded(restaurants));
        }
      } catch (e, stackTrace) {
        // ignore: avoid_print
        print("Xato yuz berdi: $e\nStack trace: $stackTrace");
        final errorMessage = _handleError(e);
        emit(RestaurantError(errorMessage));
      }
    });
  }

  String _handleError(dynamic error) {
    if (error is Exception) {
      if (error.toString().contains("SocketException")) {
        return "Internet ulanishingizni tekshiring.";
      } else if (error.toString().contains("TimeoutException")) {
        return "Serverga ulanish vaqti o‘tdi. Qayta urinib ko‘ring.";
      }
      return "Ma'lumotlarni yuklashda xato: ${error.toString()}";
    }
    return "Noma'lum xato yuz berdi. Iltimos, qayta urinib ko‘ring.";
  }
}
