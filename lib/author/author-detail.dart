import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:holywings/author/author-page.dart';
import 'package:holywings/shared/shared.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';

class AuthorDetail extends StatefulWidget {
  int id;
  String name;
  String ttl;
  String genre;

  AuthorDetail({Key key, this.id, this.name, this.ttl, this.genre});

  @override
  _AuthorDetailState createState() => _AuthorDetailState();
}

class _AuthorDetailState extends State<AuthorDetail> {
  final _formkey = GlobalKey<FormState>();

  String getToken = "";

  List data = [];
  int page = 1;

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
    var urlPostSubmitGenre = baseURL + "pengarang/" +widget.id.toString();
    var map = new Map<String, dynamic>();
    map['nama'] = '$authorname';
    map['tanggalLahir'] = '$ttl';
    map['genreSpecialization'] = '$authorgenre';
    final msg = jsonEncode(map);
    Response response =
    await put(Uri.parse(urlPostSubmitGenre), headers: headers, body: msg);
    print(response.body);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataAuthor();
    getGenreDropdown();
    _authorttlNameController.text = widget.ttl;
    _authorNameController.text = widget.name;
  }

  //GenreNameController
  TextEditingController _authorNameController = TextEditingController();
  TextEditingController _authorttlNameController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    var ttlFormatter = new MaskTextInputFormatter(mask: '####-##-##', filter: { "#": RegExp(r'[0-9]') });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Genre Detail",
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Form(
                  key: _formkey,
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
                            "Update Author",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () async {
                            print(_formkey.currentState.validate());
                            if (_formkey.currentState.validate()) {
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
            ],
          ),
        ),
      ),
    );
  }
}
