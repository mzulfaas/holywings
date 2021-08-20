import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:holywings/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';
import 'book-page.dart';

class BookDetail extends StatefulWidget {
  String genre;
  int price;
  String title;
  String keyword;
  String lokasi;
  String pengarang;
  bool statuspinjam;
  String tahun;
  int id;

  BookDetail(
      {Key key, this.genre, this.price, this.title, this.keyword, this.lokasi, this.pengarang, this.statuspinjam, this.tahun, this.id});

  @override
  _BookDetailState createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail> {

  List data = [];
  int page = 1;
  String getToken = "";
  bool pinjam = false;

  final _formKey = GlobalKey<FormState>();

  //BookController
  TextEditingController _pricebookController = TextEditingController();
  TextEditingController _titlebookController = TextEditingController();
  TextEditingController _keywordbookController = TextEditingController();
  TextEditingController _locationbookController = TextEditingController();
  TextEditingController _publishbookController = TextEditingController();

  Future<String> getDataBook() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    getToken = prefs.getString("getAccessToken");
    var urlGetBook = baseURL + "buku/";
    print(urlGetBook);
    Response r = await get(Uri.parse(urlGetBook), headers: {
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

  void getGenreDropdown() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    getToken = prefs.getString("getAccessToken");
    var headers = {'Authorization': "Bearer $getToken"};
    final response =
    await get(Uri.parse(urlGetGenreDropdown), headers: headers);
    var listData = jsonDecode(response.body);
    print(urlGetGenreDropdown);
    setState(() {
      _dataGenreDropdown = listData;
      if (!genreContains(_valGenreDropdown.toString())) {
        _valGenreDropdown = null;
      }
    });
    print("Data Genre Dropdown: $listData");
  }

  bool genreContains(String genre) {
    for (int i = 0; i < _dataGenreDropdown.length; i++) {
      if (genre == _dataGenreDropdown[i]["id"]) return true;
    }
    return false;
  }

  var urlGetPengarangDropdown = baseURL + "pengarang/";
  int _valPengarangDropdown;
  List<dynamic> _dataPengarangDropdown = [];

  void getPengarangDropdown() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    getToken = prefs.getString("getAccessToken");
    var headers = {'Authorization': "Bearer $getToken"};
    final response =
    await get(Uri.parse(urlGetPengarangDropdown), headers: headers);
    var listData = jsonDecode(response.body);
    print(urlGetPengarangDropdown);
    setState(() {
      _dataPengarangDropdown = listData;
      if (!pengarangContains(_valPengarangDropdown.toString())) {
        _valPengarangDropdown = null;
      }
    });
    print("Data Genre Dropdown: $listData");
  }

  bool pengarangContains(String genre) {
    for (int i = 0; i < _dataPengarangDropdown.length; i++) {
      if (genre == _dataPengarangDropdown[i]["id"]) return true;
    }
    return false;
  }

  processSubmitBookForm(
      int genre,
      int price,
      String title,
      String keyword,
      String lokasi,
      int pengarang,
      bool statuspinjam,
      String tahun,
      ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    getToken = prefs.getString("getAccessToken");
    var urlPostSubmitBook = baseURL + "buku/" +"?id&=" + widget.id.toString();
    print("Ini url Post Submit Customer : $urlPostSubmitBook");
    var jsonSubmitCustomerForm = await put(
        Uri.parse(
          urlPostSubmitBook,
        ),
        headers: <String, String>{
          'Authorization': "Bearer $getToken",
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "genre": [
            genre
          ],
          "harga": price,
          "judul": "$title",
          "keyword": [
            "$keyword"
          ],
          "lokasi": "$lokasi",
          "pengarang": [
            pengarang,
          ],
          "pinjam": pinjam,
          "tahunTerbit": "$tahun",
        }));
    print(jsonSubmitCustomerForm.body.toString());
    if(jsonSubmitCustomerForm.statusCode == 200){
      return jsonDecode(jsonSubmitCustomerForm.body);
    }else{
      throw Exception("Failed");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataBook();
    getGenreDropdown();
    getPengarangDropdown();
    _pricebookController.text = widget.price.toString();
    _titlebookController.text = widget.title;
    _keywordbookController.text = widget.keyword;
    _locationbookController.text = widget.lokasi;
    _publishbookController.text = widget.tahun;
    // convertTextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Book",
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
                    //text harga
                    Container(
                      width: 300,
                      child: TextFormField(
                        textCapitalization: TextCapitalization.words,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter field!!';
                          }
                          return null;
                        },
                        textAlign: TextAlign.center,
                        controller: _pricebookController,
                        keyboardType: TextInputType.number,
                        autofocus: false,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Create New price book',
                          filled: true,
                          contentPadding: EdgeInsets.all(5),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    //Text title
                    Container(
                      width: 300,
                      child: TextFormField(
                        textCapitalization: TextCapitalization.words,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter field!!';
                          }
                          return null;
                        },
                        textAlign: TextAlign.center,
                        controller: _titlebookController,
                        keyboardType: TextInputType.text,
                        autofocus: false,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Create New title book',
                          filled: true,
                          contentPadding: EdgeInsets.all(5),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    //Text keyword
                    Container(
                      width: 300,
                      child: TextFormField(
                        controller: _keywordbookController,
                        textCapitalization: TextCapitalization.words,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter field!!';
                          }
                          return null;
                        },
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.text,
                        autofocus: false,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Create New keyword book',
                          filled: true,
                          contentPadding: EdgeInsets.all(5),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    //Text lokasi
                    Container(
                      width: 300,
                      child: TextFormField(
                        controller: _locationbookController,
                        textCapitalization: TextCapitalization.words,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter field!!';
                          }
                          return null;
                        },
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.text,
                        autofocus: false,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Create New location book',
                          filled: true,
                          contentPadding: EdgeInsets.all(5),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    //Text Spesialisasi genre
                    DropdownButton(
                      hint: Text("Select Pengarang"),
                      value: _valPengarangDropdown,
                      items: _dataPengarangDropdown.map((item) {
                        return DropdownMenuItem(
                          child: Text(item['nama'] ?? "loading.."),
                          value: item['id'],
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _valPengarangDropdown = value;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    //checkbox
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Status pinjam buku"),
                            Checkbox(
                              value: pinjam,
                              onChanged: (bool value) {
                                setState(() {
                                  pinjam = value;
                                  print(value);
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    //Text tahun
                    Container(
                      width: 300,
                      child: TextFormField(
                        controller: _publishbookController,
                        textCapitalization: TextCapitalization.words,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter field!!';
                          }
                          return null;
                        },
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.text,
                        autofocus: false,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Create New publish book',
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
                            processSubmitBookForm(
                                _valGenreDropdown,
                                _pricebookController.hashCode,
                                _titlebookController.text,
                                _keywordbookController.text,
                                _locationbookController.text,
                                _valPengarangDropdown,
                                pinjam,
                                _publishbookController.text);
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                const AlertDialog(
                                  title: Text("Success"),
                                ));
                            Navigator.pop(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => new BookPage()));
                          }
                        })
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
