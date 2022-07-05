import Foundation

/// A protocol for Docker registry credential storage .
public protocol RegistryAuthenticator {
	/// The type of the result that will need to be encoded and base64ed.
	associatedtype AuthenticationResult: Codable

	/// The `Encodable` representation of a token that can be passed to the `X-Registry-Auth` header once encoded.
	var result: AuthenticationResult { get }
}

public extension RegistryAuthenticator {
	/// Returns `authenticated` encoded to the correct format for Docker's API.
	func encodedResult() throws -> String {
		let encoder = JSONEncoder()
		let encodedData = try self.result.encode(with: encoder)
		return encodedData.base64URLEncodedString()
	}
}

/// An authenticator that authenticates with username/password auth directly.
///
/// Do not use this if a more secure alternative is available.
public struct PasswordAuthenticator: RegistryAuthenticator {
	public typealias AuthenticationResult = Result

	/// Initialize the authenticator with the necessary credentials.
	///
	/// - Parameters:
	///   - username: The username used to authenticate with the registry.
	///   - password: The password used to authenticate with the registry.
	///   - email: The email address (if any) used to authenticate with the registry.
	///   - serverAddress: The address (without any protocol markers) of the server.
	init(username: String, password: String, email: String? = nil, serverAddress: String) {
		self.result = .init(
			username: username,
			password: password,
			email: email,
			serverAddress: serverAddress
		)
	}

	public var result: Result

	public struct Result: Codable {
		/// The username used to authenticate with the registry.
		private var username: String
		/// The password used to authenticate with the registry.
		private var password: String
		/// The email address (if any) used to authenticate with the registry.
		private var email: String?
		/// The address (without any protocol markers) of the server.
		private var serverAddress: String

		/// Necessary to make Docker happy.
		enum CodingKeys: String, CodingKey {
			case username = "username"
			case password = "password"
			case email = "email"
			case serverAddress = "serveraddress"
		}

		init(username: String, password: String, email: String? = nil, serverAddress: String) {
			self.username = username
			self.password = password
			self.email = email
			self.serverAddress = serverAddress
		}
	}
}


/// A stand-in type used only when an Authenticator type must be provided, but we can be sure it will be `nil` in practice.
struct NoAuthenticator: RegistryAuthenticator {
	public var result = NoBody()

	public typealias AuthenticationResult = NoBody
}
