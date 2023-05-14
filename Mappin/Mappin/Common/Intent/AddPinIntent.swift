//
//  AddPinIntent.swift
//  Mappin
//
//  Created by changgyo seo on 2023/05/03.
//

import AppIntents

struct AddPinIntent: AppIntent {
    
    static var title: LocalizedStringResource = "pinning"
    static var description = IntentDescription("Let's add our new pin")
    
    
    @IntentParameter(title: "음악")

    var music: String
    
    // 말을 못알아 듣는다
    func perform() async throws -> some IntentResult {

        let musicSearchUseCase = DefaultSearchMusicUseCase(musicRepository: RequestMusicRepository()) 
        let musicList = try await musicSearchUseCase.execute(searchTerm: music).map {
            "\($0.artist) - \($0.title)"
        }
        let uploadMusic = try await musicSearchUseCase.execute(searchTerm: music)
        
        let selectedMusic = try await $music.requestDisambiguation(among: musicList, dialog: "음악을 골라주세요!")
        let index = musicList.firstIndex { $0 == selectedMusic }
        //try await DefaultMockDIContainer.shared.container.resolver.resolve(AddPinUseCase.self).excute(music: uploadMusic[index!])
        return .result(value: selectedMusic, dialog: IntentDialog(stringLiteral:
       "피닝 성공했어요! 감사합니다."))

    }
}

struct AddPinShortcutProvider: AppShortcutsProvider {
    
    static var appShortcuts: [AppShortcut] = [
        AppShortcut(
            intent: AddPinIntent(),
            phrases: ["\(.applicationName) 실행해줘."]
        )
    ]
}
