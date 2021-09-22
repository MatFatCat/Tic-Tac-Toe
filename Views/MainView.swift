//
//  GameView.swift
//  TicToe
//
//  Created by Matthew Popov on 10.07.2021.
//

import SwiftUI


enum GameDifficulty {
    case easy, normal, medium, hard
}

enum Player {
    case human, computer
}

struct Move {
    let player: Player
    let boardIndex: Int
    
    var indicator: String {
        return player == .human ? "xmark" : "circle"
    }
}

struct MainView: View {
    var body: some View {
        GameView()
    }
}
