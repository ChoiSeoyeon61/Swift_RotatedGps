//
//  GPS.swift
//  GPS_Point
//
//  Created by 최서연 on 2022/03/24.
//

import Foundation

class GPS {
  
  static func getTheta(_ originX: Double, _ originY: Double, _ x: Double, _ y: Double, _ isRadian: Bool) -> Double {
    let theta = GPS.getθ(GPS.lonToLat(lon: originX) , originY, GPS.lonToLat(lon: x), y, isRadian) * -1
    return theta
  }
  
  
  static let targetLon: Double = 37.277 // 용인 - 원점 0 - 의 위도
  static let radiusOfEarth: Double = 6371.009 //지구 r(km)
  static var roundOfEarthKm: Double { return 2 * Double.pi * radiusOfEarth } // 지구 2ㅠr
  static var lat1ToKm: Double { return roundOfEarthKm / 360 } //경도 1당 거리(km)
  static var lon1ToKm: Double { return cos(targetLon * Double.pi / 180) * roundOfEarthKm / 360 }  //위도 1당 거리(km)
  
  
  /// (원점 - y값이 같은 점을 잇는 선분)과, (원점-지정한 점을 잇는 선분)이 이루는 각도를 리턴 - origin: 원점
  static private func getθ(
    _ originX: Double,
    _ originY: Double,
    _ x: Double,
    _ y: Double,
    _ isRadian: Bool) -> Double {
      
    let θ = atan((x - originX) / (y - originY))
    let returnValue: Double
    isRadian ? (returnValue = θ) : (returnValue = θ * (180 / Double.pi))
    return returnValue
  }
  
  /// 경도 -> 위도
  static func lonToLat(lon: Double) -> Double {
    return lon * lon1ToKm / lat1ToKm
  }
  
  /// 위도 -> 경도
  static func latToLon(lat: Double) -> Double {
    return lat * lat1ToKm / lon1ToKm
  }
  
  
  static func getAngle(x1: Double, y1: Double, x2: Double, y2: Double) -> Double {
    var a: Double
    if y1 == y2 {
      if x2 < x1 {
        a = -90
      } else {
        a = 90
      }
    } else if x1 == x2 && y2 > y1 {
      a = 180
    } else {
      let rad = atan((x2 - x1) / (y1 - y2))
      a = rad * 180 / Double.pi
      
      if y2 > y1 && x2 > x1 {
        a = 180 + a;
      } else if(y2>y1 && x2<x1) {
        a = -180 + a;
      }
    }
    return a
  }
  
  /// 좌표 회전하기
  static func calcCoordinatesAfterRotation(_ origin_x: Double, _ origin_y: Double, _ x: Double, _ y: Double, _ theta: Double, _ is_rad: Bool) -> (x: Double, y: Double) {
    let rebased_x = x - origin_x;
    let rebased_y = y - origin_y;
    
    var rad_theta: Double
    
    if (is_rad) {
      rad_theta = theta;
    } else {
      rad_theta = theta * (Double.pi / 180);
    }
    
    let rotatedX = (rebased_x * cos(rad_theta)) - (rebased_y * sin(rad_theta));
    let rotatedY = (rebased_x * sin(rad_theta)) + (rebased_y * cos(rad_theta));
    
    let xx = rotatedX + origin_x;
    let yy = rotatedY + origin_y;
    
    return (x: xx, y: yy)
    
  }
  
  /// GPS값을 화면 좌표계로 변환하기
  static func makeLinearEquation(_ origin_x: Double, _ origin_y: Double, _ to_x: Double, _ to_y: Double) -> (slope: Double, intercept: Double) {
    let x_variation = to_x - origin_x
    let y_variation = to_y - origin_y
    let slope = y_variation / x_variation
    let intercept = origin_y - (slope * origin_x)

    return (slope: slope, intercept: intercept)
  }
  
  /// GPS 좌표를 스크린 좌표로 변환하기
  static func calcScreenCoordinates(_ lat: Double, _ lon: Double) {
    let tempCoordi = calcCoordinatesAfterRotation(GPS.lonToLat(lon: gpsData[0].lon), gpsData[0].lat, GPS.lonToLat(lon: lon), lat, theta, true)
      tempCoordi.x = convertUnitToLon(tempCoordi.x);

      let x = lonQuation.slope * tempCoordi.x + lonQuation.intercept;
      let y = latQuation.slope * tempCoordi.y + latQuation.intercept;
      return { x: x, y: y };
  }
  
}



