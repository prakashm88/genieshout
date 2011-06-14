package com.itechgenie.chat.util
{
	import com.itechgenie.chat.pages.SettingsPage;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import flashx.textLayout.formats.TextAlign;
	
	import mx.controls.Alert;
	import mx.core.mx_internal;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;

	public class Utility
	{
		public function Utility()
		{
		}
		
		public static function getRGBCode(hexCode:String):String
		{
			if (hexCode.length < 6){
				var colorLength:int = 6-hexCode.length;
				var temp_color:String = '';
				for (var i:int=0; i<colorLength; i++){
					temp_color += '0';
				}
				temp_color += hexCode;
				hexCode = temp_color ;
			} 
			return hexCode ;
		}
		
		public static function goToHomePage(event:Event):void
		{
			var urlRequest:URLRequest =  new URLRequest("http://itechgenie.com/myblog/genieshout") ;
			navigateToURL(urlRequest);
		}
				
		public static function alert(e:*, alertType:String = "Message"):void
		{
			Alert.show(alertType + ": " + e);
		}

	}
}