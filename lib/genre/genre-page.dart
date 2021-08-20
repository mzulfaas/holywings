import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:holywings/genre/genre-detail-page.dart';
import 'package:holywings/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';

class GenrePage extends StatefulWidget {
  const GenrePage({Key key}) : super(key: key);

  @override
  _GenrePageState createState() => _GenrePageState();
}

class _GenrePageState extends State<GenrePage> {
  List data = [];
  int page = 1;
  String getToken = "";
  Future<String> getDataGenre() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    getToken = prefs.getString("getAccessToken");
    var urlGetGenre = baseURL + "genre";
    print(urlGetGenre);
    Response r = await get(Uri.parse(urlGetGenre), headers: {
      "Authorization": "Bearer $getToken",
    });
    print("Token: $getToken");
    print(r.statusCode);
    print(r.body);
    this.setState(() {
      data = json.decode(r.body);
    });
  }

  processSubmitGenreForm(String genre) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    getToken = prefs.getString("getAccessToken");
    var headers = {'Authorization': "Bearer $getToken"};
    var urlPostSubmitGenre = baseURL + "genre";
    var map = new Map<String, dynamic>();
    map['name'] = '$genre';
    Response response =
        await post(Uri.parse(urlPostSubmitGenre), headers: headers, body: map);
    print(response.body);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataGenre();
  }

  final _formKey = GlobalKey<FormState>();

  //GenreNameController
  TextEditingController _genreNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Genre",
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 6),
                    //Text Genre
                    Container(
                      width: 300,
                      child: TextFormField(
                        textCapitalization: TextCapitalization.words,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Customer Name!!';
                          }
                          return null;
                        },
                        textAlign: TextAlign.center,
                        controller: _genreNameController,
                        keyboardType: TextInputType.text,
                        autofocus: false,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Create New Genre',
                          filled: true,
                          contentPadding: EdgeInsets.all(5),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    //Button submit genre
                    // ignore: deprecated_member_use
                    RaisedButton(
                        color: Colors.blue,
                        child: Text(
                          "Submit",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () async {
                          print(_formKey.currentState.validate());
                          if (_formKey.currentState.validate()) {
                            print("Ini Proses Submit");
                            processSubmitGenreForm(_genreNameController.text);
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    const AlertDialog(
                                      title: Text("Success"),
                                    ));
                            Navigator.pop(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => new GenrePage()));
                          }
                        })
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              "List Genre",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Container(
                height: 400,
                width: 300,
                child: ListView.builder(
                  itemCount: data == null ? 0 : data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return new Container(
                      height: 110,
                      // width: 30,
                      padding: EdgeInsets.all(7),
                      child: Card(
                        elevation: 3,
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              padding: EdgeInsets.all(6),
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Text(
                                    "Name : ${data[index]["name"]}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        "Edit",
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => GenreDetail(
                                                      id: data[index]["id"],
                                                      name: data[index]['name'],
                                                    )
                                                )
                                            );
                                          },
                                          icon: Icon(Icons.edit)),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
