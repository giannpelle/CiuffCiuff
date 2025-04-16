//
//  Game.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 12/01/24.
//

import Foundation
import UIKit

enum Game: String, Codable {
    case g1830 = "1830"
    case g1840 = "1840"
    case g1846 = "1846"
    case g1848 = "1848"
    case g1849 = "1849"
    case g1856 = "1856"
//    case g1860 = "1860"
//    case g1871 = "1871"
//    case g1880 = "1880"
    case g1882 = "1882"
    case g1889 = "1889"
    case g18Chesapeake = "18Ch"
//    case g18CZ = "18CZ"
    case g18MEX = "18MEX"
    
    func getMetadata() -> [String: Any] {
        var metadata: [String: Any] = [:]
        
        switch self {
        case .g1830:
            metadata["gameSpecificPlayerTurnOrderType"] = PlayerTurnOrderType.classic
            metadata["roundOperationTypes"] = [OperationType.brownOR, OperationType.greenOR, OperationType.yellowOR, OperationType.SR]
            metadata["roundOperationTypeColors"] = [UIColor.brownORColor, UIColor.greenORColor, UIColor.yellowORColor, UIColor.white]
            metadata["roundOperationTypeTextColors"] = [UIColor.white, UIColor.white, UIColor.black, UIColor.black]
            
            metadata["companies"] = ["B&M", "B&O", "C&O", "CPR", "ERIE", "N&W", "NKP", "NNH", "NYC", "PMQ", "PRR", "RDR"]
            metadata["floatModifiers"] = Array(repeating: 0, count: 12)
            metadata["companiesTypes"] = Array(repeating: CompanyType.standard, count: 12)
            metadata["compTotShares"] = Array(repeating: 10.0, count: 12)
            metadata["predefinedShareAmounts"] = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0]
            metadata["printShareAmountsAsInt"] = true
            metadata["shareStartingLocation"] = ShareStartingLocation.ipo
            metadata["compLogos"] = ["B&M_30", "B&O_30", "C&O_30", "CPR_30", "ERIE_30", "N&W_30", "NKP_30", "NNH_30", "NYC_30", "PMQ_30", "PRR_30", "RDR_30"]
            metadata["compColors"] = [
                UIColor.fromHex("6A3234"),
                UIColor.fromHex("225696"),
                UIColor.fromHex("FFFF00"),
                UIColor.fromHex("B5332E"),
                
                UIColor.fromHex("000000"),
                UIColor.fromHex("6A3234"),
                UIColor.fromHex("220084"),
                UIColor.fromHex("DD3027"),
                
                UIColor.fromHex("727258"),
                UIColor.fromHex("1C006A"),
                UIColor.fromHex("196E3F"),
                UIColor.fromHex("272F11")
            ]
            metadata["compTextColors"] = Array(repeating: UIColor.white, count: 2) + Array(repeating: UIColor.black, count: 1) + Array(repeating: UIColor.white, count: 9)
            metadata["totalBankAmount"] = [12000] as [Double]
            metadata["playersStartingMoney"] = [1200, 800, 600, 480, 400] as [Double]
            metadata["openCompanyValues"] = [402, 426, 456, 492, 540, 600]
            metadata["gamePARValues"] = [67, 71, 76, 82, 90, 100]
            metadata["PARValueIsIrrelevantToShow"] = false
            metadata["requiredNumberOfSharesToFloat"] = 6
            metadata["tileTokensPriceSuggestions"] = [40, 80, 100]
            metadata["trainPriceValues"] = [80, 180, 300, 450, 630, 800, 1100]
            metadata["trainPriceIndexToCloseAllPrivates"] = 3
            metadata["certificateLimit"] = [28, 20, 16, 13, 11] as [Double]
            metadata["shareValues"] = [[60, 53, 46, 38, 32, 25, 18, 10, nil, nil, nil],
                                       [67, 60, 55, 48, 41, 34, 27, 20, 10, nil, nil],
                                       [71, 66, 60, 54, 48, 42, 36, 30, 20, 10, nil],
                                       [76, 70, 65, 60, 55, 50, 45, 40, 30, 20, 10],
                                       [82, 76, 70, 66, 62, 58, 54, 50, 40, 30, 20],
                                       [90, 82, 76, 71, 67, 65, 63, 60, 50, 40, 30],
                                       [100, 90, 82, 76, 71, 67, 67, 67, 60, 50, 40],
                                       [112, 100, 90, 82, 76, 71, 69, 68, nil, nil, nil],
                                       [126, 112, 100, 90, 82, 75, 70, nil, nil, nil, nil],
                                       [142, 126, 111, 100, 90, 80, nil, nil, nil, nil, nil],
                                       [160, 142, 125, 110, 100, nil, nil, nil, nil, nil, nil],
                                       [180, 160, 140, 120, nil, nil, nil, nil, nil, nil, nil],
                                       [200, 180, 155, 130, nil, nil, nil, nil, nil, nil, nil],
                                       [225, 200, 170, nil, nil, nil, nil, nil, nil, nil, nil],
                                       [250, 220, 185, nil, nil, nil, nil, nil, nil, nil, nil],
                                       [275, 240, 200, nil, nil, nil, nil, nil, nil, nil, nil],
                                       [300, 260, nil, nil, nil, nil, nil, nil, nil, nil, nil],
                                       [325, 280, nil, nil, nil, nil, nil, nil, nil, nil, nil],
                                       [350, 300, nil, nil, nil, nil, nil, nil, nil, nil, nil]] as [[Double?]]
            metadata["currencyType"] = CurrencyType.dollar
            
            metadata["ipoSharesPayBank"] = true
            metadata["bankSharesPayBank"] = false
            metadata["compSharesPayBank"] = true
            metadata["asideSharesPayBank"] = true
            metadata["tradeInSharesPayBank"] = true
            
            metadata["buyShareFromIPOPayBank"] = true
            metadata["buyShareFromBankPayBank"] = true
            metadata["buyShareFromCompPayBank"] = true
            
            metadata["sharesFromIPOHavePARprice"] = true
            metadata["sharesFromBankHavePARprice"] = false
            metadata["sharesFromCompHavePARprice"] = true
            metadata["sharesFromAsideHavePARprice"] = true
            metadata["sharesFromTradeInHavePARprice"] = true
            
            metadata["unitShareValuePayoutRoundPolicy"] = PayoutRoundPolicy.doNotRound
            metadata["isPayoutRoundedUpOnTotalValue"] = true
            metadata["buySellRoundPolicyOnTotal"] = BuySellRoundPolicy.roundUp
            
            metadata["isGenerateTrashHidden"] = true
            
            metadata["privatesBuyInModifiers"] = ["0.5x", "1.0x", "2.0x"]
            metadata["privatesLabels"] = ["Schuylkill", "Pittsburgh", "Champlain", "C&O", "Potomac", "Delaware", "Mohawk", "James", "Camden", "Baltimore"] as [String]
            metadata["privatesPrices"] = [20, 30, 40, 50, 60, 70, 110, 120, 160, 220] as [Double]
            metadata["privatesIncomes"] = [5, 5, 10, 10, 10, 15, 20, 20, 25, 30] as [Double]
            metadata["privatesMayBeBuyInFlags"] = [true, true, true, true, true, true, true, true, true, false] as [Bool]
            metadata["privatesDescriptions"] = ["No effect",
                                                "A railroad owning the PL may lay a tile on any Ohio river hex with no terrain cost (J-2, J-4, K-5, J-6, J-8), or I-9. This hex need not be connected to one of the railroad’s stations, and it need not be connect to any track at all. This free tile placement may be performed in addition to the railroad’s normal tile placement—on that turn only it may play two tiles",
                                                "A railroad owning the CL may lay a tile on the CL’s hex (B-20). This hex need not be connected to one of the railroad’s stations, and it need not be connected to any track at all. This tile placement may be performed in addition to the raillroad’s normal tile placement—on that turn only it may play two tiles",
                                                "A railroad owning the CC may build on the hexes marked as containing the CC (K9, K11) for a terrain cost of only $20 each. The company is closed when tiles have been laid on both hexes",
                                                "A railroad owning the PP receives a free (New River) coal field license which can not be sold or traded (see p. 35 for license effects). When the owning railroad first runs a route including the New River coal field hex, the PP is closed down. The owner still retains the license after the PP closes",
                                                "A railroad owning the DH may lay a track tile and a station token on the DH’s hex (F-16). The mountain costs $120 as usual, but laying the token is free. This hex need not be connected to one of the railroad’s stations, and it need not be connect to any track at all. The tile layed does count as the owning railroad’s one tile placement for his turn. If the DH does not lay a station token on the turn it lays the tile on its starting hex, it must follow the normal rules when placing a station (i.e., it must have a legal train route to the hex). Other railroads may lay a tile on the DH starting hex subject to the ordinary rules, after which the DH special effects are no longer available",
                                                "A player owning the MH may exchange it for a 10% share of NYC, provided he does not already hold 60% of the NYC shares and there is NYC shares available in the bank or the pool. The exchange may be made during the player’s turn of a stock round or between the turns of other players or railroads in either stock or operating rounds. This action closes the MH",
                                                "The initial purchaser of the JK receives a free Kanawha license which can not be sold or traded (see p. 35 for license effects). The railroad has the right to build on any one (1) hex that is adjacent to the Kanawha Coal River hex at half price. This would constitute the railroad’s regular tile lay and close the company. The owner retains the license after the JK closes",
                                                "The initial purchaser of the CA immediately receives a 10% share of PRR without further payment. This action does not close the CA. The PRR railroad will not be running at this point, but the share may be retained or sold subject to the ordinary rules of the game",
                                                "The owner of the BO private company immediately receives the president’s certificate of the B&O railroad without further payment and immediately sets a par share value. The BO private company may not be sold to any corporation, and does not change hands if the owning player loses the presidency of the B&O. When the B&O railroad purchases its first train this private company is closed down. No buy-in"] as [String]
            metadata["privatesMayBeVoluntarilyClosedFlags"] = [false, false, false, true, true, false, true, true, false, true]
            metadata["privatesOwnerGlobalIndexes"] = Array(repeating: BankIndex.bank.rawValue, count: 10)
            metadata["privatesLockMoneyIfOutbidden"] = true
            
            metadata["legalActionsPlayers"] = [Int]([ActionMenuType.turnOrder.rawValue, ActionMenuType.sellPrivate.rawValue, ActionMenuType.buyShares.rawValue, ActionMenuType.sellShares.rawValue])
            metadata["legalActionsCompanies"] = [Int]([ActionMenuType.buyPrivate.rawValue, ActionMenuType.float.rawValue, ActionMenuType.buyTrain.rawValue, ActionMenuType.tilesTokens.rawValue, ActionMenuType.operate.rawValue])
            
        case .g1840:
            metadata["gameSpecificPlayerTurnOrderType"] = PlayerTurnOrderType.mostCashAmount
            metadata["roundOperationTypes"] = [] // custom
            metadata["roundOperationTypeColors"] = [UIColor.white, UIColor.black, UIColor.yellowORColor, UIColor.yellowORColor, UIColor.black, UIColor.white, UIColor.greenORColor, UIColor.greenORColor, UIColor.black, UIColor.white, UIColor.greenORColor, UIColor.greenORColor, UIColor.black, UIColor.white, UIColor.brownORColor, UIColor.brownORColor, UIColor.black, UIColor.white, UIColor.grayORColor, UIColor.grayORColor, UIColor.grayORColor, UIColor.black]
            metadata["roundOperationTypeTextColors"] = [UIColor.black, UIColor.white, UIColor.black, UIColor.black, UIColor.white, UIColor.black, UIColor.black, UIColor.black, UIColor.white, UIColor.black, UIColor.black, UIColor.black, UIColor.white, UIColor.black, UIColor.black, UIColor.black, UIColor.white, UIColor.black, UIColor.black, UIColor.black, UIColor.black, UIColor.white]
            
            metadata["companies"] = ["BBG", "DTK&C", "GWStStB", "SJE", "WKB", "WT", "D", "G", "V", "W"]
            metadata["floatModifiers"] = Array(repeating: 0, count: 10)
            metadata["companiesTypes"] = Array(repeating: CompanyType.standard, count: 6) + Array(repeating: CompanyType.g1840Stadtbahn, count: 4)
            metadata["compTotShares"] = Array(repeating: 10.0, count: 10)
            metadata["predefinedShareAmounts"] = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0]
            metadata["printShareAmountsAsInt"] = true
            metadata["shareStartingLocation"] = ShareStartingLocation.bank
            metadata["compLogos"] = ["BBG_40", "DTKC_40", "GWStStB_40", "SJE_40", "WKB_40", "WT_40", "D_40", "G_40", "V_40", "W_40"]
            metadata["compColors"] = [
                UIColor.fromHex("FFE600"),
                UIColor.fromHex("B14183"),
                UIColor.fromHex("C82025"),
                UIColor.fromHex("444890"),
                UIColor.fromHex("009739"),
                UIColor.fromHex("000000"),
                
                UIColor.fromHex("FECC00"),
                UIColor.fromHex("EF7F1A"),
                UIColor.fromHex("D7B56D"),
                UIColor.fromHex("A75F4A"),
            ]
            metadata["compTextColors"] = [UIColor.black] + Array(repeating: UIColor.white, count: 5) + [UIColor.black, UIColor.white, UIColor.black, UIColor.white]
            metadata["totalBankAmount"] = [40000] as [Double]
            metadata["playersStartingMoney"] = [350, 300, 260, 230, 200] as [Double]
            metadata["openCompanyValues"] = [350, 400, 450, 500]
            metadata["gamePARValues"] = [70, 80, 90, 100]
            metadata["PARValueIsIrrelevantToShow"] = true
            metadata["requiredNumberOfSharesToFloat"] = 5
            metadata["tileTokensPriceSuggestions"] = [20, 40, 60]
            metadata["trainPriceValues"] = [100, 200, 300, 400, 500, 600, 800]
            metadata["trainPriceIndexToCloseAllPrivates"] = 3
            metadata["certificateLimit"] = [18, 16, 14, 13, 12] as [Double]
            metadata["shareValues"] = [[100, 90, 80, 70, 60],
                                       [105, 95, 85, 75, 65],
                                       [110, 100, 90, 80, 70],
                                       [115, 105, 95, 85, 75],
                                       [121, 111, 101, 91, 81],
                                       [128, 118, 108, 98, nil],
                                       [136, 126, 116, 106, nil],
                                       [145, 135, 125, 115, nil],
                                       [155, 145, 135, 125, nil],
                                       [167, 157, 147, 137, nil],
                                       [180, 170, 160, nil, nil],
                                       [195, 185, 175, nil, nil],
                                       [210, 200, 190, nil, nil],
                                       [230, 220, 210, nil, nil],
                                       [250, 240, 230, nil, nil],
                                       [275, 265, nil, nil, nil],
                                       [300, 290, nil, nil, nil],
                                       [330, 320, nil, nil, nil],
                                       [360, 350, nil, nil, nil],
                                       [400, 380, nil, nil, nil]] as [[Double?]]
            metadata["currencyType"] = CurrencyType.none
            
