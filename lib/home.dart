import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> userNames = [];
  int currentIndex = 0;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    fetchUsers();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('API Call '),
        backgroundColor: Colors.blueGrey,
      ),
      body: Container(
        color: Colors.redAccent,
        child: SizedBox(
          height: 40,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: userNames.length,
            itemBuilder: (context, index) {
              final userName = userNames[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  userName,
                  style: TextStyle(fontSize: 30.0),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void fetchUsers() async {
    print('API Fetching...');
    const url =
        'https://newsdata.io/api/1/news?country=np&category=top&language=ne&apikey=pub_289961268fcc7c68fd65e762924c2c64a1a59';
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      final results = json['results'] as List<dynamic>;

      setState(() {
        userNames = results.map((user) => user['title'].toString()).toList();
      });

      print('Completed');
      startAutoScroll();
    } else {
      print('Failed to fetch data. Status code: ${response.statusCode}');
    }
  }

  void startAutoScroll() {
    const scrollDuration = Duration(seconds: 3);
    Timer.periodic(scrollDuration, (_) {
      if (_scrollController.hasClients) {
        final maxScrollExtent = _scrollController.position.maxScrollExtent;
        if (_scrollController.offset >= maxScrollExtent) {
          _scrollController.jumpTo(0);
        } else {
          _scrollController.animateTo(
            _scrollController.offset + 100, // Adjust the scrolling amount
            duration: scrollDuration,
            curve: Curves.linear,
          );
        }
      }
    });
  }
}
