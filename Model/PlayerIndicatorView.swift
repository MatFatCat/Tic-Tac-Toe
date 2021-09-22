//
//  PlayerIndicatorView.swift
//  TicToe
//
//  Created by Matthew Popov on 11.07.2021.
//

import SwiftUI

struct PlayerIndicatorView: View {
    
    var systemImageName: String
    
    var body: some View {
        Image(systemName: systemImageName)
            .resizable()
            .frame(width: 40, height: 40)
            .foregroundColor(.white)
    }
}