            metadata["ipoSharesPayBank"] = true
            metadata["bankSharesPayBank"] = true
            metadata["compSharesPayBank"] = true
            metadata["asideSharesPayBank"] = true
            metadata["tradeInSharesPayBank"] = true
            
            metadata["buyShareFromIPOPayBank"] = true
            metadata["buyShareFromBankPayBank"] = true
            metadata["buyShareFromCompPayBank"] = true
            
            metadata["sharesFromIPOHavePARprice"] = false
            metadata["sharesFromBankHavePARprice"] = false
            metadata["sharesFromCompHavePARprice"] = false
            metadata["sharesFromAsideHavePARprice"] = false
            metadata["sharesFromTradeInHavePARprice"] = false
            
            metadata["unitShareValuePayoutRoundPolicy"] = PayoutRoundPolicy.doNotRound
            metadata["isPayoutRoundedUpOnTotalValue"] = true
            metadata["buySellRoundPolicyOnTotal"] = BuySellRoundPolicy.roundUp
            
            metadata["isGenerateTrashHidden"] = true
            
            metadata["privatesBuyInModifiers"] = ["1", "1.0x"]
            metadata["privatesLabels"] = ["Prater", "Karlskirche", "Belvedere", "Hofburg", "Stephansdom", "Schonbrunn"] as [String]
            metadata["privatesPrices"] = [10, 20, 30, 40, 50, 60] as [Double]
            metadata["privatesIncomes"] = [5, 10, 15, 20, 25, 30] as [Double]
            metadata["privatesMayBeBuyInFlags"] = [true, true, true, true, true, true] as [Bool]
            metadata["privatesDescriptions"] = ["landmark D28:\nThe revenue of a tram route is increased by 20 Gulden if it runs to or through the halt of a Private Company owned by its Tram Company",
                                                "landmark E21:\nThe revenue of a tram route is increased by 20 Gulden if it runs to or through the halt of a Private Company owned by its Tram Company",
                                                "landmark H22:\nThe revenue of a tram route is increased by 20 Gulden if it runs to or through the halt of a Private Company owned by its Tram Company",
                                                "landmark E19:\nThe revenue of a tram route is increased by 20 Gulden if it runs to or through the halt of a Private Company owned by its Tram Company",
                                                "landmark D20:\nThe revenue of a tram route is increased by 20 Gulden if it runs to or through the halt of a Private Company owned by its Tram Company",
                                                "landmark K7:\nThe revenue of a tram route is increased by 20 Gulden if it runs to or through the halt of a Private Company owned by its Tram Company"] as [String]
            metadata["privatesMayBeVoluntarilyClosedFlags"] = Array(repeating: true, count: 6)
            metadata["privatesOwnerGlobalIndexes"] = Array(repeating: BankIndex.bank.rawValue, count: 6)
            metadata["privatesLockMoneyIfOutbidden"] = false
            
            metadata["legalActionsPlayers"] = [Int]([ActionMenuType.turnOrder.rawValue, ActionMenuType.sellPrivate.rawValue, ActionMenuType.buyShares.rawValue, ActionMenuType.sellShares.rawValue, ActionMenuType.loans.rawValue])
            metadata["legalActionsCompanies"] = [Int]([ActionMenuType.buyPrivate.rawValue, ActionMenuType.float.rawValue, ActionMenuType.buyTrain.rawValue, ActionMenuType.tilesTokens.rawValue, ActionMenuType.operate.rawValue])
            
        case .g1846:
            metadata["gameSpecificPlayerTurnOrderType"] = PlayerTurnOrderType.classic
            metadata["roundOperationTypes"] = [OperationType.greenOR, OperationType.yellowOR, OperationType.SR]
            metadata["roundOperationTypeColors"] = [UIColor.greenORColor, UIColor.yellowORColor, UIColor.white]
            metadata["roundOperationTypeTextColors"] = [UIColor.white, UIColor.black, UIColor.black]
            
