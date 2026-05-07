# Voodo Architecture Demo 📺

## Architecture

This repo is used to demonstrate a nover architecture, called VODOO (https://swiftuivoodo.com)

It is similar to MVVM, but it seems more adapted to SwiftUI and very versatile for small projects.

At its base, it works as follows:
- ObservableObject is declared as a `@StateObject` in the root of the app
- Subsequent Views inherit it as `@EnvironmentObject` ie -> `.environmentObject(observable)`
- It contains DataObject which is usually CoreData or connected to the Networking layer
- Observable contains all logic, allowing for "dumb views" (here you can see where similarity with MVVM comes from)

I used it for its versatility and speed of development ⚡️. It is quite handy for MVPs and proof of concept apps.

For larger scale apps one would usually have more than one **ObservableObjects**, either per screen or per Tab/Section of the app, depending on the logic.

Another great benefit of the VOODO is the ability to make changes fast. Once the app reaches the level where it needs to be refactored, it can easily be branched into separate Services/ViewModels or replaced with a Coordinator pattern.

## Networking
I created **DemoAPI** which had methods similar to a regular networking class, but only if you look at it from the outside.

Inside it interacted with the local JSON and stored the changes right on the device.

Observable object was of course completely separate from this logic, allowing an easy switch to Remote Networking layer in the future.

Protocol `VoodoAPI` is to be used as the blueprint for the apps remote networking class.

## Data
We are using [GRDB](https://github.com/groue/GRDB.swift) for its versatility and ease of use. Only one model is "addede" to the data layer, and only as a guiding template for the future setup.
`ExampleModel` would be used to define your own future models that would be stored in the data layer.

This layer is of course injected through the `Observable` and could be replaced by any other data system (ex. SwiftData, CoreData)

> [!IMPORTANT]
> This repo is still under development and will be made into a more re-usable piece of code that can easily be used as a starter kit for your SwiftUI projects.

# Thank you 👋
