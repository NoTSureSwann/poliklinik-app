import 'dart:async';

/// Representasi sebuah event / message dalam arsitektur Event-Driven
class AppEvent {
  final String name;
  final dynamic payload;
  AppEvent(this.name, [this.payload]);
}

/// Implementasi Message Queue / Event Bus lokal menggunakan StreamController
class EventBus {
  static final EventBus _instance = EventBus._internal();
  factory EventBus() => _instance;
  EventBus._internal();

  final StreamController<AppEvent> _controller = StreamController<AppEvent>.broadcast();

  Stream<AppEvent> get stream => _controller.stream;

  /// Mempublish sebuah event ke seluruh subscriber
  void publish(AppEvent event) {
    _controller.sink.add(event);
    print("ðŸ”” [EventBus] Dispatched Event: ${event.name}");
  }

  /// Subscribe ke event tertentu (opsional dengan memfilter nama event)
  StreamSubscription<AppEvent> subscribe(String eventName, void Function(AppEvent) onData) {
    return _controller.stream.where((event) => event.name == eventName).listen(onData);
  }

  void dispose() {
    _controller.close();
  }
}

/// Singleton Helper
final eventBus = EventBus();
