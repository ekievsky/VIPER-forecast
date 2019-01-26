//
//  Tab.swift
//  Forecast
//
//  Created by Evgenii Kyivskyi on 1/25/19.
//  Copyright © 2019 Evgenii Kyivskyi. All rights reserved.
//

import UIKit

enum Tabs: CaseIterable {
    case today
    case forecast
}

extension Tabs {
    var title: String {
        switch self {
        case .today:
            return "Today"
        case .forecast:
            return "Forecast"
        }
    }

    var image: UIImage {
        switch self {
        case .today:
            return UIImage(named: "icToday")!
        case .forecast:
            return UIImage(named: "icForecast")!
        }
    }

    var selectedImage: UIImage {
        switch self {
        case .today:
            return UIImage(named: "icTodaySelected")!
        case .forecast:
            return UIImage(named: "icForecastSelected")!
        }
    }
}
