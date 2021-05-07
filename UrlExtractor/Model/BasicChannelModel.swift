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
    case RadioSwissPop
    case CheesyRadio
    
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
        case .RadioSwissPop:
            return "https://www.radioswisspop.ch/en"
        case .CheesyRadio :
            return "https://cheesyfm.co.uk/radioplayer/"
        }
    }
        var websiteName : String {
            switch self {
            case .RadioNet:
                return "RadioNet"
            case .ShalomBeats:
                return "Shalom Beats Radio"
            case .NammRadio:
                return "Namm Radio"
            case .RadioMirchi:
                return "Radio Mirchi"
            case .CBCListen:
                return "CBCListen Radio"
            case .IndianAustralianRadio:
                return "Indian Australian Radio"
            case .BombayBeats:
                return "Bombay Beats Radio"
            case .RadioCityHindi:
                return "RadioCity Hindi"
            case .Wgbh:
                return "WGBH Radio"
            case .CamFM:
                return "CamFM Radio"
            case .Madhuban:
                return "Madhuban Radio"
            case .ElectricRadio:
                return "Electric Radio"
            case .RadioSwissPop:
                return "Radio SwissPop"
            case .CheesyRadio :
                return "Cheesy Radio"
            }
    }
}


class BasicChannelModel {
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
