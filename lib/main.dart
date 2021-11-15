import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home:  MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
   MyHomePage({Key? key}) : super(key: key);





  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final TextEditingController _controller = TextEditingController();
  WebSocketChannel channel = IOWebSocketChannel.connect("wss://ws.ifelse.io/");
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title:  const Text("WebSocket Example"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Form(
              child: TextFormField(
                decoration: const InputDecoration(labelText: "Send message to the server"),
                controller: _controller,
              ),
            ),
            StreamBuilder(
              stream: channel.stream,
              builder: (context, snapshot) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(snapshot.hasData ? '${snapshot.data}' : ''),
                );
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.send),
        onPressed: sendData,
      ),
    );
  }

  void sendData() {
    if (_controller.text.isNotEmpty) {
      channel.sink.add(_controller.text);
    }
  }
  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}
