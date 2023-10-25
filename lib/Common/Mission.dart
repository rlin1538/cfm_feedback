class Mission {
  int id;
  String name;
  String content;
  int pay;
  String version;
  bool isFinished;
  String claim;
  String deadline;
  String url;

  Mission({
    required this.id,
    required this.name,
    required this.content,
    required this.pay,
    required this.version,
    required this.isFinished,
    required this.claim,
    required this.deadline,
    required this.url,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'content': content,
      'pay': pay,
      'version': version,
      'isFinished': isFinished ? 1 : 0,
      'claim': claim,
      'deadline': deadline,
      'url': url,
    };
  }

  static Mission fromJson(Map jsonstr) {
    return Mission(
        id: jsonstr["id"],
        name: jsonstr["name"],
        content: jsonstr["content"],
        pay: jsonstr["pay"],
        version: jsonstr["version"],
        isFinished: jsonstr["isFinished"],
        claim: jsonstr["claim"],
        deadline: jsonstr["deadline"],
        url: jsonstr["url"]);
  }

  @override
  String toString() {
    return 'Mission{id: $id, name: $name, content: $content, pay: $pay}';
  }

  // Map toJson() {
  //   Map map = new Map();
  //   map["id"] = this.id;
  //   map["name"] = this.name;
  //   map["content"] = this.content;
  //   map["pay"] = this.pay;
  //   map["version"] = this.version;
  //   map["isFinished"] = this.isFinished;
  //   map["claim"] = this.claim;
  //   map["deadline"] = this.deadline;
  //   map["url"] = this.url;
  //   return map;
  // }

  String toJson() {
    return "{\"id\": $id, \"name\": \"$name\", \"content\": \"$content\", \"pay\": $pay, \"version\": \"$version\", \"isFinished\": $isFinished, \"claim\": \"$claim\", \"deadline\": \"$deadline\", \"url\": \"$url\"}";
  }
}
