
class Data{
  static final Data data = Data._internal();
  factory Data(){
    return data;
  }
  Data._internal();

  String dbPath = "";
  String tempDbPath = "";
  //Za pomocą loginKey będą autoryzowane wszystkie późniejsze requesty
  String loginKey = "";


}