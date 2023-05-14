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
        
        container.register(PinClustersRepository.self) { _ in
            APIPinClustersRepository()
        }
        
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
        let getPinsClusterRe = container.resolver.resolve(PinClustersRepository.self)
        let pinsRepositoryImplementation = container.resolver.resolve(PinsRepository.self)
        let locationRepositoryImplementation = container.resolver.resolve(LocationRepository.self)
        let geoCodeRepositoryImplementation = container.resolver.resolve(GeoCodeRepository.self)
        let requestWeatherRepositoryInterfaceImplementation = container.resolver.resolve(RequestWeatherRepositoryInterface.self)
        let deviceRepositoryImplementation = container.resolver.resolve(DeviceRepository.self)
        let requestMusicRepositoryImplementation = container.resolver.resolve(RequestMusicRepositoryInterface.self)
        
        
        container.register(AddPinUseCase.self) { _ in
            DefaultAddPinUseCase(
                pinsRepository: pinsRepositoryImplementation,
                geoCodeRepository: geoCodeRepositoryImplementation,
                locationRepository: locationRepositoryImplementation,
                weatherRepository: requestWeatherRepositoryInterfaceImplementation,
                deviceRepository: deviceRepositoryImplementation
            )
        }
        
        container.register(GetPinsUseCase.self) { _ in
            DefaultGetPinUseCase(
                locationRepository: locationRepositoryImplementation,
                pinsRepository: pinsRepositoryImplementation,
                pinClustersRepository: getPinsClusterRe
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
        
        container.register(RemovePinUseCase.self) { _ in
            DefaultRemovePinUseCase(
                pinsRepository: pinsRepositoryImplementation
            )
        }
    }
    
    func DIReduecer() {
//        container.register((any ReducerProtocol).self) { resolver in
//            let addPinUseCaseImplementation = resolver.resolve(RemovePinUseCase.self)
//            let getPinsUseCaseImplementation = resolver.resolve(GetPinsUseCase.self)
//
//            return PinMusicReducer(
//                addPinUseCase: addPinUseCaseImplementation,
//                getPinsUseCase: getPinsUseCaseImplementation
//            )
//        }
        
        container.register((any ReducerProtocol).self) { resolver in
            let addPinUseCaseImplementation = resolver.resolve(AddPinUseCase.self)
            let getPinsUseCaseImplementation = resolver.resolve(GetPinsUseCase.self)
            let removePinUseCaseImplemetation = resolver.resolve(RemovePinUseCase.self)
            
            return ArchiveMusicReducer(
                removePinUseCase: removePinUseCaseImplemetation
            )
        }
    }
    
    @ViewBuilder
    func makeContentView() -> some View {
        ContentView (
            viewStore: ViewStore(Store(
                initialState: PinMusicReducer.State(),
                reducer: PinMusicReducer(
                    addPinUseCase: container.resolver.resolve(AddPinUseCase.self),
                    getPinsUseCase: container.resolver.resolve(GetPinsUseCase.self)
                )._printChanges()
            ))
        )
    }
}
