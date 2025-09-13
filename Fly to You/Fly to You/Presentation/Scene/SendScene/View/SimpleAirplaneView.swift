//
//  SimpleAirplaneView.swift
//  Fly to You
//
//  Created by 최희진 on 9/15/25.
//

import SwiftUI

struct SimpleAirplaneView: View {
    @State private var airplaneOffset: CGSize = .zero
    @State private var isFlying = false
    @State private var showHint = true
    
    var body: some View {
        ZStack {
            Color.blue.opacity(0.1)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                if showHint && !isFlying {
                    VStack(spacing: 15) {
                        Text("✈️")
                            .font(.system(size: 50))
                        
                        Text("위로 스와이프!")
                            .font(.title)
                            .foregroundColor(.blue)
                        
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.blue)
                            .scaleEffect(showHint ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: showHint)
                    }
                    .transition(.opacity)
                }
                
                Spacer()
                
                Text("✈️")
                    .font(.system(size: 80))
                    .offset(airplaneOffset)
                    .scaleEffect(isFlying ? 0.3 : 1.0)
                    .rotationEffect(.degrees(isFlying ? 20 : 0))
                    .opacity(isFlying ? 0 : 1)
                    .animation(.easeOut(duration: 1.5), value: isFlying)
                    .animation(.easeOut(duration: 1.5), value: airplaneOffset)
                    .gesture(
                        DragGesture(minimumDistance: 30)
                            .onEnded { value in
                                if value.translation.height < -100 {
                                    launchAirplane()
                                }
                            }
                    )
                
                Spacer()
                
                if isFlying {
                    Button("🔄 다시 하기") {
                        resetAirplane()
                    }
                    .font(.title2)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    .transition(.scale.combined(with: .opacity))
                }
                
                Spacer()
            }
        }
    }
    
    private func launchAirplane() {
        showHint = false
        
        withAnimation(.easeOut(duration: 1.5)) {
            isFlying = true
            airplaneOffset = CGSize(width: 100, height: -800)
        }
    }
    
    private func resetAirplane() {
        withAnimation(.easeInOut(duration: 0.5)) {
            isFlying = false
            airplaneOffset = .zero
            showHint = true
        }
    }
}

#Preview {
    SimpleAirplaneView()
}
