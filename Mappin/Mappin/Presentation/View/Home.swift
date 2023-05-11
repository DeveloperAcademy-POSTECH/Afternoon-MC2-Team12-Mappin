////
////  Home.swift
////  MapsBottmSheet
////
////  Created by 이승준 on 2023/05/07.
////
//
//import SwiftUI
//import MapKit
//
//@available(iOS 16.4, *)
//struct Home: View {
//
//    @State var showAnotherSheet: [PresentationDetent] = [.height(100), .medium, .large]
//
//    var body: some View {
//        ZStack {
//            //Sample Coordinate Region
//
//
//                .overlay(alignment: .topTrailing, content:{
//                    Button{
//                        if index + 1 > 3 {
//                            index = 0
//                        }
//                        else {
//                            index += 1
//                        }
//                    } label: {
//                        Image(systemName: "gearshape.fill")
//                            .font(.title2)
//                    }
//                    .padding()
//                })
//            //Building Sheet UI
//            //presentationDetents: [.medium, .large, .height(70)], ispresented: .constant(true), sheetCornerRadius: 20, largestUndimmedIdentifier: UUID() , isTransparentBG: true, interactiveDisabled: false
//            //presentationDetents: [.medium, .large, .height(70)], ispresented: .constant(true), sheetCornerRadius: 20, isTransparentBG: true
//            // Since We Always Need Bottom Sheet At Bottom Setting to True By Dfault
////                .bottomSheet(presentationDetents: [.medium, .large, .height(70)], ispresented: .constant(true), sheetCornerRadius: 20, isTransparentBG: true) {
////
////
////                    //MARK: In SwiftUI A ViewController Currently Present Only One Sheet
////                    // So If We try to show Another Sheet It will not Show up
////                    // But There is a Work Around
////                    // Simply Insert All Sheets And FullScreenCover Vies to Bottom Shteet View
////                    // Because its A New View Controller so It can able to Show Another Sheet
////
////                    .sheet(isPresented: $showAnotherSheet) {
////                        Text("Hi Settings")
////                    }
////                } onDismiss: {}
//                .sheet(isPresented: .constant(true)) {
//
//                }
//
//        }
//    }
//
//    @ViewBuilder
//    func SongsList()->some View{
//        VStack(spacing: 25){
//            ForEach(albums){album in
//                HStack(spacing:12){
//                    Text("#\(getIndex(album: album) + 1)")
//                        .fontWeight(.semibold)
//
//                    Image(album.albumImage)
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(width:50, height: 50)
//                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
//                    VStack(alignment: .leading, spacing: 10){
//                        Text(album.albumName)
//                            .fontWeight(.semibold)
//                        Label{
//                            Text("65,78,909")
//                        } icon: {
//                            Image(systemName: "beats.headphones")
//                        }
//                        .font(.caption)
//                    }
//                    .frame(maxWidth:.infinity, alignment: .leading)
//
//                    Button{
//
//                    } label:{
//                        Image(systemName: album.isLiked ? "suit.heart.fill" : "suit.heart")
//                            .font(.title3)
//                            .foregroundColor(album.isLiked ? .red :.primary)
//                    }
//
//                    Button{
//
//                    } label: {
//                        Image(systemName: "ellipsis")
//                            .font(.title3)
//                            .foregroundColor(.primary)
//                    }
//                }
//            }
//        }
//        .padding(.top,15)
//    }
//
//    // MARK: Album Index
//    func getIndex(album: Album)-> Int {
//        return albums.firstIndex { CALbum in
//            CALbum.id == album.id
//        } ?? 0
//
//    }
//
//}
//
//struct View2: PreviewProvider {
//    static var previews: some View {
//        Home()
//    }
//}
