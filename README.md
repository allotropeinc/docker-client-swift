# Docker Client
[![Language](https://img.shields.io/badge/Swift-5.4-brightgreen.svg)](http://swift.org)
[![Docker Engine API](https://img.shields.io/badge/Docker%20Engine%20API-%20%201.4.1-blue)](https://docs.docker.com/engine/api/v1.41/)

This is a Docker Client written in Swift. It's using the NIO Framework to communicate with the Docker Engine via sockets.

## Current Use Cases
- [x] List of all images
- [x] List of all containers
- [x] Pull an image
- [x] Create a new container from an image
- [x] Start a container
- [x] Get the stdOut and stdErr output of a container
- [x] Get the docker version information
- [] Manage the container state
- [] Create and manage services
- [x] Update services
- [x] List services
- [] Get resource usages
- [] Clean the system (prune containers and images)


## Installation
```Swift
import PackageDescription

let package = Package(
    dependencies: [
    .package(url: "https://github.com/alexsteinerde/docker-client-swift.git", from: "0.1.0"),
    ],
    targets: [
    .target(name: "App", dependencies: ["DockerClient"]),
    ...
    ]
)
```

## Usage Example
```swift
let client = DockerClient()
let image = try client.images.pullImage(imageName: "hello-world:latest").wait()
let container = try! client.containers.createContainer(image: image).wait()
try container.start(on: client).wait()
let output = try container.logs(on: client).wait()
print(output)
```

For further usage examples, please consider looking at the provided test cases.

## Security Advice
When using this in production, make sure you secure your appclication so no others can execute code. Otherwise the attacker could access your Docker environment and so all of the containers running in it.

## License
This project is released under the MIT license. See [LICENSE](LICENSE) for details.

## Contribution
You can contribute to this project by submitting a detailed issue or by forking this project and sending a pull request. Contributions of any kind are very welcome :)
