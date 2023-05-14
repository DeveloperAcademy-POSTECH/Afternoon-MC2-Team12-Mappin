//
//  APIProvider.swift
//  Mappin
//
//  Created by byo on 2023/05/05.
//

import Foundation
import Moya

final class APIProvider: MoyaProvider<APITarget> {
    typealias APIResult = Result<Response, MoyaError>
    
    private let decoder = APIJSONDecoder()
    
    func justRequest(_ target: Target) async throws {
        let result = await request(target)
        switch result {
        case .success:
            printLog(title: "response", message: "success")
        case let .failure(error):
            throw try getAPIError(error)
        }
    }
    
    func requestResponsable<T: Target & Responsable>(_ target: T) async throws -> T.Response {
        let result = await request(target)
        return try getResponse(target: target, result: result)
    }
    
    private func request(_ target: Target) async -> APIResult {
        await withCheckedContinuation { continuation in
            printLog(title: "request", message: target.description)
            self.request(target) { result in
                continuation.resume(returning: result)
            }
        }
    }
    
    private func getResponse<T: Target & Responsable>(target: T, result: APIResult) throws -> T.Response {
        switch result {
        case let .success(response):
            let responseString = String(data: response.data, encoding: .utf8) ?? ""
            printLog(title: "response", message: responseString)
            if let decoded = try? decoder.decode(T.Response.self, from: response.data) {
                return decoded
            } else if let string = responseString as? T.Response {
                return string
            } else {
                throw APIError.unknown
            }
        case let .failure(error):
            throw try getAPIError(error)
        }
    }
    
    private func getAPIError(_ error: MoyaError) throws -> APIError {
        guard let data = error.response?.data else {
            return .unknown
        }
        printLog(title: "response error", data: data)
        return try decoder.decode(APIError.self, from: data)
    }
    
    // TODO: - Logger
    
    private func printLog(title: String, data: Data) {
        let message = String(data: data, encoding: .utf8) ?? ""
        printLog(title: title, message: message)
    }
    
    private func printLog(title: String, message: String) {
//        print("@LOG \(title)\n\(message)")
    }
}
