import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/counter_row.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/selection_sheet.dart';
import '../../domain/entities/hotel_search_criteria.dart';

typedef GuestsRooms = ({int guests, int rooms});

Future<GuestsRooms?> showGuestsRoomsSheet(
  BuildContext context, {
  required int guests,
  required int rooms,
}) {
  return showModalBottomSheet<GuestsRooms>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _GuestsRoomsSheet(guests: guests, rooms: rooms),
  );
}

class _GuestsRoomsSheet extends StatefulWidget {
  const _GuestsRoomsSheet({required this.guests, required this.rooms});

  final int guests;
  final int rooms;

  @override
  State<_GuestsRoomsSheet> createState() => _GuestsRoomsSheetState();
}

class _GuestsRoomsSheetState extends State<_GuestsRoomsSheet> {
  static const int _maxPerRoom = HotelSearchCriteria.maxGuestsPerRoom;
  static const int _maxRooms = HotelSearchCriteria.maxRooms;

  late int _guests = widget.guests;
  late int _rooms = widget.rooms;

  bool get _canAddGuest => _guests < _rooms * _maxPerRoom;
  bool get _canRemoveGuest => _guests > _rooms;
  bool get _canAddRoom => _rooms < _maxRooms && _rooms < _guests;
  bool get _canRemoveRoom =>
      _rooms > 1 && _guests <= (_rooms - 1) * _maxPerRoom;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(child: SheetHandle()),
            const SizedBox(height: 12),
            const Text(
              AppStrings.guestsAndRooms,
              textAlign: TextAlign.center,
              style: AppTextStyles.sectionTitle,
            ),
            const SizedBox(height: 8),
            CounterRow(
              icon: Icons.person_outline,
              title: '$_guests ${_guests == 1 ? 'Guest' : 'Guests'}',
              subtitle: 'Max $_maxPerRoom per room',
              onIncrement:
                  _canAddGuest ? () => setState(() => _guests++) : null,
              onDecrement:
                  _canRemoveGuest ? () => setState(() => _guests--) : null,
            ),
            CounterRow(
              icon: Icons.bed_outlined,
              title: '$_rooms ${_rooms == 1 ? 'Room' : 'Rooms'}',
              subtitle: 'Max $_maxRooms rooms',
              onIncrement: _canAddRoom ? () => setState(() => _rooms++) : null,
              onDecrement:
                  _canRemoveRoom ? () => setState(() => _rooms--) : null,
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              label: AppStrings.save,
              onPressed:
                  () => Navigator.of(
                    context,
                  ).pop<GuestsRooms>((guests: _guests, rooms: _rooms)),
            ),
          ],
        ),
      ),
    );
  }
}
