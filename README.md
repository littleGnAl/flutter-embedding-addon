# flutter embedding add-on
For the better experience when adding [Flutter to the existing APP](https://flutter.dev/docs/development/add-to-app), we will pre-warmed the `FlutterEngine` when the APP starts, and then use it later. This does make the better experience when launching the Flutter page, but if the Flutter page has not been opened after the APP is started, the cached `FlutterEngine` will always exist in memory, which causing the memory of `FlutterEngine` to be wasted. Because the memory of the cached `FlutterEngine` cannot be released, in the worst case, it will cause OOM when the memory is insufficient. We can solve this problem by creating the `FlutterEngine` lazily. The `FlutterEngine` is created and cached when the user first enters the Flutter page, and the cached `FlutterEngine` can be reused when the user enters the Flutter page again.

This project show you how to lazily creates and manages `FlutterEngine` on Android and iOS. In this way, we can better solve the problem of page navigation like `Flutter -> Native -> Flutter`, and the project sample shows such a scenario.

*NOTE*: The iOS version is still in progress.

## Build
1. Open the `flutter_embedding_addon` directory, and build the android aar.
    ```
    cd flutter_embedding_addon
    flutter packages get
    flutter build aar
    ```

2. Open the `flutter-embedding-addon-android` project on your Android Studio and run.

## License
    Copyright (C) 2020 littlegnal

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.