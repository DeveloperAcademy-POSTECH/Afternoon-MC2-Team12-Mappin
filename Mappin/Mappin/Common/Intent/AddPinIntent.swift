//
//  AddPinIntent.swift
//  Mappin
//
//  Created by changgyo seo on 2023/05/03.
//

import AppIntents

struct AddPinIntent: AppIntent {
    
    static var title: LocalizedStringResource = "Add pin"
    static var description = IntentDescription("Let's add our new pin")
    
    @Parameter(title: "음악")
    var music: String
    
    func perform() async throws -> some IntentResult {

        let musicSearchUseCase = DefaultSearchMusicUseCase(musicRepository: RequestMusicRepository())

        let list = try await musicSearchUseCase.execute(searchTerm: music).map { $0.title }
        _ = try await $music.requestDisambiguation(among: list, dialog: "which?")

        return .result()
    }
}

struct AddPinShortcutProvider: AppShortcutsProvider {
    
    static var appShortcuts: [AppShortcut] = [
        AppShortcut(
            intent: AddPinIntent(),
            phrases: ["Add pin in \(.applicationName)"]
        )
    ]
}



