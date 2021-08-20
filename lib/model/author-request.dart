class AuthorRequest {
  int genreSpecialization;
  String nama;
  String tanggalLahir;

  AuthorRequest({this.genreSpecialization, this.nama, this.tanggalLahir});

  AuthorRequest.fromJson(Map<String, dynamic> json) {
    genreSpecialization = json['genreSpecialization'];
    nama = json['nama'];
    tanggalLahir = json['tanggalLahir'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['genreSpecialization'] = this.genreSpecialization;
    data['nama'] = this.nama;
    data['tanggalLahir'] = this.tanggalLahir;
    return data;
  }
}