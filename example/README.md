## Define a model

Assume we have a `Post` model as following:

```dart
class Post {
    static Future<List<Post>> getAll();
    static Future<Post> getDetail(int id);
    static Future<Post> delete(int id);
    static Future<Post> update(Post post);
    static Future<Post> create(Post newPost);
}
```

## Work with the list of posts

**Step 1. Define a provider**

```dart
class PostListProvider extends DataListProvider<Post> {
  @override
  Future<List<Post>> onFetch() {
    return Post.getAll();
  }

  @override
  Future<Post> onAdd(Post newItem) {
    return Post.create(newItem);
  }

  @override
  Future<int> onRemove(int index) async {
    final result = await Post.delete(data[index].id!);
    if (result.id != data[index].id) {
      throw Exception('Failed to remove item');
    }
    return index;
  }
}
```

**Step 2. In the parent widget**

```dart
ChangeNotifierProvider(
  create: (context) => PostListProvider(),
  child: YourChildWidget()
)
```

**Step 3. In the `build` function of the child widget**

```dart
final postList = Provider.of<PostListProvider>(context);

bool isLoading = postList.isLoading;
bool isError = postList.error;
bool isEmpty = postList.isEmpty;
bool isAdding = postList.isAdding;
bool isRemoving = postList.isRemoving;

List<Post> data = postList.data;

Future<void> refresh = postList.refresh;
Future<void> add = postList.add;
Future<void> removeAt = postList.removeAt;
```

## Work with a single post

**Step 1. Define your provider**

```dart
class PostDetailProvider extends BasicDataProvider<Post> {
  late int _id;

  PostDetailProvider({required int id}) {
    _id = id;
  }

  @override
  Future<Post> onFetch() async {
    return Post.getDetail(_id);
  }

  @override
  Future<Post> onUpdate(Post newData) async {
    return Post.update(newData);
  }
}
```

**Step 2. In the parent widget**

```dart
ChangeNotifierProvider(
  create: (context) => PostDetailProvider(),
  child: YourChildWidget()
)
```

**Step 3. In the `build` function of the child widget**

```dart
final postDetail = Provider.of<PostDetailProvider>(context);

bool isLoading = postDetail.isLoading;
bool isError = postDetail.error;
bool isEmpty = postDetail.isEmpty;

Post data = postDetail.data;

Future<void> refresh = postDetail.refresh;
Future<void> update = postDetail.update;
```

## Extended HTTP - fetch data from your API with caching and timeout options

All methods from `BaseClient` is inherited, including `get`, `post`, `put`, `patch` and more. See at [BaseClient APIs](https://pub.dev/documentation/http/latest/http/BaseClient-class.html)

```dart
// Call config at the App init to apply for all following requests, skip to use default config.
ExtendedHttp().config(
    Duration timeout = const Duration(seconds: 60),
    bool networkFirst = true,
    Map<String, String>? headers,
    String? baseURL,
);

// Usage: Post APIs
class Post {
  static Future<List<Post>> getAll({
    int page = 1,
    int limit = 10,
    String search = '',
  }) async {
    final uri = ExtendedHttp().createURI('/posts', params: {
      "_page": "$page",
      "_limit": "$limit",
      "q": search,
    });
    final res = await ExtendedHttp().get(uri);
    final dataList = jsonDecode(res.body) as List<dynamic>;
    return dataList.map((e) => Post.fromJson(e)).toList();
  }

  static Future<Post> getDetail(int id) async {
    final uri = ExtendedHttp().createURI('/posts/$id');
    final res = await ExtendedHttp().get(uri);
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return Post.fromJson(data);
  }

  static Future<Post> create(Post newPost) async {
    final uri = ExtendedHttp().createURI('/posts');
    final res = await ExtendedHttp().post(
      uri,
      body: newPost.toJson(),
    );
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return Post.fromJson(data);
  }

  static Future<Post> update(Post post) async {
    final uri = ExtendedHttp().createURI('/posts/${post.id}');
    final res = await ExtendedHttp().put(
      uri,
      body: post.toJson()..remove('id'),
    );
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return Post.fromJson(data);
  }

  static Future<Post> delete(int id) async {
    final uri = ExtendedHttp().createURI('/posts/$id');
    final res = await ExtendedHttp().delete(uri);
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return Post.fromJson(data);
  }
}
```
