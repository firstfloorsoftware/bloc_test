import 'dart:async';

/// A simple StreamController wrapper, keeping a reference to the last added value.
class ValueStreamController<T> {
  final StreamController<T> _controller;
  T _value;
  ValueStream<T> _valueStream;

  ValueStreamController() : _controller = StreamController<T>();
  ValueStreamController.broadcast() : _controller = StreamController<T>.broadcast();

  ValueStream<T> get valueStream => _valueStream = _valueStream ?? ValueStream(this);

  void add(T value) {
    _value = value;
    _controller.add(value);
  }

  void close() {
    _controller.close();
  }
}

/// Provides access to a stream and it's last added value.
class ValueStream<T> {
  final ValueStreamController<T> _controller;

  const ValueStream(this._controller);

  Stream<T> get stream => _controller._controller.stream;
  T get value => _controller._value;
}
