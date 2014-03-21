package  com.ablesky.vcore.ui
{
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author szhang
	 */
	public class Dialog extends Component 
	{
		private var ok:PushButton = new PushButton();
		private var dialogpanel:Panel = new Panel();
		private var imask:Shape = new Shape();
		private var label:TextField = new TextField();
		private var _signal:Signal = new Signal();
		public function Dialog(parent:DisplayObject) 
		{
			ok.label = "确认";
			parent = parent;
			this.addEventListener(Event.RESIZE, onSize);
			ok.addEventListener(MouseEvent.CLICK, onClick);
			var tf:TextFormat = new TextFormat();
			tf.align = TextFormatAlign.CENTER;
			label.defaultTextFormat = tf ;
			
		}
		
		private function onClick(e:MouseEvent):void
		{
			if (imask && stage.contains(imask))
			{
				stage.removeChild(imask);
			}
			if (dialogpanel && stage.contains(dialogpanel))
			{
				stage.removeChild(dialogpanel);
			}
			_signal.dispatch("close");
		}
		private function onOKMouseClick(e:MouseEvent):void
		{


		}
		
		
		public function popup(msg:String):void
		{

			stage.addChild(imask);
			label.text = msg ;
			dialogpanel.width = _width;
			dialogpanel.height = _height;
			dialogpanel.addChild(label);
			dialogpanel.addChild(ok);
			stage.addChild(dialogpanel);

			dialogpanel.x = stage.stageWidth / 2 - dialogpanel.width / 2;
			dialogpanel.y = stage.stageHeight / 2 - dialogpanel.height / 2;
			ok.x = _width / 2 - ok.width / 2;
			ok.y = _height - ok.height - 20 ;
			label.x = _width / 2 - dialogpanel.width / 2;
			label.y = ok.y - 30 ;
		}
		
		
		private function onSize(e:Event):void
		{
			if ( parent.stage)
			{
				imask.graphics.clear();
				imask.graphics.beginFill(0x000000, 0.1);
				imask.graphics.drawRect(0, 0, parent.stage.stageWidth, parent.stage.stageHeight);
				imask.graphics.endFill();				
				dialogpanel.x = stage.stageWidth / 2 - dialogpanel.width / 2;
				dialogpanel.y = stage.stageHeight / 2 - dialogpanel.height / 2;					
			}

			
			dialogpanel.width = _width;
			dialogpanel.height = _height;
			label.width = dialogpanel.width;

			ok.x = _width / 2 - ok.width / 2;
			ok.y = _height - ok.height - 20 ;
		}
		
		public function get signal():Signal 
		{
			return _signal;
		}
		
	}

}