import 'dart:async';

/// A simple StreamController wrapper, keeping a reference to the last added value.
class ValueStreamController<T> {
  final StreamController<T> _controller;
  T _value;
  ValueStream<T> _stream;

  ValueStreamController({T seedValue}) : _controller = StreamController<T>() {
    if (seedValue != null) {
      add(seedValue);
    }
  }

  ValueStreamController.broadcast({T seedValue})
      : _controller = StreamController<T>.broadcast() {
    if (seedValue != null) {
      add(seedValue);
    }
  }

  ValueStream<T> get stream =>
      _stream = _stream ?? ValueStream(this, _controller.stream);

  void add(T value) {
    _value = value;
    _controller.add(value);
  }

  void close() {
    _controller.close();
  }
}

/// Provides access to a stream and it's last added value.
class ValueStream<T> implements Stream<T> {
  final ValueStreamController<T> _controller;
  final Stream<T> _stream;

  ValueStream(this._controller, this._stream);

  T get value => _controller._value;

  @override
  Future<bool> any(bool Function(T element) test) => _stream.any(test);

  @override
  Stream<T> asBroadcastStream(
          {void Function(StreamSubscription<T> subscription) onListen,
          void Function(StreamSubscription<T> subscription) onCancel}) =>
      _stream.asBroadcastStream(onListen: onListen, onCancel: onCancel);

  @override
  Stream<E> asyncExpand<E>(Stream<E> Function(T event) convert) =>
      _stream.asyncExpand(convert);

  @override
  Stream<E> asyncMap<E>(FutureOr<E> Function(T event) convert) =>
      _stream.asyncMap(convert);

  @override
  Stream<R> cast<R>() => _stream.cast<R>();

  @override
  Future<bool> contains(Object needle) => _stream.contains(needle);

  @override
  Stream<T> distinct([bool Function(T previous, T next) equals]) =>
      _stream.distinct(equals);

  @override
  Future<E> drain<E>([E futureValue]) => _stream.drain(futureValue);

  @override
  Future<T> elementAt(int index) => _stream.elementAt(index);

  @override
  Future<bool> every(bool Function(T element) test) => _stream.every(test);

  @override
  Stream<S> expand<S>(Iterable<S> Function(T element) convert) =>
      _stream.expand(convert);

  @override
  Future<T> get first => _stream.first;

  @override
  Future<T> firstWhere(bool Function(T element) test, {T Function() orElse}) =>
      _stream.firstWhere(test, orElse: orElse);

  @override
  Future<S> fold<S>(
          S initialValue, S Function(S previous, T element) combine) =>
      _stream.fold(initialValue, combine);

  @override
  Future forEach(void Function(T element) action) => _stream.forEach(action);

  @override
  Stream<T> handleError(Function onError,
          {bool Function(dynamic error) test}) =>
      _stream.handleError(onError, test: test);

  @override
  bool get isBroadcast => _stream.isBroadcast;

  @override
  Future<bool> get isEmpty => _stream.isEmpty;

  @override
  Future<String> join([String separator = ""]) => _stream.join(separator);

  @override
  Future<T> get last => _stream.last;

  @override
  Future<T> lastWhere(bool Function(T element) test, {T Function() orElse}) =>
      _stream.lastWhere(test, orElse: orElse);

  @override
  Future<int> get length => _stream.length;

  @override
  StreamSubscription<T> listen(void Function(T event) onData,
          {Function onError, void Function() onDone, bool cancelOnError}) =>
      _stream.listen(onData,
          onError: onError, onDone: onDone, cancelOnError: cancelOnError);

  @override
  Stream<S> map<S>(S Function(T event) convert) => _stream.map(convert);

  @override
  Future pipe(StreamConsumer<T> streamConsumer) => _stream.pipe(streamConsumer);

  @override
  Future<T> reduce(T Function(T previous, T element) combine) =>
      _stream.reduce(combine);

  @override
  Future<T> get single => _stream.single;

  @override
  Future<T> singleWhere(bool Function(T element) test, {T Function() orElse}) =>
      _stream.singleWhere(test, orElse: orElse);

  @override
  Stream<T> skip(int count) => _stream.skip(count);

  @override
  Stream<T> skipWhile(bool Function(T element) test) => _stream.skipWhile(test);

  @override
  Stream<T> take(int count) => _stream.take(count);

  @override
  Stream<T> takeWhile(bool Function(T element) test) => _stream.takeWhile(test);

  @override
  Stream<T> timeout(Duration timeLimit,
          {void Function(EventSink<T> sink) onTimeout}) =>
      _stream.timeout(timeLimit, onTimeout: onTimeout);

  @override
  Future<List<T>> toList() => _stream.toList();

  @override
  Future<Set<T>> toSet() => _stream.toSet();

  @override
  Stream<S> transform<S>(StreamTransformer<T, S> streamTransformer) =>
      _stream.transform(streamTransformer);

  @override
  Stream<T> where(bool Function(T event) test) => _stream.where(test);
}
