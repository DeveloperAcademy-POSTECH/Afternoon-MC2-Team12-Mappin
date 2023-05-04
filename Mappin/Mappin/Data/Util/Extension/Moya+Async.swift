//
//  Moya+Async.swift
//  Mappin
//
//  Created by byo on 2023/05/04.
//

import Foundation
import Moya

extension MoyaProvider {
    func request(_ target: Target) async -> Result<Response, MoyaError> {
        await withCheckedContinuation { continuation in
            self.request(target) { result in
                continuation.resume(returning: result)
            }
        }
    }
}
