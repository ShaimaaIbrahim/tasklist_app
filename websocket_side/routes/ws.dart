import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';

//1-run on terminal install wscat(npm install -g wscat)
//2- run on terminal (wscat -c ws://localhost:8080/ws)

Future<Response> onRequest(RequestContext context) async {
  final handler = webSocketHandler((channel, protocol) {
    print("Client connected 🌱");

    // Listen for messages from the WebSocket.
    channel.stream.listen((message) {
      print('Received message: $message');
      // Echo the message back to the client.
      channel.sink.add('$message');
    },
      onDone: () => print("Client disconnected 🌱"),
      onError: (error) => print('WebSocket error: $error'),
    );
  });

  // Correctly return the handler
  return handler(context);
}