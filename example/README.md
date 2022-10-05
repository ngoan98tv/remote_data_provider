## Define a model

Assume we have a `Post` model as following:

```dart
class Post {
    static Future<List<Post>> getAll();
    static Future<Post> getDetail(int id);
    static Future<Post> create(Post newPost);
    static Future<Post> update(Post post);
    static Future<bool> delete(int id);
}
```

## Work with the list of posts

**Step 1. Define a provider**

```dart
class PostListProvider extends DataListProvider<Post> {@override

  PostListProvider() : super(isInfinity: true);

  @override
  Future<List<Post>> onFetch() {
    return Post.getAll(
      page: page,
      pageSize: pageSize,
      search: search,
      sortOptions: sortOptions,
    );
  }

  @override
  Future<String> onUpdate(String newData) async {
    await Future.delayed(Duration(milliseconds: 100));
    return newData;
  }

  @override
  Future<Post> onCreate(Post newItem) {
    return Post.create(newItem);
  }

  @override
  Future<bool> onDelete(Post item) async {
    return Post.delete(item.id!);
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
  final int _id;

  PostDetailProvider({required int id})
      : _id = id,
        super();

  @override
  Future<Post> onFetch() async {
    return Post.getDetail(_id);
  }

  @override
  Future<Post> onUpdate(Post newData) async {
    return Post.update(newData);
  }

  @override
  Future<bool> onDelete() {
    return Post.delete(_id);
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
