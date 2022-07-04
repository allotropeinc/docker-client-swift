import NIOHTTP1
import Foundation

/// A protocol describing the structure of an endpoint that can be used to make a request with DockerClient.
protocol Endpoint {
	/// The type that describes the response body.
    associatedtype Response: Codable
	/// The type that describes the request body.
    associatedtype Body: Codable
	/// The (relative to the version specifier) path to the endpoint.
    var path: String { get }
	/// The method of the HTTP request.
    var method: HTTPMethod { get }
	/// An object representing the body of the request (if there is one).
    var body: Body? { get }
}

extension Endpoint {
    public var body: Body? {
        return nil
    }
}

protocol PipelineEndpoint: Endpoint {
    func map(data: String) throws -> Self.Response
}
