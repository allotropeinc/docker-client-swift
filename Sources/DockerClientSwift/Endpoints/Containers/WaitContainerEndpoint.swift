import NIOHTTP1

/// An Endpoint object that describes the container waiting endpoint.
struct WaitContainerEndpoint: Endpoint {
	typealias Response = WaitContainerResponse
	typealias Body = NoBody
	var method: HTTPMethod = .POST

	/// The ID of the container to wait for.
	private let id: String
	/// The condition to wait for the container to achieve.
	private let exitCondition: Container.ExitCondition

	/// Initialize the endpoint object with the necessary data to make the request.
	/// - Parameters:
	///   - containerId: The ID of name of the container to wait for.
	///   - exitCondition: The condition to wait for the container to arrive at. Defaults to `.notRunning`.
	init(containerId: String, exitCondition: Container.ExitCondition = .notRunning) {
		self.id = containerId
		self.exitCondition = exitCondition
	}

	var path: String {
		"containers/\(id)/wait"
	}

	/// The structure of a successful status response.
	struct WaitContainerResponse: Codable {
		/// The returned status code.
		let StatusCode: Int
		/// The error the container returned (if any).
		var Error: Error?

		/// A helper struct for containing errors the container itself returns.
		struct Error: Codable {
			/// The error message returned by the container, if any.
			var Message: String
		}
	}
}

