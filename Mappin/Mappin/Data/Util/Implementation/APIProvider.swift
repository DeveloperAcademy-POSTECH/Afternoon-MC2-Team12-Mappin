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
        _ = try await request(target).get()
    }
    
    func requestResponsable<T: Target & Responsable>(_ target: T) async throws -> T.Response {
        let result = await request(target)
        return try getResponse(target: target, result: result)
    }
    
    private func request(_ target: Target) async -> APIResult {
        await withCheckedContinuation { continuation in
            self.request(target) { result in
                continuation.resume(returning: result)
            }
        }
    }
    
    private func getResponse<T: Target & Responsable>(target: T, result: APIResult) throws -> T.Response {
        switch result {
        case let .success(response):
            return try decoder.decode(T.Response.self, from: response.data)
        case let .failure(error):
            guard let data = error.response?.data else {
                throw APIError.unknown
            }
            throw try decoder.decode(APIError.self, from: data)
        }
    }
}
