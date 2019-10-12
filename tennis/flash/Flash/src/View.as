package 
{	
	import flash.display.Sprite;	

	public class View extends Sprite
	{		
		private var diagonalLength: Number, diagonalAngle: Number, width_:Number;
			
		public function View(width: int, height: int): void
		{								
			diagonalLength = Math.sqrt(width*width + height*height) / 2;			
			diagonalAngle = Math.atan(height / width);
		}
		
		public function showPosition(r: Array, a: Number, type: String): void
		{			
			if (type == 'player')
			{
				a = Math.PI/2;
			}
			
			if (type == 'ball_shadow')
			{
				var res = Perspective.ballShadow(r);
				a = - res[0] * 180 / Math.PI;				
			}
			/*var x =  x - diagonalLength * Math.cos(diagonalAngle - a);
			var y =  - y - diagonalLength * Math.sin(diagonalAngle - a);*/
			var res:Array=Perspective.point(r);
			//this.r=res;
			//this.rotation = - a * 180 / Math.PI;*/
			
			this.x =  res[0] - diagonalLength*scaleX * Math.cos(diagonalAngle - a+Math.PI/2);
			this.y =  res[1] - diagonalLength*scaleX * Math.sin(diagonalAngle - a+Math.PI/2);			
			
			scaleX = Perspective.scale(r);
			scaleY = scaleX;
			
			if (type == 'ball_shadow')
			{
				scaleY = scaleY / 2;			
			}
						
		}
	}	
}