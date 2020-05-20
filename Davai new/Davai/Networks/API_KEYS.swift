//
//  Constants.swift
//  Marriott-Aruba
//
//  Created by Apple on 3/24/19.
//  Copyright © 2019 Mariam. All rights reserved.
//

import Foundation


class Constant {
    
    static let BASE_URL = "http://104.248.175.110/api/user/"
    static let SING_UP_URL = "http://104.248.175.110/api/user/register"
    static let COUNTRIES_URL = "http://104.248.175.110/api/user/countries"
    static let CITIES_URL = "http://104.248.175.110/api/user/citiesById?countryID="
    static let CATEGORIES = "http://104.248.175.110/api/user/Category"
    static let SERVICES_BY_CATEGORY_ID = "http://104.248.175.110/api/user/servicesByCategoryID?categoryID="
    static let UPLOAD_IMG_URL = "http://104.248.175.110/api/user/uploadFile?imgPath="
    static let CHECK_EMAIL_EXIST = "http://104.248.175.110/api/user/getUserByEmail?email="
    static let SIGN_IN = "http://104.248.175.110/api/user/login"
    static let FORGET_PASSWORD = "http://104.248.175.110/api/user/forgetPassword?email="
    static let ADS_URL = "http://104.248.175.110/api/user/ads"
    static let USER_FAVORITE = "http://104.248.175.110/api/user/userFav?id="
    static let VENDOR_BY_ID = "http://104.248.175.110/api/user/getClientByID?id="
    static let ADD_FAV = "http://104.248.175.110/api/user/userFav"
    static let RATE = "http://104.248.175.110/api/user/ratePlace"
    static let DELETE_FAV = "http://104.248.175.110/api/user/deleteFav?userID="
    static let TOTAL_CLIENT_FAV = "http://104.248.175.110/api/user/totalClientFav?clientID="
    static let CLIENT_BY_CATEGORY_ID = "http://104.248.175.110/api/user/clientByCategoryID?categoryID="
    static let CLIENT_SERVICES = "http://104.248.175.110/api/user/clientServices?clientID="
    static let RESERVE_SERVICE = "http://104.248.175.110/api/user/booking"
    static let USER_PROFILE = "http://104.248.175.110/api/user/getUserByID?id="
   
    static let UPDATE_USER_INFO = "http://104.248.175.110/api/user/user/"
    static let USER_NOTIFICATION = "http://104.248.175.110/api/user/userNotify?id="
    static let USER_CHAT_LIST = "http://104.248.175.110/api/user/getUserChat?userID="
    static let USER_HISTORY_CHAT = "http://104.248.175.110/api/user/getChatHistory?userID="
     static let CRATE_CHAT__CHANNEL = "http://104.248.175.110/api/user/startChat"
    static let CONTACT_US = "http://104.248.175.110/api/user/contactUS"
    static let SETTING = "http://104.248.175.110/api/user/setting"
    static let ABOUT = "http://104.248.175.110/api/user/"
    static let ABOUT_VIDEO = "http://104.248.175.110/api/user/adsVideo"
    static let CLIENTS = "http://104.248.175.110/api/user/clients"
    static let USER_ORDERS = "http://104.248.175.110/api/user/getUserBooking?userID="
    static let CLIENT_SIGN_UP = "http://104.248.175.110/api/user/client"
    static let CLIENT_CHAT_LIST = "http://104.248.175.110/api/user/getClientChat?clientID="
    static let UPDATE_CLIENT = "http://104.248.175.110/api/user/client/"
    static let VENDOR_NOTIFICATION = "http://104.248.175.110/api/user/clientNotify?id="
    static let VENDOR_ORDERS = "http://104.248.175.110/api/user/getClientBooking?clientID="
    static let ORDER_DETAIL = "http://104.248.175.110/api/user/getBookingServices?bookingID="
    static let GET_SERVICES_BY_ID = "http://104.248.175.110/api/user/clientServices?clientID="
    static let CANCEL_ORDER = "http://104.248.175.110/api/user/"
    static let UPDATE_ORDER = "http://104.248.175.110/api/user/"
    static let CREATE_ADS = "http://104.248.175.110/api/user/clientAds"
    static let get_categories = "http://104.248.175.110/api/user/getCategoryByID?"
}
