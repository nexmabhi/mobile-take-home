//
//  Constants.swift
//  Rick&Morty
//
//  Created by Dsilva on 04/07/19.
//  Copyright © 2019 Dsilva. All rights reserved.
//

import UIKit

import Foundation
import UIKit

/////////////////////////////////////////////////

let APPDELEGATE = UIApplication.shared.delegate as! AppDelegate

struct RMSegues {
    static let SEGUE_EPISODE_TO_DETAIL_PAGE   = "episode_to_detail_page"
}

struct DateFormats {
    static let EPISODE_DATE_FORMAT   = "dd/MM/yyyy"
}


struct RM_CELL_IDS {
    static let EPISODE_CELL = "episode_cell"
    static let SECTION_HEADER = "section_header"
    
}

