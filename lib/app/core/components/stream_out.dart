import 'package:aco_plus/app/core/components/loading.dart';
import 'package:flutter/material.dart';

class StreamOut<T> extends StatelessWidget {
  final Stream<T> stream;
  final Widget Function(BuildContext context, T data) builder;
  final Function? preFunction;
  final bool condition;
  final Function? request;
  final Widget loading;

  const StreamOut({
    super.key,
    required this.stream,
    required this.builder,
    this.preFunction,
    this.condition = true,
    this.request,
    this.loading = const LoadingStreamOut(),
  });

  @override
  Widget build(BuildContext context) {
    if (condition && preFunction != null) preFunction!.call();
    return StreamBuilder<T>(
      stream: stream,
      builder: (value, snapshot) {
        if (snapshot.connectionState == ConnectionState.active ||
            snapshot.hasData) {
          if (snapshot.data != null) {
            return builder(value, snapshot.requireData);
          } else {
            return loading;
          }
        } else {
          return loading;
        }
      },
    );
  }
}

class StreamOutNull<T> extends StatelessWidget {
  final Stream<T?> stream;
  final Widget Function(BuildContext context, T? data) child;
  final Function? preFunction;
  final bool condition;
  final Function? request;
  final Widget loading;

  const StreamOutNull({
    super.key,
    required this.stream,
    required this.child,
    this.preFunction,
    this.condition = true,
    this.request,
    this.loading = const SizedBox(),
  });

  @override
  Widget build(BuildContext context) {
    if (condition && preFunction != null) preFunction!.call();
    return StreamBuilder<T?>(
      stream: stream,
      builder: (BuildContext value, AsyncSnapshot<T?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active ||
            snapshot.hasData) {
          return child(value, snapshot.data);
        } else {
          return loading;
        }
      },
    );
  }
}

class StreamOutResponse<ApiResponse, T> extends StatelessWidget {
  final Stream<ApiResponse> stream;
  final Widget Function(BuildContext context, T data) child;
  final Function? preFunction;
  final bool condition;
  final Function? request;
  final bool noLoading;
  final Widget? loading;
  final Widget? emptyLoading;
  final double columnLength;

  const StreamOutResponse({
    super.key,
    required this.stream,
    required this.child,
    this.preFunction,
    this.condition = true,
    this.noLoading = false,
    this.request,
    this.loading,
    this.emptyLoading,
    this.columnLength = 1,
  });

  @override
  Widget build(BuildContext context) {
    if (condition && preFunction != null) preFunction!.call();
    return StreamBuilder<ApiResponse>(
      stream: stream,
      builder: (value, snapshot) {
        if (snapshot.connectionState != ConnectionState.active) {
          return emptyLoading ?? loading ?? Container();
        }
        if (snapshot.connectionState == ConnectionState.active ||
            snapshot.hasData) {
          dynamic response = snapshot.requireData;
          if (response.hasData) {
            return child(value, response.data);
          } else if (response.hasLoading) {
            return loading ?? const SizedBox();
          } else {
            return Container();
          }
        } else if (noLoading) {
          return Container();
        } else {
          return loading ?? const SizedBox();
        }
      },
    );
  }
}
