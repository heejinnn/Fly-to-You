//
//  Route.swift
//  Fly to You
//
//  Created by 최희진 on 7/10/25.
//

enum PlaneCellRoute{
    case receive
    case send
    case map
}


enum searchBarRoute{
    case searchNickname
    case searchTopic
}

enum DepartureLogRoute {
    case departureLogInfo
}

enum LandingZoneRoute {
    case landingZoneInfo
    case relayLetter
    case flyAnimation
}

enum MainRoute {
    case profile
    case editNickname
    case selectSubject
    case sendLetter
    case flyAnimation
}

enum SendLetterRoute {
    case start
    case relay
}

