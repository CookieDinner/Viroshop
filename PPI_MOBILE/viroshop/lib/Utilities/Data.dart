//Singleton we flutterze
class Data{
  static final Data data = Data._internal();
  factory Data(){
    return data;
  }
  Data._internal();

  String dbPath = "";
  String tempDbPath = "";


}