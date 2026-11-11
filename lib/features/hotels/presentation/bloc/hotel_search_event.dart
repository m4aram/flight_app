part of 'hotel_search_bloc.dart';

sealed class HotelSearchEvent extends Equatable {
  const HotelSearchEvent();

  @override
  List<Object?> get props => [];
}

final class HotelSearchStarted extends HotelSearchEvent {
  const HotelSearchStarted({this.city});

  final String? city;

  @override
  List<Object?> get props => [city];
}

final class HotelTonightSelected extends HotelSearchEvent {
  const HotelTonightSelected();
}

final class HotelCitySelected extends HotelSearchEvent {
  const HotelCitySelected(this.city);

  final String city;

  @override
  List<Object?> get props => [city];
}

final class HotelCheckInSelected extends HotelSearchEvent {
  const HotelCheckInSelected(this.date);

  final DateTime date;

  @override
  List<Object?> get props => [date];
}

final class HotelCheckOutSelected extends HotelSearchEvent {
  const HotelCheckOutSelected(this.date);

  final DateTime date;

  @override
  List<Object?> get props => [date];
}

final class HotelGuestsRoomsChanged extends HotelSearchEvent {
  const HotelGuestsRoomsChanged({required this.guests, required this.rooms});

  final int guests;
  final int rooms;

  @override
  List<Object?> get props => [guests, rooms];
}

final class HotelSearchSubmitted extends HotelSearchEvent {
  const HotelSearchSubmitted();
}
