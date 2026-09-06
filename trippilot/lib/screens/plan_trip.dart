import 'package:flutter/material.dart';

import '../data.dart';
import '../theme.dart';
import '../widgets.dart';
import 'drivers.dart';

class PlanTripScreen extends StatefulWidget {
  final TripDraft draft;
  const PlanTripScreen({super.key, required this.draft});

  @override
  State<PlanTripScreen> createState() => _PlanTripScreenState();
}

class _PlanTripScreenState extends State<PlanTripScreen> {
  late final TripDraft d = widget.draft;
  final _notes = TextEditingController();

  static const _places = [
    '175 Pitt Street, Sydney NSW 2000',
    'Sydney Airport T1, Mascot NSW 2020',
    'Circular Quay, Sydney NSW 2000',
    'Bondi Beach, Sydney NSW 2026',
    'Parramatta Square, Parramatta NSW 2150',
    '1 Collins Street, Melbourne VIC 3000',
    'Melbourne Airport T2, Tullamarine VIC 3043',
    '120 Adelaide Street, Brisbane QLD 4000',
  ];

  @override
  void initState() {
    super.initState();
    _notes.text = d.notes;
  }

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  Future<void> _pickPlace({required bool isPickup}) async {
    final chosen = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) => _PlacePickerSheet(
        title: isPickup ? 'Pickup point' : 'Drop off point',
        current: isPickup ? d.pickup : d.dropoff,
        places: _places,
      ),
    );
    if (chosen != null && chosen.isNotEmpty) {
      setState(() {
        if (isPickup) {
          d.pickup = chosen;
        } else {
          d.dropoff = chosen;
        }
      });
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: d.date,
      firstDate: DateTime(2026, 1, 1),
      lastDate: DateTime(2027, 12, 31),
    );
    if (picked != null) setState(() => d.date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: d.startTime);
    if (picked != null) setState(() => d.startTime = picked);
  }

  String? get _problem {
    if (d.pickup.trim().isEmpty) return 'Add a pickup point';
    if (d.dropoff.trim().isEmpty) return 'Add a drop off point';
    if (d.pickup.trim().toLowerCase() == d.dropoff.trim().toLowerCase()) {
      return 'Pickup and drop off cannot be the same place';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final problem = _problem;
    return Scaffold(
      appBar: AppBar(leading: const BackChip(), title: const Text('Plan your trip')),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 24),
              children: [
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (final t in tripTypes)
                      TpChip(
                        label: t.name,
                        selected: d.type.name == t.name,
                        onTap: () => setState(() => d.type = t),
                      ),
                  ],
                ),
                const SizedBox(height: 18),
                FieldTile(
                  label: 'Pickup',
                  value: d.pickup,
                  icon: Icons.place_outlined,
                  onTap: () => _pickPlace(isPickup: true),
                ),
                const SizedBox(height: 10),
                FieldTile(
                  label: 'Drop off',
                  value: d.dropoff,
                  icon: Icons.arrow_forward_rounded,
                  onTap: () => _pickPlace(isPickup: false),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: FieldTile(label: 'Date', value: d.dateLabel, onTap: _pickDate),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FieldTile(label: 'Start time', value: d.timeLabel, onTap: _pickTime),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _Stepper(
                        label: 'Duration',
                        value: '${d.hours} hours',
                        onMinus: d.hours > 2 ? () => setState(() => d.hours -= 1) : null,
                        onPlus: d.hours < 14 ? () => setState(() => d.hours += 1) : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _Stepper(
                        label: 'Passengers',
                        value: '${d.passengers} ${d.passengers == 1 ? "person" : "people"}',
                        onMinus: d.passengers > 1 ? () => setState(() => d.passengers -= 1) : null,
                        onPlus: d.passengers < 7 ? () => setState(() => d.passengers += 1) : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                const SectionHeader(title: 'Extras'),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (final e in extrasCatalogue)
                      TpChip(
                        label: e.price == 0 ? e.name : '${e.name}  +AUD ${e.price}',
                        selected: d.extras.contains(e.name),
                        onTap: () => setState(() {
                          if (!d.extras.remove(e.name)) d.extras.add(e.name);
                        }),
                      ),
                  ],
                ),
                if (d.passengers > 4)
                  const Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: _Note(
                      icon: Icons.info_outline_rounded,
                      text: 'More than four passengers needs a 7 seat car, so AUD 40 is added.',
                    ),
                  ),
                const SizedBox(height: 22),
                const SectionHeader(title: 'Notes for the driver'),
                const SizedBox(height: 4),
                TpCard(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  child: TextField(
                    controller: _notes,
                    maxLines: 3,
                    minLines: 2,
                    style: T.value,
                    onChanged: (v) => d.notes = v,
                    decoration: const InputDecoration(
                      hintText: 'Two stops on the way, please help with bags.',
                      hintStyle: T.small,
                      border: InputBorder.none,
                    ),
                  ),
                ),
                if (problem != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 14),
                    child: _Note(
                      icon: Icons.error_outline_rounded,
                      text: problem,
                      colour: AppColors.accent,
                    ),
                  ),
                const SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: StickyFooter(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Expanded(child: Text('Estimated fare', style: T.label)),
                Text('AUD ${d.estimateLow} to ${d.estimateHigh}', style: T.h3),
              ],
            ),
            const SizedBox(height: 12),
            PrimaryButton(
              label: 'Find verified drivers',
              onPressed: problem != null
                  ? null
                  : () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => DriversScreen(draft: d)),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? onMinus;
  final VoidCallback? onPlus;
  const _Stepper({required this.label, required this.value, this.onMinus, this.onPlus});

  @override
  Widget build(BuildContext context) {
    return TpCard(
      radius: AppRadius.field,
      padding: const EdgeInsets.fromLTRB(15, 11, 11, 11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: T.label),
          const SizedBox(height: 3),
          Text(value, style: T.value, maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _RoundIcon(icon: Icons.remove_rounded, onTap: onMinus, tooltip: 'Fewer $label'),
              const SizedBox(width: 8),
              _RoundIcon(icon: Icons.add_rounded, onTap: onPlus, tooltip: 'More $label'),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoundIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final String tooltip;
  const _RoundIcon({required this.icon, this.onTap, required this.tooltip});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onTap,
      padding: EdgeInsets.zero,
      icon: Icon(icon, size: 19, color: onTap == null ? AppColors.line : AppColors.ink),
      style: IconButton.styleFrom(
        backgroundColor: AppColors.bg,
        minimumSize: const Size(44, 44),
        shape: const CircleBorder(side: BorderSide(color: AppColors.line)),
      ),
    );
  }
}

