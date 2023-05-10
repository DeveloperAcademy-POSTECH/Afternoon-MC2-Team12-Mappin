//
//  DefaultMockDIContainer.swift
//  Mappin
//
//  Created by changgyo seo on 2023/05/09.
//

import Foundation
import SwiftUI
import ComposableArchitecture

final class DefaultMockDIContainer {
    
    static let shared = DefaultMockDIContainer()
    let container = MappinDIContainer()
    
    private init() {
        DIRepository()
        DIUseCase()
        DIReduecer()
    }
    
    func DIRepository() {
        
        container.register(AddPinRepository.self) { _ in
            TempAddPinRepository()
        }
        
        container.register(GetPinsRepository.self) { _ in
            TempImplementaitionOfGetPinsRepository()
        }
        
        container.register(LocationRepository.self) { _ in
            RequestLocationRepository.manager
        }
        
        container.register(DeviceRepository.self) { _ in
            RequestDeviceRepository()
        }
        
        container.register(GeoCodeRepository.self) { _ in
            RequestGeoCodeRepository()
        }
        
        container.register(PinsRepository.self) { _ in
            APIPinsRepository()
        }
        
        container.register(PinClustersRepository.self) { _ in
            APIPinClustersRepository()
        }
        
        container.register(RequestMusicRepositoryInterface.self) { _ in
            RequestMusicRepository()
        }
        
        container.register(RequestWeatherRepositoryInterface.self) { _ in
            RequestWeatherRepository()
        }
        
        container.register(UsersRepository.self) { _ in
            APIUsersRepository()
        }
        
        container.register(CSRFTokenRepository.self) { _ in
            APICSRFTokenRepository()
        }
    }
    
    func DIUseCase() {
        
        let getPinsRepositoryImplementation = container.resolver.resolve(GetPinsRepository.self)
        let addPinRepositoryImplementation = container.resolver.resolve(AddPinRepository.self)
        let locationRepositoryImplementation = container.resolver.resolve(LocationRepository.self)
        let geoCodeRepositoryImplementation = container.resolver.resolve(GeoCodeRepository.self)
        let requestWeatherRepositoryInterfaceImplementation = container.resolver.resolve(RequestWeatherRepositoryInterface.self)
        let deviceRepositoryImplementation = container.resolver.resolve(DeviceRepository.self)
        let requestMusicRepositoryImplementation = container.resolver.resolve(RequestMusicRepositoryInterface.self)
        
        
        container.register(AddPinUseCase.self) { _ in
            DefaultAddPinUseCase(
                addPinRepository: addPinRepositoryImplementation,
                geoCodeRepository: geoCodeRepositoryImplementation,
                locationRepository: locationRepositoryImplementation,
                weatherRepository: requestWeatherRepositoryInterfaceImplementation,
                deviceRepository: deviceRepositoryImplementation
            )
        }
        
        container.register(GetPinsUseCase.self) { _ in
            DefaultGetPinUseCase(
                locatationRepository: locationRepositoryImplementation,
                getPinsRepository: getPinsRepositoryImplementation
            )
        }
        
        container.register(SearchMusicUseCase.self) { _ in
            DefaultSearchMusicUseCase(
                musicRepository: requestMusicRepositoryImplementation
            )
        }
        
        container.register(MusicChartUseCase.self) { _ in
            DefaultMusicChartUseCase(
                musicRepository: requestMusicRepositoryImplementation
            )
        }
        
        container.register(RequestWeatherUseCase.self) { _ in
            DefaultRequestWeatherUseCase(
                weatherRepository: requestWeatherRepositoryInterfaceImplementation
            )
        }
    }
    
    func DIReduecer() {
        container.register((any ReducerProtocol).self) { resolver in
            let addPinUseCaseImplementation = resolver.resolve(AddPinUseCase.self)
            let getPinsUseCaseImplementation = resolver.resolve(GetPinsUseCase.self)
            
            return PinMusicReducer(
                addPinUseCase: addPinUseCaseImplementation,
                getPinsUseCase: getPinsUseCaseImplementation
            )
        }
    }
    
    @ViewBuilder
    func makeContentView() -> some View {
        ContentView (
            store: Store(
                initialState: PinMusicReducer.State(),
                reducer: PinMusicReducer(
                    addPinUseCase: container.resolver.resolve(AddPinUseCase.self),
                    getPinsUseCase: container.resolver.resolve(GetPinsUseCase.self)
                )._printChanges()
            )
        )
    }
}
