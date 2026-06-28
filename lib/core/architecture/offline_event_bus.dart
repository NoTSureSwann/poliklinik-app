import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'event_bus.dart';

/// Offline EDA Fallback implementation.
/// Simulates a Vector-like storage with Big O(1) queue insertion/extraction.
/// Enqueues events when offline and replays them when back online.
class OfflineEventBus {
  static final OfflineEventBus _instance = OfflineEventBus._internal();
  factory OfflineEventBus() => _instance;
  OfflineEventBus._internal();

  // Using Double Linked Queue for O(1) insertion and extraction
  final Queue<AppEvent> _offlineQueue = ListQueue<AppEvent>();
  bool _isOffline = false;

  void setOfflineState(bool isOffline) {
    _isOffline = isOffline;
    if (!_isOffline) {
      _replayEvents();
    }
  }

  void publish(AppEvent event) {
    if (_isOffline) {
      // Big O(1) Queue Insertion
      _offlineQueue.add(event);
      if (kDebugMode) {
        print("Event Queued (Offline): ${event.name}");
      }
    } else {
      eventBus.publish(event);
    }
  }

  void _replayEvents() {
    // Replay all events stored while offline
    while (_offlineQueue.isNotEmpty) {
      final event = _offlineQueue.removeFirst(); // O(1) removal
      eventBus.publish(event);
      if (kDebugMode) {
        print("Event Replayed (Online): ${event.name}");
      }
    }
  }
  
  int get queueLength => _offlineQueue.length;
}

final offlineEventBus = OfflineEventBus();
