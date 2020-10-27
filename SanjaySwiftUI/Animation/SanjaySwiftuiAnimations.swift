// SSNote : My Experiments with SwiftUI Animations

import SwiftUI

fileprivate let cardWidth:CGFloat = 362/4
fileprivate let cardHeight:CGFloat = 542/4
fileprivate let cardPrefix = "cards-"
fileprivate let cardTypes:[String] = ["S","C","H","D"]
fileprivate let cardOfColor = 1...13

struct SanjaySwiftuiAnimations: View {
    @EnvironmentObject  var  userSettings : UserSettings
    
    var body: some View {
        return NavigationView {
            List {
                Section(header: Text("Geometry Effect")) {
                    NavigationLink(destination: Example21(cardsCount: userSettings.e21PickCardsCount), label: {
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
    
    init( cardsCount:Int ) {
        // SSNote :- initialize the state array variable as under.
        self._playingCards = State(initialValue:fillCardsData(cardsCount: cardsCount))
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
    
    func fillCardsData( cardsCount:Int ) -> [PlayingCard] {
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
        if cardsCount > 0 {
            newDeck = Array(newDeck.choose( cardsCount ))
        }
        return newDeck
    }
}

struct RotatingShowCard: View {
    @EnvironmentObject  var  userSettings : UserSettings
    
    @Binding var playingCards:[PlayingCard]
    
    @State private var flipped = false
    @State private var animate3d = false
    @State private var rotate = false

    var body: some View {
        let totalCards = Double(playingCards.count) / Double( userSettings.e21TotalPlayers )
        
        
        var player1CardDimention:Double = userSettings.e21P1FixedModeDegree
        if userSettings.e21P1ShowMode == "Compact" {
            player1CardDimention = userSettings.e21P1CompactModeDegree * totalCards
        }
        let player1CardDegree = player1CardDimention/totalCards
        
        var player2CardDimention:Double = userSettings.e21P2FixedModeDegree
        let player2CompactCardDimention:Double = userSettings.e21P2CompactModeDegree * totalCards
        if userSettings.e21P2ShowMode == "Compact" {
            player2CardDimention = player2CompactCardDimention
        }
        let player2CardDegree = player2CardDimention/totalCards
        //let player2CompactCardDegree = player2CompactCardDimention/totalCards
        
        //_ = PrintinView("SSPrint - player1CardDimention=\(player1CardDimention)  player1CardDegree=\(player1CardDegree)")
        //_ = PrintinView("SSPrint - player2CardDimention=\(player2CardDimention)  player2CardDegree=\(player2CardDegree)")

        return VStack {
            ZStack {
                // other player cards
                ForEach(0..<playingCards.count) { i in
                    if i % userSettings.e21TotalPlayers == 0 {
                    // Player 1
                        RotatingSingleCard(0, -(player1CardDimention/2)+(Double(i / userSettings.e21TotalPlayers )*player1CardDegree), i, userSettings.e21P1ShowCards ? playingCards[i].id : "cards-BK")
                    }
                }
            }
            
            Spacer()
                // SSTODO
            Spacer()
            
            ZStack {
                // my cards
                ForEach(0..<playingCards.count) { i in
                    if i % userSettings.e21TotalPlayers > 0 {
                    // Player 2
                        RotatingSingleCard(0, -(player2CardDimention/2)+(Double(i / userSettings.e21TotalPlayers )*player2CardDegree), i, userSettings.e21P2ShowCards ? playingCards[i].id : "cards-BK")
                    }
               }
            }
            
            
            if player2CardDegree < 6 {
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
