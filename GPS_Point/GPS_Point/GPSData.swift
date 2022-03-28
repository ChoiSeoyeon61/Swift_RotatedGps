//
//  GPSData.swift
//  GPS_Point
//
//  Created by 최서연 on 2022/03/28.
//

import Foundation

struct GpsData {
  var lon: Double
  var lat: Double
  var lonRotated: Double?
  var latRotated: Double?
}

var gpsData: [GpsData] = [
  GpsData(lon: 127.078486, lat: 37.277025),
  GpsData(lon: 127.080234, lat: 37.277691),
  GpsData(lon: 127.080801, lat: 37.273178)
]
