package Game.Rally.MiddleLines
{
	
	import flash.display.Sprite;
	import Game.Rally.Scale.Scale;
	
	public class MiddleLines
	{		
		private var h:Number = 1;
		public var lines: Array;
		public var view: Sprite;
		public var centralLine: Array;
		public var x:Number = 0;
		
		public function MiddleLines()
		{
			this.x = x;
			
			lines = 
			[
				0, Scale.convertY(-h)+1,
				0, Scale.convertY(h)-1
			];				
			
			//view
			view = new Sprite();			
			viewPaint(true);			
		}
		
		//view
		private function viewPaint(show: Boolean): void
		{			
			view.graphics.lineStyle(1, 0x80bb80, show ? 1 : 0);				
			view.graphics.moveTo(lines[0], lines[1]); 
			view.graphics.lineTo(lines[2], lines[3]);			
		}
		
		public function hit(player: int, x: Number)
		{
			this.x = ((x > 0) ? Math.max(0, Math.min(475, x)) : Math.min(Math.max( -475, x))) * (75 / 475);
			view.x = this.x;
		}
		
		/*public function ballPos(x: int): void
		{
			view.x = ((x > 0) ? Math.min(475, x) : Math.max( -475, x)) * (75 / 475);
		}*/
	}

}