            metadata["companies"] = ["B&O", "C&O", "ERIE", "GTR", "IC", "NYC", "PRR", "Big 4", "MS"]
            metadata["floatModifiers"] = Array(repeating: 0, count: 9)
            metadata["companiesTypes"] = Array(repeating: CompanyType.standard, count: 7) + Array(repeating: CompanyType.g1846Miniature, count: 2)
            metadata["compTotShares"] = Array(repeating: 10.0, count: 7) + Array(repeating: 2.0, count: 2)
            metadata["predefinedShareAmounts"] = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0]
            metadata["printShareAmountsAsInt"] = true
            metadata["shareStartingLocation"] = ShareStartingLocation.company
            metadata["compLogos"] = ["B&O_46", "C&O_46", "ERIE_46", "GTR_46", "IC_46", "NYC_46", "PRR_46", "Big 4_46", "MS_46"]
            metadata["compColors"] = [
                UIColor.fromHex("00548F"),
                UIColor.fromHex("AEDBEB"),
                UIColor.fromHex("FDEE67"),
                UIColor.fromHex("F58121"),
                UIColor.fromHex("637F2A"),
                UIColor.fromHex("000000"),
                UIColor.fromHex("DD3027"),
                
                UIColor.fromHex("242B35"),
                UIColor.fromHex("242B35")
            ]
            metadata["compTextColors"] = Array(repeating: UIColor.white, count: 1) + Array(repeating: UIColor.black, count: 2) + Array(repeating: UIColor.white, count: 6)
            metadata["totalBankAmount"] = [0, 6500, 7500, 9000, 0] as [Double]
            metadata["playersStartingMoney"] = [0, 400, 400, 400, 0] as [Double]
            metadata["openCompanyValues"] = [80, 100, 120, 140, 160, 180, 200, 224, 248, 274, 300]
            metadata["gamePARValues"] = [40, 50, 60, 70, 80, 90, 100, 112, 124, 137, 150]
            metadata["PARValueIsIrrelevantToShow"] = true
            metadata["requiredNumberOfSharesToFloat"] = 2
            metadata["tileTokensPriceSuggestions"] = [20, 40, 60]
            metadata["trainPriceValues"] = [80, 160, 450, 800]
            metadata["trainPriceIndexToCloseAllPrivates"] = 2
            metadata["certificateLimit"] = [0, 14, 12, 11, 0] as [Double]
            metadata["shareValues"] = [[0],
                                       [10],
                                       [20],
                                       [30],
                                       [40],
                                       [50],
                                       [60],
                                       [70],
                                       [80],
                                       [90],
                                       [100],
                                       [112],
                                       [124],
                                       [137],
                                       [150],
                                       [165],
                                       [180],
                                       [195],
                                       [212],
                                       [230],
                                       [250],
                                       [270],
                                       [295],
                                       [320],
                                       [345],
                                       [375],
                                       [405],
                                       [440],
                                       [475],
                                       [510],
                                       [550]] as [[Double?]]
            metadata["currencyType"] = CurrencyType.dollar
            
            metadata["ipoSharesPayBank"] = true
            metadata["bankSharesPayBank"] = true
            metadata["compSharesPayBank"] = false
            metadata["asideSharesPayBank"] = true
            metadata["tradeInSharesPayBank"] = true
            
            metadata["buyShareFromIPOPayBank"] = true
            metadata["buyShareFromBankPayBank"] = true
            metadata["buyShareFromCompPayBank"] = false
            
            metadata["sharesFromIPOHavePARprice"] = false
            metadata["sharesFromBankHavePARprice"] = false
            metadata["sharesFromCompHavePARprice"] = false
            metadata["sharesFromAsideHavePARprice"] = false
            metadata["sharesFromTradeInHavePARprice"] = false
            
            metadata["unitShareValuePayoutRoundPolicy"] = PayoutRoundPolicy.doNotRound
            metadata["isPayoutRoundedUpOnTotalValue"] = true
            metadata["buySellRoundPolicyOnTotal"] = BuySellRoundPolicy.roundUp
            
            metadata["isGenerateTrashHidden"] = true
            
            metadata["privatesBuyInModifiers"] = ["1", "1.0x"]
            metadata["privatesLabels"] = ["Lake Shore Line",
                                          "Little Miami",
                                          "Michigan Central",
                                          "Ohio & Indiana",
                                          "Boomtown",
                                          "Steamboat Co.",
                                          "Meat Packing Co.",
                                          "Tunnel Blasting Co.",
                                          "C&W Indiana",
                                          "Mail Contract",
                                          "Big 4",
                                          "Michigan Southern"] as [String]
            metadata["privatesPrices"] = [40, 40, 40, 40, 40, 40, 60, 60, 60, 80, 100, 140] as [Double]
            metadata["privatesIncomes"] = [15, 15, 15, 15, 10, 10, 15, 20, 10, 0, 0, 0] as [Double]
            metadata["privatesMayBeBuyInFlags"] = [true, true, true, true, true, true, true, true, true, true, true, true] as [Bool]
            metadata["privatesDescriptions"] = ["The owning corporation may make an extra $0 cost tile upgrade of either Cleveland (E17) or Toledo (D14), but not both. This company’s ability may be used once and not until green tiles are available.",
                                                "If no track exists from Cincinnati (H12) to Dayton (G13), the owning corporation may lay/upgrade one extra $0 cost tile in each of these hexes that adds connecting track. If using this ability would complete a bridge connection to Cincinnati, the owning corporation must pay $40 to do so.",
                                                "The owning corporation may lay up to two extra $0 cost yellow tiles in the MC's reserved hexes (B10, B12). If the owning corporation lays both tiles in its reserved hexes, then these tiles must connect to each other. Other corporations may not lay tiles in these hexes until these companies have been bought by a corporation or removed.",
                                                "The owning corporation may lay up to two extra $0 cost yellow tiles in the O&I's reserved hexes (F14, F16). If the owning corporation lays both tiles in its reserved hexes, then these tiles must connect to each other. Other corporations may not lay tiles in these hexes until these companies have been bought by a corporation or removed.",
                                                "The owning corporation may place a $20 token in Cincinnati (H12), to add $20 to all of its routes run to this location. Upon being purchased or before running routes, the corporation owning each of these companies may place—or shift with the Steamboat Company—a marker among the listed locations, adding its value to the corporation’s routes that count this location. Use the second marker for the corporation after removing the company in phase III (before these markers are removed in phase IV).",
                                                "Place or shift the port marker among port locations (B8, C5, D14, G19, I1). Add $20 per port symbol to all routes run to this location by the owning (or assigned) company. Upon being purchased or before running routes, the corporation owning each of these companies may place—or shift with the Steamboat Company—a marker among the listed locations, adding its value to the corporation’s routes that count this location. Use the second marker for the corporation after removing the company in phase III (before these markers are removed in phase IV). Before the Steamboat Company is purchased by a corporation, its owner can assign its marker during the private income step to a corporation or Independent Railroad, using its second marker to indicate this. Remove both markers once it is purchased or removed. NOTES: The Steamboat marker for the board has two sides: one side shows a $40 value for when it is placed in Holland or Wheeling. In the round in which it is purchased, two corporations could each benefit from the Steamboat Company’s marker.",
                                                "The owning corporation may place a $30 marker in either St. Louis (11) or Chicago (D6), to add $30 to all routes run to this location. Upon being purchased or before running routes, the corporation owning each of these companies may place—or shift with the Steamboat Company—a marker among the listed locations, adding its value to the corporation’s routes that count this location. Use the second marker for the corporation after removing the company in phase III (before these markers are removed in phase IV).",
                                                "Reduces, for the owning corporation, the cost of laying all mountain tiles and tunnel/pass hexsides by $20. A tunnel or pass hexside cost, such as between Wheeling and Pittsburgh, could be reduced to $0.",
                                                "Reserves a token slot in Chicago (D6), in which the owning corporation may place an extra token at no cost. This company’s ability may not be used if its owning corporation already has a token in Chicago. No token may be placed in the C&WI’s spot until the C&WI is either purchased or removed.",
                                                "Adds $10 per location visited by any one train of the owning corporation. Never closes once purchased by a corporation. An “N / M” train can visit more locations than it counts for revenue. Such locations do generate money for the Mail Contract’s bonus.",
                                                "Starts with $40 in treasury, a 2 train, and a token in Indianapolis (G9). Splits revenue evenly with owner. These companies each act as “miniature” corporations, laying tiles and running routes during each Operating Round, splitting their revenue evenly with their owners and their treasuries. Put their treasury money under their train certificate. They may not buy trains. When it is purchased, put its train and treasury in the corporation’s treasury and replace its token with an extra one. A corporation purchasing an Independent Railroad must not be at the train limit; may not pay its owner more than its list price (do not include debt); and cannot run a route with the Independent Railroad’s train that round.",
                                                "Starts with $60 in treasury, a 2 train, and a token in Detroit (C15). Splits revenue evenly with owner. These companies each act as “miniature” corporations, laying tiles and running routes during each Operating Round, splitting their revenue evenly with their owners and their treasuries. Put their treasury money under their train certificate. They may not buy trains. When it is purchased, put its train and treasury in the corporation’s treasury and replace its token with an extra one. A corporation purchasing an Independent Railroad must not be at the train limit; may not pay its owner more than its list price (do not include debt); and cannot run a route with the Independent Railroad’s train that round."] as [String]
            metadata["privatesMayBeVoluntarilyClosedFlags"] = [false, false, false, false, false, false, false, false, false, false, false, false]
            metadata["privatesOwnerGlobalIndexes"] = Array(repeating: BankIndex.bank.rawValue, count: 12)
            metadata["privatesLockMoneyIfOutbidden"] = false
            
            metadata["legalActionsPlayers"] = [Int]([ActionMenuType.turnOrder.rawValue, ActionMenuType.sellPrivate.rawValue, ActionMenuType.buyShares.rawValue, ActionMenuType.sellShares.rawValue])
            metadata["legalActionsCompanies"] = [Int]([ActionMenuType.buyPrivate.rawValue, ActionMenuType.float.rawValue, ActionMenuType.buyTrain.rawValue, ActionMenuType.tilesTokens.rawValue, ActionMenuType.operate.rawValue, ActionMenuType.g1846issueShares.rawValue, ActionMenuType.g1846redeemShares.rawValue] + [ActionMenuType.close.rawValue])
            
        case .g1848:
            metadata["gameSpecificPlayerTurnOrderType"] = PlayerTurnOrderType.classic
            metadata["roundOperationTypes"] = [OperationType.brownOR, OperationType.greenOR, OperationType.yellowOR, OperationType.SR]
            metadata["roundOperationTypeColors"] = [UIColor.brownORColor, UIColor.greenORColor, UIColor.yellowORColor, UIColor.white]
            metadata["roundOperationTypeTextColors"] = [UIColor.white, UIColor.white, UIColor.black, UIColor.black]
            
            metadata["companies"] = ["BoE", "CAR", "COM", "FT", "NSW", "QR", "SAR", "VR", "WA"]
            metadata["floatModifiers"] = Array(repeating: 0, count: 9)
            metadata["companiesTypes"] = [CompanyType.g1848BoE] + Array(repeating: CompanyType.standard, count: 8)
            metadata["compTotShares"] = Array(repeating: 10.0, count: 9)
            metadata["predefinedShareAmounts"] = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0]
            metadata["printShareAmountsAsInt"] = true
            metadata["shareStartingLocation"] = ShareStartingLocation.ipo
            metadata["compLogos"] = ["BOE_48", "CAR_48", "COM_48", "FT_48", "NSW_48", "QR_48", "SAR_48", "VR_48", "WA_48"]
            metadata["compColors"] = [
                UIColor.fromHex("F8EBD9"),
                UIColor.fromHex("000000"),
                UIColor.fromHex("CFC5A2"),
                UIColor.fromHex("55C3EC"),
                UIColor.fromHex("FF9027"),
                
                UIColor.fromHex("399C42"),
                UIColor.fromHex("9E2A97"),
                UIColor.fromHex("FFE600"),
                UIColor.fromHex("EE332A"),
            ]
            metadata["compTextColors"] = [UIColor.black, UIColor.white, UIColor.black] + Array(repeating: UIColor.white, count: 4) + [UIColor.black, UIColor.white]
            metadata["totalBankAmount"] = [12000] as [Double]
            metadata["playersStartingMoney"] = [0, 840, 630, 510, 430] as [Double]
            metadata["openCompanyValues"] = [420, 480, 540, 600]
            metadata["gamePARValues"] = [70, 80, 90, 100]
            metadata["PARValueIsIrrelevantToShow"] = false
            metadata["requiredNumberOfSharesToFloat"] = 6
            metadata["tileTokensPriceSuggestions"] = [40, 50, 60]
            metadata["trainPriceValues"] = [100, 200, 300, 500, 600, 800]
            metadata["trainPriceIndexToCloseAllPrivates"] = 3
            metadata["certificateLimit"] = [0, 20, 17, 14, 12] as [Double]
            metadata["shareValues"] = [[0, 0, 0, 0, 0, 0],
                                       [70, 60, 50, 40, 30, 20],
                                       [80, 70, 60, 50, 40, 30],
                                       [90, 80, 70, 60, 50, 40],
                                       [100, 90, 80, 70, 60, 50],
                                       [110, 100, 90, 80, 70, 60],
                                       [120, 110, 100, 90, 80, 70],
                                       [140, 130, 120, 110, 100, nil],
                                       [160, 150, 140, 130, 120, nil],
                                       [190, 180, 170, 160, nil, nil],
                                       [220, 210, 200, 190, nil, nil],
                                       [250, 240, 230, nil, nil, nil],
                                       [280, 270, 260, nil, nil, nil],
                                       [320, 310, 300, nil, nil, nil],
                                       [360, 350, nil, nil, nil, nil],
                                       [400, 390, nil, nil, nil, nil],
                                       [450, 440, nil, nil, nil, nil]] as [[Double?]]
            metadata["currencyType"] = CurrencyType.pound
            
            metadata["ipoSharesPayBank"] = true
            metadata["bankSharesPayBank"] = true
            metadata["compSharesPayBank"] = true
            metadata["asideSharesPayBank"] = true
            metadata["tradeInSharesPayBank"] = true
            
            metadata["buyShareFromIPOPayBank"] = true
            metadata["buyShareFromBankPayBank"] = true
            metadata["buyShareFromCompPayBank"] = true
            
            metadata["sharesFromIPOHavePARprice"] = true
            metadata["sharesFromBankHavePARprice"] = false
            metadata["sharesFromCompHavePARprice"] = true
            metadata["sharesFromAsideHavePARprice"] = true
            metadata["sharesFromTradeInHavePARprice"] = true
            
            metadata["unitShareValuePayoutRoundPolicy"] = PayoutRoundPolicy.doNotRound
            metadata["isPayoutRoundedUpOnTotalValue"] = true
            metadata["buySellRoundPolicyOnTotal"] = BuySellRoundPolicy.roundUp
            
            metadata["isGenerateTrashHidden"] = true
            
            metadata["privatesBuyInModifiers"] = ["1", "1.0x", "any"]
            metadata["privatesLabels"] = (1...6).map { "P\($0)" } as [String]
            metadata["privatesPrices"] = [30, 70, 110, 170, 170, 230] as [Double]
            metadata["privatesIncomes"] = [5, 10, 15, 20, 25, 30] as [Double]
            metadata["privatesMayBeBuyInFlags"] = [true, true, true, true, false, false] as [Bool]
            metadata["privatesDescriptions"] = ["No special powers",
                                                "If the company is owned by a Public Company or its Director, that company can, on one occasion, place a yellow tile in a desert hex for free instead of paying the £40 terrain cost.\nIf at the time of the sale of the first 5/5+ train the company is still owned by a player, that player retains the right to the rebate and can use it at a time of his choosing for a company of which he is the Director.\nIf at the time of the sale of the first 5/5+ train the company is owned by a Public Company, that company retains the right to the rebate",
                                                "The owner receives the blue Tasmania tile.\nThe Tasmania tile can be placed by a Public Company on one of the dark blue hexes. This is in addition to the company’s normal build that turn.\nTasmania counts against a train’s range.\nIf the 5/5+ train is bought, the Tasmania tile must immediately be placed on one of the two earmarked dark blue hexes. If the Private Company is owned by a player at this point, the player places the tile. If the Private Company is owned by a Public Company at this point, the Director places the tile",
                                                "The owner has a one-time rebate on the purchase of a 2E train, “The Ghan”.\nIf at the time of the sale of the first 5/5+ train the company is still owned by a player, that player retains the right to the rebate and can use it at a time of his choosing for a company of which he is the Director.\nIf at the time of the sale of the first 5/5+ train the company is owned by a Public Company, that company retains the right to the rebate",
                                                "The owner receives in addition a 10% share in the QR. No buy-in",
                                                "The owner receives the Director’s Share in the CAR, which starts with a share price of £100. Closed when the CAR buys a train or with the sale of the first 5/5+ train. No buy-in"] as [String]
            metadata["privatesMayBeVoluntarilyClosedFlags"] = Array(repeating: false, count: 5) + [true]
            metadata["privatesOwnerGlobalIndexes"] = Array(repeating: BankIndex.bank.rawValue, count: 6)
            metadata["privatesLockMoneyIfOutbidden"] = false
            
            metadata["legalActionsPlayers"] = [Int]([ActionMenuType.turnOrder.rawValue, ActionMenuType.sellPrivate.rawValue, ActionMenuType.buyShares.rawValue, ActionMenuType.sellShares.rawValue])
            metadata["legalActionsCompanies"] = [Int]([ActionMenuType.buyPrivate.rawValue, ActionMenuType.float.rawValue, ActionMenuType.buyTrain.rawValue, ActionMenuType.tilesTokens.rawValue, ActionMenuType.loans.rawValue, ActionMenuType.operate.rawValue] + [ActionMenuType.close.rawValue])
            
        case .g1849:
            metadata["gameSpecificPlayerTurnOrderType"] = PlayerTurnOrderType.classic
            metadata["roundOperationTypes"] = [OperationType.brownOR, OperationType.greenOR, OperationType.yellowOR, OperationType.SR]
            metadata["roundOperationTypeColors"] = [UIColor.brownORColor, UIColor.greenORColor, UIColor.yellowORColor, UIColor.white]
            metadata["roundOperationTypeTextColors"] = [UIColor.white, UIColor.white, UIColor.black, UIColor.black]
            
            metadata["companies"] = ["AFG", "ATA", "CTL", "IFT", "RCS", "SFA"]
            metadata["floatModifiers"] = [-40, -30, -40, -90, -130, -40]
            metadata["companiesTypes"] = Array(repeating: CompanyType.standard, count: 6)
            metadata["compTotShares"] = Array(repeating: 10.0, count: 6)
            metadata["predefinedShareAmounts"] = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0]
            metadata["printShareAmountsAsInt"] = true
            metadata["shareStartingLocation"] = ShareStartingLocation.company
            metadata["compLogos"] = ["AFG_49", "ATA_49", "CTL_49", "IFT_49", "RCS_49", "SFA_49"]
            metadata["compColors"] = [
                UIColor.fromHex("BC3334"),
                UIColor.fromHex("357720"),
                UIColor.fromHex("F1E530"),
                UIColor.fromHex("2A4894"),
                UIColor.fromHex("E58350"),
                UIColor.fromHex("D9337E"),
            ]
            metadata["compTextColors"] = Array(repeating: UIColor.white, count: 2) + Array(repeating: UIColor.black, count: 1) + Array(repeating: UIColor.white, count: 3)
            metadata["totalBankAmount"] = [7760] as [Double]
            metadata["playersStartingMoney"] = [0, 500, 375, 300, 0] as [Double]
            metadata["openCompanyValues"] = [136, 200, 288, 432]
            metadata["gamePARValues"] = [68, 100, 144, 216]
            metadata["PARValueIsIrrelevantToShow"] = true
            metadata["requiredNumberOfSharesToFloat"] = 2
            metadata["tileTokensPriceSuggestions"] = [20, 40, 80]
            metadata["trainPriceValues"] = [100, 200, 350, 550, 800, 1100, 350]
            metadata["trainPriceIndexToCloseAllPrivates"] = 4
            metadata["certificateLimit"] = [0, 12, 11, 9, 0] as [Double]
            metadata["shareValues"] = [[72, 63, 57, 54, 52, 47, 41, 34, 27, 0],
                                       [83, 72, 66, 62, 59, 54, 47, 39, 31, 24],
                                       [95, 82, 73, 71, 68, 62, 54, 45, 36, 27],
                                       [107, 93, 84, 80, 77, 70, 61, 50, 40, 31],
                                       [120, 104, 95, 90, 86, 78, 68, 57, 45, nil],
                                       [133, 116, 105, 100, 95, 87, 75, 63, 50, nil],
                                       [147, 128, 117, 111, 106, 96, 84, 70, 56, nil],
                                       [164, 142, 129, 123, 117, 107, 93, 77, nil, nil],
                                       [182, 158, 144, 137, 130, 118, 103, 86, nil, nil],
                                       [202, 175, 159, 152, 145, 131, 114, 95, nil, nil],
                                       [224, 195, 177, 169, 160, 146, 127, nil, nil, nil],
                                       [248, 216, 196, 187, 178, 162, nil, nil, nil, nil],
                                       [276, 240, 218, 208, 198, nil, nil, nil, nil, nil],
                                       [306, 266, 242, 230, nil, nil, nil, nil, nil, nil],
                                       [340, 295, 269, nil, nil, nil, nil, nil, nil, nil],
                                       [377, 328, 298, nil, nil, nil, nil, nil, nil, nil]] as [[Double?]]
            metadata["currencyType"] = CurrencyType.lira
            
            metadata["ipoSharesPayBank"] = true
            metadata["bankSharesPayBank"] = true
            metadata["compSharesPayBank"] = false
            metadata["asideSharesPayBank"] = true
            metadata["tradeInSharesPayBank"] = true
            
            metadata["buyShareFromIPOPayBank"] = true
            metadata["buyShareFromBankPayBank"] = true
            metadata["buyShareFromCompPayBank"] = false
            
            metadata["sharesFromIPOHavePARprice"] = true
            metadata["sharesFromBankHavePARprice"] = false
            metadata["sharesFromCompHavePARprice"] = false
            metadata["sharesFromAsideHavePARprice"] = true
            metadata["sharesFromTradeInHavePARprice"] = true
            
            metadata["unitShareValuePayoutRoundPolicy"] = PayoutRoundPolicy.doNotRound
            metadata["isPayoutRoundedUpOnTotalValue"] = true
            metadata["buySellRoundPolicyOnTotal"] = BuySellRoundPolicy.roundUp
            
            metadata["isGenerateTrashHidden"] = true
            
            metadata["privatesBuyInModifiers"] = ["1", "1.0x", "2.0x"]
            metadata["privatesLabels"] = (1...5).map { "P\($0)" } as [String]
            metadata["privatesPrices"] = [20, 45, 75, 110, 150] as [Double]
            metadata["privatesIncomes"] = [5, 10, 15, 20, 25] as [Double]
            metadata["privatesMayBeBuyInFlags"] = [true, true, true, true, false, false] as [Bool]
            metadata["privatesDescriptions"] = ["No corporation may build track in the Acireale hex (G13) until this company is either closed or bought by a corporation",
                                                "During its operating turn, the owning corporation can lay or upgrade standard gauge track at half cost on mountain, hill or rough hexes. Narrow gauge track is still at normal cost",
                                                "During its operating turn, the owning corporation may close this private company to place the +L. 20 token on any port. The corporation that placed the token adds L. 20 to the revenue of the port until the end of the game. A second +L. 20 token is provided to mark this bonus on the owning corporation’s charter after the company is closed",
                                                "During its operating turn, the owning corporation may close this private company in lieu of performing both its tile and token placement steps. Performing this action allows the corporation to select any coastal city hex (all cities except Caltanisetta and Ragusa), optionally lay or upgrade a tile there, and optionally place a station token there. This power may be used even if the corporation is unable to trace a route to that city, but all other normal tile placement and station token placement rules apply",
                                                "This private comes with the president’s certificate of the first corporation in the order determined in setup.\nWhen a player buys P5 Reale Società d’Affari, they then:\n1. Take the first available president’s certificate (the one with the ‘1’ place card) along with the corporation charter and the five tokens.\n2. Set the initial market value of the new corporation at either L. 68 or L. 100 by placing a token on the appropriate space of the stock market.\n3. Place one token near the revenue tracker for use later.\n4. Take the initial treasury of the corporation from the bank; this is equivalent to the value of the president’s certificate (either L. 136 or L. 200), minus the station token fee. The fee is indicated on the corporation’s charter and in section 7.2.\n5. Place one token as a station token on the appropriate home city.\n6. Place the initial treasury and remaining station tokens on the charter.\nP5 Reale Società d’Affari closes when the associated corporation buys its first train. If the associated corporation closes before buying a train, the P5 Reale Società d’Affari remains open until all private companies are closed at the start of Phase 12. No buy-in"] as [String]
            metadata["privatesMayBeVoluntarilyClosedFlags"] = [false, false, true, true, true]
            metadata["privatesOwnerGlobalIndexes"] = Array(repeating: BankIndex.bank.rawValue, count: 5)
            metadata["privatesLockMoneyIfOutbidden"] = true
            
            metadata["legalActionsPlayers"] = [Int]([ActionMenuType.turnOrder.rawValue, ActionMenuType.sellPrivate.rawValue, ActionMenuType.buyShares.rawValue, ActionMenuType.sellShares.rawValue])
            metadata["legalActionsCompanies"] = [Int]([ActionMenuType.buyPrivate.rawValue, ActionMenuType.float.rawValue, ActionMenuType.buyTrain.rawValue, ActionMenuType.tilesTokens.rawValue, ActionMenuType.buyShares.rawValue, ActionMenuType.sellShares.rawValue, ActionMenuType.g1849Bond.rawValue, ActionMenuType.operate.rawValue] + [ActionMenuType.close.rawValue])
            
        case .g1856:
            metadata["gameSpecificPlayerTurnOrderType"] = PlayerTurnOrderType.classic
            metadata["roundOperationTypes"] = [OperationType.brownOR, OperationType.greenOR, OperationType.yellowOR, OperationType.SR]
            metadata["roundOperationTypeColors"] = [UIColor.brownORColor, UIColor.greenORColor, UIColor.yellowORColor, UIColor.white]
            metadata["roundOperationTypeTextColors"] = [UIColor.white, UIColor.white, UIColor.black, UIColor.black]
            
            metadata["companies"] = ["BBG", "CA", "CPR", "CV", "GT", "GW", "LPS", "TGB", "THB", "WGB", "WR", "CGR"]
            metadata["floatModifiers"] = Array(repeating: 0, count: 12)
            metadata["companiesTypes"] = Array(repeating: CompanyType.standard, count: 11) + [CompanyType.g1856CGR]
            metadata["compTotShares"] = Array(repeating: 10.0, count: 12)
            metadata["predefinedShareAmounts"] = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0]
            metadata["printShareAmountsAsInt"] = true
            metadata["shareStartingLocation"] = ShareStartingLocation.ipo
            metadata["compLogos"] = ["BBG_56", "CA_56", "CPR_56", "CV_56", "GT_56", "GW_56", "LPS_56", "TGB_56", "THB_56", "WGB_56", "WR_56", "CGR_56"]
            metadata["compColors"] = [
                UIColor.fromHex("FFA9E7"),
                UIColor.fromHex("C20114"),
                UIColor.fromHex("B07C9E"),
                UIColor.fromHex("7F055F"),
                
                UIColor.fromHex("9CDE9F"),
                UIColor.fromHex("C7AC92"),
                UIColor.fromHex("ACD7EC"),
                UIColor.fromHex("EB5E28"),
                
                UIColor.fromHex("D5B942"),
                UIColor.fromHex("083D77"),
                UIColor.fromHex("582630"),
                UIColor.fromHex("000000")
            ]
            metadata["compTextColors"] = [UIColor.black, UIColor.white, UIColor.white, UIColor.white, UIColor.black, UIColor.black, UIColor.black, UIColor.white, UIColor.black, UIColor.white, UIColor.white, UIColor.white]
            metadata["totalBankAmount"] = [12000] as [Double]
            metadata["playersStartingMoney"] = [0, 500, 375, 300, 250] as [Double]
            metadata["openCompanyValues"] = [130, 140, 150, 160, 180, 200]
            metadata["gamePARValues"] = [65, 70, 75, 80, 90, 100]
            metadata["PARValueIsIrrelevantToShow"] = false
            metadata["requiredNumberOfSharesToFloat"] = 2
            metadata["tileTokensPriceSuggestions"] = [40, 100]
            metadata["trainPriceValues"] = [100, 225, 350, 550, 700, 1100]
            metadata["trainPriceIndexToCloseAllPrivates"] = 3
            metadata["certificateLimit"] = [0, 20, 16, 13, 11] as [Double]
            metadata["shareValues"] = [[70, 65, 60, 55, 50, 45, 40, 35, 30, 0, 0],
                                       [75, 70, 65, 60, 55, 50, 45, 40, 35, 30, 0],
                                       [80, 75, 70, 65, 60, 55, 50, 45, 40, 35, 30],
                                       [90, 80, 75, 70, 65, 60, 55, 50, 45, 40, 35],
                                       [100, 90, 80, 75, 70, 65, 60, 55, 50, 45, 40],
                                       [110, 100, 90, 80, 75, 70, 65, 60, nil, nil, nil],
                                       [125, 110, 100, 90, 80, 75, 70, nil, nil, nil, nil],
                                       [150, 125, 110, 100, 90, 80, nil, nil, nil, nil, nil],
                                       [175, 150, 125, 110, 100, 90, nil, nil, nil, nil, nil],
                                       [200, 175, 150, 125, 110, nil, nil, nil, nil, nil, nil],
                                       [225, 200, 175, 150, 125, nil, nil, nil, nil, nil, nil],
                                       [250, 225, 200, 175, nil, nil, nil, nil, nil, nil, nil],
                                       [275, 250, 225, 200, nil, nil, nil, nil, nil, nil, nil],
                                       [300, 275, 250, nil, nil, nil, nil, nil, nil, nil, nil],
                                       [325, 300, 275, nil, nil, nil, nil, nil, nil, nil, nil],
                                       [350, 325, nil, nil, nil, nil, nil, nil, nil, nil, nil],
                                       [375, 350, nil, nil, nil, nil, nil, nil, nil, nil, nil],
                                       [400, 375, nil, nil, nil, nil, nil, nil, nil, nil, nil],
                                       [425, 400, nil, nil, nil, nil, nil, nil, nil, nil, nil],
                                       [450, 425, nil, nil, nil, nil, nil, nil, nil, nil, nil]] as [[Double?]]
            metadata["currencyType"] = CurrencyType.dollar
            
            metadata["ipoSharesPayBank"] = true
            metadata["bankSharesPayBank"] = false
            metadata["compSharesPayBank"] = true
            metadata["asideSharesPayBank"] = true
            metadata["tradeInSharesPayBank"] = true
            
            metadata["buyShareFromIPOPayBank"] = false
            metadata["buyShareFromBankPayBank"] = true
            metadata["buyShareFromCompPayBank"] = true
            
            metadata["sharesFromIPOHavePARprice"] = true
            metadata["sharesFromBankHavePARprice"] = false
            metadata["sharesFromCompHavePARprice"] = true
            metadata["sharesFromAsideHavePARprice"] = true
            metadata["sharesFromTradeInHavePARprice"] = true
            
            metadata["unitShareValuePayoutRoundPolicy"] = PayoutRoundPolicy.doNotRound
            metadata["isPayoutRoundedUpOnTotalValue"] = true
            metadata["buySellRoundPolicyOnTotal"] = BuySellRoundPolicy.roundUp
            
            metadata["isGenerateTrashHidden"] = true
            
            metadata["privatesBuyInModifiers"] = ["0.5x", "1.0x", "2.0x"]
            metadata["privatesLabels"] = ["Flos Tramway", "Waterloo", "Canada", "Great Lakes", "Niagara Falls", "St. Clair"] as [String]
            metadata["privatesPrices"] = [20, 40, 50, 70, 100, 100] as [Double]
            metadata["privatesIncomes"] = [5, 10, 10, 15, 20, 20] as [Double]
            metadata["privatesMayBeBuyInFlags"] = [true, true, true, true, true, true] as [Bool]
            metadata["privatesDescriptions"] = ["No other attributes",
                                                "The public company that owns this private company may place a free station marker on either city on the Kitchener hex if a space is available. The company may also place a green #59 tile in the Kitchener hex if it has not already been placed. Both actions are in the place of the public company's normal tile and/or station marker placement. The company need not be able to trace a legal train route to place the tile or station marker. The Waterloo & Saugeen Railway Co. is closed at the end of the operating round turn that the owning company performs either action",
                                                "During its operating round, the public company owning this private company may place a track tile in the hex occupied by this private company. This track lay is in addition to the public company's normal track lay. The company need not be able to trace a legal train route to place the tile. This action does not close the private company",
                                                "At any time during its operating round, the owning public company may place the port token in any one city adjacent to Lake Erie, Lake Huron, or Georgian Bay. These cities are marked with an anchor symbol. The port token raises the value of that city by $20 for only the owning company. Once placed, the port token may not be moved. This port token, if placed, is removed when the first type 6 train is purchased. Placement of this token closes the Great Lakes Shipping Company",
                                                "The public company that owns this private company may add the $10 bonus when running to Buffalo. Other public companies may purchase the right to use this bonus by paying $50 to the owning company. This right may not be purchased if this private company is owned by a player. The right may be purchased from the bank for $50 after the private company closes. Companies that have gained this right never lose it. The Canadian Government Railways gains this right if any of its forming companies had this right",
                                                "The public company that owns this private company may add the $10 Port Huron bonus when running to Sarnia. Other public companies may purchase the right to use this bonus by paying $50 to the owning company. This right may not be purchased if this private company is owned by a player. The right may be purchased from the bank for $50 after the private company closes. Companies that have gained this right never lose it. The Canadian Government Railways gains this right if any of its forming companies had this right"]
            metadata["privatesMayBeVoluntarilyClosedFlags"] = [false, true, false, true, false, false]
            metadata["privatesOwnerGlobalIndexes"] = Array(repeating: BankIndex.bank.rawValue, count: 6)
            metadata["privatesLockMoneyIfOutbidden"] = true
            
            metadata["legalActionsPlayers"] = [Int]([ActionMenuType.turnOrder.rawValue, ActionMenuType.sellPrivate.rawValue, ActionMenuType.buyShares.rawValue, ActionMenuType.sellShares.rawValue])
            metadata["legalActionsCompanies"] = [Int]([ActionMenuType.buyPrivate.rawValue, ActionMenuType.float.rawValue, ActionMenuType.buyTrain.rawValue, ActionMenuType.tilesTokens.rawValue, ActionMenuType.operate.rawValue, ActionMenuType.loans.rawValue] + [ActionMenuType.close.rawValue])
            
