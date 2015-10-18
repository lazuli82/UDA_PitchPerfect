//
//  RecordedAudio.swift
//  UDA_PitchPerfect
//
//  Created by MJH_Mac on 2015. 10. 5..
//  Copyright © 2015년 MJH_Mac. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl: NSURL, title: String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}