class _Note extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color colour;
  const _Note({required this.icon, required this.text, this.colour = AppColors.muted});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: colour),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: colour,
              fontWeight: FontWeight.w500,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}

class _PlacePickerSheet extends StatefulWidget {
  final String title;
  final String current;
  final List<String> places;
  const _PlacePickerSheet({required this.title, required this.current, required this.places});

  @override
  State<_PlacePickerSheet> createState() => _PlacePickerSheetState();
}

class _PlacePickerSheetState extends State<_PlacePickerSheet> {
  late final TextEditingController _search = TextEditingController(text: widget.current);

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(widget.title, style: T.h3),
                const SizedBox(height: 14),
                TextField(
                  controller: _search,
                  autofocus: true,
                  style: T.value,
                  onSubmitted: (value) => Navigator.pop(context, value.trim()),
                  decoration: InputDecoration(
                    hintText: 'Search for a place',
                    prefixIcon: const Icon(Icons.search_rounded, color: AppColors.muted),
                    filled: true,
                    fillColor: AppColors.bg,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.field),
                      borderSide: const BorderSide(color: AppColors.line),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (final place in widget.places)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.place_outlined, color: AppColors.accent),
                          title: Text(place, style: T.value),
                          onTap: () => Navigator.pop(context, place),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                PrimaryButton(
                  label: 'Use this place',
                  onPressed: () => Navigator.pop(context, _search.text.trim()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
