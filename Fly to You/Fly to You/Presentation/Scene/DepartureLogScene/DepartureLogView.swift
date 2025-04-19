//
//  DepartureLogView.swift
//  Fly to You
//
//  Created by 최희진 on 4/18/25.
//

import SwiftUI
import Combine

struct DepartureLogView: View {
    
    @EnvironmentObject var viewModelWrapper: DepatureLogViewModelWrapper
     
    var body: some View {
        NavigationStack(path: $viewModelWrapper.path) {
            VStack{
                Spacer().frame(height: Spacing.lg)
                
                Text("도착한 종이 비행기들이 여기에 착륙해요")
                    .font(.pretendard(.medium, size: 15))
                    .foregroundStyle(.gray3)
                
                Spacer().frame(height: Spacing.lg)
                
                VStack{
                    ForEach(viewModelWrapper.letters, id: \.id){ letter in
                        PlaneCell(letter: letter, route: .send)
                            .onTapGesture {
                                viewModelWrapper.path.append(.departureLogInfo)
                            }
                    }
                }
                
                Spacer()
            }
            .navigationDestination(for: DepartureLogRoute.self, destination: { route in
                switch route{
                    case .departureLogInfo:
                    if let letter = viewModelWrapper.letter {
                        DepartureLogInfoView(letter: letter)
                    }
                }
            })
        }
    }
}

class DepatureLogViewModelWrapper: ObservableObject {
    @Published var path: [DepartureLogRoute] = []
    @Published var letter: ReceiveLetterModel? = nil
    @Published var letters: [ReceiveLetterModel] = []
    
    var viewModel: DepartureLogViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: DepartureLogViewModel){
        self.viewModel = viewModel
    }
    
    func bind(){
        viewModel.lettersPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.letters, on: self)
            .store(in: &cancellables)
    }
}

#Preview {
    DepartureLogView()
}

enum DepartureLogRoute {
    case departureLogInfo
}

//import FirebaseFirestore
//
//struct SentLettersView: View {
//    @State private var sentLetters: [SentLetter] = []
//
//    var body: some View {
//        VStack {
//            Text("내가 보낸 비행기")
//                .font(.headline)
//            List {
//                        ForEach(sentLetters) { letter in
//                            HStack {
//                                VStack(alignment: .leading) {
//                                    Text(letter.topic)
//                                        .font(.headline)
//                                    Text("To: \(letter.toUid)") // .toUid 대신 .to.nickname 사용
//                                        .font(.subheadline)
//                                }
//                                Spacer()
//                                Text(DateUtil.formatLetterDate(letter.timestamp))
//                                    .font(.caption)
//                            }
//                        }
//                    }
//        }
//        .onAppear {
//            fetchSentLetters(for: UserDefaults.standard.string(forKey: "uid") ?? "") { letters in
//                self.sentLetters = letters
//            }
//        }
//    }
//    func fetchSentLetters(for uid: String, completion: @escaping ([SentLetter]) -> Void) {
//        let db = Firestore.firestore()
//        db.collection("letters")
//            .whereField("fromUid", isEqualTo: uid)
//            .getDocuments { snapshot, error in
//                guard let documents = snapshot?.documents, error == nil else {
//                    completion([])
//                    return
//                }
//                let letters = documents.compactMap { doc in
//                    try? doc.data(as: SentLetter.self)
//                }
//                completion(letters)
//            }
//    }
//}
//
//struct SentLetter: Codable, Identifiable {
//    let id: String
//    let fromUid: String
//    let toUid: String
//    let message: String
//    let topic: String
//    let topicId: String
//    let timestamp: Date
//    let isDelivered: Bool
//    let isRelayStart: Bool
//}
//
//
//
//
