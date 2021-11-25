import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:search_box/widget/user_model.dart';

class SearchBox extends StatefulWidget {
  SearchBox({Key? key}) : super(key: key);

  @override
  _SearchBoxState createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  late TextEditingController controllerSearch;

  List<User> items = [];

  Future<List<User>> readJson() async {
    final String response = await rootBundle.loadString('assets/data.json');
    List<User> list = (json.decode(response) as List)
        .map((data) => User.fromJson(data))
        .toList();
    print(list);
    return list;
  }

  @override
  void initState() {
    super.initState();
    controllerSearch = TextEditingController();
    readJson().then((value) {
      setState(() {
        items.addAll(value);
      });
    });
  }

  void filterSearchResult(String query) async {
    List<User> searchList = [];
    searchList = items;
    if (query.isNotEmpty) {
      List<User> listData = [];
      searchList.forEach((element) {
        if (element.name.toLowerCase().contains(query.toLowerCase())) {
          listData.add(element);
        }
      });
      setState(() {
        items.clear();
        items.addAll(listData);
      });
    } else {
      final localList = await readJson();
      setState(() {
        items.clear();
        items.addAll(localList);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Search Bar Example"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            sizedBoxSearchPage,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: searchTextFieldPageTop(),
            ),
            sizedBoxSearchPage,
            Expanded(child: listViewBuilderForItems()),
          ],
        ),
      ),
    );
  }

  Widget get sizedBoxSearchPage => SizedBox(height: 10);

  TextField searchTextFieldPageTop() {
    return TextField(
      controller: controllerSearch,
      onChanged: (value) async {
        filterSearchResult(value);
      },
      decoration: InputDecoration(
        labelText: 'Search In The List',
        hintText: 'Enter text',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
      ),
    );
  }

  ListView listViewBuilderForItems() {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: Icon(Icons.person),
            title: Text(
              items[index].name,
              style: TextStyle(color: Colors.black, fontSize: 24),
            ),
          ),
        );
      },
    );
  }
}
