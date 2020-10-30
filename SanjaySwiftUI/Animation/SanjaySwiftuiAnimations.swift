// SSNote : My Experiments with SwiftUI Animations

import SwiftUI

fileprivate let cardWidth:CGFloat = 362/4
fileprivate let cardHeight:CGFloat = 542/4
fileprivate let cardPrefix = "cards-"
fileprivate let cardTypes:[String] = ["S","C","H","D"]
fileprivate let cardOfColor = 1...13

struct SanjaySwiftuiAnimations: View {
    @EnvironmentObject  var  userSettings : UserSettings
    
    @State var presentedSettings = false
    private let whoAmI:CallingViews = CallingViews.sanjayExperiment
    
    var body: some View {
        return NavigationView {
            List {
                Section(header: Text("Geometry Effect")) {
                    
                    NavigationLink(destination: Example21(cardsCount: userSettings.e21PickCardsCount), label: {
                        Text("Example 21 (playing cards)")
                    })
                    
                    NavigationLink(destination: Example22(cardsCount: userSettings.e22PickCardsCount), label: {
                        Text("Example 22 (Card game of War)")
                    })
                    
                }
            }
            .navigationBarTitle(Text("Animation Experiments"), displayMode: .inline)
            .navigationBarItems(trailing:
                                    Button(action: {
                                        presentedSettings.toggle()
                                    }, label: {
                                        Image(systemName: "text.justify")
                                            .padding(.vertical, 5)
                                    })
            )
        }
        .sheet(isPresented: $presentedSettings, content: {SanjaySwiftUIOptions(self.whoAmI)})
    }
}

// MARK: Geometry Effects
// MARK: Exmaple 21 (playing cards)
struct Example21: View {
    @State var playingCards:[PlayingCard] = []
    
    @State var presentedSettings = false
    private let whoAmI:CallingViews = CallingViews.example21

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
        .navigationBarItems(trailing:
                                Button(action: {
                                    presentedSettings.toggle()
                                }, label: {
                                    Image(systemName: "text.justify")
                                        .padding(.vertical, 5)
                                })
        )
        .sheet(isPresented: $presentedSettings, content: {SanjaySwiftUIOptions(self.whoAmI)})
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
            withAnimation(Animation.linear(duration: 1.0).delay(0.5)
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

// MARK: Exmaple 22 ( Card game War )
struct Example22: View {
    @State var playingCards:[PlayingCard] = []
    
    @State var presentedSettings = false
    private let whoAmI:CallingViews = CallingViews.example22

    @State var openCard:Int = -1
    
    init( cardsCount:Int ) {
        // SSNote :- initialize the state array variable as under.
        self._playingCards = State(initialValue:fillCardsData(cardsCount: cardsCount))
        self._openCard = State(initialValue: self.playingCards.count)
    }

    var body: some View {
        
        return HStack {
            Spacer()
            DealWarCards(playingCards: $playingCards, openCard: $openCard)
            Spacer()
        }
        .background(Color.black)
        .navigationBarTitle(Text("Example 22"), displayMode: .inline)
        .navigationBarItems(trailing:
                                Button(action: {
                                    presentedSettings.toggle()
                                }, label: {
                                    Image(systemName: "text.justify")
                                        .padding(.vertical, 5)
                                })
        )
        .sheet(isPresented: $presentedSettings, onDismiss: {
            playingCards.shuffle()
            openCard = playingCards.count
        }, content: {
            SanjaySwiftUIOptions(self.whoAmI)
        })
        
    }
    
    func fillCardsData( cardsCount:Int ) -> [PlayingCard] {
        var newDeck:[PlayingCard] = []
        cardTypes.forEach{ type in
            for number in cardOfColor {
                let hexString = String(number, radix: 16, uppercase: true)
                let fileName = "\(cardPrefix)\(type)\(hexString)"
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

struct DealWarCards: View {
    @EnvironmentObject  var  userSettings : UserSettings
    
    @Binding var playingCards:[PlayingCard]
    
    @Binding var openCard:Int
    
    @State private var myPoints:Int = 0
    @State private var myPhonePoints:Int = 0
    
    @State private var alertPresented:Bool = false
    
    var body: some View {
        
        return VStack {
            Spacer()
            Text("WAR").font(.title).foregroundColor(.yellow)
            HStack {
                if openCard >= 0 && openCard < playingCards.count {
                    SingleWarCard(whoAmI:"Me", imageName: playingCards[openCard].id, pointsStr:"\(myPoints)")
                    Spacer()
                    SingleWarCard(whoAmI:"My phone", imageName: playingCards[openCard+1].id, pointsStr:"\(myPhonePoints)")
                } else {
                    SingleWarCard(whoAmI:"Me", imageName: "cards-BK", pointsStr:"--")
                    Spacer()
                    SingleWarCard(whoAmI:"My phone", imageName: "cards-BK", pointsStr:"--")
                }
            }
            Button(action: {
                if openCard > 1 {
                    openCard = openCard - 2
                    // calculation method
                    switch whoWin() {
                    case 1:
                        myPoints = myPoints + 1
                    case 2:
                        myPhonePoints = myPhonePoints + 1
                    default:
                        break
                    }
                } else {
                    self.alertPresented = true
                }
            }, label: {
                VStack {
                    Image("cards-BK").resizable()
                        .frame(width: cardWidth/3, height: cardHeight/3)
                        .rotationEffect(Angle(degrees: 90), anchor: .center)
                    Text("Pick").foregroundColor(.white)
                }
            })
            .alert(isPresented: $alertPresented) {
                Alert(title: Text("Winner"), message: Text("\( myPoints == myPhonePoints ? "NOBODY" : myPoints > myPhonePoints ? "I" : "My phone") won the WAR. Replay."), dismissButton: Alert.Button.default(Text("OK")) {
                    
                    playingCards.shuffle()
                    openCard = playingCards.count
                    myPoints = 0
                    myPhonePoints = 0

                })
            }

            Spacer()
        }
    }
    
    func whoWin() -> Int {
        let myPoint = Int(playingCards[openCard].id.suffix(1), radix: 16) ?? 0
        let myPhonePoint = Int(playingCards[openCard+1].id.suffix(1), radix: 16) ?? 0
        return myPoint == myPhonePoint ? 0 : myPoint == 1 || (myPhonePoint != 1 &&  myPoint > myPhonePoint) ? 1 : 2
    }
}

struct SingleWarCard: View {
    var whoAmI:String = ""
    var imageName:String = "cards-BK"
    var pointsStr:String = ""
    
    @State private var show = false
    
    var body: some View {
        VStack{
            Image(imageName).resizable()
                .frame(width: cardWidth, height: cardHeight)
                .onAppear {
                    withAnimation(Animation.linear(duration: 1.0).delay(0.5)
                    )
                    {
                        self.show = true
                    }
                }
            
            VStack{
                Text(whoAmI).foregroundColor(.white)
                Text(pointsStr).foregroundColor(.yellow).bold()
            }
        }
    }
}

// MARK: Models
struct PlayingCard: Identifiable {
    var id: String
    var weight: Int
}
