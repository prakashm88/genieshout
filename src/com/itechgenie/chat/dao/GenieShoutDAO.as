package com.itechgenie.chat.dao
{
	import com.itechgenie.chat.vo.GenieShoutVO;
	import com.itechgenie.chat.util.Utility;
	
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.events.Event;
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;

	public class GenieShoutDAO
	{
		private var _sqlConn:SQLConnection = null ;
		private var dp:ArrayCollection ;
		private static var dbFile:File = File.applicationStorageDirectory.resolvePath("genieshout.db");		

		private function sqlConn():SQLConnection
		{			
			if(_sqlConn == null || !_sqlConn.connected)
			{
				_sqlConn = new SQLConnection();
				_sqlConn.open(dbFile);
			}		
			return _sqlConn;
		}
		
		private function closeConn():void
		{
			if(_sqlConn.connected) _sqlConn.close();
		}
		
		public function createShoutDB():void
		{
			var sqlStmt:SQLStatement = new SQLStatement();
			sqlStmt.sqlConnection = sqlConn();
			sqlStmt.text = "CREATE TABLE IF NOT EXISTS genieshout ( id INTEGER PRIMARY KEY AUTOINCREMENT, userName TEXT, remLogin TEXT, groupName TEXT, machineID TEXT, showMachineID TEXT, showTime TEXT, machineIP TEXT, serverIP TEXT, textColor TEXT, lastLogged TEXT ); CREATE TABLE IF NOT EXISTS temp(id INTEGER PRIMARY KEY AUTOINCREMENT, ipAddress TEXT); ";
			sqlStmt.execute();
			closeConn();		
		}
		
		public function createIPDB():void{	
			var sqlStmt:SQLStatement = new SQLStatement();
			sqlStmt.sqlConnection = sqlConn();
			sqlStmt.text = "CREATE TABLE IF NOT EXISTS ipData(id INTEGER PRIMARY KEY AUTOINCREMENT, ipAddress TEXT, autoUpdate INTEGER); ";
			sqlStmt.execute();
			closeConn();		
		}
		
		public function getIPData():Object{
			var queryString:String = "select * from ipData where id=1 ; ";  			
			var dataArray:ArrayCollection = getAllUsers( queryString ) ;
			var ipData:Object = null;
			if (dataArray.length != 0)
			{
				ipData = dataArray[0] ;	
			}
			return ipData;
		}
		
		public function insertOrUpdateIP(ipAddress:String, autoUpdate:int):void
		{
			trace("Inside inserOrUpdate: " + ipAddress + " - autoUpdate: " + autoUpdate) ;
			var sqlStmt:SQLStatement ; 
			var queryString:String ;
			sqlStmt = new SQLStatement();
		
			if(null == getIPData())
			{
				queryString = "INSERT INTO ipData (ipAddress, autoUpdate) VALUES('"+ ipAddress +"', "+ autoUpdate +");";				
			}
			else
			{
				queryString = "Update ipData set ipAddress ='"+ ipAddress +"', autoUpdate = " + autoUpdate + " where id= 1 ;";
			}
			
			trace(queryString) ;
			sqlStmt.sqlConnection = sqlConn();
			sqlStmt.text = queryString ;			
			sqlStmt.execute();
			closeConn();				
		}
		
		public function insertData1(genieShoutVO:GenieShoutVO):Boolean
		{
			var flag:Boolean = false;
			var sqlStmt:SQLStatement ; 
			var queryString:String;
			try
			{
			sqlStmt = new SQLStatement();
			queryString = "INSERT INTO genieshout (userName, remLogin, groupName, machineID, showMachineID, showTime, machineIP, serverIP, textColor) VALUES('"+
				genieShoutVO.userName +"','"+
				genieShoutVO.remLogin +"','"+
				genieShoutVO.groupName +"','"+
				genieShoutVO.machineID +"','"+
				genieShoutVO.showMachineID +"','"+
				genieShoutVO.showTime +"','"+
				genieShoutVO.machineIP +"','"+
				genieShoutVO.serverIP +"','"+
				genieShoutVO.textColor +"');"; 
			trace("queryString: " + queryString) ;
			sqlStmt.sqlConnection = sqlConn();
			sqlStmt.text = queryString ;			
			sqlStmt.execute();
			closeConn();
			flag = true;
			}
			catch(e:Error)
			{
				Utility.alert(e);
			}
			return flag;
		}
		
		public function getAllUsers(queryString:String):ArrayCollection
		{		
			var sqlStmt:SQLStatement  = new SQLStatement();
			trace("queryString: " + queryString) ;
			sqlStmt.sqlConnection = sqlConn();
			sqlStmt.text = queryString ;			
			sqlStmt.execute();
			var tempColn:ArrayCollection = new ArrayCollection(sqlStmt.getResult().data) ;
			closeConn();
			return tempColn ;			
		}
		
		public function getUserByName(userName:String, machineID:String, machineIP:String, serverIP:String):GenieShoutVO{
			
			var queryString:String = "select * from genieshout where userName='"+userName+"' and machineID='"+machineID+"' and machineIP='"+machineIP+"'and serverIP='"+serverIP+"'" ;			
			var dataArray:ArrayCollection = getAllUsers( queryString ) ;
			var genieShoutVO:GenieShoutVO  = null;
			if (dataArray.length != 0)
			{
				var tempVo:Object = dataArray[0] ;					
				genieShoutVO = new GenieShoutVO;
				genieShoutVO.id = tempVo.id ;
				genieShoutVO.groupName = tempVo.groupName ;
				genieShoutVO.lastLogged = tempVo.lastLogged ;
				genieShoutVO.machineID = machineID;
				genieShoutVO.machineIP = machineIP ;
				genieShoutVO.serverIP = serverIP ;
				genieShoutVO.showMachineID = tempVo.showMachineID ;
				genieShoutVO.showTime = tempVo.showTime ;
				genieShoutVO.textColor = tempVo.textColor ;
				genieShoutVO.userName = tempVo.userName ;
				genieShoutVO.remLogin = tempVo.remLogin ;
			}
			return genieShoutVO;
		}
		
		public function changeAllStatus():void
		{
			var sqlStmt:SQLStatement = new SQLStatement(); ; 
			var updateQuery:String = "update genieshout set lastLogged = '0' where id is not NULL" ;
			sqlStmt.sqlConnection = sqlConn();
			sqlStmt.text = updateQuery ;			
			sqlStmt.execute();
			closeConn();
		}
		
		public function getLastLoggedUser(machineID:String, machineIP:String, serverIP:String):GenieShoutVO
		{
			var queryString:String = "select * from genieshout where machineID='"+machineID+"' and machineIP='"+machineIP+"'and serverIP='"+serverIP+"'" ;
			
			var dataArray:ArrayCollection = getAllUsers( queryString ) ;
			
			if (dataArray.length != 0)
			{
				for(var itr:int = 0 ; itr < dataArray.length; itr++ )
				{
					var tempVo:Object = dataArray[itr] ;					
					if(tempVo.lastLogged == "1")
					{
						var genieShoutVO:GenieShoutVO  = new GenieShoutVO(); 
						genieShoutVO.id = tempVo.id ;
						genieShoutVO.groupName = tempVo.groupName ;
						genieShoutVO.lastLogged = tempVo.lastLogged ;
						genieShoutVO.machineID = machineID;
						genieShoutVO.machineIP = machineIP ;
						genieShoutVO.serverIP = serverIP ;
						genieShoutVO.showMachineID = tempVo.showMachineID ;
						genieShoutVO.showTime = tempVo.showTime ;
						genieShoutVO.textColor = tempVo.textColor ;
						genieShoutVO.userName = tempVo.userName ;
						genieShoutVO.remLogin = tempVo.remLogin ;
						return genieShoutVO ;
					}
						
				}
			}
			return new GenieShoutVO;
		}
			
		public function insertOrUpdateData(genieShoutVO:GenieShoutVO):void
		{
			var flag:Boolean = false;
			var sqlStmt:SQLStatement ; 
			var queryString:String ;
			sqlStmt = new SQLStatement();
	
			trace("User Id: " + genieShoutVO.id) ;
			
			if(genieShoutVO.id == 0)
			{
				queryString = "INSERT INTO genieshout (userName, remLogin, groupName, machineID, showMachineID, showTime, machineIP, serverIP, textColor, lastLogged) VALUES('"+
						genieShoutVO.userName +"','"+
						genieShoutVO.remLogin +"','"+
						genieShoutVO.groupName +"','"+
						genieShoutVO.machineID +"','"+
						genieShoutVO.showMachineID +"','"+
						genieShoutVO.showTime +"','"+
						genieShoutVO.machineIP +"','"+
						genieShoutVO.serverIP +"','"+
						genieShoutVO.textColor +"','1');";				
			}
			else
			{
				queryString = "Update genieshout set userName ='"+ 
						genieShoutVO.userName +"'," + " remLogin= '"+
						genieShoutVO.remLogin +"', groupName = '"+
						genieShoutVO.groupName +"', machineID ='"+
						genieShoutVO.machineID +"', showMachineID = '"+
						genieShoutVO.showMachineID +"', showTime ='"+
						genieShoutVO.showTime +"', machineIP = '"+
						genieShoutVO.machineIP +"', serverIP ='"+
						genieShoutVO.serverIP +"', textColor = '"+
						genieShoutVO.textColor +"', lastLogged = '"+
						genieShoutVO.lastLogged +"' where id=" + genieShoutVO.id + " ;";
			}
			
			trace(queryString) ;
			sqlStmt.sqlConnection = sqlConn();
			sqlStmt.text = queryString ;			
			sqlStmt.execute();
			closeConn();				
		}
		
	}
}