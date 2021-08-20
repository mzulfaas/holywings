import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:holywings/shared/shared.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'member-page.dart';

class MemberDetail extends StatefulWidget {
  int id;
  String alamat;
  String genre;
  String nama;
  String pengarang;
  String ttl;

  MemberDetail(
      {Key key,
      this.alamat,
      this.genre,
      this.nama,
      this.pengarang,
      this.ttl,
      this.id});

  @override
  _MemberDetailState createState() => _MemberDetailState();
}

class _MemberDetailState extends State<MemberDetail> {
  String getToken = "";
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

  Future<void> processSubmitMemberForm(
    String alamat,
    int genre,
    String nama,
    int pengarang,
    String ttl,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    getToken = prefs.getString("getAccessToken");
    String urlPostSubmitMember = baseURL + "member/" + widget.id.toString();
    final headers = {
      'Authorization': "Bearer $getToken",
      'Content-Type': 'application/json; charset=UTF-8',
    };
    Map<String,dynamic> reqMember = {
      "alamat": "$alamat",
      "genreFavorit": [
        genre.toInt(),
      ],
      "nama": "$nama",
      "pengarangFavorit": [
        pengarang.toInt(),
      ],
      "tanggalLahir": "$ttl"
    };
    // final json = jsonEncode(<String, dynamic>{
    //     "alamat": "$alamat",
    //     "genreFavorit": [
    //       genre.toInt(),
    //     ],
    //     "nama": "$nama",
    //     "pengarangFavorit": [
    //       pengarang.toInt(),
    //   ],
    //     "tanggalLahir": "$ttl"
    // });
    // print(json);
    final response = await put(Uri.parse(urlPostSubmitMember), headers: headers, body: jsonEncode(reqMember));
    print("Status code: ${response.statusCode}");
    print("Body: ${response.body}");
  }

  final _formKey = GlobalKey<FormState>();

  //MemberController
  TextEditingController _alamatMemberController = TextEditingController();
  TextEditingController _namaMemberController = TextEditingController();
  TextEditingController _ttlMemberController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getGenreDropdown();
    getPengarangDropdown();
    _alamatMemberController.text = widget.alamat;
    _namaMemberController.text = widget.nama;
    _ttlMemberController.text = widget.ttl;
    // convertTextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    var ttlFormatter = new MaskTextInputFormatter(
        mask: '####-##-##', filter: {"#": RegExp(r'[0-9]')});
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
        child: Center(
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
            ],
          ),
        ),
      ),
    );
  }
}
