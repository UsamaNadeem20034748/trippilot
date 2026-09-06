import 'dart:async';

import 'package:flutter/material.dart';

import '../data.dart';
import '../theme.dart';
import '../widgets.dart';
import 'rate.dart';

class TrackingScreen extends StatefulWidget {
  final TripDraft draft;
  const TrackingScreen({super.key, required this.draft});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  int _minutesAway = 4;
  double _progress = 0.15;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 8), (timer) {
      if (_minutesAway == 0) {
        timer.cancel();
        return;
      }
      setState(() {
        _minutesAway = _minutesAway - 1;
        _progress = _progress + 0.21;
        if (_progress > 1) {
          _progress = 1;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final driver = widget.draft.driver ?? drivers[0];
    final mapWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFE8EAF4),
      body: Stack(
        children: [
          Positioned.fill(child: Container(color: const Color(0xFFE3E7F1))),
          for (var i = 1; i <= 6; i++)
            Positioned(
              top: i * 118,
              left: 0,
              right: 0,
              child: Container(height: 10, color: Colors.white),
            ),
          for (var i = 1; i <= 3; i++)
            Positioned(
              top: 0,
              bottom: 0,
              left: i * (mapWidth / 4),
              child: Container(width: 10, color: Colors.white),
            ),
          Positioned(
            top: 400,
            left: 24,
            child: Container(
              width: 70,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFCFE8D6),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          for (var i = 0; i < 8; i++)
            Positioned(
              top: 178 + (i * 12),
              left: 44 + (i * (mapWidth * 0.075)),
              child: Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
              ),
            ),
          Positioned(
            top: 412,
            left: 30,
            child: Text('Hyde Park', style: T.small.copyWith(fontSize: 11)),
          ),
          Positioned(
            top: 128,
            left: 26,
            child: Text('George St', style: T.small.copyWith(fontSize: 11)),
          ),
          Positioned(
            top: 246,
            left: 26,
            child: Text('Pitt St', style: T.small.copyWith(fontSize: 11)),
          ),
          Positioned(
            top: 364,
            left: 26,
            child: Text('Elizabeth St', style: T.small.copyWith(fontSize: 11)),
          ),
          Positioned(
            top: 252,
            left: mapWidth * 0.66,
            child: const Icon(Icons.place_rounded, size: 42, color: AppColors.ink),
          ),
          Positioned(
            top: 296,
            left: mapWidth * 0.58,
            child: Text('Sydney Airport T1', style: T.value.copyWith(fontSize: 11)),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 900),
            top: 160 + (_progress * 86),
            left: 24 + (_progress * (mapWidth * 0.58)),
            child: Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: AppColors.verified,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: const Icon(Icons.directions_car_rounded, size: 20, color: Colors.white),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const Row(children: [BackChip()]),
                const Spacer(),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                  decoration: const BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
                    border: Border(top: BorderSide(color: AppColors.line)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        _minutesAway > 0
                            ? 'Driver is $_minutesAway min away'
                            : '${driver.name.split(" ").first} has arrived',
                        style: T.h2,
                      ),
                      const SizedBox(height: 14),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: _progress,
                          minHeight: 6,
                          backgroundColor: AppColors.line,
                          color: AppColors.verified,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Avatar(
                            initials: driver.initials,
                            gradient: driver.gradient,
                            size: 52,
                            verified: true,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(driver.name, style: T.title),
                                const SizedBox(height: 3),
                                Text(
                                  '${driver.car}  .  Plate ${driver.plate}',
                                  style: T.small,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          _CircleAction(
                            icon: Icons.call_rounded,
                            tooltip: 'Call the driver',
                            onTap: () => _showMessage('Calling ${driver.name}'),
                          ),
                          const SizedBox(width: 8),
                          _CircleAction(
                            icon: Icons.chat_bubble_outline_rounded,
                            tooltip: 'Message the driver',
                            onTap: () => _showMessage('Opening the chat with ${driver.name}'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: SecondaryButton(
                              label: 'Share trip',
                              onPressed: () =>
                                  _showMessage('Trip link sent to your trusted contact'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: PrimaryButton(
                              label: 'End trip',
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RateScreen(draft: widget.draft),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleAction extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  const _CircleAction({required this.icon, required this.tooltip, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onTap,
      icon: Icon(icon, size: 19, color: AppColors.ink),
      style: IconButton.styleFrom(
        backgroundColor: AppColors.bg,
        minimumSize: const Size(46, 46),
        shape: const CircleBorder(side: BorderSide(color: AppColors.line)),
      ),
    );
  }
}
