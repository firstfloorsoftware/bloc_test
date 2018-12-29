import 'package:bloc_test/blocs/bloc_provider.dart';
import 'package:bloc_test/blocs/value_stream.dart';

class SearchBloc implements BlocBase {
  final ValueStreamController<String> _searchTermController =
      ValueStreamController<String>();

  ValueStream<String> get searchTerm => _searchTermController.valueStream;

  void search(String searchTerm) {
    _searchTermController.add(searchTerm);
  }

  void dispose() {
    _searchTermController.close();
  }
}
