# bloc_test

A real-world example of using the BLoC pattern in Flutter. This app features a searchable list of persons and demonstrates an elegant way to keep the UI in sync with the model.

## Features
The app implements the following features:
- async load random user list with loading indicator
- searchbar for filtering users
- button to favorite/unfavorite a user
- real-time online status indicator per user

## BLoC
Proper separation of concerns by introducing a Business Logic Component. Heavily relies on streams to notify the UI of changes in the business layer.

## Acknowledgements
Based on the great work of [Didier Boelens](https://www.didierboelens.com/). If you need a proper introduction into BLoC, please do read his article about [Reactive Programming - Streams - BLoC](https://www.didierboelens.com/2018/08/reactive-programming---streams---bloc/).

Random user data powered by https://randomuser.me.