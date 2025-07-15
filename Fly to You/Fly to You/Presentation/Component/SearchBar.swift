//
//  SearchBar.swift
//  Fly to You
//
//  Created by 최희진 on 5/8/25.
//

import SwiftUI


struct SearchBar: View {
    @Binding var seachText: String
    let searchBarRoute: searchBarRoute
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(.gray0)
            HStack{
                TextField(searchBarRoute == .searchNickname ? "닉네임을 검색해 보세요" : "주제를 검색해 보세요", text: $seachText)
                    .font(.pretendard(.light, size: 15))
                    .foregroundColor(.black)
                    .padding(.leading, 15)
                
                Spacer()
                
                Image(systemName: "magnifyingglass")
                    .frame(width: 25, height: 25)
                    .padding(.trailing, 15)
                    .foregroundStyle(.gray3)
            }
            .cornerRadius(10)
        }
        .frame(height: 45)
        .frame(maxWidth: .infinity)
    }
}

