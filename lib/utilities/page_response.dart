import 'dart:convert';

PageResponse pageResponseFromJson(String str) =>
    PageResponse.fromJson(json.decode(str));

String pageResponseToJson(PageResponse data) => json.encode(data.toJson());

class PageResponse {
  int pageIndex;
  int totalPages;
  int totalItems;
  bool last;
  bool first;
  List<dynamic> items;

  PageResponse({
    required this.pageIndex,
    required this.totalPages,
    required this.totalItems,
    required this.last,
    required this.first,
    required this.items,
  });

  factory PageResponse.fromJson(Map<String, dynamic> json) => PageResponse(
        pageIndex: json["pageIndex"],
        totalPages: json["totalPages"],
        totalItems: json["totalItems"],
        last: json["last"],
        first: json["first"],
        items: json['items'],
      );

  Map<String, dynamic> toJson() => {
        "pageIndex": pageIndex,
        "totalPages": totalPages,
        "totalItems": totalItems,
        "last": last,
        "first": first,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}
