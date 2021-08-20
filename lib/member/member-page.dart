import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:holywings/shared/shared.dart';
import 'package:http/http.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'member-detail.dart';

class MemberPage extends StatefulWidget {
  const MemberPage({Key key}) : super(key: key);

  @override
  _MemberPageState createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {

  List data = [];
  int page = 1;
  String getToken = "";

  Future<String> getDataMember() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    getToken = prefs.getString("getAccessToken");
    var urlGetMember = baseURL + "member/";
    print(urlGetMember);
    Response r = await get(Uri.parse(urlGetMember), headers: {
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

  processSubmitMemberForm(
      String alamat,
      int genre,
      String nama,
      int pengarang,
      String ttl,
      ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    getToken = prefs.getString("getAccessToken");
    var urlPostSubmitMember = baseURL + "member/";
    print("Ini url Post Submit Customer : $urlPostSubmitMember");
    var jsonSubmitCustomerForm = await post(
        Uri.parse(
          urlPostSubmitMember,
        ),
        headers: <String, String>{
          'Authorization': "Bearer $getToken",
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "alamat": "$alamat",
          "genreFavorit": [
            genre,
          ],
          "nama": "$nama",
          "pengarangFavorit": [
            pengarang,
          ],
          "tanggalLahir": "$ttl",
        }));
    print(jsonSubmitCustomerForm.body.toString());
    print(jsonSubmitCustomerForm.statusCode);
    print(jsonSubmitCustomerForm.request);
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
    getDataMember();
    getGenreDropdown();
    getPengarangDropdown();
    _ttlMemberController.text = "yyyy-mm-dd";
    // convertTextEditingController();
  }

  final _formKey = GlobalKey<FormState>();

  //MemberController
  TextEditingController _alamatMemberController = TextEditingController();
  TextEditingController _namaMemberController = TextEditingController();
  TextEditingController _ttlMemberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var ttlFormatter = new MaskTextInputFormatter(mask: '####-##-##', filter: { "#": RegExp(r'[0-9]') });
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
                    //Text alamat
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
                        controller: _alamatMemberController,
                        keyboardType: TextInputType.text,
                        autofocus: false,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Create New address member',
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
                    //Text nama
                    Container(
                      width: 300,
                      child: TextFormField(
                        controller: _namaMemberController,
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
                          hintText: 'Create New name member',
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
                    //Text lokasi
                    Container(
                      width: 300,
                      child: TextFormField(
                        inputFormatters: [
                          ttlFormatter,
                        ],
                        controller: _ttlMemberController,
                        textCapitalization: TextCapitalization.words,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter field!!';
                          }
                          return null;
                        },
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        autofocus: false,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Create New ttl member',
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
                            processSubmitMemberForm(
                                _alamatMemberController.text,
                                _valGenreDropdown,
                                _namaMemberController.text,
                                _valPengarangDropdown,
                                _ttlMemberController.text,
                                );
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                const AlertDialog(
                                  title: Text("Success"),
                                ));
                            Navigator.pop(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => new MemberPage()));
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
              "List Member",
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
                      height: 200,
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
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Text(
                                    "Alamat : ${data[index]["alamat"]}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "Genre Favorit : ${data[index]["genreFavorit"][0]["name"]}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "Nama : ${data[index]["nama"]}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "Pengarang Favorit : ${data[index]["pengarangFavorit"][0]["name"]}",
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
                                                        MemberDetail(
                                                          id: data[index]['id'],
                                                          alamat: data[index]['alamat'],
                                                          genre: data[index]["genreFavorit"][0]["name"],
                                                          nama: data[index]['nama'],
                                                          pengarang: data[index]['pengarangFavorit'][0]['name'],
                                                          ttl: data[index]['tanggalLahir'],
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
