package com.etherpros.components
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	import mx.controls.Label;
	import mx.core.UIComponent;
	
	import spark.components.Group;
	
	public class RigSprite extends Group
	{
		private const LABEL_PADDING:Number = 10;
		
		private var s:Sprite = new Sprite();
		private var g:Graphics;		
		private var _width:int;
		private var _height:int;
		
		public var color:int;
		public var nameLabel:Label;
		
		
		public function RigSprite(color:int, name:String) {
			super();			
			this.color = color;			
			this.g = s.graphics;
			
			// instantiate sprite and add it to the stage.
			var container:UIComponent = new UIComponent();
			container.addChild(s);
			addElement(container);
			
			// instantate rig driver name and add to stage.
			createNameLabel(name);
			addElement(nameLabel);
			
			// draw graphics!
			draw();
		}

		/** Creates label with name of the rig driver **/
		private function createNameLabel(name:String):void {
			nameLabel = new Label();
			nameLabel.setStyle('color', '#ffffff');
			nameLabel.setStyle('fontWeight', 'bold');
			nameLabel.setStyle('fontSize', '11');
			nameLabel.x = LABEL_PADDING;			
			// set the label to the staff name
			nameLabel.text = name;	
		}
		
		/** Redraws the graphics of the rig sprite. Used for updating the view
		 *  with changes to the width or height of the component **/		
		public function draw():void {			
			// clear out old graphics.			
			g.clear();
			
			//re-paint
			g.beginFill(color);
			g.drawRoundRect(0,0, width, height, 15);
			g.endFill();	
		}
		
		override public function set width(value:Number):void {
			super.width = value;			
			_width = value;
			nameLabel.width = width - (LABEL_PADDING * 2)
			draw();
		}
		
		override public function get width():Number {
			return _width;
		}
		
		override public function set height(value:Number):void {
			super.height = value;
			_height = value;
			draw();
		}
		
		override public function get height():Number {
			return _height;
		}
	
	}
}