import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) {
  return Future.value(Response(body: 'Welcome WS!'));
}
