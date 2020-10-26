// SSNote : My Experiments with SwiftUI Animations

import SwiftUI

fileprivate let cardWidth:CGFloat = 362/4
fileprivate let cardHeight:CGFloat = 542/4
fileprivate let cardPrefix = "cards-"
fileprivate let cardTypes:[String] = ["S","C","H","D"]
fileprivate let cardOfColor = 1...13

// SSTODO :- start user options
// this will be differnt depending on each Example
fileprivate let pickCardsCount = 26 // 1 to 52 divided between total players
fileprivate let totalPlayers = 2
// player options
//      show player - Bool
//      show back of cards of player - Bool
//      show cards in maximum spread view - Bool
// end user options


struct SanjaySwiftuiAnimations: View {
    var body: some View {
        return NavigationView {
            List {
                Section(header: Text("Geometry Effect")) {
                    NavigationLink(destination: Example21(), label: {
                        Text("Example 21 (playing cards)")
                    })
                }
            }.navigationBarTitle(Text("Animation Experiments"), displayMode: .inline)
        }
    }
}

// MARK: Geometry Effects
// MARK: Exmaple 21 (playing cards)
struct Example21: View {

    @State var playingCards:[PlayingCard] = []
    
    init() {
        // SSNote :- initialize the state array variable as under.
        self._playingCards = State(initialValue:fillCardsData())
    }

    var body: some View {
        
        return HStack {
            Spacer()
            RotatingShowCard(playingCards: $playingCards)
            Spacer()
        }
        .background(Color.black)
        .navigationBarTitle(Text("Example 21"), displayMode: .inline)
    }
    
    func fillCardsData() -> [PlayingCard] {
        var newDeck:[PlayingCard] = []
        cardTypes.forEach{ type in
            for number in cardOfColor {
                let hexString = String(number, radix: 16, uppercase: true)
                let fileName = "\(cardPrefix)\(type)\(hexString)"
                //print("SSTODO - \(fileName)")
                newDeck.append(PlayingCard(id: fileName, weight: number))
            }
            
        }
        newDeck.shuffle()
        if pickCardsCount > 0 {
            newDeck = Array(newDeck.choose(pickCardsCount))
        }
        return newDeck
    }
}

enum CardsSpreadView:Double {
    case fullFixed = 140
    case closedFixed = 10
    case compactMultiply = 6
}

struct RotatingShowCard: View {
    @Binding var playingCards:[PlayingCard]
    
    @State private var flipped = false
    @State private var animate3d = false
    @State private var rotate = false

    var body: some View {
        let totalCards = Double(playingCards.count) / Double(totalPlayers)
        let minCardDimention:Double = CardsSpreadView.compactMultiply.rawValue * totalCards
        let fixedCardDimention:Double = CardsSpreadView.fullFixed.rawValue
        let fixedCardDegree = fixedCardDimention/totalCards
        let minCardDegree = minCardDimention/totalCards
        //print("minCardDegree=\(minCardDegree) minCardDimention=\(minCardDimention)")
        //print("fixedCardDegree=\(fixedCardDegree) fixedCardDimention=\(fixedCardDimention)")
        
        
        return VStack {
            ZStack {
                // other player cards
                ForEach(0..<playingCards.count) { i in
                    if i % totalPlayers == 0 {
                    // Player 1
                    RotatingSingleCard(0, -(fixedCardDimention/2)+(Double(i/totalPlayers)*fixedCardDegree), i, playingCards[i].id)//"cards-BK") // SSTODO
                    }
                }
            }
            
            Spacer()
                // SSTODO
            Spacer()
            
            ZStack {
                // my cards
                ForEach(0..<playingCards.count) { i in
                    if i % totalPlayers > 0 {
                    // Player 2
                    RotatingSingleCard(0, -(minCardDimention/2)+(Double(i/totalPlayers)*minCardDegree), i, playingCards[i].id)
                    }
               }
            }
            
            if fixedCardDegree < minCardDegree {
                Spacer(minLength: cardHeight)
            }
        }
    }
}

struct RotatingSingleCard: View {
    var rotateDegreeFrom:Double = 0
    var rotateDegreeto:Double = 45
    var imageName:String = "cards-BK"

    @State private var rotate = false
    
    // Initializer
    init(_ rf: Double, _ rt: Double, _ i: Int, _ n: String ) {
        self.rotateDegreeFrom = rf
        self.rotateDegreeto = rt
        self.imageName = n
    }

    var body: some View {
    Image(imageName).resizable()
        .frame(width: cardWidth, height: cardHeight)
        .rotationEffect(Angle(degrees:  rotate ? Double(rotateDegreeto) : rotateDegreeFrom), anchor: .bottom)
        .onAppear {
            withAnimation(Animation.linear(duration: 1.0)
            )
            {
                self.rotate = true
            }
        }
    }

}

struct FlipEffectShowCard: GeometryEffect {
    
    var animatableData: Double {
        get { angle }
        set { angle = newValue }
    }
    
    @Binding var flipped: Bool
    var angle: Double
    let axis: (x: CGFloat, y: CGFloat)
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        
        // We schedule the change to be done after the view has finished drawing,
        // otherwise, we would receive a runtime error, indicating we are changing
        // the state while the view is being drawn.
        DispatchQueue.main.async {
            self.flipped = self.angle >= 90 && self.angle < 270
        }
        
        let a = CGFloat(Angle(degrees: angle).radians)
        
        var transform3d = CATransform3DIdentity;
        transform3d.m34 = -1/max(size.width, size.height)
        
        transform3d = CATransform3DRotate(transform3d, a, axis.x, axis.y, 0)
        transform3d = CATransform3DTranslate(transform3d, -size.width/2.0, -size.height/2.0, 0)
        
        let affineTransform = ProjectionTransform(CGAffineTransform(translationX: size.width/2.0, y: size.height / 2.0))
        
        return ProjectionTransform(transform3d).concatenating(affineTransform)
    }
}


// MARK: Models
struct PlayingCard: Identifiable {
    var id: String
    var weight: Int
}
