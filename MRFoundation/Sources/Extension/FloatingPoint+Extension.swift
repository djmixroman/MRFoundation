//
//  FloatingPoint+Extension.swift
//  MRFoundation
//
//  Created by Roman Mogutnov on 09.02.2022.
//  Copyright © 2022 mxrn. All rights reserved.
//

import Foundation


// MARK: - Range Mapping

extension FloatingPoint {
    
    /// Range mapping
    ///
    /// - Parameters:
    ///   - source: source range
    ///   - destination: destination range
    ///   - clamped: specify true to clamp result in destination range
    ///   - reversed: specify true to reverse result
    /// - Returns: By mapping source range to destination, result goes from destination lower bound,
    /// to destination upper bound once the phase hits source upper bound
    public func scaled(from source: ClosedRange<Self>,
                       to destination: ClosedRange<Self>,
                       clamped: Bool = false,
                       reversed: Bool = false) -> Self {
        let destinationStart = reversed ? destination.upperBound : destination.lowerBound
        let destinationEnd = reversed ? destination.lowerBound : destination.upperBound
        
        // these are broken up to speed up compile time
        let selfMinusLower = self - source.lowerBound
        let sourceUpperMinusLower = source.upperBound - source.lowerBound
        let destinationUpperMinusLower = destinationEnd - destinationStart
        var result = (selfMinusLower / sourceUpperMinusLower) * destinationUpperMinusLower + destinationStart
        if clamped {
            result = result.clamped(to: destination)
        }
        
        return result
    }
}


// MARK: - Projection

extension FloatingPoint {
    
    /// Distance travelled after decelerating to zero velocity at a constant rate
    ///
    /// - Parameters:
    ///   - initialVelocity: the velocity at the moment the touch was released
    ///   - decelerationRate: a value that determines the rate of deceleration after the user lifts their finger
    /// - Returns: the projection
    public func project(initialVelocity: Self, decelerationRate: Self) -> Self {
        if decelerationRate >= 1 {
            assert(false)
            return self
        }
        
        return self + initialVelocity * decelerationRate / (1 - decelerationRate)
    }
}