//        case .g1860:
//            metadata["roundOperationTypes"] = [OperationType.brownOR, OperationType.greenOR, OperationType.yellowOR, OperationType.SR]
//            metadata["roundOperationTypeColors"] = [UIColor.brownORColor, UIColor.greenORColor, UIColor.yellowORColor, UIColor.white]
//            metadata["roundOperationTypeTextColors"] = [UIColor.white, UIColor.white, UIColor.black, UIColor.black]
//            metadata["companies"] = ["BHIR", "CN", "FYN", "IOW", "IWN", "NGStL", "SC", "VYSC"]
//            metadata["floatModifiers"] = Array(repeating: 0, count: 8)
//            metadata["companiesTypes"] = Array(repeating: CompanyType.standard, count: 8)
//            metadata["compTotShares"] = Array(repeating: 10.0, count: 8)
//            metadata["predefinedShareAmounts"] = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0]
//            metadata["printShareAmountsAsInt"] = true
//            metadata["shareStartingLocation"] = ShareStartingLocation.ipo
//            metadata["compLogos"] = ["BHIR_60", "CN_60", "FYN_60", "IOW_60", "IWN_60", "NGStL_60", "SC_60", "VYSC_60"]
//            metadata["compColors"] = [
//                UIColor.fromHex("8B008B"),
//                UIColor.fromHex("00BFFF"),
//                UIColor.fromHex("008000"),
//                UIColor.fromHex("FF0000"),
//                
//                UIColor.fromHex("000000"),
//                UIColor.fromHex("FFFF00"),
//                UIColor.fromHex("00008B"),
//                UIColor.fromHex("9ACD32"),
//            ]
//            metadata["compTextColors"] = Array(repeating: UIColor.white, count: 5) + [UIColor.black, UIColor.white, UIColor.black]
//            metadata["totalBankAmount"] = [10000] as [Double]
//            metadata["playersStartingMoney"] = [1000, 670, 500] as [Double]
//            metadata["openCompanyValues"] = [270, 290, 310, 340, 370, 410, 450, 500]
//            metadata["gamePARValues"] = [54, 58, 62, 68, 74, 82, 90, 100]
//            metadata["PARValueIsIrrelevantToShow"] = false
//            metadata["requiredNumberOfSharesToFloat"] = 5
//            metadata["trainPriceValues"] = [80, 180, 300, 450, 630, 800, 1100]
//            metadata["trainPriceIndexToCloseAllPrivates"] = 3
//            metadata["certificateLimit"] = [20, 16, 13] as [Double]
//            metadata["currencyType"] = CurrencyType.pound
//            
//            metadata["ipoSharesPayBank"] = true
//            metadata["bankSharesPayBank"] = true
//            metadata["compSharesPayBank"] = true
//            metadata["asideSharesPayBank"] = true
//            metadata["tradeInSharesPayBank"] = true
//            
//            metadata["buyShareFromIPOPayBank"] = true
//            metadata["buyShareFromBankPayBank"] = true
//            metadata["buyShareFromCompPayBank"] = true
//            
//            metadata["sharesFromIPOHavePARprice"] = true
//            metadata["sharesFromBankHavePARprice"] = false
//            metadata["sharesFromCompHavePARprice"] = true
//            metadata["sharesFromAsideHavePARprice"] = true
//            metadata["sharesFromTradeInHavePARprice"] = true
//            
//            metadata["unitShareValuePayoutRoundPolicy"] = PayoutRoundPolicy.doNotRound
//            metadata["isPayoutRoundedUpOnTotalValue"] = true
//            metadata["buySellRoundPolicyOnTotal"] = BuySellRoundPolicy.roundUp
//            
//            metadata["isGenerateTrashHidden"] = true
//            
//            metadata["privatesBuyInModifiers"] = ["0.5x", "1.0x", "2.0x"]
//            metadata["privatesPrices"] = [30, 50, 90, 130, 200] as [Double]
//            // descriptions max length "coastal teleportation"
//            metadata["privatesOwnerGlobalIndexes"] = Array(repeating: BankIndex.bank.rawValue, count: 5)
//            metadata["privatesLockMoneyIfOutbidden"] = false
//            
//            metadata["legalActionsPlayers"] = [Int]([ActionMenuType.turnOrder.rawValue, ActionMenuType.buyShares.rawValue, ActionMenuType.sellShares.rawValue])
//            metadata["legalActionsCompanies"] = [Int]([ActionMenuType.float.rawValue, ActionMenuType.buyTrain.rawValue, ActionMenuType.tilesTokens.rawValue, ActionMenuType.operate.rawValue] + [ActionMenuType.close.rawValue])
            
