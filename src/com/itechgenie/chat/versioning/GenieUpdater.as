package com.itechgenie.chat.versioning
{
	import air.update.ApplicationUpdaterUI;
	import air.update.events.UpdateEvent;
	
	import flash.events.ErrorEvent;
	
	import mx.controls.Alert;

	public class GenieUpdater
	{
		private static var appUpdater:ApplicationUpdaterUI = new ApplicationUpdaterUI();

		public static function checkForUpdate():void {
			trace("Inside Update") ;
			//	setApplicationVersion(); // Find the current version so we can show it below			
			appUpdater.updateURL = "http://localhost/genieshout/update.xml"; // Server-side XML file describing update
			appUpdater.isCheckForUpdateVisible = false; // We won't ask permission to check for an update
			appUpdater.addEventListener(UpdateEvent.INITIALIZED, onUpdate); // Once initialized, run onUpdate
			appUpdater.addEventListener(ErrorEvent.ERROR, onError); // If something goes wrong, run onError
			appUpdater.initialize(); // Initialize the update framework
		}
		
		private static function onError(event:ErrorEvent):void {
			Alert.show(event.toString());
			Alert.show("" + event);
		}
		
		private static function onUpdate(event:UpdateEvent):void {
			appUpdater.checkNow(); // Go check for an update now
		}		
	}
}