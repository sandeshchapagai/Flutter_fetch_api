import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> {
  @override
  List<dynamic> users =[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Api call'),
        backgroundColor: Colors.blueGrey,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchUsers,
      ),
      body: Container(
        color: Colors.white54,
        child: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context,index){
          final  user=users[index];
          final  name = user['name']['first'];
          final email =user['email'];
          final imageUrl=user['picture']['thumbnail'];
          final phone=user['phone'];
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child:  Image.network(imageUrl)
            ),
            title: Text(name.toString()),
            // subtitle: Text(email),
            subtitle: Text(phone)

          );
        }),
      ),
    );
  }
  void fetchUsers() async {
    print('Api Fetched');
    const url = 'https://randomuser.me/api/?results=100';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);

    setState((){
       users = json['results'];
    });
    print('Completed');
  }
}
