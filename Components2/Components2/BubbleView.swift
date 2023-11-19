//
//  BubbleView.swift
//  Components2
//
//  Created by Ankit Sachan on 18/11/23.
//

import SwiftUI

struct BubbleView: View {
    let text: String
    var onClose: () -> Void

    var body: some View {
        HStack {
            Image(systemName: "star.fill")
            Text(text)
                .font(.system(size: 17))
                .padding(.all, 10)
                .background(Color.green.opacity(0.2))
                .cornerRadius(20)
            Button(action: onClose) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
            }
        }
//        .frame(maxWidth: .infinity, alignment: .leading)
        .border(.red)
        .transition(.scale) // Add a scale transition
    }
}

struct BubbleView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BubbleView(text: "Short text", onClose: {})
                .padding()
                .previewLayout(.sizeThatFits)
                .previewDisplayName("Short Text")

            BubbleView(text: "This is a longer bubble view text that demonstrates how the view adjusts its size based on the content.", onClose: {})
                .padding()
                .previewLayout(.sizeThatFits)
                .previewDisplayName("Long Text")

            BubbleView(text: "Medium length text for the bubble view.", onClose: {})
                .padding()
                .previewLayout(.sizeThatFits)
                .previewDisplayName("Medium Text")
        }
    }
}
