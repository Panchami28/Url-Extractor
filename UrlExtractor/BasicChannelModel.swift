//
//  BasicChannelModel.swift
//  UrlExtractor
//
//  Created by Panchami Rao on 25/04/21.
//

import Foundation

enum MainChannelOption :CaseIterable{
    
    case RadioNet
    case ShalomBeats
    case NammRadio
    case RadioMirchi
    case CBCListen
    case IndianAustralianRadio
    case BombayBeats
    case RadioCityHindi
    case Wgbh
    case CamFM
    case Madhuban
    case ElectricRadio
    
    var websiteUrl : String {
        switch self {
        case .RadioNet:
            return "https://www.radio.net/"
        case .ShalomBeats:
            return "http://shalombeatsradio.com/"
        case .NammRadio:
            return "http://nammradio.com/"
        case .RadioMirchi:
            return "https://www.radiomirchi.com/"
        case .CBCListen:
            return "https://www.cbc.ca/listen/live-radio"
        case .IndianAustralianRadio:
            return "https://hindiradios.com/australian-indian-radio"
        case .BombayBeats:
            return "https://hindiradios.com/bombay-beats-radio"
        case .RadioCityHindi:
            return "https://hindiradios.com/radio-city-hindi-fm"
        case .Wgbh:
            return "https://www.wgbh.org/"
        case .CamFM:
            return "https://www.camfm.co.uk/"
        case .Madhuban:
            return "http://radiomadhuban.in/pop_up_player.html"
        case .ElectricRadio:
            return "https://player.electricradio.co.uk/"
        }
    }
}


struct BasicChannelModel {
    var channelList = [MainChannelOption]()
    
    init() {
        for channel in MainChannelOption.allCases {
            channelList.append(channel)
        }
    }
    
    func numberOfChannels() -> Int {
        return channelList.count
    }
    
    func item(atIndexPath indexpPath: IndexPath) -> MainChannelOption {
        return channelList[indexpPath.row]
    }
    
}
