import 'package:equatable/equatable.dart';

class MenuEntity extends Equatable {
  final String name;
  final String description;
  final String imageUrl;
  final double price;

  const MenuEntity({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
  });

  @override
  List<Object?> get props => [name, description, imageUrl, price];
}
