import 'package:flutter/material.dart';
import 'package:holywings/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';

import 'genre-page.dart';

class GenreDetail extends StatefulWidget {
  int id;
  String name;

  GenreDetail({Key key, this.id, this.name});

  @override
  _GenreDetailState createState() => _GenreDetailState();
}

class _GenreDetailState extends State<GenreDetail> {

  final _formkey = GlobalKey<FormState>();

  //GenreNameController
  TextEditingController _genreNameController = TextEditingController();

  String getToken = "";

  processSubmitGenreForm(String genre) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    getToken = prefs.getString("getAccessToken");
    var headers = {'Authorization': "Bearer $getToken"};
    var urlPostSubmitGenre = baseURL + "genre";
    var map = new Map<String, dynamic>();
    map['name'] = '$genre';
    map['id'] = widget.id.toString();
    Response response = await put(Uri.parse(urlPostSubmitGenre), headers: headers, body: map);
    print(response.body);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _genreNameController.text = widget.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Genre Detail",
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        scrollDirection: Axis.vertical,
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 6),
              //Text Genre
              Center(
                child: Container(
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
                      hintText: 'Edit New Genre',
                      filled: true,
                      contentPadding: EdgeInsets.all(5),
                    ),
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
                    print(_formkey.currentState.validate());
                    if (_formkey.currentState.validate()) {
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
    );
  }
}
