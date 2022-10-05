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
