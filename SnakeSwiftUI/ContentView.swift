//
//  ContentView.swift
//  SnakeSwiftUI
//
//  Created by Chris on 23/01/2022.
//

import SwiftUI

struct ContentView: View {
    private let boardSize: Int = 20
    @StateObject var gameController = GameController()
    
    var body: some View {
        ZStack {
            MainGameView(score: gameController.score, board: gameController.board, boardSize: boardSize, isPaused: $gameController.isPaused, gameController: gameController)
                .gamePadReceiving()
                .padding()
            
            if gameController.isPaused {
                GamePausedView(settings: gameController.settings, isPaused: $gameController.isPaused)
                    .gamePadReceiving()
            }
            else if gameController.gameIsOver {
                GameOverView(newGameAction: gameController.reset, finalScore: gameController.score)
                    .gamePadReceiving()
            }
        }.background(Image("background").centerCropped().ignoresSafeArea())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct GamePadReceiving: ViewModifier {
    var identifier: String
    var receiver: GamePadInputReceiver
    
    func body(content: Content) -> some View {
        content
            .onAppear(perform: { GamePadHandler.default.receivers.append((identifier, receiver)) })
            .onDisappear(perform: { GamePadHandler.default.receivers.removeAll(where: { $0.id == identifier }) })
    }
}

extension View {
    func gamePadReceiving() -> some View {
        let identifier = type(of: self)
        print(identifier, GamePadHandler.default.receivers.count)
        guard let asReceiver = self as? GamePadInputReceiver else { return AnyView(self) }
        return AnyView(modifier(GamePadReceiving(identifier: "\(identifier)", receiver: asReceiver)))
    }
}
