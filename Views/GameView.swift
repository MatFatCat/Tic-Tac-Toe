//
//  GameView.swift
//  TicToe
//
//  Created by Matthew Popov on 09.08.2021.
//

import SwiftUI

struct GameView: View {
    
    @StateObject private var viewModel = GameViewModel()
    
    var body: some View {
        VStack {
            Picker(selection: $viewModel.pickedDifficultyIndex, label: Text("")) {
                ForEach(0 ..< viewModel.GameDifficultyList.count) {
                    Text(viewModel.GameDifficultyList[$0])
                }
            }
            
            Text("\(viewModel.GameDifficultyList[viewModel.pickedDifficultyIndex])")
                .font(.system(size: 25, weight: .bold, design: .default))
                .foregroundColor(.gray)
            
            HStack {
                Image(systemName: "person.fill")
                    .frame(width: 40, height: 40)
                Text("\(viewModel.humanScore) vs \(viewModel.computerScore)")
                    .font(.system(size: 25, weight: .bold, design: .default))
                    .foregroundColor(.gray)
                Image(systemName: "desktopcomputer")
                    .frame(width: 40, height: 40)
                
            }
        }.padding()
        
        GeometryReader { geometry in
            VStack {
                Spacer()
                LazyVGrid(columns: viewModel.columns, spacing: 5){
                    ForEach(0..<9) { i in
                        ZStack {
                            GameSquareView(proxy: geometry)
                            PlayerIndicatorView(systemImageName: viewModel.moves[i]?.indicator ?? "")
                        }
                        .onTapGesture {
                            viewModel.processPlayerMove(for: i )
                        }
                    }
                }
                Spacer()
            }
            .disabled(viewModel.isGameboardDisabled)
            .padding()
            .alert(item: $viewModel.alertItem) { alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: .default(alertItem.buttonTitle, action: { viewModel.resetGame()
                        
                      }))
            }
        }
    }
}
