// exploration of a multi selector developed by Cihat Gündüz (Jeehut) ref: https://dev.to/jeehut/multi-selector-in-swiftui-5heg

// Example to use ... 

import SwiftUI

let allGoals: [MultiSelectorGoal] = [MultiSelectorGoal(name: "Learn Japanese"), MultiSelectorGoal(name: "Learn SwiftUI"), MultiSelectorGoal(name: "Learn Serverless with Swift")]

struct MultiSelectorTaskEditExampleView: View {
    
    @State var multiSelecterTask = MultiSelectorTask(name: "", servingGoals: [allGoals[1]])

    var body: some View {
        Form {
            Section(header: Text("Name")) {
                TextField("e.g. Find a good Japanese textbook", text: $multiSelecterTask.name)
            }

            Section(header: Text("Relationships")) {
                MultiSelector(
                    label: Text("Serving Goals"),
                    options: allGoals,
                    optionToString: { $0.name },
                    selected: $multiSelecterTask.servingGoals
                )
            }
        }
        //.navigationTitle("Edit Task")
    }
    
}

struct MultiSelectorTaskEditView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MultiSelectorTaskEditExampleView()
        }
    }
}
