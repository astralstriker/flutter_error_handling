import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_error_handling/api_exception.dart';
import 'package:flutter_error_handling/result_e.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final StreamController<Result> _resultController =
      StreamController<Result>.broadcast();

  Stream<Result> get _resultStream => _resultController.stream;

  Sink<Result> get _resultSink => _resultController.sink;

  @override
  void dispose() {
    _resultController?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      title: 'Error Handling',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Error Handling'),
        ),
        body: Builder(builder: (context) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Spacer(),
                StreamListener(
                  stream: _resultStream,
                  onError: (error) {
                    (error as ApiException).when(
                      noNetworkException:
                      (exception) =>  Scaffold.of(context).showSnackBar(SnackBar(content: Text(exception.toString()),)),
                      notFoundException: print,
                      customException: print,
                      unauthorizedException: print,
                    );
                  },
                  child: StreamBuilder<Result>(
                      stream: _resultStream,
                      builder: (context, snapshot) {
                        final message = !snapshot.hasError ? snapshot.data?.when(
                            onSuccess: (success) => success.value,
                            onMalformedDataError: (error) => error.value,
                            onNullResponseError: (nullError) =>
                            nullError.value) ??
                            "No operation performed yet" : "Exception occurred";

                        return Text(
                          message,
                          style: Theme.of(context).primaryTextTheme.display1,
                        );
                      }),
                ),
                Spacer(),
                RaisedButton(
                  child: Text('Ok'),
                  color: Colors.green,
                  onPressed: () {
                    try {
                      _resultSink.add(Success("success!"));
                    }
                    on ApiException catch (e) {
                      _resultController.addError(e);
                    }
                  },
                ),
                RaisedButton(
                  child: Text('Error#1'),
                  color: Colors.orange,
                  onPressed: () {
                    _resultSink.add(MalformedDataError());
                  },
                ),
                RaisedButton(
                  child: Text('Error#2'),
                  color: Colors.orange,
                  onPressed: () => _resultSink.add(NullResponseError()),
                ),
                RaisedButton(
                  child: Text('Exception#1'),
                  color: Colors.red,
                  onPressed: () {
                    _resultController.addError(NoNetworkException());
                  },
                ),
                RaisedButton(
                  child: Text('Exception#2'),
                  color: Colors.red,
                  onPressed: () =>
                      _resultController.addError(NotFoundException()),
                ),
                RaisedButton(
                  child: Text('Exception#3'),
                  color: Colors.red,
                  onPressed: () => _resultController
                      .addError(CustomException("Custom Exception")),
                ),
                RaisedButton(
                  child: Text('Exception#4'),
                  color: Colors.red,
                  onPressed: () =>
                      _resultController.addError(UnauthorizedException()),
                ),
                Spacer(),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class StreamListener<T> extends StatefulWidget {
  final Stream<T> stream;
  final Function(T) onListen;
  final Function onError;
  final Widget child;

  const StreamListener({
    Key key,
    @required this.stream,
    @required this.child,
    this.onListen,
    this.onError,
  }) : super(key: key);

  @override
  _StreamListenerState createState() => _StreamListenerState();
}

class _StreamListenerState extends State<StreamListener> {
  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();

      _subscription = widget.stream.listen(widget.onListen ?? (data){})
        ..onError(widget.onError ?? (error){});
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
