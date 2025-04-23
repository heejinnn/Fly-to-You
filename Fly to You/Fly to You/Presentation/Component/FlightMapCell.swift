//
//  FlightMapCell.swift
//  Fly to You
//
//  Created by 최희진 on 4/22/25.
//

import SwiftUI

struct FlightMapCell: View{
    let flight: FlightModel
    let onSpotTap: (ReceiveLetterModel) -> Void
    @State private var spotPositions: [SpotPosition] = []
    
    var body: some View{
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
                .shadow(radius: 2)
            
            
            VStack(spacing: Spacing.xs){
                Text(flight.topic)
                    .font(.pretendard(.semibold, size: 15))
                HStack(spacing: Spacing.xxs){
                    Text("시작일: \(DateUtil.formatLetterDate(flight.startDate))")
                        .font(.pretendard(.medium
                                          , size: 12))
                    Text("참여자: \(flight.routes.count)명")
                        .font(.pretendard(.medium, size: 12))
                }
                
                ZStack{
                    Image(.backgroundMap)
                        .resizable()
                        .scaledToFit()
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        ZStack {
                            HStack(spacing: Spacing.xl) {
                                ForEach(Array(flight.routes.enumerated()), id: \.element.id) { index, route in
                                    VStack {
                                        if index % 2 == 0 {
                                            SpotButtonWithPosition(route: route, index: index) {
                                                onSpotTap(route)
                                            }
                                            Spacer()
                                        } else {
                                            Spacer()
                                            SpotButtonWithPosition(route: route, index: index) {
                                                onSpotTap(route)
                                            }
                                        }
                                    }
                                    .frame(height: 150)
                                }
                            }
                            .padding(.horizontal, Spacing.xxl)
                        }
                        .backgroundPreferenceValue(SpotPositionKey.self) { anchors in
                            GeometryReader { geo in
                                Canvas { context, size in
                                    let globalPositions: [SpotPosition] = anchors.map {
                                        SpotPosition(
                                            id: $0.id,
                                            index: $0.index,
                                            center: geo[$0.centerAnchor]
                                        )
                                    }.sorted(by: { $0.index < $1.index })

                                    for i in 1..<globalPositions.count {
                                        let from = globalPositions[i - 1].center
                                        let to = globalPositions[i].center

                                        let path = arrowPath(from: from, to: to)
                                        context.stroke(path, with: .color(.blue1), lineWidth: 2)
                                    }
                                }
                            }
                        }
                    }
                }
                
                Text("이 릴레이는 현재 진행 중입니다. 참여하려면 비행기를 받아보세요!")
                    .font(.pretendard(.regular, size: 12))
                    .padding(.top, 10)
            }
        }
        .frame(height: 350)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, Spacing.md)
    }
    
    func arrowPath(from start: CGPoint, to end: CGPoint, arrowLength: CGFloat = 10, arrowAngle: CGFloat = .pi / 6) -> Path {
        var path = Path()
        
        // 직선
        path.move(to: start)
        path.addLine(to: end)
        
        // 방향 벡터
        let dx = end.x - start.x
        let dy = end.y - start.y
        let angle = atan2(dy, dx)
        
        // 좌우 화살촉 좌표 계산
        let tip1 = CGPoint(
            x: end.x - arrowLength * cos(angle - arrowAngle),
            y: end.y - arrowLength * sin(angle - arrowAngle)
        )
        
        let tip2 = CGPoint(
            x: end.x - arrowLength * cos(angle + arrowAngle),
            y: end.y - arrowLength * sin(angle + arrowAngle)
        )
        
        // 화살촉 삼각형 그리기
        path.move(to: end)
        path.addLine(to: tip1)
        
        path.move(to: end)
        path.addLine(to: tip2)
        
        return path
    }
}

struct SpotButton: View {
    
    let route: ReceiveLetterModel
    let onTap: () -> Void
    
    var body: some View {
        ZStack{
            Circle()
                .fill(.white)
                .shadow(radius: 2)
            
            Button(action: onTap) {
                VStack {
                    Image(.iconMap)
                        .resizable()
                        .frame(width: 37, height: 37)
                    Text(route.from.nickname)
                        .font(.pretendard(.regular, size: 12))
                }
                
            }
            .buttonStyle(.plain)
        }
    }
}

struct SpotAnchorPosition: Identifiable {
    let id: UUID
    let index: Int
    let centerAnchor: Anchor<CGPoint>
}

struct SpotPosition: Identifiable, Equatable {
    let id: UUID
    let index: Int
    let center: CGPoint

    static func == (lhs: SpotPosition, rhs: SpotPosition) -> Bool {
        lhs.id == rhs.id &&
        lhs.index == rhs.index &&
        lhs.center == rhs.center
    }
}

struct SpotPositionKey: PreferenceKey {
    static var defaultValue: [SpotAnchorPosition] = []

    static func reduce(value: inout [SpotAnchorPosition], nextValue: () -> [SpotAnchorPosition]) {
        value.append(contentsOf: nextValue())
    }
}

struct SpotButtonWithPosition: View {
    let route: ReceiveLetterModel
    let index: Int
    let onTap: () -> Void

    var body: some View {
        GeometryReader { geo in
            SpotButton(route: route, onTap: onTap)
                .anchorPreference(key: SpotPositionKey.self, value: .center) { anchor in
                    [SpotAnchorPosition(id: UUID(), index: index, centerAnchor: anchor)]
                }
                
        }
        .frame(width: 60, height: 60)
    }
}
