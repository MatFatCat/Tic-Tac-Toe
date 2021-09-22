//
//  Alerts.swift
//  TicToe
//
//  Created by Matthew Popov on 11.07.2021.
//

import SwiftUI

struct AlertItem: Identifiable {
    var id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertsContext {
    static let humanWin = AlertItem(title: Text("You Win!"),
                             message: Text("You are so smart!"),
                             buttonTitle: Text("Hell yeah"))
    static let computerWin = AlertItem(title: Text("You Lost!"),
                                message: Text("You programmed a super AI."),
                                buttonTitle: Text("Rematch"))
    static let draw = AlertItem(title: Text("Draw!"),
                                message: Text("Whats a battle of wins we have here..."),
                                buttonTitle: Text("Try again"))
}
