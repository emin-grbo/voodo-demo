# Tise case
Hi! If you are seeing this you are probably from Tise, or you are in the wong corner of github.

I had quite a bit of fun coding this assignment and I have to say some parts caught me off guard a bit 😅.
For that reason it is not the cleanest approach, but to be fair, I hope it is also expected with limited time resources.

[Canva Presentation link](https://www.canva.com/design/DAGcGTBmG5A/uhYLpBXOi5QAE6nWz6dmDw/edit?utm_content=DAGcGTBmG5A&utm_campaign=designshare&utm_medium=link2&utm_source=sharebutton)

## Architecture

Being a proof of concept, I decided to go for a kind of novel architecture called VODOO (https://swiftuivoodo.com)

It is similar to MVVM, but to me it seems more adapted to SwiftUI and very versatile for small projects.

At it's base, it works as follows:
- ObservableObject is declared as a @StateObject in the root of the app
- Subsequent Views inherit it as @EnvironmentObject
- It contains DataObject which is usually CoreData or connected to the Networking layer
- Observable contains all logic, allowing for "dumb views" (here you can see where similaryty with MVVM comes from)

I used it for its versatility and speed of development ⚡️. It is quite handy for MVPs and proof of concept apps.

For larger scale apps one would usually have more than one **ObservbleObjects**, either per screen or per Tab/Section of the app, depending on the logic.

Another great benefit of the VOODO is the ability to make changes fast. Once the app reaches the level where it needs to be refactored, it can easily be branched into separate Services/ViewModels or replaced with a Coordinator pattern.

In this app I had some major changes to the Data layer in the very end, and thanks to this architecture, it took me just a few minutes to adapt my approach. (It was due to the fact that JSON needed to be modifed separately from the original loading method)

## Networking
As the case had a .json delivery, I asumed it would be beneficial working with this JSON as if working with an external API. I created **TiseAPI** which had methods similar to a regular networking class, but only if you look at it from the outside.

Inside it interacted with the local JSON ans stored the changes right on the device.

Observable object was of course completely separate from this logic, allowing an easy switch to Remote Networking layer in the future. 

I wish I had time to define the protocols and make it even more clean, but time got to me :)

## The good ✅
What I believe I did well(details):
- [X] Liking is only done when user dismisses the screen
- [X] The way TiseAPI works, allowing for future switch to remote Networking easily
- [X] Used new API from Apple for PhotoPicker
- [X] General layout and design
- [X] Handling sizes

## The not-as-good ⚠️
What I wish I had the time to add, but did not:
- [ ] Add Categories on the top as in the main app
- [ ] Type-check new entries
- [ ] Read local photos (I used AsyncImage for JSON images but locally added objects needed a different approach)
- [ ] Liking system refactor
- [ ] Ability to delete added items
- [ ] Sorting

# Thank you 👋
