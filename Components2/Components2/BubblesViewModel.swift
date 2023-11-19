//
//  BubblesViewModel.swift
//  Components2
//
//  Created by Ankit Sachan on 19/11/23.
//

import SwiftUI

struct Bubble : Identifiable, Equatable {
    var id  = UUID()
    var text : String
}

class BubblesViewModel: ObservableObject {
    @Published var bubbles: [Bubble] = []
    @Published var contentHeight: CGFloat = 0
    @Published var scrollToBottomTrigger = UUID()  // New property to trigger scrolling
    
    func addBubble(text: String) {
        let newBubble = Bubble(text: text)
        bubbles.append(newBubble)
        scrollToBottomTrigger = UUID()  // Update the trigger after adding a bubble
    }
    
    func deleteBubble(withId id: UUID) {
        bubbles.removeAll { $0.id == id }
    }
}

class MockBubblesViewModel : BubblesViewModel{
    init(_ bubbles : [String]) {
        super.init()
        for bubble in bubbles {
            self.bubbles.append(Bubble(text: bubble))
        }
    }
}
