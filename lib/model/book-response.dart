class BookResponse {
  int id;
  String judul;
  String tahunTerbit;
  String lokasi;
  int harga;
  List<Datas> pengarang;
  List<Datas> genre;
  List<String> keyword;
  bool pinjam;

  BookResponse(
      {this.id,
        this.judul,
        this.tahunTerbit,
        this.lokasi,
        this.harga,
        this.pengarang,
        this.genre,
        this.keyword,
        this.pinjam});

  BookResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    judul = json['judul'];
    tahunTerbit = json['tahunTerbit'];
    lokasi = json['lokasi'];
    harga = json['harga'];
    if (json['pengarang'] != null) {
      // ignore: deprecated_member_use
      pengarang = new List<Datas>();
      json['pengarang'].forEach((v) {
        pengarang.add(new Datas.fromJson(v));
      });
    }
    if (json['genre'] != null) {
      // ignore: deprecated_member_use
      genre = new List<Datas>();
      json['genre'].forEach((v) {
        genre.add(new Datas.fromJson(v));
      });
    }
    keyword = json['keyword'].cast<String>();
    pinjam = json['pinjam'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['judul'] = this.judul;
    data['tahunTerbit'] = this.tahunTerbit;
    data['lokasi'] = this.lokasi;
    data['harga'] = this.harga;
    if (this.pengarang != null) {
      data['pengarang'] = this.pengarang.map((v) => v.toJson()).toList();
    }
    if (this.genre != null) {
      data['genre'] = this.genre.map((v) => v.toJson()).toList();
    }
    data['keyword'] = this.keyword;
    data['pinjam'] = this.pinjam;
    return data;
  }
}

class Datas {
  int id;
  String name;

  Datas({this.id, this.name});

  Datas.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}