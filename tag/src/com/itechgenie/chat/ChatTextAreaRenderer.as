package com.itechgenie.chat
{
	import mx.controls.RichTextEditor;
	import mx.core.EdgeMetrics;
	import mx.core.FlexVersion;

	
	public class ChatTextAreaRenderer extends RichTextEditor
	{
		
		public function ChatTextAreaRenderer()
		{
			super();
		}
		
		/**
		 * Static var to indicate top alignment for the control bar.
		 */
		public static const TOP:String = "top";
		
		/**
		 * Static var to indicate bottom alignment for the control bar.
		 */
		public static const BOTTOM:String = "bottom";
		
		/**
		 * @private
		 */
		private var _controlBarPosition:String = ChatTextAreaRenderer.BOTTOM;
		
		[Inspectable(enumeration="top,bottom", defaultValue="bottom")]
		
		/**
		 * Position of the ControlBar element (if one is present). Possible values 
		 * are &apos;top&apos; or &apos;bottom&apos;.
		 */
		public function set controlBarPosition(value:String):void {
			_controlBarPosition = value;
			invalidateDisplayList();
		}
		
		/**
		 * @private
		 */
		public function get controlBarPosition():String {
			return _controlBarPosition;
		}
		
		/**
		 *  @private
		 */
		override protected function layoutChrome(unscaledWidth:Number, unscaledHeight:Number):void {
			super.layoutChrome(unscaledWidth, unscaledHeight);
			
			/* If we&apos;ve got a controlbar, then it&apos;s already been placed at the bottom
			* by the Panel class (when we called super.layoutChrome). So now we move
			* it to the top instead.
			*/
			if(controlBar && _controlBarPosition == ChatTextAreaRenderer.TOP) {
				var headerHeight:Number = getHeaderHeight();
				var bm:EdgeMetrics =
					FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0 ?
					borderMetrics :
					EdgeMetrics.EMPTY;
				
				//we put the controlbar just below the header
				controlBar.move(bm.left,
					headerHeight + bm.top);
			}
		}
		/**
		 * @private  
		 *
		 * We use the viewMetrics of our Panel superclass first, then we modify that a bit.
		 * We check if there&apos;s a control bar visible, if there is then we alter the top and
		 * bottom margins if we&apos;re supposed to show the control bar at the top instead of the
		 * bottom.
		 */
		override public function get viewMetrics():EdgeMetrics
		{
			var vm:EdgeMetrics = super.viewMetrics;
			
			var bt:Number = getStyle("borderThickness");
			var btl:Number = getStyle("borderThicknessLeft");
			var btt:Number = getStyle("borderThicknessTop");
			var btb:Number = getStyle("borderThicknessBottom");
			
			vm.top = (isNaN(btt) ? bt : btt);
			vm.bottom = (isNaN(btb) ? 
				(controlBar && !isNaN(btt) ? btt : isNaN(btl) ? bt : btl) : 
				btb);
			
			var hHeight:Number = getHeaderHeight();
			if (!isNaN(hHeight))
				vm.top += hHeight;
			
			if (controlBar && controlBar.includeInLayout) {
				
				_controlBarPosition == ChatTextAreaRenderer.TOP ?
					vm.top += controlBar.getExplicitOrMeasuredHeight()
					:     vm.bottom += controlBar.getExplicitOrMeasuredHeight();
			}
			
			return vm;
		}

	}
}