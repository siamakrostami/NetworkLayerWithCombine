
NetworkLayerWithCombine is a sample project that demonstrates how to implement a networking layer using Apple's Combine framework and Alamofire. This project shows how to create a reusable networking layer that can be used to fetch data from any REST API.
The request method returns a AnyPublisher<T, Error> that can be used with Combine operators.
T stands for your JSON model.
## Requirements
* Xcode 12 or later
* iOS 13 or later
## Getting Started
To get started with the project, clone the repository and open the NetworkLayerWithCombine.xcodeproj file in Xcode.
## Network Layers
The Network Layer consists of several layers that work together to provide a seamless experience.
## NetworkRouter
NetworkRouter is responsible for defining the endpoint and parameters of the request. It uses an enum to define the different endpoints and their corresponding HTTP methods and parameters.
## APIRequest
APIRequest is responsible for building the URL request from the APIRequest and executing the request using Alamofire. It also handles response serialization and error handling.
## RequestHeaderBuilder
RequestHeaderBuilder is a builder pattern that is responsible for creating headers for each request. It allows for dynamic and flexible header creation based on the needs of each request.
## Retrier and Adapter
Retrier and Adapter are Alamofire middlewares that are responsible for handling authentication, refreshing access tokens, and retrying failed requests. They can be customized to fit the specific needs of your application.
## NetworkManager
NetworkManager is responsible for implementing repositories and services to call network requests inside view models. It abstracts away the complexity of the network layer and provides a clean interface for the view models to interact with.
## License

[MIT](https://choosealicense.com/licenses/mit/)


