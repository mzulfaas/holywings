import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:holywings/genre/genre-detail-page.dart';
import 'package:holywings/model/author-request.dart';
import 'package:holywings/model/genre.dart';
import 'package:holywings/shared/shared.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';

import 'author-detail.dart';

class AuthorPage extends StatefulWidget {
  const AuthorPage({Key key}) : super(key: key);

  @override
  _AuthorPageState createState() => _AuthorPageState();
}

class _AuthorPageState extends State<AuthorPage> {
  List data = [];
  int page = 1;
  String getToken = "";

  Future<String> getDataAuthor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    getToken = prefs.getString("getAccessToken");
    var urlGetGenre = baseURL + "pengarang/";
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

  var urlGetGenreDropdown = baseURL + "genre";
  int _valGenreDropdown;
  List<dynamic> _dataGenreDropdown = [];

  void getGenreDropdown()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    getToken = prefs.getString("getAccessToken");
    var headers = {'Authorization': "Bearer $getToken"};
    final response = await get(Uri.parse(urlGetGenreDropdown),headers: headers);
    var listData = jsonDecode(response.body);
    print(urlGetGenreDropdown);
    setState(() {
      _dataGenreDropdown = listData;
      if (!genreContains(_valGenreDropdown.toString())){
        _valGenreDropdown = null;
      }
    });
    print("Data Genre Dropdown: $listData");
  }
  bool genreContains(String genre){
    for (int i = 0; i < _dataGenreDropdown.length; i++){
      if (genre == _dataGenreDropdown[i]["id"])return true;
    }
    return false;
  }


  processSubmitAuthorForm(String authorname, String ttl, int authorgenre) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    getToken = prefs.getString("getAccessToken");
    var headers = {
      'Authorization': "Bearer $getToken",
      'Content-Type': 'application/json; charset=UTF-8',
    };
    var urlPostSubmitGenre = baseURL + "pengarang/";
    var map = new Map<String, dynamic>();
    map['nama'] = '$authorname';
    map['tanggalLahir'] = '$ttl';
    map['genreSpecialization'] = '$authorgenre';
    final msg = jsonEncode(map);
    Response response = await post(Uri.parse(urlPostSubmitGenre), headers: headers, body: msg);
    print(response.body);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataAuthor();
    getGenreDropdown();
    _authorttlNameController.text = "yyyy-mm-dd";
  }

  final _formKey = GlobalKey<FormState>();

  //GenreNameController
  TextEditingController _authorNameController = TextEditingController();
  TextEditingController _authorttlNameController = TextEditingController();
  TextEditingController _authorspecNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    var ttlFormatter = new MaskTextInputFormatter(mask: '####-##-##', filter: { "#": RegExp(r'[0-9]') });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Author",
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
                    //Text Name
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
                        controller: _authorNameController,
                        keyboardType: TextInputType.text,
                        autofocus: false,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Create New Name Author',
                          filled: true,
                          contentPadding: EdgeInsets.all(5),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    //Text ttl
                    Container(
                      width: 300,
                      child: TextFormField(
                        inputFormatters: [
                          ttlFormatter,
                        ],
                        textCapitalization: TextCapitalization.words,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Customer Name!!';
                          }
                          return null;
                        },
                        textAlign: TextAlign.center,
                        controller: _authorttlNameController,
                        keyboardType: TextInputType.datetime,
                        autofocus: false,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Create New ttl Author',
                          filled: true,
                          contentPadding: EdgeInsets.all(5),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    //Text Spesialisasi genre
                    DropdownButton(
                      hint: Text("Select Genre"),
                      value: _valGenreDropdown,
                      items: _dataGenreDropdown.map((item) {
                        return DropdownMenuItem(
                          child: Text(item['name'] ?? "loading.."),
                          value: item['id'],
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _valGenreDropdown = value;
                        });
                      },
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
                            processSubmitAuthorForm(_authorNameController.text, _authorttlNameController.text, _valGenreDropdown);
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                const AlertDialog(
                                  title: Text("Success"),
                                ));
                            Navigator.pop(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => new AuthorPage()));
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
              "List Author",
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
                      height: 150,
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
                                    "Name : ${data[index]["nama"]}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "TTL : ${data[index]["tanggalLahir"]}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "Genre : ${data[index]["genreSpecialization"]["name"]}",
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
                                                    builder: (context) => AuthorDetail(
                                                      id: data[index]["id"],
                                                      name: data[index]['nama'],
                                                      ttl: data[index]["tanggalLahir"],
                                                      genre: data[index]["genreSpecialization"]["name"],

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
