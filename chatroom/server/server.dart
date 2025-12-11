import 'dart:convert';
import 'dart:io';
//thread singolo
List<Socket>clients=[];
Future <void> main ()async{
  final server =await ServerSocket.bind(InternetAddress.anyIPv4, 3000);
  print("server aperto........");
  server.listen((Socket client){
      processo(client);
  });
}
void processo(Socket client){
  clients.add(client);
  print("adesso persone:${clients.length}");
  client.write("benvenuto alla chatroom di su");
  print("arriva da ${client.remoteAddress.address}");

  client.listen(
      (List<int>data){
        final message=utf8.decode(data).trim();
        if (message.isEmpty) return;
        print("messagio:$message");
        condivide(client, message);
      },
      onError: (error){
        print("no funzione");
        clients.remove(client);
        client.close();
      },
    onDone: (){
      print("non riesco collegare");
      clients.remove(client);
      client.close();
    }

  );
}
void condivide (Socket duimian,String messagio){
  for(int i=0;i<clients.length;i++){
      clients[i].write(messagio+"\n");
  }

}