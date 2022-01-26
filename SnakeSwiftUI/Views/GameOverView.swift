//
//  ContentView.swift
//  SnakeSwiftUI
//
//  Created by Chris on 25/01/2022.
//

import SwiftUI

struct GameOverView: View {
    let newGameAction: () -> Void
    let finalScore: Int

    var body: some View {
        VStack(spacing: 16) {
            Text("GAME OVER!").font(.largeTitle).foregroundColor(Color(UIColor.systemRed))
            Text("Score: \(finalScore)").font(.title).foregroundColor(.primary)
            Text("Press START to start a new game.").font(.title).foregroundColor(.primary)
        }
    }
}

struct GameOverView_Previews: PreviewProvider {
    static var previews: some View {
        GameOverView(newGameAction: { print("New Game tapped") }, finalScore: 10)
    }
}