//        case .g1871:
//            metadata["roundOperationTypes"] = [OperationType.brownOR, OperationType.greenOR, OperationType.yellowOR, OperationType.SR]
//            metadata["roundOperationTypeColors"] = [UIColor.brownORColor, UIColor.greenORColor, UIColor.yellowORColor, UIColor.white]
//            metadata["roundOperationTypeTextColors"] = [UIColor.white, UIColor.white, UIColor.black, UIColor.black]
//            metadata["companies"] = ["PEIR", "So", "A", "MS", "MR", "S", "Gt", "C", "BB", "CB", "HRB", "MB", "SB", "WB"]
//            metadata["floatModifiers"] = Array(repeating: 0, count: 14)
//            metadata["companiesTypes"] = Array(repeating: CompanyType.standard, count: 14)
//            metadata["compTotShares"] = Array(repeating: 10.0, count: 13) + [5]
//            metadata["predefinedShareAmounts"] = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0]
//            metadata["printShareAmountsAsInt"] = true
//            metadata["shareStartingLocation"] = ShareStartingLocation.ipo
//            metadata["compLogos"] = ["PEIR_71", "So_71", "A_71", "MS_71", "MR_71", "S_71", "Gt_71", "C_71", "BB_71", "CB_71", "HRB_71", "MB_71", "SB_71", "WB_71"]
//            metadata["compColors"] = [
//                UIColor.fromHex("EC767C"),
//                
//                UIColor.fromHex("000000"),
//                UIColor.fromHex("B58168"),
//                UIColor.fromHex("FCEA18"),
//                UIColor.fromHex("37B2E2"),
//                UIColor.fromHex("7BB137"),
//                UIColor.fromHex("9A9A9D"),
//                UIColor.fromHex("A21C40"),
//                
//                UIColor.fromHex("EB6F0E"),
//                UIColor.fromHex("BAA4CB"),
//                UIColor.fromHex("008F4F"),
//                UIColor.fromHex("0A70B3"),
//                UIColor.fromHex("B057A2"),
//                UIColor.fromHex("BDBD00"),
//            ]
//            metadata["compTextColors"] = Array(repeating: UIColor.white, count: 3) + Array(repeating: UIColor.black, count: 1) + Array(repeating: UIColor.white, count: 10)
//            metadata["totalBankAmount"] = [40000] as [Double]
//            metadata["playersStartingMoney"] = [0, 580, 480, 0, 0] as [Double]
//            metadata["openCompanyValues"] = [348, 390, 444, 480, 516, 552]
//            metadata["gamePARValues"] = [58, 65, 74, 80, 86, 92]
//            metadata["PARValueIsIrrelevantToShow"] = false
//            metadata["requiredNumberOfSharesToFloat"] = 5
//            metadata["trainPriceValues"] = [80, 180, 300, 450, 630, 800, 1100]
//            metadata["trainPriceIndexToCloseAllPrivates"] = 3
//            metadata["certificateLimit"] = [0, 20, 16, 0, 0] as [Double]
//            metadata["currencyType"] = CurrencyType.dollar
//            
//            metadata["ipoSharesPayBank"] = true
//            metadata["bankSharesPayBank"] = false
//            metadata["compSharesPayBank"] = false
//            metadata["asideSharesPayBank"] = true
//            metadata["tradeInSharesPayBank"] = true
//            
//            metadata["buyShareFromIPOPayBank"] = true
//            metadata["buyShareFromBankPayBank"] = true
//            metadata["buyShareFromCompPayBank"] = true
//            
//            metadata["sharesFromIPOHavePARprice"] = true
//            metadata["sharesFromBankHavePARprice"] = false
//            metadata["sharesFromCompHavePARprice"] = true
//            metadata["sharesFromAsideHavePARprice"] = true
//            metadata["sharesFromTradeInHavePARprice"] = true
//            
//            metadata["unitShareValuePayoutRoundPolicy"] = PayoutRoundPolicy.roundUp
//            metadata["isPayoutRoundedUpOnTotalValue"] = true
//            metadata["buySellRoundPolicyOnTotal"] = BuySellRoundPolicy.roundUp
//            
//            metadata["isGenerateTrashHidden"] = true
//            
//            metadata["privatesBuyInModifiers"] = ["0.5x", "1.0x", "2.0x"]
//            metadata["privatesPrices"] = [20, 40, 50, 90, 130, 220] as [Double]
//            // descriptions max length "coastal teleportation"
//            metadata["privatesOwnerGlobalIndexes"] = Array(repeating: BankIndex.bank.rawValue, count: 6)
//            metadata["privatesLockMoneyIfOutbidden"] = false
//            
//            metadata["legalActionsPlayers"] = [Int]([ActionMenuType.turnOrder.rawValue, ActionMenuType.sellPrivate.rawValue, ActionMenuType.buyShares.rawValue, ActionMenuType.sellShares.rawValue])
//            metadata["legalActionsCompanies"] = [Int]([ActionMenuType.buyPrivate.rawValue, ActionMenuType.float.rawValue, ActionMenuType.buyTrain.rawValue, ActionMenuType.tilesTokens.rawValue, ActionMenuType.operate.rawValue] + [ActionMenuType.close.rawValue])
            
