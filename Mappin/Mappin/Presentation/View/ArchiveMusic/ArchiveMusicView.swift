//
//  ArchiveMusicView.swift
//  Mappin
//
//  Created by 한지석 on 2023/05/09.
//

import SwiftUI

import MusicKit
import ComposableArchitecture

struct ArchiveMusicView: View {
    
    @ObservedObject var viewStore: ViewStoreOf<ArchiveMusicReducer>
    
    init(viewStore: ViewStoreOf<ArchiveMusicReducer>) {
        self.viewStore = viewStore
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if !viewStore.state.archiveMusic.isEmpty {
                    archiveMusicList
                } else {
                    archiveEmptyView
                }
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(leading:
                                    Text(!viewStore.isOtherPin ? "내가 저장한 핀들 돌아보기" : "다른 사람들이 저장한 핀들 돌아보기")
<<<<<<< Updated upstream
                .font(.system(size: 16, weight: .bold)),
                                trailing:
                                    Button(action: {
                print("취소 버튼 클릭")
            }, label: {
                Text("취소")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.black)
            }))
=======
                                        .font(.system(size: 16, weight: .bold)))
//                                trailing:
//                                    Button(action: {
//                                        print("취소 버튼 클릭")
//                                    }, label: {
//                                        Text("취소")
//                                            .font(.system(size: 16, weight: .regular))
//                                            .foregroundColor(.black)
//                                    })
>>>>>>> Stashed changes
            .task {
                viewStore.send(.requestArchive)
            }
        }
    }
    
    /// 음악 검색 리스트 구현
    var archiveMusicList: some View {
        withAnimation {
            List {
                Section {
                    ForEach(viewStore.archiveMusic.isEmpty ? [] : viewStore.archiveMusic) { archive in
                        ArchiveMusicCell(music: archive.music, date: archive.createdAt)
                            .onTapGesture {
                                print("피닝 되어있는 위치로 이동!")
                            }
                    }
                    .onDelete { index in
                        viewStore.send(.removeArchive(index: index))
                    }
                } header: {
                }
                
            }
            .listStyle(.inset)
        }
    }
    
    var archiveEmptyView: some View {
        VStack {
            Text("당신의 감정을 기록해주세요.")
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(Color(red: 0.4235, green: 0.4235, blue: 0.4392))
                .padding(.top, 15)
            Button {
                
            } label: {
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 55)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    .overlay {
                        Text("현재 위치에 음악 핀하기")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    }
            }
            Spacer()
        }
    }
    
}
