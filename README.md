# FeedPlayer
Full-screen video feed playing app.

### Purpose
This app reads a JSON file from the local storage. Then it plays the videos from the URLs provided on the JSON file. This is a full-screen video-playing app. Infinite scrolling is done by injecting the same resources but modifying the property of the corresponding model.

### Note
1. All the videos are a lot longer than they should be. As a result, the initial video loading/buffering is a bit slow. 
2. The videos do not have the best resolution suitable for iPhone.
3. Returning to the app from the background is not yet handled.

### Project structure
There is a total of 6 targets on the project.
1. **Feed** is a framework focused on responsibility which requires no view part.
2. **FeedTests** is used to unit test **Feed**.
3. **FeediOS** is a framework that handles the responsibility which requires the view part
4. **FeediOSTests** is used to unit test **FeediOS**.
5. **FeedPlayer** is the composition part. This is the iOS app that runs on the simulator.
6. **FeedPlayerTests** is used to unit test **FeedPlayer**

### UITableView and UITableViewCell
There is only one cell is visible at a time on the device.

1. A video is played only when the cell is visible.
2. Once the cell is not in the visible state immediately the video is paused
3. Also, the video player is set to nil to save space and smoothness on the app
4. On `prepareForReuse` the texts are set to nil.
5. Request for more data/feed is called through pre-fetch API of the table-view.

### Architectural general guideline
All over the app, the dependency is abstracted mostly by protocol. An example can be the `UniqueFeedGenerator` protocol. The `UniqueFeedGenerator` provides the interface for generating unique feeds. `FeedGenerator` implements this protocol for providing consistent unique feeds. However, this is not an idea for test purpose. Because we need to compare feeds on testing. So on the FeedTests, we use `NonUniqueFeedGenerator` which implements the `UniqueFeedGenerator` but underneath the `NonUniqueFeedGenerator` was providing the same feed which makes it easier to compare feed on the test environment. 

Also, we use the Mapper object to map the real model with the test model. Because on the test there might be some confirmation of some protocol which might not necessary for production code. An example can be the confirmation of `Equatable` protocol. The production code models don't need to confirm the `Equatable` protocol, it is a test-only requirement. So we use `FeedModelMapper`, which confirms `Equatable`, which maps the production model `FeedModel` into the test environment.

We use Spy based test doubles to track different messages on testing time. Such a spy(test double) is `FeedClientSpy`, which captures each of the messages when a call is being made or some behavior is being injected into the Client.

### Architectural Diagram

![Architecture Diagram](https://user-images.githubusercontent.com/1079470/151222469-57116bfa-b304-459b-9ddb-bea78daeb2bf.png)