//        case .g1880:
//            metadata["roundOperationTypes"] = [OperationType.brownOR, OperationType.greenOR, OperationType.yellowOR, OperationType.SR]
//            metadata["roundOperationTypeColors"] = [UIColor.brownORColor, UIColor.greenORColor, UIColor.yellowORColor, UIColor.white]
//            metadata["roundOperationTypeTextColors"] = [UIColor.white, UIColor.white, UIColor.black, UIColor.black]
//            metadata["companies"] = ["BCR", "BZU", "CKR", "HKR", "JGG", "JHA", "JHU", "JLR", "LHR", "NJR", "NXR", "QSR", "SCR", "WNR"]
//            metadata["floatModifiers"] = Array(repeating: 0, count: 14)
//            metadata["companiesTypes"] = Array(repeating: CompanyType.standard, count: 14)
//            metadata["compTotShares"] = Array(repeating: 10.0, count: 14)
//            metadata["predefinedShareAmounts"] = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0]
//            metadata["printShareAmountsAsInt"] = true
//            metadata["shareStartingLocation"] = ShareStartingLocation.ipo
//            metadata["compLogos"] = ["BCR_80", "BZU_80", "CKR_80", "HKR_80", "JGG_80", "JHA_80", "JHU_80", "JLR_80", "LHR_80", "NJR_80", "NXR_80", "QSR_80", "SCR_80", "WNR_80"]
//            metadata["compColors"] = [
//                UIColor.fromHex("94121D"),
//                UIColor.fromHex("9D8359"),
//                UIColor.fromHex("507EAE"),
//                UIColor.fromHex("40743A"),
//                
//                UIColor.fromHex("534074"),
//                UIColor.fromHex("BA6128"),
//                UIColor.fromHex("000000"),
//                
//                UIColor.fromHex("008A8B"),
//                UIColor.fromHex("004294"),
//                UIColor.fromHex("452518"),
//                UIColor.fromHex("A83B5B"),
//                
//                UIColor.fromHex("B3932C"),
//                UIColor.fromHex("282F1A"),
//                UIColor.fromHex("A4391F"),
//            ]
//            metadata["compTextColors"] = Array(repeating: UIColor.white, count: 14)
//            metadata["totalBankAmount"] = [40000] as [Double]
//            metadata["playersStartingMoney"] = [600, 480, 400, 340, 300] as [Double]
//            // check this out
//            metadata["openCompanyValues"] = [140, 160, 180, 200]
//            metadata["gamePARValues"] = [70, 80, 90, 100]
//            metadata["PARValueIsIrrelevantToShow"] = false
//            metadata["requiredNumberOfSharesToFloat"] = 5
//            metadata["trainPriceValues"] = [80, 180, 300, 450, 630, 800, 1100]
//            metadata["trainPriceIndexToCloseAllPrivates"] = 3
//            metadata["certificateLimit"] = [28, 20, 16, 13, 11] as [Double]
//            metadata["currencyType"] = CurrencyType.yuan
//            
//            // check carefully
//            metadata["ipoSharesPayBank"] = true
//            metadata["bankSharesPayBank"] = false
//            metadata["compSharesPayBank"] = true
//            metadata["asideSharesPayBank"] = true
//            metadata["tradeInSharesPayBank"] = true
//            
//            metadata["buyShareFromIPOPayBank"] = true
//            metadata["buyShareFromBankPayBank"] = true
//            metadata["buyShareFromCompPayBank"] = true
//            
//            metadata["sharesFromIPOHavePARprice"] = true
//            metadata["sharesFromBankHavePARprice"] = false
//            metadata["sharesFromCompHavePARprice"] = true
//            metadata["sharesFromAsideHavePARprice"] = true
//            metadata["sharesFromTradeInHavePARprice"] = true
//            
//            metadata["unitShareValuePayoutRoundPolicy"] = PayoutRoundPolicy.doNotRound
//            metadata["isPayoutRoundedUpOnTotalValue"] = true
//            metadata["buySellRoundPolicyOnTotal"] = BuySellRoundPolicy.roundUp
//            
//            metadata["isGenerateTrashHidden"] = true
//            
//            metadata["privatesBuyInModifiers"] = ["0.5x", "1.0x", "2.0x"]
//            metadata["privatesPrices"] = [5, 10, 25, 45, 70, 100, 160, 50] as [Double]
//            // descriptions max length "coastal teleportation"
//            metadata["privatesOwnerGlobalIndexes"] = Array(repeating: BankIndex.bank.rawValue, count: 8)
//            metadata["privatesLockMoneyIfOutbidden"] = false
//            
//            metadata["legalActionsPlayers"] = [Int]([ActionMenuType.turnOrder.rawValue, ActionMenuType.sellPrivate.rawValue, ActionMenuType.buyShares.rawValue, ActionMenuType.sellShares.rawValue])
//            metadata["legalActionsCompanies"] = [Int]([ActionMenuType.buyPrivate.rawValue, ActionMenuType.float.rawValue, ActionMenuType.buyTrain.rawValue, ActionMenuType.tilesTokens.rawValue, ActionMenuType.operate.rawValue] + [ActionMenuType.close.rawValue])
            
        case .g1882:
            metadata["gameSpecificPlayerTurnOrderType"] = PlayerTurnOrderType.classic
            metadata["roundOperationTypes"] = [OperationType.brownOR, OperationType.greenOR, OperationType.yellowOR, OperationType.SR]
            metadata["roundOperationTypeColors"] = [UIColor.brownORColor, UIColor.greenORColor, UIColor.yellowORColor, UIColor.white]
            metadata["roundOperationTypeTextColors"] = [UIColor.white, UIColor.white, UIColor.black, UIColor.black]
            
            metadata["companies"] = ["CNaR", "CNoR", "CPR", "GTP", "HBR", "QL", "SCR"]
            metadata["floatModifiers"] = Array(repeating: 0, count: 7)
            metadata["companiesTypes"] = Array(repeating: CompanyType.standard, count: 7)
            metadata["compTotShares"] = Array(repeating: 10.0, count: 7)
            metadata["predefinedShareAmounts"] = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0]
            metadata["printShareAmountsAsInt"] = true
            metadata["shareStartingLocation"] = ShareStartingLocation.ipo
            metadata["compLogos"] = ["CNaR_82", "CNoR_82", "CPR_82", "GTP_82", "HBR_82", "QL_82", "SCR_82"]
            metadata["compColors"] = [
                UIColor.fromHex("FE8B41"),
                UIColor.fromHex("008C55"),
                UIColor.fromHex("DD3027"),
                UIColor.fromHex("000000"),
                
                UIColor.fromHex("FFDD40"),
                UIColor.fromHex("C14674"),
                UIColor.fromHex("3562BF"),
            ]
            metadata["compTextColors"] = Array(repeating: UIColor.white, count: 4) + Array(repeating: UIColor.black, count: 1) + Array(repeating: UIColor.white, count: 2)
            metadata["totalBankAmount"] = [9000] as [Double]
            metadata["playersStartingMoney"] = [900, 600, 450, 360, 300] as [Double]
            metadata["openCompanyValues"] = [402, 426, 456, 492, 540, 600]
            metadata["gamePARValues"] = [67, 71, 76, 82, 90, 100]
            metadata["PARValueIsIrrelevantToShow"] = false
            metadata["requiredNumberOfSharesToFloat"] = 6
            metadata["tileTokensPriceSuggestions"] = [20, 40, 60]
            metadata["trainPriceValues"] = [80, 180, 300, 450, 630, 800, 1100]
            metadata["trainPriceIndexToCloseAllPrivates"] = 3
            metadata["certificateLimit"] = [20, 14, 11, 10, 9] as [Double]
            metadata["shareValues"] = [[76, 70, 65, 60, 55, 50, 45, 40, 30, 20, 10],
                                       [82, 76, 70, 66, 62, 58, 54, 50, 40, 30, 20],
                                       [90, 82, 76, 71, 67, 65, 63, 60, 50, 40, 30],
                                       [100, 90, 82, 76, 71, 67, 67, 67, 60, 50, 40],
                                       [112, 100, 90, 82, 76, 71, 69, 68, nil, nil, nil],
                                       [126, 112, 100, 90, 82, 75, 70, nil, nil, nil, nil],
                                       [142, 126, 111, 100, 90, 80, nil, nil, nil, nil, nil],
                                       [160, 142, 125, 110, 100, nil, nil, nil, nil, nil, nil],
                                       [180, 160, 140, 120, nil, nil, nil, nil, nil, nil, nil],
                                       [200, 180, 155, 130, nil, nil, nil, nil, nil, nil, nil],
                                       [225, 200, 170, nil, nil, nil, nil, nil, nil, nil, nil],
                                       [250, 220, 185, nil, nil, nil, nil, nil, nil, nil, nil],
                                       [275, 240, 200, nil, nil, nil, nil, nil, nil, nil, nil],
                                       [300, 260, nil, nil, nil, nil, nil, nil, nil, nil, nil],
                                       [325, 280, nil, nil, nil, nil, nil, nil, nil, nil, nil],
                                       [350, 300, nil, nil, nil, nil, nil, nil, nil, nil, nil]] as [[Double?]]
            metadata["currencyType"] = CurrencyType.dollar
            
            metadata["ipoSharesPayBank"] = true
            metadata["bankSharesPayBank"] = false
            metadata["compSharesPayBank"] = true
            metadata["asideSharesPayBank"] = true
            metadata["tradeInSharesPayBank"] = true
            
            metadata["buyShareFromIPOPayBank"] = true
            metadata["buyShareFromBankPayBank"] = true
            metadata["buyShareFromCompPayBank"] = true
            
            metadata["sharesFromIPOHavePARprice"] = true
            metadata["sharesFromBankHavePARprice"] = false
            metadata["sharesFromCompHavePARprice"] = true
            metadata["sharesFromAsideHavePARprice"] = true
            metadata["sharesFromTradeInHavePARprice"] = true
            
            metadata["unitShareValuePayoutRoundPolicy"] = PayoutRoundPolicy.doNotRound
            metadata["isPayoutRoundedUpOnTotalValue"] = true
            metadata["buySellRoundPolicyOnTotal"] = BuySellRoundPolicy.roundUp
            
            metadata["isGenerateTrashHidden"] = true
            
            metadata["privatesBuyInModifiers"] = ["0.5x", "1.0x", "2.0x"]
            metadata["privatesLabels"] = (1...5).map { "P\($0)" } as [String]
            metadata["privatesPrices"] = [20, 50, 80, 140, 180] as [Double]
            metadata["privatesIncomes"] = [5, 10, 15, 0, 25] as [Double]
            metadata["privatesMayBeBuyInFlags"] = [true, true, true, true, false] as [Bool]
            metadata["privatesDescriptions"] = ["Blocks hex C11 while owned by a player. No special ability.\nThis private company closes at the start of Phase 5",
                                                "Blocks hex H4 while owned by a player.\nDuring the owning player’s stock round turn, they can close it to exchange it for the president’s certificate of the SCR public company. This is the only way the SCR public company may enter the game. This counts as a stock round turn “buy” action. The SCR floats using the same rules as other companies. If the private company is sold to a company, it can no longer be converted.\nTo enact the exchange, the player:\nExchanges the private company for the president’s certificate of the SCR. Discard the private company from the game.\nSets the par price and pays for one share at par price to the bank. The exchange accounts for the second share of the 20% president’s certificate.\nPlaces the SCR home token in any available non-reserved city or replaces a neutral station marker on the map (the neutral station marker is removed from the game).\nAdds an SCR token to the stock market, underneath any existing tokens in the same space.\nAdds an “extra” train to the bank using one of the trains that were set aside during setup. Only perform this step if a 3, 4, 5, or 6-train is the next available train from the bank. Add one more of the currently available train to the stack of available trains. Discard the other “extra” trains that were set aside.\nThis private company closes at the start of Phase 6 or when the power is used",
                                                "A public company owning this company may move one of its existing on-map station markers located in a non-NWR indicated city to any open NWR indicated hex city, including upgraded cities. There is no cost to perform this action, but it may only be taken one time per game. There is no track connection requirement. This power is in addition to all normal operating turn actions and may be taken at any time during the operating turn. If the company home token is moved, replace it with a neutral station marker from the supply. After performing the action, a single (extra) tile lay or upgrade may be performed on the destination hex. This is in addition to a regular track lay(s) or upgrade performed by the company.\nException: A company’s home token cannot be moved if a neutral station marker already exists in the company’s home hex.\nThis private company closes at the start of Phase 5",
                                                "Blocks hex G9 while owned by a player.\nThis company earns no money at the start of the operating round like the other private companies. It instead earns $10 from the bank immediately when each new connection across a river hexside is established (by any company). A tile lay or upgrade that completes multiple crossings earns $10 for each one.\nDuring game setup randomly select a 10% share certificate to go with this private company (see Section 3, Setting Up the Game).\nThe selected certificate is placed with this private company. When this private company is purchased during the private company auction, the winning player also receives the selected 10% share with the certificate.\nThis company closes at the start of Phase 5",
                                                "This company comes with the 20% president’s certificate of the CPR public company. The buying player must immediately set the par price for the CPR. This private company cannot be purchased by a public company.\nThis private company closes at the start of phase 5, or when the CPR purchases a train. No buy-in"]
            metadata["privatesMayBeVoluntarilyClosedFlags"] = Array(repeating: true, count: 5)
            metadata["privatesOwnerGlobalIndexes"] = Array(repeating: BankIndex.bank.rawValue, count: 5)
            metadata["privatesLockMoneyIfOutbidden"] = true
            
            metadata["legalActionsPlayers"] = [Int]([ActionMenuType.turnOrder.rawValue, ActionMenuType.sellPrivate.rawValue, ActionMenuType.buyShares.rawValue, ActionMenuType.sellShares.rawValue])
            metadata["legalActionsCompanies"] = [Int]([ActionMenuType.buyPrivate.rawValue, ActionMenuType.float.rawValue, ActionMenuType.buyTrain.rawValue, ActionMenuType.tilesTokens.rawValue, ActionMenuType.operate.rawValue])
            
        case .g1889:
            metadata["gameSpecificPlayerTurnOrderType"] = PlayerTurnOrderType.classic
            metadata["roundOperationTypes"] = [OperationType.brownOR, OperationType.greenOR, OperationType.yellowOR, OperationType.SR]
            metadata["roundOperationTypeColors"] = [UIColor.brownORColor, UIColor.greenORColor, UIColor.yellowORColor, UIColor.white]
            metadata["roundOperationTypeTextColors"] = [UIColor.white, UIColor.white, UIColor.black, UIColor.black]
            
            metadata["companies"] = ["AR", "IR", "SR", "TER", "TKE", "TKR", "UR"]
            metadata["floatModifiers"] = Array(repeating: 0, count: 7)
            metadata["companiesTypes"] = Array(repeating: CompanyType.standard, count: 7)
            metadata["compTotShares"] = Array(repeating: 10.0, count: 7)
            metadata["predefinedShareAmounts"] = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0]
            metadata["printShareAmountsAsInt"] = true
            metadata["shareStartingLocation"] = ShareStartingLocation.ipo
            metadata["compLogos"] = ["AR_89", "IR_89", "SR_89", "TER_89", "TKE_89", "TKR_89", "UR_89"]
            metadata["compColors"] = [
                UIColor.fromHex("38383A"),
                UIColor.fromHex("F68121"),
                UIColor.fromHex("79A242"),
                UIColor.fromHex("01A89E"),
                
                UIColor.fromHex("DA1F3E"),
                UIColor.fromHex("0089D1"),
                UIColor.fromHex("6F533E"),
            ]
            metadata["compTextColors"] = Array(repeating: UIColor.white, count: 7)
            metadata["totalBankAmount"] = [7000] as [Double]
            metadata["playersStartingMoney"] = [420, 420, 420, 390, 390] as [Double]
            metadata["openCompanyValues"] = [325, 350, 375, 400, 450, 500]
            metadata["gamePARValues"] = [65, 70, 75, 80, 90, 100]
            metadata["PARValueIsIrrelevantToShow"] = false
            metadata["requiredNumberOfSharesToFloat"] = 5
            metadata["tileTokensPriceSuggestions"] = [40, 80]
            metadata["trainPriceValues"] = [80, 180, 300, 450, 630, 800, 1100]
            metadata["trainPriceIndexToCloseAllPrivates"] = 3
            metadata["certificateLimit"] = [25, 19, 14, 12, 11] as [Double]
            metadata["shareValues"] = [[75, 70, 65, 60, 55, 50, 45, 40, 30, 20, 10],
                                       [80, 75, 70, 65, 60, 55, 50, 45, 40, 30, 20],
                                       [90, 80, 75, 70, 65, 60, 55, 50, 45, 40, 30],
                                       [100, 90, 80, 75, 70, 65, 60, 55, 50, 45, 40],
                                       [110, 100, 90, 80, 75, 70, 65, 60, nil, nil, nil],
                                       [125, 110, 100, 90, 80, 75, 70, nil, nil, nil, nil],
                                       [140, 125, 110, 100, 90, 80, nil, nil, nil, nil, nil],
                                       [155, 140, 125, 110, 100, nil, nil, nil, nil, nil, nil],
                                       [175, 155, 140, 125, nil, nil, nil, nil, nil, nil, nil],
                                       [200, 175, 155, 140, nil, nil, nil, nil, nil, nil, nil],
                                       [225, 200, 175, nil, nil, nil, nil, nil, nil, nil, nil],
                                       [255, 225, 200, nil, nil, nil, nil, nil, nil, nil, nil],
                                       [285, 255, nil, nil, nil, nil, nil, nil, nil, nil, nil],
                                       [315, 285, nil, nil, nil, nil, nil, nil, nil, nil, nil],
                                       [350, 315, nil, nil, nil, nil, nil, nil, nil, nil, nil]] as [[Double?]]
            metadata["currencyType"] = CurrencyType.yuan
            
            metadata["ipoSharesPayBank"] = true
            metadata["bankSharesPayBank"] = false
            metadata["compSharesPayBank"] = true
            metadata["asideSharesPayBank"] = true
            metadata["tradeInSharesPayBank"] = true
            
            metadata["buyShareFromIPOPayBank"] = true
            metadata["buyShareFromBankPayBank"] = true
            metadata["buyShareFromCompPayBank"] = true
            
            metadata["sharesFromIPOHavePARprice"] = true
            metadata["sharesFromBankHavePARprice"] = false
            metadata["sharesFromCompHavePARprice"] = true
            metadata["sharesFromAsideHavePARprice"] = true
            metadata["sharesFromTradeInHavePARprice"] = true
            
            metadata["unitShareValuePayoutRoundPolicy"] = PayoutRoundPolicy.doNotRound
            metadata["isPayoutRoundedUpOnTotalValue"] = true
            metadata["buySellRoundPolicyOnTotal"] = BuySellRoundPolicy.roundUp
            metadata["isGenerateTrashHidden"] = true
            
            metadata["privatesBuyInModifiers"] = ["0.5x", "1.0x", "2.0x"]
            metadata["privatesLabels"] = (["A", "B", "C", "D", "E", "F", "G"]).map { "Private \($0)" } as [String]
            metadata["privatesPrices"] = [20, 30, 40, 50, 60, 80, 150] as [Double]
            metadata["privatesIncomes"] = [5, 5, 10, 15, 15, 20, 30] as [Double]
            metadata["privatesMayBeBuyInFlags"] = [true, true, true, true, true, true, true] as [Bool]
            metadata["privatesDescriptions"] = ["Takamatsu may only be upgraded if this Private Company is owned by a Corporation or is closed",
                                                "If owned by a player, that player may place the port tile (#437) on one of the following coastal towns: Nakamura, Nankoku, Mugi, Komatsujima.\nThis placement may occur at any time outside of the operation of a Corporation controlled by another player. The player need not control a Corporation and the port tile need not have connectivity to other hexes",
                                                "Ôzu may only be upgraded if this Private Company is owned by a Corporation or is closed.\nWhen this Private Company is sold to a Corporation, the selling player may immediately upgrade Ôzu. This upgrade is in addition to any tile action the buying Corporation takes on the same operating turn",
                                                "If owned by a Corporation, that Corporation may ignore mountain terrain costs",
                                                "If owned by a player, that player may close this Private Company in exchange for a 10% share of Iyo Railway from the Initial Offering",
                                                "No abilities",
                                                "If owned by a player when the first 5-train is purchased, instead of closing, this Private Company may no longer be sold to a Corporation and its revenue is increased to ¥50.\nIt will contribute ¥150 to the owning player’s net worth at the end of the game."]
            metadata["privatesMayBeVoluntarilyClosedFlags"] = Array(repeating: false, count: 4) + [true, false, false, false]
            metadata["privatesOwnerGlobalIndexes"] = Array(repeating: BankIndex.bank.rawValue, count: 7)
            metadata["privatesLockMoneyIfOutbidden"] = true
            
            metadata["legalActionsPlayers"] = [Int]([ActionMenuType.turnOrder.rawValue, ActionMenuType.sellPrivate.rawValue, ActionMenuType.buyShares.rawValue, ActionMenuType.sellShares.rawValue])
            metadata["legalActionsCompanies"] = [Int]([ActionMenuType.buyPrivate.rawValue, ActionMenuType.float.rawValue, ActionMenuType.buyTrain.rawValue, ActionMenuType.tilesTokens.rawValue, ActionMenuType.operate.rawValue])
            
        case .g18Chesapeake:
            metadata["gameSpecificPlayerTurnOrderType"] = PlayerTurnOrderType.classic
            metadata["roundOperationTypes"] = [OperationType.brownOR, OperationType.greenOR, OperationType.yellowOR, OperationType.SR]
            metadata["roundOperationTypeColors"] = [UIColor.brownORColor, UIColor.greenORColor, UIColor.yellowORColor, UIColor.white]
            metadata["roundOperationTypeTextColors"] = [UIColor.white, UIColor.white, UIColor.black, UIColor.black]
            
            metadata["companies"] = ["B&O", "C&A", "C&O", "LVR", "N&W", "PLE", "PRR", "SRR"]
            metadata["floatModifiers"] = Array(repeating: 0, count: 8)
            metadata["companiesTypes"] = Array(repeating: CompanyType.standard, count: 8)
            metadata["compTotShares"] = Array(repeating: 10.0, count: 8)
            metadata["predefinedShareAmounts"] = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0]
            metadata["printShareAmountsAsInt"] = true
            metadata["shareStartingLocation"] = ShareStartingLocation.ipo
            metadata["compLogos"] = ["B&O_ch", "C&A_ch", "C&O_ch", "LVR_ch", "N&W_ch", "PLE_ch", "PRR_ch", "SRR_ch"]
            metadata["compColors"] = [
                UIColor.fromHex("377AB2"),
                UIColor.fromHex("E78B41"),
                UIColor.fromHex("AEDBEB"),
                UIColor.fromHex("FDEE67"),
                
                UIColor.fromHex("631623"),
                UIColor.fromHex("000000"),
                UIColor.fromHex("419250"),
                UIColor.fromHex("DD5345"),
            ]
            metadata["compTextColors"] = Array(repeating: UIColor.white, count: 2) + Array(repeating: UIColor.black, count: 2) + Array(repeating: UIColor.white, count: 4)
            metadata["totalBankAmount"] = [8000] as [Double]
            metadata["playersStartingMoney"] = [1200, 800, 600, 480, 400] as [Double]
            metadata["openCompanyValues"] = [420, 480, 570]
            metadata["gamePARValues"] = [70, 80, 95]
            metadata["PARValueIsIrrelevantToShow"] = false
            metadata["requiredNumberOfSharesToFloat"] = 6
            metadata["tileTokensPriceSuggestions"] = [40, 60, 80]
            metadata["trainPriceValues"] = [80, 180, 300, 500, 630, 700, 900]
            metadata["trainPriceIndexToCloseAllPrivates"] = 3
            metadata["certificateLimit"] = [20, 20, 16, 13, 11] as [Double]
            metadata["shareValues"] = [[80, 75, 70, 65, 60, 55, 50, 40],
                                       [85, 80, 75, 70, 65, 60, 55, 45],
                                       [90, 85, 80, 75, 70, 65, 60, 50],
                                       [100, 90, 85, 80, 75, 70, 65, nil],
                                       [110, 100, 95, 85, 80, 75, nil, nil],
                                       [125, 110, 105, 95, 85, 80, nil, nil],
                                       [140, 125, 115, 105, 95, nil, nil, nil],
                                       [160, 140, 130, 115, 105, nil, nil, nil],
                                       [180, 160, 145, 130, nil, nil, nil, nil],
                                       [200, 180, 160, 145, nil, nil, nil, nil],
                                       [225, 200, 180, nil, nil, nil, nil, nil],
                                       [250, 225, 200, nil, nil, nil, nil, nil],
                                       [275, 250, nil, nil, nil, nil, nil, nil],
                                       [300, 275, nil, nil, nil, nil, nil, nil],
                                       [325, 300, nil, nil, nil, nil, nil, nil],
                                       [350, 325, nil, nil, nil, nil, nil, nil],
                                       [375, 350, nil, nil, nil, nil, nil, nil]] as [[Double?]]
            metadata["currencyType"] = CurrencyType.dollar
            
            metadata["ipoSharesPayBank"] = true
            metadata["bankSharesPayBank"] = false
            metadata["compSharesPayBank"] = true
            metadata["asideSharesPayBank"] = true
            metadata["tradeInSharesPayBank"] = true
            
            metadata["buyShareFromIPOPayBank"] = true
            metadata["buyShareFromBankPayBank"] = true
            metadata["buyShareFromCompPayBank"] = true
            
            metadata["sharesFromIPOHavePARprice"] = true
            metadata["sharesFromBankHavePARprice"] = false
            metadata["sharesFromCompHavePARprice"] = true
            metadata["sharesFromAsideHavePARprice"] = true
            metadata["sharesFromTradeInHavePARprice"] = true
            
            metadata["unitShareValuePayoutRoundPolicy"] = PayoutRoundPolicy.doNotRound
            metadata["isPayoutRoundedUpOnTotalValue"] = true
            metadata["buySellRoundPolicyOnTotal"] = BuySellRoundPolicy.roundUp
            
            metadata["isGenerateTrashHidden"] = true
            
            metadata["privatesBuyInModifiers"] = ["0.5x", "1.0x", "2.0x"]
            metadata["privatesLabels"] = (1...6).map { "P\($0)" } as [String]
            metadata["privatesPrices"] = [20, 40, 50, 80, 100, 200] as [Double]
            metadata["privatesIncomes"] = [5, 10, 10, 15, 0, 30] as [Double]
            metadata["privatesMayBeBuyInFlags"] = [true, true, true, true, true, false] as [Bool]
            metadata["privatesDescriptions"] = ["Blocks hex K3 while owned by a player. No special ability",
                                                "Blocks hexes H2 and I3 while owned by a player. The owning company may lay two connected tiles in hexes H2 and I3. Both tiles must have track that connects to the shared hex edge. Only #8 and #9 track tiles may be used (one of each or two of the same). If any tiles are played in either of these hexes other than by using this special ability, the ability is forfeit. These tiles may be placed, even if the owning company does not have a route to the hexes and are in addition to the company’s tile placement action",
                                                "Blocks hexes F4 and G5 while owned by a player. The owning company may lay two connected tiles in hexes F4 and G5. Both tiles must have track that connects to the shared hex edge. Only #8 and #9 tiles may be used (one of each or two of the same). If any tiles are played in either of these hexes other than by using this special ability, the ability is forfeit. These tiles may be placed, even if the owning company does not have a route to the hexes and are in addition to the company’s tile placement action",
                                                "Blocks hex D2 while owned by a player. The owning company may place a #57 (straight city) tile in hex D2. The company does not need to have a route to this hex. The tile placed counts as the company’s tile lay action and the company must pay the terrain cost. After the company lays the tile, it may then immediately place a station token in hex D2 free of charge. The token used must be the next available cheapest station. If placed, this counts as the company’s token laying action",
                                                "During game setup, place one share of the Baltimore and Ohio public company with this certificate. The player purchasing this private company takes both the private company and the B&O share. This private company has no other special ability",
                                                "During game setup, select a random president’s certificate and place it with this certificate (see Section 3, Setting Up the Game). The player purchasing this private company takes both the private company and the associated president’s certificate of a public company. Upon purchase, the purchaser immediately sets the par value of the public company. This private company closes when this associated public company buys its first train. This private company has no other special ability and may not be purchased by a company. No buy-in"]
            metadata["privatesMayBeVoluntarilyClosedFlags"] = Array(repeating: false, count: 5) + [true]
            metadata["privatesOwnerGlobalIndexes"] = Array(repeating: BankIndex.bank.rawValue, count: 6)
            metadata["privatesLockMoneyIfOutbidden"] = false
            
            metadata["legalActionsPlayers"] = [Int]([ActionMenuType.turnOrder.rawValue, ActionMenuType.sellPrivate.rawValue, ActionMenuType.buyShares.rawValue, ActionMenuType.sellShares.rawValue])
            metadata["legalActionsCompanies"] = [Int]([ActionMenuType.buyPrivate.rawValue, ActionMenuType.float.rawValue, ActionMenuType.buyTrain.rawValue, ActionMenuType.tilesTokens.rawValue, ActionMenuType.operate.rawValue])
            
