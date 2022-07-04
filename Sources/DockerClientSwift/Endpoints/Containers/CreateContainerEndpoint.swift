import NIOHTTP1

/// An Endpoint object that describes lets you
struct CreateContainerEndpoint: Endpoint {
    var body: CreateContainerBody?
    
    typealias Response = CreateContainerResponse
    typealias Body = CreateContainerBody
    var method: HTTPMethod = .POST

	/// The name of the image to use as a base for the container.
    private let imageName: String
	/// The commands to use to override the image's commands (if any).
    private let commands: [String]?

	/// Initialize the endpoint object with the necessary data to make the request.
	init(imageName: String, commands: [String]?=nil, hostConfig: CreateContainerBody.HostConfig?=nil) {
        self.imageName = imageName
        self.commands = commands
		self.body = .init(Image: imageName, Cmd: commands, HostConfig: hostConfig)
    }

    var path: String {
        "containers/create"
    }

	/// The structure of the body of a request to the container creation endpoint.
    struct CreateContainerBody: Codable {
		/// The name of the image to use as a base for the container.
        let Image: String
		/// The commands to use to override the image's commands (if any).
        let Cmd: [String]?
		/// The host configuration for the container creation request (if any).
		let HostConfig: HostConfig?

		/// A struct describing the HostConfig data type as described in
		/// https://docs.docker.com/engine/api/v1.41/#operation/ContainerCreate
		///
		/// NOTE: This is very incomplete.
		struct HostConfig: Codable {
			/// The binds that the container will have in `host_path:container_path` format.
			var Binds: [String]
		}
    }

	/// The structure
    struct CreateContainerResponse: Codable {
		/// The ID of the container.
        let Id: String
    }
}
