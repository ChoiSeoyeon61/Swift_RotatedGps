//
//  ViewController.swift
//  GPS_Point
//
//  Created by 최서연 on 2022/03/24.
//

import UIKit

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    getGPS()
  }
  
  func getGPS() {
    
    let originX = gpsData[0].lon
    let originY = gpsData[0].lat
    let x2 = gpsData[1].lon
    let y2 = gpsData[1].lat
    let x3 = gpsData[2].lon
    let y3 = gpsData[2].lat
    
    let theta = GPS.getTheta(originX, originY, x2, y2, false)
    print(theta)
    
    var tempCoordi = GPS.calcCoordinatesAfterRotation(GPS.lonToLat(lon: originX), originY, GPS.lonToLat(lon: x2), y2, theta, true)
    tempCoordi.x = GPS.latToLon(lat: tempCoordi.x)
    gpsData[1].lonRotated = tempCoordi.x
    gpsData[1].latRotated = tempCoordi.y
    print("dot 2: ", tempCoordi.x, " / ", tempCoordi.y)
    
    // 세 번째 입력한 위치 회전변환
    var tempCoordi2 = GPS.calcCoordinatesAfterRotation(GPS.lonToLat(lon: originX), gpsData[0].lat, GPS.lonToLat(lon: x3), y3, theta, true);
    tempCoordi2.x = GPS.latToLon(lat: tempCoordi2.x)
    gpsData[2].lonRotated = tempCoordi2.x
    gpsData[2].latRotated = tempCoordi2.y
    print("dot 3: ", tempCoordi2.x, " / ", tempCoordi2.y)
    
    
    var xy = GPS.calcScreenCoordinates(lat, lon)

        print(xy)

//        drawCircle(xy['x'], xy['y']);

  }
  
  func drawCircle(_ x: Double, _ y: Double) {
    let circle = UIView()
    circle.backgroundColor = .red
    circle.layer.shadowColor = UIColor.red.cgColor
    circle.layer.shadowOffset = CGSize(width: 0, height: 3)
    circle.layer.shadowRadius = 4
    circle.layer.shadowOpacity = 0
    circle.frame.size.width = 5
    circle.frame.size.height = 5
    circle.center = CGPoint(x: x, y: y)
    circle.layer.borderColor = UIColor.white.cgColor
    circle.layer.borderWidth = 1
  }
  
}

