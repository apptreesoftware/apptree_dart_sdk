import 'dart:convert';
import 'dart:math';

import 'package:logging/logging.dart';
import 'package:server/server.dart';
import 'package:shelf_plus/shelf_plus.dart';
import 'errors.dart';

final serverLogger = Logger('Server')..level = Level.INFO;

/// {@template server}
/// A package containing the apptree connector basic server template components
/// {@endtemplate}
class Server<T extends AppBase> {
  final T app;

  final router = Router().plus;
  Server(this.app);

  void addCollectionRoute<TInput,
      TDataSource extends CollectionDataSource<TInput, TOutput>, TOutput>(
    String path,
    TInput Function(Map<String, dynamic>) fromJson,
  ) {
    router.post(
      path,
      (Request request) async {
        var dataSource = app.get<TDataSource>();
        var data = await handleCollectionPostRequest<TInput, List<TOutput>>(
          app: app,
          request: request,
          fromJson: fromJson,
          fetch: (input) => dataSource.getCollection(input),
        );
        return data;
      },
    );
  }

  Future<ShelfRunContext> start() async {
    return shelfRun(_handler);
  }

  Handler _handler() {
    return router.call;
  }

  Future<dynamic> handleCollectionPostRequest<TInput, TOutput>(
      {required AppBase app,
      required Request request,
      required TInput Function(Map<String, dynamic>) fromJson,
      required dynamic Function(TInput) fetch}) async {
    var traceId = _generateTraceId();
    try {
      var input = await _parseJsonBody<TInput>(request, fromJson);
      _logRequest(traceId, request, input);
      var result = await fetch(input);
      _logResponse(traceId, request, result);
      return result;
    } on JsonInputException catch (e) {
      serverLogger.severe('Error: $traceId - ${e.toString()}', e);
      return Response.badRequest(
        body: json.encode({'error': e.toString()}),
        encoding: utf8,
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      serverLogger.severe('Error: $traceId - ${e.toString()}', e);
      return Response.badRequest(
        body: json.encode({'error': e.toString()}),
        encoding: utf8,
        headers: {'content-type': 'application/json'},
      );
    }
  }

  Future<T> _parseJsonBody<T>(
    Request request,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      var jsonBody = await request.body.asJson;
      return fromJson(jsonBody);
    } on FormatException catch (e) {
      throw JsonInputException(e.message);
    }
  }

  String _generateTraceId() {
    return '${DateTime.now().toIso8601String()}-${Random().nextInt(1000000)}';
  }

  void _logRequest<T>(String traceId, Request request, T? input) {
    serverLogger.info('Request: $traceId - ${request.method} ${request.url}');
    if (input != null) {
      serverLogger.info('Input: ${json.encode(input)}');
    } else {
      serverLogger.info('Input: null');
    }
  }

  void _logResponse<T>(String traceId, Request request, T? output) {
    serverLogger.info('Response: $traceId - ${request.method} ${request.url}');
    if (output != null) {
      if (output is List && output.isNotEmpty) {
        var firstItem = output.first;
        var remainingCount = output.length - 1;
        serverLogger.info(
          'Output preview: ${json.encode(firstItem)} (and $remainingCount more items)',
        );
      } else if (output is Map) {
        serverLogger.info('Output: ${json.encode(output)}');
      }
    } else {
      serverLogger.info('Output: null');
    }
  }
}
