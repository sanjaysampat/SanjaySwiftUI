//
//  RecordDetailView.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 06/11/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import SwiftUI

struct RecordDetailView: View {
    let recorded:Recorded
    let webUrl:URL? = nil
    
    var body: some View {
        ZStack {
            Color(.black)
            if let url = webUrl {
                // will extend in future.
                VideoPlayerContainerView(url: url)
            } else {
                VideoPlayerContainerView(url: URL(fileURLWithPath: "\(CommonUtils.cuScreenRecordFolder.stringByAppendingPathComponent(path: recorded.fileName))"), theStartPlay: true)
            }
            
            //Text("\(recorded.fileName)")
            //    .foregroundColor(.white)
        }
        .navigationTitle(Text("\(recorded.fileName)"))
    }
}

struct RecordDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RecordDetailView(recorded: Recorded(name: "test", fileName: "test.mp4", imageName: "test.jpg"))
    }
}
