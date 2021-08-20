import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:holywings/genre/genre-detail-page.dart';
import 'package:holywings/model/author-request.dart';
import 'package:holywings/model/book-response.dart';
import 'package:holywings/model/genre.dart';
import 'package:holywings/shared/shared.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';

import 'book-detail.dart';

class BookPage extends StatefulWidget {
  const BookPage({Key key}) : super(key: key);

  @override
  _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  List data = [];
  int page = 1;
  String getToken = "";

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
    var urlPostSubmitBook = baseURL + "buku/";
    print("Ini url Post Submit Customer : $urlPostSubmitBook");
    var jsonSubmitCustomerForm = await post(
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

  Future<List<BookResponse>> getAllBook() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var headers = {'Authorization': "Bearer $token"};
    Response response = await get(Uri.parse(baseURL + 'buku/'),headers: headers);
    var listBook = <BookResponse>[];
    for (var index = 0; index < response.body.length; index++) {
      listBook.add(BookResponse.fromJson(jsonDecode(response.body[index])));
    }
    return listBook;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataBook();
    getGenreDropdown();
    getPengarangDropdown();
    // convertTextEditingController();
  }

  final _formKey = GlobalKey<FormState>();

  //BookController
  TextEditingController _pricebookController = TextEditingController();
  TextEditingController _titlebookController = TextEditingController();
  TextEditingController _keywordbookController = TextEditingController();
  TextEditingController _locationbookController = TextEditingController();
  TextEditingController _publishbookController = TextEditingController();

  bool pinjam = false;

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
            SizedBox(
              height: 50,
            ),
            Text(
              "List Book",
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
                      height: 350,
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
                                  Container(
                                    height: 100,
                                    width: 200,
                                    child: Image.network(
                                        "https://asset.kompas.com/crops/mTnVdoYXCoN9ElxrsEDbdoY7y0s=/65x65:865x599/750x500/data/photo/2017/06/28/1265845835.jpg"),
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Text(
                                    "Genre : ${data[index]["genre"][0]["name"]}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "Price : ${data[index]["harga"]}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "Title : ${data[index]["judul"]}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "Keyword : ${data[index]["keyword"][0]}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "Lokasi : ${data[index]["lokasi"]}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "Pengarang : ${data[index]["pengarang"][0]["name"]}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "Pinjam : ${data[index]["pinjam"]}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "Tahun : ${data[index]["tahunTerbit"]}",
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
                                                    builder: (context) =>
                                                        BookDetail(
                                                          id: data[index]["id"],
                                                          genre: data[index]["genre"][0]["name"],
                                                          price: data[index]["harga"],
                                                          title: data[index]["judul"],
                                                          keyword: data[index]
                                                              [0],
                                                          lokasi: data[index]
                                                              ["lokasi"],
                                                          pengarang: data[index]["pengarang"]
                                                              [0]["name"],
                                                          statuspinjam:
                                                              data[index]
                                                                  ["pinjam"],
                                                          tahun: data[index]
                                                              ["tahunTerbit"],
                                                        )));
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
