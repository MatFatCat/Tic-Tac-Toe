//
//  GameViewModel.swift
//  TicToe
//
//  Created by Matthew Popov on 11.07.2021.
//
//IN GameView YOU GOT TO HAVE ONLY UI. AND IN GameViewModel YOU GOT TO HAVE ALL THE FUNCTIONALITY. THATS THE WHOLE IDEA OF MVV


import SwiftUI

final class GameViewModel: ObservableObject {
    
    var columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    var GameDifficultyList = ["Easy", "Normal", "Medium", "Hard"]
    
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isGameboardDisabled = false
    @Published var alertItem: AlertItem? //State gives us : any time it changes, the UI is going to redrow
    @Published var pickedDifficultyIndex = 0
    @Published var humanScore = 0
    @Published var computerScore = 0
    var timeToThink: Double {
        switch gameMode {
            
        case .easy:
            return 0.3123
        case .normal:
            return 0.4234
        case .medium:
            return 0.6321
        case .hard:
            return 1.0002
        }
    }
    
    var gameMode : GameDifficulty {
        switch pickedDifficultyIndex {
        case 0:
            return .easy
        case 1:
            return .normal
        case 2:
            return .medium
        case 3:
            return .hard
        default:
            return .easy
        }
    }
    
    func processPlayerMove(for position: Int) {
        
        if isSquareOccupied(in: moves, forIndex: position) { return }
        moves[position] = Move(player: .human, boardIndex: position)
        //self.isGameboardDisabled = true
        
        //check the board for win condition
        if checkWinCondition(in: moves, for: .human) == true {
            alertItem = AlertsContext.humanWin
            self.humanScore = self.humanScore + 1
            return
        }
        
        //check the board for draw condition
        if self.checkForDrawCondition(in: moves) == true {
            alertItem = AlertsContext.draw
            return
        }
        
        self.isGameboardDisabled = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + self.timeToThink ) { [self] in //quic fix
            let computerPosition = determineComputerMovePosition(in: moves)
            moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
            if checkWinCondition(in: moves, for: .computer) == true {
                alertItem = AlertsContext.computerWin
                self.computerScore = self.computerScore + 1
                self.isGameboardDisabled = false
                return
            }
            
            if checkForDrawCondition(in: moves) == true {
                alertItem = AlertsContext.draw
                self.computerScore = self.computerScore + 1
                self.isGameboardDisabled = false
                return
            }
            
            self.isGameboardDisabled = false
        }
    }
    
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: { $0?.boardIndex == index })
    }
    
    func determineComputerMovePosition(in moves: [Move?]) -> Int {
        
        switch gameMode {
            
        case .easy:
            var movePosition = Int.random(in: 0..<9)
            
            while isSquareOccupied(in: moves, forIndex: movePosition) {
                movePosition = Int.random(in: 0..<9)
            }
            
            return movePosition
            
        case .normal:
            let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
            
            let computerMoves = moves.compactMap { $0 }.filter { $0.player == .computer }//all the moves without the NILs and only moves with the AI
            let computerPositions = Set(computerMoves.map { $0.boardIndex }) //$0 - every element, thats how we get all moves' boardIndex
            
            for pattern in winPatterns {
                let winPositions = pattern.subtracting(computerPositions)//get
                
                if winPositions.count == 1 {
                    let isAvaiable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                    if isAvaiable { return winPositions.first! }
                }
            }
            
            var movePosition = Int.random(in: 0..<9)
            
            while isSquareOccupied(in: moves, forIndex: movePosition) {
                movePosition = Int.random(in: 0..<9)
            }
            
            return movePosition
            
        case .medium:
            //If AI can win, then win
            let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
            
            let computerMoves = moves.compactMap { $0 }.filter { $0.player == .computer }//all the moves without the NILs and only moves with the AI
            let computerPositions = Set(computerMoves.map { $0.boardIndex }) //$0 - every element, thats how we get all moves' boardIndex
            
            for pattern in winPatterns {
                let winPositions = pattern.subtracting(computerPositions)//get
                
                if winPositions.count == 1 {
                    let isAvaiable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                    if isAvaiable { return winPositions.first! }
                }
            }
            
            //If AI can NOT win, then block
            
            let humanMoves = moves.compactMap { $0 }.filter { $0.player == .human }//all the moves without the NILs and only moves with the AI
            let humanPositions = Set(humanMoves.map { $0.boardIndex }) //$0 - every element, thats how we get all moves' boardIndex
            
            for pattern in winPatterns {
                let winPositions = pattern.subtracting(humanPositions)//get
                
                if winPositions.count == 1 {
                    let isAvaiable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                    if isAvaiable { return winPositions.first! }
                }
            }
            
            var movePosition = Int.random(in: 0..<9)
            
            while isSquareOccupied(in: moves, forIndex: movePosition) {
                movePosition = Int.random(in: 0..<9)
            }
            
            return movePosition
            
        case .hard:
            
            let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
            
            let computerMoves = moves.compactMap { $0 }.filter { $0.player == .computer }//all the moves without the NILs and only moves with the AI
            let computerPositions = Set(computerMoves.map { $0.boardIndex }) //$0 - every element, thats how we get all moves' boardIndex
            
            for pattern in winPatterns {
                let winPositions = pattern.subtracting(computerPositions)//get
                
                if winPositions.count == 1 {
                    let isAvaiable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                    if isAvaiable { return winPositions.first! }
                }
            }
            
            
            let humanMoves = moves.compactMap { $0 }.filter { $0.player == .human }//all the moves without the NILs and only moves with the AI
            let humanPositions = Set(humanMoves.map { $0.boardIndex }) //$0 - every element, thats how we get all moves' boardIndex
            
            for pattern in winPatterns {
                let winPositions = pattern.subtracting(humanPositions)//get
                
                if winPositions.count == 1 {
                    let isAvaiable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                    if isAvaiable { return winPositions.first! }
                }
            }
            
            let centerSquare = 4//middle square on the board
            if !isSquareOccupied(in: moves, forIndex: centerSquare) {
                return centerSquare
            }
            
            var movePosition = Int.random(in: 0..<9)
            
            while isSquareOccupied(in: moves, forIndex: movePosition) {
                movePosition = Int.random(in: 0..<9)
            }
            
            return movePosition
        }
    }
    
    func checkWinCondition(in moves: [Move?], for player: Player) -> Bool {
        
        let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        let playerMoves = moves.compactMap { $0 }.filter { $0.player == player }//all the moves without the NILs and only moves with our player
        let playerPositions = Set(playerMoves.map { $0.boardIndex }) //$0 - every element
        for pattern in winPatterns where pattern.isSubset(of: playerPositions) { return true }
        
        return false
    }
    
    func resetGame() {
        moves = Array(repeating: nil, count: 9)
    }
    
    func checkForDrawCondition(in moves: [Move?]) -> Bool {
        return moves.compactMap { $0 }.count == 9
    }
}
