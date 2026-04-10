class PostMediaItem {
  final String url;
  final String type;
  final String? altText;
  final String? thumbnailUrl;
  final List<UserTag>? userTags;
  final List<InstagramUserTag>? instagramUserTags;

  const PostMediaItem({
    required this.url,
    required this.type,
    this.altText,
    this.thumbnailUrl,
    this.userTags,
    this.instagramUserTags,
  });

  factory PostMediaItem.fromJson(Map<String, dynamic> json) {
    return PostMediaItem(
      url: json['url'] as String,
      type: json['type'] as String,
      altText: json['altText'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      userTags: (json['userTags'] as List<dynamic>?)
          ?.map((e) => UserTag.fromJson(e as Map<String, dynamic>))
          .toList(),
      instagramUserTags: (json['instagramUserTags'] as List<dynamic>?)
          ?.map((e) => InstagramUserTag.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'type': type,
      if (altText != null) 'altText': altText,
      if (thumbnailUrl != null) 'thumbnailUrl': thumbnailUrl,
      if (userTags != null) 'userTags': userTags!.map((e) => e.toJson()).toList(),
      if (instagramUserTags != null)
        'instagramUserTags': instagramUserTags!.map((e) => e.toJson()).toList(),
    };
  }
}

class UserTag {
  final String username;
  final double x;
  final double y;

  const UserTag({required this.username, required this.x, required this.y});

  factory UserTag.fromJson(Map<String, dynamic> json) {
    return UserTag(
      username: json['username'] as String,
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {'username': username, 'x': x, 'y': y};
}

class InstagramUserTag {
  final String username;
  final double x;
  final double y;

  const InstagramUserTag({required this.username, required this.x, required this.y});

  factory InstagramUserTag.fromJson(Map<String, dynamic> json) {
    return InstagramUserTag(
      username: json['username'] as String,
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {'username': username, 'x': x, 'y': y};
}

class Location {
  final String name;
  final String? platformId;
  final double latitude;
  final double longitude;

  const Location({
    required this.name,
    this.platformId,
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'] as String,
      platformId: json['platformId'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (platformId != null) 'platformId': platformId,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class DefaultPostContent {
  final String text;
  final List<String>? links;
  final bool? shortenLinks;
  final List<PostMediaItem>? media;
  final Location? location;

  const DefaultPostContent({
    required this.text,
    this.links,
    this.shortenLinks,
    this.media,
    this.location,
  });

  factory DefaultPostContent.fromJson(Map<String, dynamic> json) {
    return DefaultPostContent(
      text: json['text'] as String? ?? '',
      links: (json['links'] as List<dynamic>?)?.map((e) => e as String).toList(),
      shortenLinks: json['shortenLinks'] as bool?,
      media: (json['media'] as List<dynamic>?)
          ?.map((e) => PostMediaItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      location: json['location'] != null
          ? Location.fromJson(json['location'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      if (links != null) 'links': links,
      if (shortenLinks != null) 'shortenLinks': shortenLinks,
      if (media != null) 'media': media!.map((e) => e.toJson()).toList(),
      if (location != null) 'location': location!.toJson(),
    };
  }
}

class FacebookPostContent {
  final String text;
  final List<PostMediaItem>? media;
  final String? title;
  final bool? boostPost;
  final String? firstComment;
  final bool? showLinkPreview;

  const FacebookPostContent({
    required this.text,
    this.media,
    this.title,
    this.boostPost,
    this.firstComment,
    this.showLinkPreview,
  });

  factory FacebookPostContent.fromJson(Map<String, dynamic> json) {
    return FacebookPostContent(
      text: json['text'] as String? ?? '',
      media: (json['media'] as List<dynamic>?)
          ?.map((e) => PostMediaItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      title: json['title'] as String?,
      boostPost: json['boostPost'] as bool?,
      firstComment: json['firstComment'] as String?,
      showLinkPreview: json['showLinkPreview'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      if (media != null) 'media': media!.map((e) => e.toJson()).toList(),
      if (title != null) 'title': title,
      if (boostPost != null) 'boostPost': boostPost,
      if (firstComment != null) 'firstComment': firstComment,
      if (showLinkPreview != null) 'showLinkPreview': showLinkPreview,
    };
  }
}

class InstagramPostContent {
  final String text;
  final List<PostMediaItem>? media;
  final String? firstComment;
  final List<String>? collaborators;
  final String? audioTitle;
  final bool? shareToFeed;

  const InstagramPostContent({
    required this.text,
    this.media,
    this.firstComment,
    this.collaborators,
    this.audioTitle,
    this.shareToFeed,
  });

  factory InstagramPostContent.fromJson(Map<String, dynamic> json) {
    return InstagramPostContent(
      text: json['text'] as String? ?? '',
      media: (json['media'] as List<dynamic>?)
          ?.map((e) => PostMediaItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      firstComment: json['firstComment'] as String?,
      collaborators:
          (json['collaborators'] as List<dynamic>?)?.map((e) => e as String).toList(),
      audioTitle: json['audioTitle'] as String?,
      shareToFeed: json['shareToFeed'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      if (media != null) 'media': media!.map((e) => e.toJson()).toList(),
      if (firstComment != null) 'firstComment': firstComment,
      if (collaborators != null) 'collaborators': collaborators,
      if (audioTitle != null) 'audioTitle': audioTitle,
      if (shareToFeed != null) 'shareToFeed': shareToFeed,
    };
  }
}

class LinkedInPostContent {
  final String text;
  final List<PostMediaItem>? media;
  final bool? showLinkPreview;
  final bool? imageCarousel;

  const LinkedInPostContent({
    required this.text,
    this.media,
    this.showLinkPreview,
    this.imageCarousel,
  });

  factory LinkedInPostContent.fromJson(Map<String, dynamic> json) {
    return LinkedInPostContent(
      text: json['text'] as String? ?? '',
      media: (json['media'] as List<dynamic>?)
          ?.map((e) => PostMediaItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      showLinkPreview: json['showLinkPreview'] as bool?,
      imageCarousel: json['imageCarousel'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      if (media != null) 'media': media!.map((e) => e.toJson()).toList(),
      if (showLinkPreview != null) 'showLinkPreview': showLinkPreview,
      if (imageCarousel != null) 'imageCarousel': imageCarousel,
    };
  }
}

class TwitterPostContent {
  final String text;
  final List<PostMediaItem>? media;

  const TwitterPostContent({required this.text, this.media});

  factory TwitterPostContent.fromJson(Map<String, dynamic> json) {
    return TwitterPostContent(
      text: json['text'] as String? ?? '',
      media: (json['media'] as List<dynamic>?)
          ?.map((e) => PostMediaItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      if (media != null) 'media': media!.map((e) => e.toJson()).toList(),
    };
  }
}

class PinterestPostContent {
  final String text;
  final List<PostMediaItem>? media;
  final String title;
  final String board;

  const PinterestPostContent({
    required this.text,
    this.media,
    required this.title,
    required this.board,
  });

  factory PinterestPostContent.fromJson(Map<String, dynamic> json) {
    return PinterestPostContent(
      text: json['text'] as String? ?? '',
      media: (json['media'] as List<dynamic>?)
          ?.map((e) => PostMediaItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      title: json['title'] as String? ?? '',
      board: json['board'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      if (media != null) 'media': media!.map((e) => e.toJson()).toList(),
      'title': title,
      'board': board,
    };
  }
}

class TikTokPostContent {
  final String text;
  final List<PostMediaItem>? media;
  final bool allowComments;
  final bool allowDuet;
  final bool allowStitch;
  final bool commercialContent;
  final String? privacy;

  const TikTokPostContent({
    required this.text,
    this.media,
    required this.allowComments,
    required this.allowDuet,
    required this.allowStitch,
    required this.commercialContent,
    this.privacy,
  });

  factory TikTokPostContent.fromJson(Map<String, dynamic> json) {
    return TikTokPostContent(
      text: json['text'] as String? ?? '',
      media: (json['media'] as List<dynamic>?)
          ?.map((e) => PostMediaItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      allowComments: json['allowComments'] as bool? ?? true,
      allowDuet: json['allowDuet'] as bool? ?? true,
      allowStitch: json['allowStitch'] as bool? ?? true,
      commercialContent: json['commercialContent'] as bool? ?? false,
      privacy: json['privacy'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      if (media != null) 'media': media!.map((e) => e.toJson()).toList(),
      'allowComments': allowComments,
      'allowDuet': allowDuet,
      'allowStitch': allowStitch,
      'commercialContent': commercialContent,
      if (privacy != null) 'privacy': privacy,
    };
  }
}

class YouTubePostContent {
  final String title;
  final String description;
  final List<PostMediaItem>? media;
  final String? audience;
  final String? privacy;
  final String? category;
  final List<String>? tags;

  const YouTubePostContent({
    required this.title,
    required this.description,
    this.media,
    this.audience,
    this.privacy,
    this.category,
    this.tags,
  });

  factory YouTubePostContent.fromJson(Map<String, dynamic> json) {
    return YouTubePostContent(
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      media: (json['media'] as List<dynamic>?)
          ?.map((e) => PostMediaItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      audience: json['audience'] as String?,
      privacy: json['privacy'] as String?,
      category: json['category'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      if (media != null) 'media': media!.map((e) => e.toJson()).toList(),
      if (audience != null) 'audience': audience,
      if (privacy != null) 'privacy': privacy,
      if (category != null) 'category': category,
      if (tags != null) 'tags': tags,
    };
  }
}

class PlatformPost {
  final String socialConnectionId;
  final String platformPostId;
  final String? publishedAt;
  final String status;
  final String? error;

  const PlatformPost({
    required this.socialConnectionId,
    required this.platformPostId,
    this.publishedAt,
    required this.status,
    this.error,
  });

  factory PlatformPost.fromJson(Map<String, dynamic> json) {
    return PlatformPost(
      socialConnectionId: json['socialConnectionId'] as String,
      platformPostId: json['platformPostId'] as String,
      publishedAt: json['publishedAt'] as String?,
      status: json['status'] as String,
      error: json['error'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'socialConnectionId': socialConnectionId,
      'platformPostId': platformPostId,
      if (publishedAt != null) 'publishedAt': publishedAt,
      'status': status,
      if (error != null) 'error': error,
    };
  }
}

class PostContent {
  final DefaultPostContent defaultContent;
  final FacebookPostContent? facebook;
  final InstagramPostContent? instagram;
  final LinkedInPostContent? linkedin;
  final TwitterPostContent? twitter;
  final PinterestPostContent? pinterest;
  final TikTokPostContent? tiktok;
  final YouTubePostContent? youtube;
  final List<PlatformPost>? platformPosts;

  const PostContent({
    required this.defaultContent,
    this.facebook,
    this.instagram,
    this.linkedin,
    this.twitter,
    this.pinterest,
    this.tiktok,
    this.youtube,
    this.platformPosts,
  });

  factory PostContent.fromJson(Map<String, dynamic> json) {
    return PostContent(
      defaultContent: DefaultPostContent.fromJson(
          json['default'] as Map<String, dynamic>),
      facebook: json['facebook'] != null
          ? FacebookPostContent.fromJson(json['facebook'] as Map<String, dynamic>)
          : null,
      instagram: json['instagram'] != null
          ? InstagramPostContent.fromJson(json['instagram'] as Map<String, dynamic>)
          : null,
      linkedin: json['linkedin'] != null
          ? LinkedInPostContent.fromJson(json['linkedin'] as Map<String, dynamic>)
          : null,
      twitter: json['twitter'] != null
          ? TwitterPostContent.fromJson(json['twitter'] as Map<String, dynamic>)
          : null,
      pinterest: json['pinterest'] != null
          ? PinterestPostContent.fromJson(json['pinterest'] as Map<String, dynamic>)
          : null,
      tiktok: json['tiktok'] != null
          ? TikTokPostContent.fromJson(json['tiktok'] as Map<String, dynamic>)
          : null,
      youtube: json['youtube'] != null
          ? YouTubePostContent.fromJson(json['youtube'] as Map<String, dynamic>)
          : null,
      platformPosts: (json['platformPosts'] as List<dynamic>?)
          ?.map((e) => PlatformPost.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'default': defaultContent.toJson(),
      if (facebook != null) 'facebook': facebook!.toJson(),
      if (instagram != null) 'instagram': instagram!.toJson(),
      if (linkedin != null) 'linkedin': linkedin!.toJson(),
      if (twitter != null) 'twitter': twitter!.toJson(),
      if (pinterest != null) 'pinterest': pinterest!.toJson(),
      if (tiktok != null) 'tiktok': tiktok!.toJson(),
      if (youtube != null) 'youtube': youtube!.toJson(),
      if (platformPosts != null)
        'platformPosts': platformPosts!.map((e) => e.toJson()).toList(),
    };
  }
}
