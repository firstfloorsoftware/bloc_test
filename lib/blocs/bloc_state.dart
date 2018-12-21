import 'package:flutter/material.dart';
import 'package:bloc_test/blocs/bloc_provider.dart';

abstract class BlocState<T extends StatefulWidget, B extends BlocBase>
    extends State<T> {
  B _bloc;
  B get bloc => _bloc;
  B createBloc();

  @override
  void initState() {
    super.initState();
    _bloc = createBloc();
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }
}
