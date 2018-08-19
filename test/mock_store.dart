import 'dart:async';

import 'package:redux/redux.dart';

class MockStore implements Store {
  List<NextDispatcher> _dispatchers;
  final List<dynamic> actions = <dynamic>[];
  final StreamController _changeController;

  MockStore({List<Middleware> middleware = const []})
  : _changeController = new StreamController.broadcast()
  {
    _dispatchers = _createDispatchers(middleware);
  }

  List<NextDispatcher> _createDispatchers(List<Middleware> middleware) {
    final dispatchers = <NextDispatcher>[]..add((dynamic action) {
      this.actions.add(action);
      this._changeController.add(null);
    });
    for (var nextMiddleware in middleware.reversed) {
      final next = dispatchers.last;
      dispatchers.add(
        (dynamic action) => nextMiddleware(this, action, next)
      );
    }
    return dispatchers.reversed.toList();
  }

  @override
  Reducer reducer = (state, _a) => state;

  @override
  void dispatch(action) {
    _dispatchers[0](action);
  }

  @override
  Stream get onChange => _changeController.stream;

  Future wait() async { this.onChange.any((_) => true); }

  // TODO: implement state
  @override
  get state => null;

  @override
  Future teardown() async {
  }
}
