import SwiftUI

struct BubblesContainerView: View {
    @ObservedObject var viewModel: BubblesViewModel
    @State private var padding: CGFloat = 10

    var body: some View {
        ScrollViewReader {scrollProxy in
            ScrollView {
                VStack {
                    generateContent()
                        .frame(minHeight: viewModel.contentHeight)
                }
                .onChange(of: viewModel.scrollToBottomTrigger) { newValue in
                    scrollToBottom(using: scrollProxy)
                }
            }
            .background(RoundedRectangle(cornerRadius: 10)
            .stroke(Color.black, lineWidth: 1))
        }
    }
    
    private func scrollToBottom(using scrollProxy: ScrollViewProxy) {
        if let lastId = viewModel.bubbles.last?.id {
            withAnimation {
                scrollProxy.scrollTo(lastId, anchor: .bottom)
            }
        }
    }

    private func generateContent() -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        var maxHeight = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            ForEach(viewModel.bubbles) { bubble in
                BubbleView(text: bubble.text, onClose: {
                    withAnimation {
                        viewModel.deleteBubble(withId: bubble.id)
                    }
                })
                .padding([.horizontal, .top], padding)
                .alignmentGuide(.leading) { d in
                    if (abs(width - d.width) > UIScreen.main.bounds.width) {
                        width = 0
                        height = height - maxHeight
                        maxHeight = 0
                    }
                    maxHeight = max(maxHeight, d.height)
                    let result = width
                    if bubble.id == viewModel.bubbles.last?.id {
                        width = 0
                        DispatchQueue.main.async {
                            self.viewModel.contentHeight = -height + maxHeight + padding
                        }
                    } else {
                        width -= d.width
                    }
                    return result
                }
                .alignmentGuide(.top) { d in
                    let result = height
                    if bubble.id == viewModel.bubbles.last?.id {
                        height = 0
                    }
                    return result
                }
            }
        }
        .animation(.default, value: viewModel.bubbles) // Add animation for the layout
    }
}


struct BubbleContainerWithAddDelete : View{
    @ObservedObject var viewModel: BubblesViewModel = MockBubblesViewModel(["Long Bubble Text 1", "B2", "Very Very Long Bubble Text 3", "Bubble 4", "multiline \n 1, \n 2 \n 3 \n 4 \n 5 \n 6 \n 7", "B5", "Bubble 6", "Bubble 7"])
    var body: some View {
        VStack{
            HStack {
                Button("Add") {
                    viewModel.addBubble(text: generateRandomText())
                }
                Button("Clear all") {
                    viewModel.bubbles.removeAll()
                }
            }
            BubblesContainerView(viewModel: viewModel)
        }
    }
    
    func generateRandomText() -> String {
        let words = ["e", "f", "g", "h", "i", "j", "\n"]

        let emojis = ["😀", "🚀", "🌟", "💻", "📱", "🎉"]
        
        var randomText = ""

        // Generate a random number of sentences
        let numberOfSentences = Int.random(in: 1...2)
        for _ in 0..<numberOfSentences {
            let numberOfWords = Int.random(in: 1...10)
            let sentenceWords = (0..<numberOfWords).map { _ in words.randomElement()! }
            let sentence = sentenceWords.joined(separator: " ")
            randomText += sentence + ". "
        }

        // Add a random emoji
        randomText += emojis.randomElement()! + " "

        return randomText
    }

}


struct BubblesContainerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BubblesContainerView(viewModel: MockBubblesViewModel(["Bubble 1", "Bubble 2", "Bubble 3"]))
            
                .padding()
                .previewLayout(.sizeThatFits)
                .previewDisplayName("Few Bubbles")
            
            BubblesContainerView(viewModel: MockBubblesViewModel(["Long Bubble Text 1", "B2", "Very Very Long Bubble Text 3", "Bubble 4", "multiline \n 1, \n 2 \n 3 \n 4 \n 5 \n 6 \n 7", "B5", "Bubble 6", "Bubble 7"]))
                .padding()
                .previewLayout(.sizeThatFits)
                .previewDisplayName("Mixed Length Bubbles")
            
            BubbleContainerWithAddDelete()
                .padding()
                .previewLayout(.sizeThatFits)
                .previewDisplayName("Test Add Delete")
        }
    }
}

/*
 @State private var totalHeight = CGFloat.zero // Default height
 @State private var minimumY = CGFloat.infinity // Default height
 @State private var maximumY = CGFloat.zero // Default height
 
 .background(GeometryReader { d in
     Color.clear
         .onAppear {
             minimumY = min(minimumY, d.frame(in: .global).minY)
             maximumY = max(maximumY, d.frame(in: .global).maxY)
             let total = d.frame(in: .global).maxY
             if total > totalHeight {
                 totalHeight = maximumY - minimumY + padding
             }
         }
 })
 */
