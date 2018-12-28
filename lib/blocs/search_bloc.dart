import 'dart:async';
import 'package:bloc_test/blocs/bloc_provider.dart';

class SearchBloc implements BlocBase {
  final StreamController<String> _searchTermController =
      StreamController<String>();
  String _searchTerm;

  String get searchTerm => _searchTerm;
  Stream<String> get searchTermStream => _searchTermController.stream;

  void search(String searchTerm) {
    _searchTerm = searchTerm;
    _searchTermController.sink.add(searchTerm);
  }

  void dispose() {
    _searchTermController.close();
  }
}
