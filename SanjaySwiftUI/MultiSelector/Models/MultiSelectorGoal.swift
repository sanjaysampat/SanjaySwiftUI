// exploration of a multi selector developed by Cihat Gündüz (Jeehut) ref: https://dev.to/jeehut/multi-selector-in-swiftui-5heg

import Foundation

struct MultiSelectorGoal: Hashable, Identifiable {
    var id: String { name }
    var name: String
}
