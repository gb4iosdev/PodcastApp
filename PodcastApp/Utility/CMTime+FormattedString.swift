//
//  CMTime+FormattedString.swift
//  PodcastApp
//
//  Created by Gavin Butler on 12-04-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import CoreMedia

extension CMTime {
    var formattedString: String {
        //1:12:34
        //23:09
        let totalSeconds = seconds
        let hours = Int(totalSeconds / 3600)
        let minutes = Int(totalSeconds.truncatingRemainder(dividingBy: 3600)) / 60
        let seconds = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
        
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
}
