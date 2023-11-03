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
  List<int> numbers = [];
  late ScrollController _scrollController;
  int page = 1;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    fetchUsers(page);
    for (int i = 1; i <= 200; i++) {
      numbers.add(i);
    }
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          color: Colors.white10,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.vertical,
            itemCount: userNames.length + 1,
            itemBuilder: (context, index) {
              if (index < userNames.length) {
                final userName = userNames[index];
                final number = numbers[index];
                return SizedBox(
                  height: 100,
                  child: Row(
                    children: [
                      Text(
                        number.toString() + '.\t',
                        style: TextStyle(fontSize: 25),
                      ),
                      Text(
                        userName,
                        style: const TextStyle(fontSize: 30.0),
                      ),
                    ],
                  ),
                );
              } else if (isLoading) {
                return Center(child: CircularProgressIndicator());
              } else {
                return Container(); // Placeholder for the end of the list
              }
            },
          ),
        ),
      ),
    );
  }

  void fetchUsers(page) async {
    print('API Fetching...');
    const pageSize =8;
    const  page = 100;
    const url = 'https://randomuser.me/api/?results=$pageSize&page=$page';
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      final results = json['results'] as List<dynamic>;

      setState(() {
        userNames.addAll(results.map((user) => user['name']['first'].toString()));
      });

      print('Completed');
      isLoading = false; // Data is loaded
    } else {
      print('Failed to fetch data. Status code: ${response.statusCode}');
    }
  }

  void _scrollListener() {
    if (_scrollController.position.extentAfter == 0 && !isLoading) {
      // If we've reached the end of the list and not already loading, load more data.
      setState(() {
        isLoading = true;
        page++; // Increment the page
      });
      fetchUsers(page);
    }
  }
}
