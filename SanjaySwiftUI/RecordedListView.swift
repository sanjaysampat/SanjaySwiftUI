//
//  RecordedListView.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 06/11/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import SwiftUI

struct RecordedListView: View {
    @ObservedObject var store = RecordedStore()
    
    var body: some View {
        NavigationView {
            List {
                //Section{
                    ForEach (store.recordedFiles) { recorded in
                        RecordedCell(recorded: recorded)
                    }
                    .onDelete( perform: deleteRecording)
                    .onMove(perform: moveRecording)
                //}
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle(Text("Recording"), displayMode: .inline)
            .navigationBarItems(trailing: EditButton())

        }
    }
    
    func deleteRecording(at offsets: IndexSet) {
        store.deleteRecording(at: offsets)
    }

    func moveRecording(from source: IndexSet, to destination: Int) {
        store.recordedFiles.move(fromOffsets: source, toOffset: destination)
    }
    
}

struct RecordedListView_Previews: PreviewProvider {
    static var previews: some View {
        RecordedListView()
    }
}

struct RecordedCell: View {
    let recorded: Recorded
    
    var body: some View {
        NavigationLink(destination: RecordDetailView(recorded: recorded)) {
            //PrintinView("SSPrint - \(CommonUtils.cuScreenRecordFolder.stringByAppendingPathComponent(path: recorded.imageName))")
            Image(uiImage: UIImage(contentsOfFile: "\(CommonUtils.cuScreenRecordFolder.stringByAppendingPathComponent(path: recorded.imageName))"), placeholderSystemName: "square.stack.3d.down.dottedline")
                .resizable()
                .scaledToFit()
                .frame(height: 200.0)
                .cornerRadius(10)
            VStack(alignment: .leading) {
                Text(recorded.name)
            }
        }
    }
}
