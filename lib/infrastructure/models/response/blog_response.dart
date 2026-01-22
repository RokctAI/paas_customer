import '../data/blog_data.dart';
import '../data/help_data.dart';

class BlogResponse {
  final List<BlogData> data;
  final Links links;
  // final Meta meta;

  BlogResponse({
    required this.data,
    required this.links,
    // required this.meta,
  });

  factory BlogResponse.fromJson(Map<String, dynamic> json) {
    return BlogResponse(
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => BlogData.fromJson(e))
          .toList(),
      links: Links.fromJson(json['links'] ?? {}),
      // meta: Meta.fromJson(json['meta'] ?? {}),
    );
  }
}
