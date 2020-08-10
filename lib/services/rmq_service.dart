import 'package:dart_amqp/dart_amqp.dart';

class RMQService {
  final String userQueue = "survey";
  final String passQueue = "\$surv3yy!";
  final String vHostQueue = "/survey";
  final String hostQueue = "rmq.server.pptik.id";
  final String queues = "android_publish";

  void publish(String message) {
    ConnectionSettings settings = new ConnectionSettings(
      host: hostQueue,
      authProvider: new PlainAuthenticator(userQueue, passQueue),
      virtualHost: vHostQueue,
    );
    Client client = new Client(settings: settings);
    print("kirim data");
    client.channel().then((Channel channel) {
      return channel.queue(queues, durable: true);
    }).then((Queue queue) {
      queue.publish(message);
      client.close();
    });
  }
}
