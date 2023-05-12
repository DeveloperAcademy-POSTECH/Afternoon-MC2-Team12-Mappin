//
//  RequestGeoCodeRepository.swift
//  Mappin
//
//  Created by changgyo seo on 2023/05/08.
//

import CoreLocation

final class RequestGeoCodeRepository: GeoCodeRepository {
    
    /// 검색한 음악의 응답을 처리합니다.
    ///  - Parameter latitude: 위도
    ///  - Parameter longitude: 경도
    func requestGeoCode(latitude: Double, longitude: Double) async throws -> (locality: String, subLocality: String) {
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        let geoCodeResponse = try await geocoder.reverseGeocodeLocation(CLLocation(
            latitude: latitude,
            longitude: longitude), preferredLocale: locale).last!
        
//        print("---------------------")
//        print(geoCodeResponse.country)
//        print(geoCodeResponse.administrativeArea)
//        print(geoCodeResponse.displayRepresentation.title)
//        print(geoCodeResponse.displayRepresentation.subtitle)
//        
        return (locality: geoCodeResponse.locality ?? "사랑시",
                subLocality: geoCodeResponse.subLocality ?? "고백구 행복동")
    }
}


