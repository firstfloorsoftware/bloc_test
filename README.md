# bloc_test

A real-world example of using the BLoC pattern in Flutter. This app features a searchable list of users and demonstrates an elegant way to keep the UI in sync with the model.

## Features
The app implements the following features:
- user list and detail pages
- user management
  - add single user
  - slide to remove single user with undo
  - favorite / unfavorite button
- multi-select mode (long-press and icon tap)
  - selection counter
  - favorite multiple users
  - delete multiple users with undo
- searchbar for filtering users
- real-time status
  - online status indicator per user
  - user statistics

## BLoC
Proper separation of concerns by using the Business Logic Component pattern. Heavily relies on streams to notify the UI of changes in the business layer. The app uses vanilla Flutter SDK, without 3rd-party package dependencies.

## Acknowledgements
Based on the great work of [Didier Boelens](https://www.didierboelens.com/). If you need a proper introduction into BLoC, please do read his article about [Reactive Programming - Streams - BLoC](https://www.didierboelens.com/2018/08/reactive-programming---streams---bloc/).
