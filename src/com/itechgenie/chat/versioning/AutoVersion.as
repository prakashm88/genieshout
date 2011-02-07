package com.itechgenie.chat.versioning
{
	import flash.display.Loader;
	import flash.external.ExternalInterface;
	import flash.net.SharedObject;
	
	/**
	 * AutoVersion provides versioning information for your SWF files, including 
	 * automatic build number incrementation: a "build number" is incremented every 
	 * time you rebuild your swf file. This is a 100% ActionScript solution, no
	 * third party stuff required, although there is a minor first-time-use setup 
	 * required.
	 * 
	 * The programmer sets the major/minor/revision numbers manually in his
	 * swf file declaration; the build number is automatically generated.
	 * Should the major/minor/revision numbers ever change, the build number
	 * is automatically set back to 0.
	 * 
	 * A running tally of ALL builds since version 0.0.0 is also kept.
	 * 
	 * HOW IT WORKS:
	 *  
	 * At compile time (**not runtime**) the  var EmbeddedVersion will be set to a
	 * ByteArray capture of a SharedObject stored locally on the developer's hard disk,
	 * which contains build# information from the last time he ran this class.
	 * We use SharedObjects because it is a known safe method of writing data to the user's
	 * hard drive using only AS3. We never actually read the SO, at least in the normal
	 * sense.
	 * 
	 * At runtime, this embedded byte stream is analyzed and the proper version 
	 * information is extracted. If the code is running on the developer's machine, 
	 * the build number is automatically updated for the next time he compiles; 
	 * otherwise execution simply terminates.
	 * 
	 * */   
	public class AutoVersion
	{
		
		// ========================================================================
		// Unable to resolve the following line for transcoding? 
		//
		// 1) Comment out the [Embed], compile and run once. 
		// 
		// 2) Locate the AutoVersion.sol file that was just created. This will be located
		//    somewhere in %APP_DATA%\Macromedia\Flash Player\#SharedObjects\[RANDOM]\localhost
		// 
		// 3) Include the absolute path to the folder this file is in under
		//    Project:Properties:Flex Build Path:Source Paths.
		// 
		// 4) Finally Uncomment the line and run again. 
		//
		// You will only need to repeat these steps if source code is compiled on a
		// different machine.
		// ========================================================================
		[Embed(mimeType="application/octet-stream", source="C:/Documents and Settings/prak1728/Application Data/GenieShout/Local Store/#SharedObjects/AutoVersion.sol")]
		private var EmbeddedVersion : Class;
				
		public function AutoVersion(majorVer:int, minorVer:int, revisionVer:int)
		{
			major = majorVer;
			minor = minorVer;
			revision = revisionVer;
			processEmbeddedVersionFile();
			
		}		
		
		private var strSOFile:String = "AutoVersion";
		
		public var major:uint = 0;
		public var minor:uint = 0;
		public var revision:uint = 0;
		public var build:uint = 0;
		public var totalBuilds:uint = 0;
		
		private const tagBegin:String = "<VER>";
		private const tagClose:String = "</VER>";
		private const tagDelim:String = "|";
		
		// ====================================================================
		// READ/WRITE EMBEDDED SHARED OBJECT
		// The last time this swf was compiled, we embedded a SharedObject file
		// from the developer's computer. In this section we analyze the SO
		// file to determine what we should do.
		// ====================================================================
		private function processEmbeddedVersionFile():void {
			var result:String = "";
			
			//--------------------------------------------------------------------------
			// Read whats already there...
			//--------------------------------------------------------------------------
			try {
				// Attempt to load and read the embedded file. If we can't, no harm, no foul.
				var fileByteArray:Object = new EmbeddedVersion();
				
				// Convert non-control chars from the byte stream into strings and concatenate:
				for(var i:uint = 0 ; i < fileByteArray.length; i++){
					result += ((fileByteArray[i]> 14) ? (String.fromCharCode(fileByteArray[i])) : "");
				}
				
				// Look for our tags so we can find the data:
				var begin:int = result.indexOf(tagBegin) + tagBegin.length;
				var close:int = result.indexOf(tagClose);
				result = result.substring(begin, close);
				var embeddedData:Array = result.split(tagDelim);
				
				if(embeddedData.length > 0) {
					
					// These are simply for comparison: Has the version changed since
					// the last compile?
					var embeddedMajor:int = embeddedData[0];
					var embeddedMinor:int = embeddedData[1];
					var embeddedRevision:int = embeddedData[2];
					
					// These guys are what we really want:
					build = embeddedData[3];
					totalBuilds = embeddedData[4];    
					
					if ( (major!=embeddedMajor) || (minor!=embeddedMinor) || (revision!=embeddedRevision) ){
						// programmer has updated the version number of this swf
						// so reset build number to zero. totalBuilds won't change however.
						build = 0;
					}
					
					//--------------------------------------------------------------------------
					// Update build numbers...
					//--------------------------------------------------------------------------
					// The build number/totalBuilds is always going to be one more than what 
					// was written the last time we compiled:
					build++;
					totalBuilds++;  
				}
				
			} catch(err:Error) {
				// Most likely the file is missing or commented out; this is ok.
				if(err.errorID==1007){
					// Instantiation attempted on a non-constructor.
					// This happens when the EMBED is commented out on the first run...
					//... its an acceptable error.
					trace("Prepping AutoVersion for First Run.. you should uncomment EMBED now.");
				} else {
					trace("AutoVersion Error in processEmbeddedVersionFile:\n" + err);
				}
			}      
			//--------------------------------------------------------------------------
			// Write the build numbers for next time
			// if this is the developers machine, write out the SO file so we can pull
			// it for the next compile.
			//--------------------------------------------------------------------------
			try {
				var pathFromServerRoot:String = "/"
				var mySO:SharedObject = SharedObject.getLocal(strSOFile, pathFromServerRoot);
				mySO.data.version = toParserString();
				trace("Writing out:" + mySO.data.version)
				mySO.flush();
			} catch(err:Error){
				if(err.errorID==2134){
					// localpath was invalid: this is the path of the swf fromthe SERVER ROOT.
					// Usually leave this as "/"
					trace("Server path '" + pathFromServerRoot + "' was invalid.");
				}
			}   
		}
		
		
		// ====================================================================
		// Formatters
		// ====================================================================
		/**
		 * Returns a formatted string representing the current version and build number.
		 * 
		 * Examples: 1.0, 1.01, 1.02, 1.03.01, 1.03.02, 1.0.01 r0027
		 * */
		public function toString():String {
			var result:String = major + ".";    
			result += minor ? zeroPad(minor, 2) : "0";
			result += revision ? ("." + zeroPad(revision, 2)) : "";
			result += build ? " r" + zeroPad(build, 3) : "";    
			return result;
		}
		
		/**
		 * To avoid the need to build a parser, we cheat a little and simply search for "<VER>"
		 * in the Binary file we have loaded, knowing the info we want will be in there, in 
		 * the format we find here in this function.
		 * */
		private function toParserString():String {
			var result:String = tagBegin 
			result+= major + tagDelim  
			result+= minor + tagDelim  
			result+= revision + tagDelim  
			result+= build + tagDelim  
			result+= totalBuilds 
			result+= tagClose; 
			return result;
		}
		
		private function zeroPad(number:int, width:int):String { 
			var ret:String = ""+number; 
			while( ret.length < width ) 
				ret="0" + ret; 
			return ret; 
		} 
		
	}

}