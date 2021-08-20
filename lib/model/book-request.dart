class BookRequest {
  List<int> genre;
  int harga;
  String judul;
  List<String> keyword;
  String lokasi;
  List<int> pengarang;
  bool pinjam;
  String tahunTerbit;

  BookRequest(
      {this.genre,
        this.harga,
        this.judul,
        this.keyword,
        this.lokasi,
        this.pengarang,
        this.pinjam,
        this.tahunTerbit});

  BookRequest.fromJson(Map<String, dynamic> json) {
    genre = json['genre'].cast<int>();
    harga = json['harga'];
    judul = json['judul'];
    keyword = json['keyword'].cast<String>();
    lokasi = json['lokasi'];
    pengarang = json['pengarang'].cast<int>();
    pinjam = json['pinjam'];
    tahunTerbit = json['tahunTerbit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['genre'] = this.genre;
    data['harga'] = this.harga;
    data['judul'] = this.judul;
    data['keyword'] = this.keyword;
    data['lokasi'] = this.lokasi;
    data['pengarang'] = this.pengarang;
    data['pinjam'] = this.pinjam;
    data['tahunTerbit'] = this.tahunTerbit;
    return data;
  }
}