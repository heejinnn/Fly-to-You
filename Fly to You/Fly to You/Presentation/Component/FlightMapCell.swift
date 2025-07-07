//
//  FlightMapCell.swift
//  Fly to You
//
//  Created by 최희진 on 4/22/25.
//

import SwiftUI

// MARK: - FlightMapCell
struct FlightMapCell: View {
    let flight: FlightModel
    let participantCount: Int
    let isParticipated: Bool
    let onSpotTap: (ReceiveLetterModel) -> Void

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
                .shadow(radius: 2)

            VStack(spacing: Spacing.xs) {
                titleSection
                infoSection
                mapSection
                statusText
            }
        }
        .frame(height: 350)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, Spacing.md)
    }

    private var titleSection: some View {
        Text(flight.topic)
            .font(.pretendard(.semibold, size: 15))
    }

    private var infoSection: some View {
        HStack(spacing: Spacing.xxs) {
            Text("시작일: \(DateUtil.formatLetterDate(flight.startDate))")
            Text("참여자: \(participantCount)명")
        }
        .font(.pretendard(.medium, size: 12))
    }

    private var mapSection: some View {
        ZStack {
            Image(.backgroundMap)
                .resizable()
                .scaledToFit()

            ScrollView(.horizontal, showsIndicators: false) {
                ZStack {
                    HStack(spacing: Spacing.xl) {
                        ForEach(Array(flight.routes.enumerated()), id: \.element.id) { index, route in
                            VStack {
                                if index % 2 == 0 {
                                    SpotButtonWithPosition(route: route, index: index, onTap: { onSpotTap(route) })
                                    Spacer()
                                } else {
                                    Spacer()
                                    SpotButtonWithPosition(route: route, index: index, onTap: { onSpotTap(route) })
                                }
                            }
                            .frame(height: 200)
                        }
                    }
                    .padding(.horizontal, Spacing.xxl)
                }
                .backgroundPreferenceValue(SpotPositionKey.self) { anchors in
                    GeometryReader { geo in
                        Canvas { context, size in
                            let positions = anchors.map {
                                SpotPosition(
                                    id: $0.id,
                                    index: $0.index,
                                    center: geo[$0.centerAnchor]
                                )
                            }
                                .sorted(by: { $0.index < $1.index })
                            
                            for i in 1..<positions.count {
                                let from = positions[i - 1].center
                                let to = positions[i].center
                                
                                var path = Path()
                                path.move(to: from)
                                path.addLine(to: to)
                                
                                context.stroke(path, with: .color(.blue1), lineWidth: 2)
                            }
                        }
                    }
                }
            }
        }
        .frame(height: 230)
    }

    private var statusText: some View {
        Text(isParticipated ? "여정이 이어지고 있어요. 다음 목적지는 어디일까요?" : "이 릴레이는 현재 진행 중입니다. 참여하려면 비행기를 받아보세요!")
            .font(.pretendard(.regular, size: 12))
            .padding(.top, 10)
    }
}

// MARK: - Spot Components
struct SpotButton: View {
    let route: ReceiveLetterModel
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack {
                Image(.iconMap)
                    .resizable()
                    .frame(width: 37, height: 37)
                Text(route.from.nickname)
                    .font(.pretendard(.regular, size: 12))
            }
            .padding(10)
            .background(Circle().fill(.white).shadow(radius: 2))
        }
        .buttonStyle(.plain)
    }
}

struct SpotButtonWithPosition: View {
    let route: ReceiveLetterModel
    let index: Int
    let onTap: () -> Void

    var body: some View {
        GeometryReader { geo in
            SpotButton(route: route, onTap: onTap)
                .anchorPreference(
                    key: SpotPositionKey.self,
                    value: .center
                ) { anchor in
                    [SpotAnchorPosition(id: UUID(), index: index, centerAnchor: anchor)]
                }
        }
        .frame(width: 60, height: 80)
    }
}

// MARK: - Anchor & Preference
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
