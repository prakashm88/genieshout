package com.itechgenie.chat.vo
{	
	public class GenieShoutVO
	{
		private var  _id:int;
		private var  _userName:String;
		private var  _groupName:String;
		private var  _machineID:String;
		private var  _showMachineID:String;
		private var  _showTime:String;
		private var  _machineIP:String;
		private var  _serverIP:String;
		private var  _textColor:String;
		private var  _remLogin:String ;
		private var _lastLogged:String;
		
		public function get remLogin():String
		{
			return _remLogin;
		}

		public function set remLogin(value:String):void
		{
			_remLogin = value;
		}

		public function get lastLogged():String
		{
			return _lastLogged;
		}

		public function set lastLogged(value:String):void
		{
			_lastLogged = value;
		}	
		
		public function get textColor():String
		{
			return _textColor;
		}
		
		public function set textColor(value:String):void
		{
			_textColor = value;
		}
		
		public function get serverIP():String
		{
			return _serverIP;
		}
		
		public function set serverIP(value:String):void
		{
			_serverIP = value;
		}
		
		public function get machineIP():String
		{
			return _machineIP;
		}
		
		public function set machineIP(value:String):void
		{
			_machineIP = value;
		}
		
		public function get showTime():String
		{
			trace("showTime - get") ;
			return _showTime;
		}
		
		public function set showTime(value:String):void
		{
			trace("showTime - set") ;
			_showTime = value;
		}
		
		public function get showMachineID():String
		{
			trace("showId - get") ;
			return _showMachineID;
		}
		
		public function set showMachineID(value:String):void
		{
			trace("showId - set") ;
			_showMachineID = value;
		}
		
		public function get machineID():String
		{
			return _machineID;
		}
		
		public function set machineID(value:String):void
		{
			_machineID = value;
		}
		
		public function get groupName():String
		{
			return _groupName;
		}
		
		public function set groupName(value:String):void
		{
			_groupName = value;
		}
		
		public function get userName():String
		{
			return _userName;
		}
		
		public function set userName(value:String):void
		{
			_userName = value;
		}
		
		public function get id():int
		{
			return _id;
		}
		
		public function set id(value:int):void
		{
			_id = value;
		}
		
	}
}