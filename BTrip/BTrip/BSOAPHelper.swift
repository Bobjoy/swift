//
//  BSOAPHelper.swift
//  BTrip
//
//  Created by Vetech on 15/6/8.
//  Copyright (c) 2015年 BFL. All rights reserved.
//

import UIKit
import Alamofire

//定义接口类型
enum Type: String {
    case BASE_DATA = "B2CBaseDataWebService"             //基础数据
    case TICKET = "B2CTicketWebService"                  //机票
    case HOTEL = "B2CHotelWebService"                    //酒店
    case TRAIN = "TrainTicketWebService"                 //火车票
    case MEMBER = "B2CMemberWebService"                  //会员
    case NEWS_PHOTOS = "B2CNewsPhotosWebService"         //新闻图片
    case PAYMENT = "B2CPaymentWebService"                //支付
    case TOURISM = "VetechAsmsTripWebService"            //"B2CTourismWebService"; //旅游
    case NEW_TOURISM = "B2CTourismWebService"            //旅游接口
    case CPS_TICKET = "B2CTicketCPSWebService"           //CPS飞机票
    case CHECKIN = "B2CCheckinWebService"                 //网上值机
    case FLIGHT_SCHEDULE = "B2CFlightDynamicWebService"  //航班动态
    case PAYMENTNEW = "B2CNewPayWebService"               //新支付接口
}

typealias CallBack = (data: NSDictionary?, error: NSError?) -> ()

protocol BSOAPHelperDelegate {
    func completeRequest(data: NSString, error: NSError?)
}

class BSOAPHelper: NSObject, NSXMLParserDelegate {
    
    private var elementName: NSString!
    private var data = ""
    
    var delegate: BSOAPHelperDelegate?
    
    // 请求前执行制定的函数
    func beforeRequest(before: ()->()) -> BSOAPHelper {
        before()
        return self
    }
    
    // 查询机票
    func searchTicket(method: String, request: String) -> BSOAPHelper {
        self.execute(Type.CPS_TICKET, method: method, xml: request)
        return self
    }
    
    // 会员
    func member(method: String, request: String) -> BSOAPHelper {
        self.execute(Type.MEMBER, method: method, xml: request)
        return self
    }
    
    private func execute(type: Type, method: String, xml: String) {
        // 请求相关的参数
        let account = "XYJADMIN"
        let urlString = "http://192.168.1.69:8150/services/\(type.rawValue)"
        var soapMessage = "<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><\(method)><in0>\(account)</in0><in1>%@</in1><in2>%@</in2></\(method)></soap:Body></soap:Envelope>"
        let key = "wuhve090"
        let md5 = ((account + key.md5()).md5() + xml + "VETRIP_B2C").md5()
        let requestBody = NSString(format: soapMessage, md5, "<![CDATA[\(xml)]]>").dataUsingEncoding(NSUTF8StringEncoding)!
        
        // 封装请求体
        var request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        request.addValue("application/soap+xml; charset=utf-8", forHTTPHeaderField:"Content-Type")
        request.addValue("\(urlString)/searchTicket", forHTTPHeaderField: "SOAPAction")
        request.addValue("gzip,deflate,sdch", forHTTPHeaderField: "Accept-Encoding") // 压缩
        request.HTTPMethod = "POST"
        request.HTTPBody = requestBody
        
        Alamofire.request(request).responseString{ (_, _, data, error) -> Void in
            println(error)
            if let resData = data {
                var xmlParser = NSXMLParser(data: resData.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
                xmlParser.delegate = self
                xmlParser.parse()
            }
            self.delegate?.completeRequest(self.data, error: error)
        }
    }
    
    func parserDidStartDocument(parser: NSXMLParser) {
        self.elementName = ""
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject]) {
        self.elementName = elementName
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String?) {
        if self.elementName.isEqualToString("ns1:out") || self.elementName.isEqualToString("faultstring") {
            self.data += string!
        }
    }
    
}