//        case .g18CZ:
//            metadata["roundOperationTypes"] = [OperationType.brownOR, OperationType.greenOR, OperationType.yellowOR, OperationType.SR]
//            metadata["roundOperationTypeColors"] = [UIColor.brownORColor, UIColor.greenORColor, UIColor.yellowORColor, UIColor.white]
//            metadata["roundOperationTypeTextColors"] = [UIColor.white, UIColor.white, UIColor.black, UIColor.black]
//            metadata["companies"] = ["BCB", "EKJ", "MW", "OFE", "VBW", "ATE", "BN", "BTE", "KFN", "NWB", "By", "kk", "Pr", "Sx", "Ug"]
//            metadata["floatModifiers"] = Array(repeating: 0, count: 15)
//            metadata["companiesTypes"] = Array(repeating: CompanyType.standard, count: 15)
//            metadata["compTotShares"] = Array(repeating: 4.0, count: 5) + Array(repeating: 5.0, count: 5) + Array(repeating: 10.0, count: 5)
//            metadata["predefinedShareAmounts"] = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0]
//            metadata["printShareAmountsAsInt"] = true
//            metadata["shareStartingLocation"] = ShareStartingLocation.ipo
//            metadata["compLogos"] = ["BCB_CZ", "EKJ_CZ", "MW_CZ", "OFE_CZ", "VBW_CZ", "ATE_CZ", "BN_CZ", "BTE_CZ", "KFN_CZ", "NWB_CZ", "By_CZ", "kk_CZ", "Pr_CZ", "Sx_CZ", "Ug_CZ"]
//            metadata["compColors"] = [
//                UIColor.fromHex("FABC48"),
//                UIColor.fromHex("FFFFFF"),
//                UIColor.fromHex("9AD0C2"),
//                UIColor.fromHex("FFC0D9"),
//                UIColor.fromHex("E1FFB1"),
//                
//                UIColor.fromHex("FFED00"),
//                UIColor.fromHex("D9D9D9"),
//                UIColor.fromHex("E6F0C6"),
//                UIColor.fromHex("A2D9F7"),
//                UIColor.fromHex("FFFBDB"),
//                
//                UIColor.fromHex("001B79"),
//                UIColor.fromHex("ED7D31"),
//                UIColor.fromHex("000000"),
//                UIColor.fromHex("B31312"),
//                UIColor.fromHex("FF90BC"),
//            ]
//            metadata["compTextColors"] = Array(repeating: UIColor.black, count: 10) + Array(repeating: UIColor.white, count: 5)
//            metadata["totalBankAmount"] = [40000] as [Double]
//            metadata["playersStartingMoney"] = [0, 380, 300, 250, 210] as [Double]
//            metadata["openCompanyValues"] = [402, 426, 456, 492, 540, 600]
//            metadata["gamePARValues"] = [67, 71, 76, 82, 90, 100]
//            metadata["PARValueIsIrrelevantToShow"] = false
//            metadata["requiredNumberOfSharesToFloat"] = 5
//            metadata["trainPriceValues"] = [80, 180, 300, 450, 630, 800, 1100]
//            metadata["trainPriceIndexToCloseAllPrivates"] = 3
//            metadata["certificateLimit"] = [0, 20, 16, 13, 11] as [Double]
//            metadata["currencyType"] = CurrencyType.krone
//            
//            metadata["ipoSharesPayBank"] = true
//            metadata["bankSharesPayBank"] = true
//            metadata["compSharesPayBank"] = true
//            metadata["asideSharesPayBank"] = true
//            metadata["tradeInSharesPayBank"] = true
//            
//            metadata["buyShareFromIPOPayBank"] = true
//            metadata["buyShareFromBankPayBank"] = true
//            metadata["buyShareFromCompPayBank"] = true
//            
//            metadata["sharesFromIPOHavePARprice"] = true
//            metadata["sharesFromBankHavePARprice"] = false
//            metadata["sharesFromCompHavePARprice"] = true
//            metadata["sharesFromAsideHavePARprice"] = true
//            metadata["sharesFromTradeInHavePARprice"] = true
//            
//            metadata["unitShareValuePayoutRoundPolicy"] = PayoutRoundPolicy.doNotRound
//            metadata["isPayoutRoundedUpOnTotalValue"] = true
//            metadata["buySellRoundPolicyOnTotal"] = BuySellRoundPolicy.roundUp
//            metadata["isGenerateTrashHidden"] = true
//            
//            metadata["privatesBuyInModifiers"] = ["1", "any"]
//            metadata["privatesPrices"] = [55, 55, 40, 40, 25, 25] as [Double]
//            // descriptions max length "coastal teleportation"
//            metadata["privatesOwnerGlobalIndexes"] = Array(repeating: BankIndex.bank.rawValue, count: 6)
//            metadata["privatesLockMoneyIfOutbidden"] = true
//            
//            metadata["legalActionsPlayers"] = [Int]([ActionMenuType.turnOrder.rawValue, ActionMenuType.sellPrivate.rawValue, ActionMenuType.buyShares.rawValue, ActionMenuType.sellShares.rawValue])
//            metadata["legalActionsCompanies"] = [Int]([ActionMenuType.buyPrivate.rawValue, ActionMenuType.float.rawValue, ActionMenuType.buyTrain.rawValue, ActionMenuType.tilesTokens.rawValue, ActionMenuType.operate.rawValue] + [ActionMenuType.acquire.rawValue] + [ActionMenuType.close.rawValue])
            
        case .g18MEX:
            metadata["gameSpecificPlayerTurnOrderType"] = PlayerTurnOrderType.classic
            metadata["roundOperationTypes"] = [OperationType.brownOR, OperationType.greenOR, OperationType.yellowOR, OperationType.SR]
            metadata["roundOperationTypeColors"] = [UIColor.brownORColor, UIColor.greenORColor, UIColor.yellowORColor, UIColor.white]
            metadata["roundOperationTypeTextColors"] = [UIColor.white, UIColor.white, UIColor.black, UIColor.black]
            
            metadata["companies"] = ["CHI", "MCR", "MEX", "NDM", "PAC", "SPM", "TMR", "UDY", "A", "B", "C"]
            metadata["floatModifiers"] = Array(repeating: 0, count: 11)
            metadata["companiesTypes"] = Array(repeating: CompanyType.standard, count: 8) + Array(repeating: CompanyType.g18MEXMinor, count: 3)
            metadata["compTotShares"] = Array(repeating: 10.0, count: 8) + Array(repeating: 2.0, count: 3)
            metadata["predefinedShareAmounts"] = [0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5, 5.5, 6, 6.5, 7, 7.5, 8, 8.5, 9, 9.5, 10]
            metadata["printShareAmountsAsInt"] = false
            metadata["shareStartingLocation"] = ShareStartingLocation.ipo
            metadata["compLogos"] = ["CHI_MEX", "MCR_MEX", "MEX_MEX", "NDM_MEX", "PAC_MEX", "SPM_MEX", "TMR_MEX", "UDY_MEX", "A_MEX", "B_MEX", "C_MEX"]
            metadata["compColors"] = [
                UIColor.fromHex("DD3027"),
                UIColor.fromHex("000000"),
                UIColor.fromHex("B4BBBC"),
                UIColor.fromHex("79A242"),
                
                UIColor.fromHex("FCEA00"),
                UIColor.fromHex("0086C4"),
                UIColor.fromHex("F58121"),
                UIColor.fromHex("5F2384"),
                
                UIColor.fromHex("242B35"),
                UIColor.fromHex("242B35"),
                UIColor.fromHex("242B35")
            ]
            metadata["compTextColors"] = Array(repeating: UIColor.white, count: 4) + Array(repeating: UIColor.black, count: 1) + Array(repeating: UIColor.white, count: 6)
            metadata["totalBankAmount"] = [9000] as [Double]
            metadata["playersStartingMoney"] = [0, 625, 500, 450, 0] as [Double]
            metadata["openCompanyValues"] = [300, 350, 375, 400, 450]
            metadata["gamePARValues"] = [60, 70, 75, 80, 90]
            metadata["PARValueIsIrrelevantToShow"] = false
            metadata["requiredNumberOfSharesToFloat"] = 5
            metadata["tileTokensPriceSuggestions"] = [20, 40, 60]
            metadata["trainPriceValues"] = [100, 180, 300, 450, 600, 700]
            metadata["trainPriceIndexToCloseAllPrivates"] = 3
            metadata["certificateLimit"] = [0, 19, 14, 11, 0] as [Double]
            metadata["shareValues"] = [[60, 55, 50, 45, 40, 30, 20, 10],
                                       [65, 60, 55, 50, 45, 40, 30, nil],
                                       [70, 65, 60, 55, 50, 45, 40, nil],
                                       [75, 70, 65, 60, 55, 50, 45, nil],
                                       [80, 75, 70, 65, 60, 55, 50, nil],
                                       [90, 80, 75, 70, 65, nil, nil, nil],
                                       [100, 90, 80, 75, 70, nil, nil, nil],
                                       [110, 100, 90, 80, 75, nil, nil, nil],
                                       [120, 110, 100, 90, 80, nil, nil, nil],
                                       [130, 120, 110, 100, nil, nil, nil, nil],
                                       [140, 130, 120, 110, nil, nil, nil, nil],
                                       [150, 140, 130, 120, nil, nil, nil, nil],
                                       [165, 150, 140, nil, nil, nil, nil, nil],
                                       [180, 165, 150, nil, nil, nil, nil, nil],
                                       [200, 180, nil, nil, nil, nil, nil, nil]] as [[Double?]]
            metadata["currencyType"] = CurrencyType.dollar
            
            metadata["ipoSharesPayBank"] = true
            metadata["bankSharesPayBank"] = false
            metadata["compSharesPayBank"] = false
            metadata["asideSharesPayBank"] = true
            metadata["tradeInSharesPayBank"] = true
            
            metadata["buyShareFromIPOPayBank"] = true
            metadata["buyShareFromBankPayBank"] = true
            metadata["buyShareFromCompPayBank"] = true
            
            metadata["sharesFromIPOHavePARprice"] = true
            metadata["sharesFromBankHavePARprice"] = false
            metadata["sharesFromCompHavePARprice"] = true
            metadata["sharesFromAsideHavePARprice"] = true
            metadata["sharesFromTradeInHavePARprice"] = true
            
            metadata["unitShareValuePayoutRoundPolicy"] = PayoutRoundPolicy.doNotRound
            metadata["isPayoutRoundedUpOnTotalValue"] = true
            metadata["buySellRoundPolicyOnTotal"] = BuySellRoundPolicy.roundUp
            metadata["isGenerateTrashHidden"] = true
            
            metadata["privatesBuyInModifiers"] = ["0.5x", "1.0x", "1.5x"]
            metadata["privatesLabels"] = (1...7).map { "#\($0)" } as [String]
            metadata["privatesPrices"] = [20, 40, 50, 50, 50, 100, 140] as [Double]
            metadata["privatesIncomes"] = [5, 10, 0, 0, 0, 20, 20] as [Double]
            metadata["privatesMayBeBuyInFlags"] = [true, true, false, false, false, true, false] as [Bool]
            metadata["privatesDescriptions"] = ["Private company. Revenue $5. No special abilities",
                                                "Private company. Revenue $10.\nOnly a major company that owns the KCM&O may lay the \"Copper Canyon\" special tile (number 470).\nThis tile can be laid only in the Copper Canyon hex (F5). It need not be connected to an existing station token of the major company. It does not count toward the major company's normal limit of two yellow tile lays per turn. (But it still must be laid during the tile-laying step of the major company's turn.)\nThe company must pay a reduced terrain cost of $60 (not the $120 it says in the hex) to lay the tile. Laying the tile does not close the KCM&O.\nThe Copper Canyon tile is permanent, and cannot be upgraded. Like any other tile, once played, any company that connects to it can run there.\nIf any other tile is laid in the Copper Canyon hex, or if the Copper Canyon tile has not been laid before the first 5-Train is purchased, the tile is removed from play",
                                                "Minor company. Begins in Tampico (M12).\nWhen Phase 3(1⁄2) begins, the company closes, but its owner receives a 5% “trade-in certificate” of NdM",
                                                "Minor company. Begins in Mazatlán (K6).\nWhen Phase 31⁄2 begins, the company closes, but its owner receives a 5% “trade-in certificate” of NdM",
                                                "Minor company. Begins in Oaxaca (S12).\nWhen Phase 31⁄2 begins, the company closes, but its owner receives a 10% \"trade-in certificate\" of UdY.\nThe Udy share has no value, and cannot be sold until some player has set a market value for the Udy by purchasing its president's certificate. However, the share does not count toward the 50% required to float the United Railways of Yucatán until the Minor company closes",
                                                "Private company. Revenue $20.\nThe initial purchaser of the Mexican International receives a free 10% share of the Chihuahua Pacific Railway (CHI).\nThe CHI share has no value, and cannot be sold, until some player has set a market value for the CHI by purchasing its president's certificate. However, the share does count toward the 50% required to float the Chihuahua Pacific. Once purchased, the Mexican International has no special abilities",
                                                "Private company. Revenue $20.\nThe initial purchaser of the MNR receives the 20% president's certificate of the NdM for free. He must then immediately set the par value of the NdM.\nNote that under Rule 5.1, no one is allowed to buy any further shares of the NdM – and therefore, the purchaser will be unable either to float the NdM, or to sell the president's certificate - until Phase 31⁄2. However, the president's certificate does count toward the 50% required to float the NdM. Once purchased, the MNR has no special abilities.\nUnlike other private companies, the MNR may not be sold to a major company. The MNR closes when the NdM buys its first train"]
            metadata["privatesMayBeVoluntarilyClosedFlags"] = [false, false, true, true, true, false, true]
            metadata["privatesOwnerGlobalIndexes"] = Array(repeating: BankIndex.bank.rawValue, count: 7)
            metadata["privatesLockMoneyIfOutbidden"] = true
            
            metadata["legalActionsPlayers"] = [Int]([ActionMenuType.turnOrder.rawValue, ActionMenuType.tradePrivate.rawValue, ActionMenuType.sellPrivate.rawValue, ActionMenuType.buyShares.rawValue, ActionMenuType.sellShares.rawValue])
            metadata["legalActionsCompanies"] = [Int]([ActionMenuType.buyPrivate.rawValue, ActionMenuType.float.rawValue, ActionMenuType.mail.rawValue, ActionMenuType.buyTrain.rawValue, ActionMenuType.tilesTokens.rawValue, ActionMenuType.operate.rawValue]) + [ActionMenuType.g18MEXCloseMinors.rawValue]
        }
        
        return metadata
    }
    
    func getSetupOperations(forGameState gameState: GameState) -> [Operation] {
        switch self {
            
        case .g1846:
            let miniatureBig4CompOp = Operation(type: .float, uid: nil)
            miniatureBig4CompOp.addCashDetails(sourceIndex: BankIndex.bank.rawValue, destinationIndex: gameState.getGlobalIndex(forEntity: "Big 4"), amount: 40)
            miniatureBig4CompOp.addSharesDetails(shareSourceIndex: gameState.getGlobalIndex(forEntity: "Big 4"), shareDestinationIndex: gameState.getGlobalIndex(forEntity: "Big 4"), shareAmount: 1, shareCompanyBaseIndex: gameState.getBaseIndex(forEntity: "Big 4"))
            let miniatureMSCompOp = Operation(type: .float, uid: nil)
            miniatureMSCompOp.addCashDetails(sourceIndex: BankIndex.bank.rawValue, destinationIndex: gameState.getGlobalIndex(forEntity: "MS"), amount: 60)
            miniatureMSCompOp.addSharesDetails(shareSourceIndex: gameState.getGlobalIndex(forEntity: "MS"), shareDestinationIndex: gameState.getGlobalIndex(forEntity: "MS"), shareAmount: 1, shareCompanyBaseIndex: gameState.getBaseIndex(forEntity: "MS"))
            return [miniatureBig4CompOp, miniatureMSCompOp]
            
        case .g1848:
            let boeSetupOp = Operation(type: .float, uid: nil)
            boeSetupOp.addCashDetails(sourceIndex: BankIndex.bank.rawValue, destinationIndex: gameState.getGlobalIndex(forEntity: "BoE"), amount: 2000.0, isEmergencyEnabled: false)
            return [boeSetupOp]
            
        case .g18MEX:
            let NdMtradeInOp = Operation(type: .setup, uid: nil)
            NdMtradeInOp.addSharesDetails(shareSourceIndex: BankIndex.ipo.rawValue, shareDestinationIndex: BankIndex.tradeIn.rawValue, shareAmount: 2, shareCompanyBaseIndex: 3)
            let UdYtradeInOp = Operation(type: .setup, uid: nil)
            UdYtradeInOp.addSharesDetails(shareSourceIndex: BankIndex.ipo.rawValue, shareDestinationIndex: BankIndex.tradeIn.rawValue, shareAmount: 1, shareCompanyBaseIndex: 7)
            let minorCompAOp = Operation(type: .float, uid: nil)
            minorCompAOp.addCashDetails(sourceIndex: BankIndex.bank.rawValue, destinationIndex: gameState.getGlobalIndex(forEntity: "A"), amount: 0)
            minorCompAOp.addSharesDetails(shareSourceIndex: BankIndex.ipo.rawValue, shareDestinationIndex: gameState.getGlobalIndex(forEntity: "A"), shareAmount: 1, shareCompanyBaseIndex: gameState.getBaseIndex(forEntity: "A"))
            let minorCompBOp = Operation(type: .float, uid: nil)
            minorCompBOp.addCashDetails(sourceIndex: BankIndex.bank.rawValue, destinationIndex: gameState.getGlobalIndex(forEntity: "B"), amount: 0)
            minorCompBOp.addSharesDetails(shareSourceIndex: BankIndex.ipo.rawValue, shareDestinationIndex: gameState.getGlobalIndex(forEntity: "B"), shareAmount: 1, shareCompanyBaseIndex: gameState.getBaseIndex(forEntity: "B"))
            let minorCompCOp = Operation(type: .float, uid: nil)
            minorCompCOp.addCashDetails(sourceIndex: BankIndex.bank.rawValue, destinationIndex: gameState.getGlobalIndex(forEntity: "C"), amount: 0)
            minorCompCOp.addSharesDetails(shareSourceIndex: BankIndex.ipo.rawValue, shareDestinationIndex: gameState.getGlobalIndex(forEntity: "C"), shareAmount: 1, shareCompanyBaseIndex: gameState.getBaseIndex(forEntity: "C"))
            return [NdMtradeInOp, UdYtradeInOp, minorCompAOp, minorCompBOp, minorCompCOp]
        
        case .g1830, .g1840, .g1849, .g1856, .g1882, .g1889, .g18Chesapeake:
            return []
        }
    }
    
    func getPublisherLogo() -> UIImage {
        switch self {
        case .g1830, .g1856:
            return UIImage(named: "mayfair_games") ?? UIImage()
        case .g1840:
            return UIImage(named: "lonny_games") ?? UIImage()
        case .g1846, .g1848:
            return UIImage(named: "gmt_games") ?? UIImage()
        case .g1849, .g1882, .g18Chesapeake, .g18MEX:
            return UIImage(named: "all-aboard_games") ?? UIImage()
        case .g1889:
            return UIImage(named: "grand_trunk_games") ?? UIImage()
//            return UIImage(named: "self_published_games") ?? UIImage()
        }
    }
    
    func getFullTitle() -> String {
        switch self {
        case .g1830:
            return "1830: Railways & Robber Barons"
        case .g1840:
            return "1840: Vienna Tramways"
        case .g1846:
            return "1846: Race for the Midwest"
        case .g1848:
            return "1848: Australia"
        case .g1849:
            return "1849: The game of Sicilian Railways"
        case .g1856:
            return "1856: Railroading in Upper Canada from 1856"
//        case .g1860:
//            return "1860: Railways on the Isle of Wight"
//        case .g1871:
//            return "The old prince 1871"
//        case .g1880:
//            return "1880: China"
        case .g1882:
            return "1882: Assiniboia"
        case .g1889:
            return "Shikoku 1889"
        case .g18Chesapeake:
            return "18Chesapeake"
//        case .g18CZ:
//            return "18CZ"
        case .g18MEX:
            return "18MEX"
        }
    }
    
    func getShortTitle() -> String {
        switch self {
        case .g1830:
            return "1830: Railways & Robber Barons"
        case .g1840:
            return "1840: Vienna Tramways"
        case .g1846:
            return "1846: Race for the Midwest"
        case .g1848:
            return "1848: Australia"
        case .g1849:
            return "1849: The game of Sicilian Railways"
        case .g1856:
            return "1856: Railroading in Upper Canada"
//        case .g1860:
//            return "1860: Railways on the Isle of Wight"
//        case .g1871:
//            return "The old prince 1871"
//        case .g1880:
//            return "1880: China"
        case .g1882:
            return "1882: Assiniboia"
        case .g1889:
            return "Shikoku 1889"
        case .g18Chesapeake:
            return "18Chesapeake"
//        case .g18CZ:
//            return "18CZ"
        case .g18MEX:
            return "18MEX"
        }
    }
    
    func getVeryVeryShortTitle() -> String {
        switch self {
        case .g1830:
            return "1830"
        case .g1840:
            return "1840"
        case .g1846:
            return "1846"
        case .g1848:
            return "1848"
        case .g1849:
            return "1849"
        case .g1856:
            return "1856"
//        case .g1860:
//            return "1860"
//        case .g1871:
//            return "1871"
//        case .g1880:
//            return "1880"
        case .g1882:
            return "1882"
        case .g1889:
            return "1889"
        case .g18Chesapeake:
            return "18Ch"
//        case .g18CZ:
//            return "18CZ"
        case .g18MEX:
            return "18MEX"
        }
    }
    
    func isBGGSuggestedFor3p() -> Bool {
        switch self {
        case .g1840, .g1849, .g1889:
            return true
        case .g1830, .g1846, .g1848, .g1856, .g1882, .g18Chesapeake, .g18MEX:
            return false
        }
    }
    
    func isBGGSuggestedFor4p() -> Bool {
        switch self {
        case .g1830, .g1840, .g1846, .g1848, .g1849, .g1856, .g1882, .g1889, .g18Chesapeake, .g18MEX:
            return true
        }
    }
    
    func isBGGSuggestedFor5p() -> Bool {
        switch self {
        case .g1830, .g1840, .g1856, .g18Chesapeake:
            return true
        case .g1846, .g1848, .g1849, .g1882, .g1889, .g18MEX:
            return false
        }
    }
    
    func getNumberOfPlayers() -> (Int, Int) {
        switch self {
        case .g1830:
            return (2, 7)
        case .g1840:
            return (2, 6)
        case .g1846:
            return (3, 5)
        case .g1848:
            return (3, 6)
        case .g1849:
            return (3, 5)
        case .g1856:
            return (3, 6)
//        case .g1860:
//            return (2, 4)
//        case .g1871:
//            return (3, 4)
//        case .g1880:
//            return (3, 7)
        case .g1882:
            return (2, 6)
        case .g1889:
            return (2, 6)
        case .g18Chesapeake:
            return (2, 6)
//        case .g18CZ:
//            return (3, 6)
        case .g18MEX:
            return (3, 5)
        }
    }
    
    func getRulesTxtPath() -> String {
        return self.rawValue + "_rules"
    }
    
}
