//
//  Color.swift
//  ExchCurrency
//
//  Created by Dana on 20/11/2022.
//  Copyright © 2022 Sito. All rights reserved.
//

import UIKit

//цвета для view фона
enum Colors {
    case upColorTopView
    case bottomColorTopView
    case partsColormedimView
    case centralColormedimView
    case labelColor
    case redLabelColor
    case placeHolderColor
    var colorViewUIColor: UIColor{
        switch self {
        case .upColorTopView:
            return #colorLiteral(red: 0.06586541927, green: 0.2627367188, blue: 0.7324512005, alpha: 1)
        case .bottomColorTopView:
            return #colorLiteral(red: 0.3272100091, green: 0.6094940305, blue: 0.9126271605, alpha: 1)
        case .partsColormedimView:
            return #colorLiteral(red: 0.01055246126, green: 0.3625304103, blue: 0.6282795668, alpha: 1)
        case .centralColormedimView:
            return #colorLiteral(red: 0.0568895191, green: 0.445638299, blue: 0.7031494975, alpha: 1)
        case .labelColor:
            return #colorLiteral(red: 0.5881078839, green: 0.8096932769, blue: 0.9557163119, alpha: 1)
        case .redLabelColor:
            return #colorLiteral(red: 0.6605595946, green: 0.3039845228, blue: 0.572892487, alpha: 1)
        case .placeHolderColor:
            return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
    }
    var colorViewCGColor: CGColor{
        switch self {
        case .upColorTopView:
            return #colorLiteral(red: 0.06586541927, green: 0.2627367188, blue: 0.7324512005, alpha: 1)
        case .bottomColorTopView:
            return #colorLiteral(red: 0.3272100091, green: 0.6094940305, blue: 0.9126271605, alpha: 1)
        case .partsColormedimView:
            return #colorLiteral(red: 0.01055246126, green: 0.3625304103, blue: 0.6282795668, alpha: 1)
        case .centralColormedimView:
            return #colorLiteral(red: 0.0568895191, green: 0.445638299, blue: 0.7031494975, alpha: 1)
        case .labelColor:
            return #colorLiteral(red: 0.5881078839, green: 0.8096932769, blue: 0.9557163119, alpha: 1)
        case .redLabelColor:
            return #colorLiteral(red: 0.6605595946, green: 0.3039845228, blue: 0.572892487, alpha: 1)
        case .placeHolderColor:
            return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
    }
}
