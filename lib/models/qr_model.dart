class QRModel {
  String title;
  String description;
  String date;
  String time;
  String url;

  QRModel({
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.url,
  });

  factory QRModel.matasquita(Map<String, dynamic> map) => QRModel(
        title: map["title"],
        description: map["description"],
        date: map["date"],
        time: map["time"],
        url: map["url"],
      );

}
