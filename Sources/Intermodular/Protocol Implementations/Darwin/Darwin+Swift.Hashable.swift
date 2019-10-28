//
// Copyright (c) Vatsal Manot
//

import Darwin
import Swallow

extension timeval: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(tv_sec)
        hasher.combine(tv_usec)
    }
}
