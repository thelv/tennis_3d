package 
{
	import Game.Game;
	import flash.display.Graphics;
	
	public class Perspective 
	{
		//public static var r0:Array=[-900, 0, 300], k:Number=1000;
		//public static var r0:Array, r00:Array = [ -1100, 0, 400], k:Number = 1400;// , x0:Number, y0:Number;
		public static var r0:Array, r00:Array = [ -700, 0, /*150*/300], k:Number = 1200;// , x0:Number, y0:Number;
		
		public function Perspective() 
		{
			
		}
		
		public static function scale(r: Array)
		{
			return k / Math.sqrt(Math.pow(r[0]-r0[0],2)+Math.pow(r[1]-r0[1],2)+Math.pow(r[2]-r0[2],2));
		}
		
		public static function point(r:Array):Array
		{
			
			try {
				var a:Number = Game.Game.game.rally.player1.a-Math.PI/2;	
				r0 = [Game.Game.game.rally.player1.x-/*300*/600*Math.cos(a), r00[1] + Game.Game.game.rally.player1.y-/*300*/600*Math.sin(a), r00[2]];								
			}
			catch (e)
			{
				var a = 0;
				r0 = r00.concat();
			}
			//Main.jsLog(r[0]);
			//Main.jsLog(r[1]);
			var x:Number=r[0]-r0[0];
			var y:Number = r[1] - r0[1];
			
			var x_ = x * Math.cos(a) + y * Math.sin(a)
			var y_ = -x * Math.sin(a) + y * Math.cos(a)
			x = x_;
			y = y_;
			
			var z:Number=r[2]-r0[2];
			var l:Number=Math.sqrt(Math.pow(y, 2)+Math.pow(z, 2));
			if(l==0) return [0, 0];
			/*var l_:Number=k*Math.log
			(
				(
					Math.sqrt(Math.pow(x, 2)+Math.pow(l, 2))
					+l
				)
				/
				x
			);*/
			var l_1 =  k * Math.atan(l / x );
				var l_2 = k * l / x;
				var l_ = (l_1 * 6 + l_2 * 3) / 9;
				
			var a1 = Math.atan(l / x ) ;
			var a2 = Math.asin(Math.sin(a1) * 4 / 5);
			var l_ = k * 80 * (l / x - (l / x * 79 / 80));//Math.sin(a3);
			var l_ = k * 5 * Math.sin(a1 - a2);// Math.sin(a1 - a2);//Math.sin(a3);
			
			
			
			
			var x_:Number=-y*l_/l;
			var y_:Number=-z*l_/l;
			
		/*	var l:Number=Math.sqrt(Math.pow(y, 2));
			if(l==0) return [0, 0];
			var l_:Number=k*Math.log
			(
				(
					Math.sqrt(Math.pow(x, 2)+Math.pow(l, 2))
					+l
				)
				/
				x
			);
			var x_:Number=-y*l_/l;
			
			
			var l:Number=Math.sqrt(Math.pow(z, 2));
			if(l==0) return [0, 0];
			var l_:Number=k*Math.log
			(
				(
					Math.sqrt(Math.pow(x, 2)+Math.pow(l, 2))
					+l
				)
				/
				x
			);*/
			var y_:Number=-z*l_/l;
			
			//Main.jsLog(x_);
			//Main.jsLog(y_);
			return [x_, y_];
		}			
		
		/*public static function graphicsMoveTo(graphics:Graphics, x:Number, y:Number)
		{
			var res:Array=Perspective.point([x, y, 0]);
			graphics.moveTo(res[0], res[1]);
		}
		
		public static function graphicsLineTo(graphics:Graphics, x:Number, y:Number)
		{
			var res:Array=Perspective.point([x, y, 0]);
			
			graphics.lineTo(res[0], res[1]);
		}*/
		
		public static function graphicsMoveTo(graphics:Graphics, x:Number, y:Number)
		{
			//graphics.moveTo(res[0], res[1]);
			//var res:Array=Perspective.point([x, y, 0]);			
			//x0=x;
			//y0=y; 
		}
		
		public static function graphicsLineTo(graphics:Graphics, x0:Number, y0:Number, x:Number, y:Number, parts:int=1)
		{						
			if (x < x0) 
			{
				var m:Number = x;
				x = x0;
				x0 = m;
				
				var m:Number = y;
				y = y0;
				y0 = m;
			}			
			var dx:Number = (x - x0) / parts;
			var dy:Number = (y - y0) / parts;
			while ((x0+dx/2 <= x) && ((y0+dy/2-y)*dy<=0))
			{						
				var xy:Array = Perspective.point([x0, y0, 0]);
				graphics.moveTo(xy[0], xy[1]);
				x0 += dx;
				y0 += dy;
				var xy:Array = Perspective.point([x0, y0, 0]);
				graphics.lineTo(xy[0], xy[1]);				
			}
		}
		
		public static function ballShadow(r:Array)
		{ return [1, 1];
			try {
				var a:Number = Game.Game.game.rally.player1.a-Math.PI/2;	
				r0 = [Game.Game.game.rally.player1.x-300*Math.cos(a), r00[1] + Game.Game.game.rally.player1.y-300*Math.sin(a), r00[2]];								
			}
			catch (e)
			{
				var a = 0;
				r0 = r00.concat();
			}
			//Main.jsLog(r[0]);
			//Main.jsLog(r[1]);
			var x:Number=r[0]-r0[0];
			var y:Number = r[1] - r0[1];
			
			var x_ = x * Math.cos(a) + y * Math.sin(a)
			var y_ = -x * Math.sin(a) + y * Math.cos(a)
			x = x_;
			y = y_;
			
			var z:Number=r[2]-r0[2];
			var l:Number=Math.sqrt(Math.pow(y, 2)+Math.pow(z, 2));
			if(l==0) return [0, 0];
			/*var l_:Number=k*Math.log
			(
				(
					Math.sqrt(Math.pow(x, 2)+Math.pow(l, 2))
					+l
				)
				/
				x
			);*/
			var l_ =  k * Math.atan(l / x );
			var x_:Number=-y*l_/l;
			var y_:Number =-z * l_ / l;
			
			var a = Math.atan(z / y);
			
				
		/*	var l:Number=Math.sqrt(Math.pow(y, 2));
			if(l==0) return [0, 0];
			var l_:Number=k*Math.log
			(
				(
					Math.sqrt(Math.pow(x, 2)+Math.pow(l, 2))
					+l
				)
				/
				x
			);
			var x_:Number=-y*l_/l;
			
			
			var l:Number=Math.sqrt(Math.pow(z, 2));
			if(l==0) return [0, 0];
			var l_:Number=k*Math.log
			(
				(
					Math.sqrt(Math.pow(x, 2)+Math.pow(l, 2))
					+l
				)
				/
				x
			);*/			
			
			//Main.jsLog(x_);
			//Main.jsLog(y_);
			return [1, 1];//[a, 1];		
		}
	}		
		
}