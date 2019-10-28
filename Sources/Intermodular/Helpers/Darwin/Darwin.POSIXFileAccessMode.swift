//
// Copyright (c) Vatsal Manot
//

import Darwin
import Swallow

public enum POSIXFileAccessMode: String {
    case read = "r"
    case write = "w"
    case append = "a"
    case readUpdate = "r+"
    case writeUpdate = "w+"
    case appendUpdate = "a+"
}
