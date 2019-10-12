package Game.Rally.Ball.BallCollisions 
{
	
	import Game.Game;
	import Game.Rally.Ball.Ball;
	
	public class BallCollisions
	{
		private var game:Game, ball: Ball;		
		private var prevX: Number, prevY: Number, prevT: int, prevR: Array; 
		private var excludeLine: int = -1, excludePlayer: int=-1;
		private var m = 0.1;
		
		public function BallCollisions(game:Game, ball:Ball): void
		{
			this.game = game;
			this.ball = ball;
			init(0);
		}
		
		public function init(t: int): void
		{	
			prevX = ball.r[0];
			prevY = ball.r[1];
			prevR = ball.r;
			prevT = t;
			excludeLine = -1;			
		}				
		
		public function collise(t: int):void
		{
			//столкновение с линиями поля
			for (var i = 0; i < game.rally.fieldLines.lines.length; i++)
			{
				if (i != excludeLine)				
				{
					var line:Array=game.rally.fieldLines.lines[i].concat();					
					if (i == 0 || i == 2)
					{
						line[1] -= ball.R/2;
						line[3] -= ball.R/2;
					}
					else
					{
						line[1] += ball.R/2;
						line[3] += ball.R/2;
					}					
					var collisionPoint:Object = collisionWithLine(line, t);
					if (collisionPoint.exists)
					{											
						bounceOfLine(line);
						ball.setControlPoint([collisionPoint.x, collisionPoint.y, ball.r[2]], ball.v, ball.w, collisionPoint.t);
						ball.viewShowPos();
						init(collisionPoint.t);
						excludeLine = i;						
						ball.shiftTime(t);						
						game.rally.referee.collision('field', i);
						break;
					}
				}
				else
				{
					excludeLine = -1;
				}
			}
			
			//выход за пределы поля
			for (var i:int = 0; i < game.rally.borderLines.lines.length; i++)
			{				
				var line:Array = game.rally.borderLines.lines[i];
				var collisionPoint:Object = collisionWithLine(line, t);
				if (collisionPoint.exists)
				{					
					game.rally.referee.collision('border', 0);
				}
			}
			
			//удар об землю
			if (ball.r[2] < 0)
			{
				ball.setControlPoint([ball.r[0], ball.r[1], -ball.r[2]], [ball.v[0], ball.v[1], -ball.v[2]] , ball.w, t);
				//bounceOfGround();
			}
			
			//столкновение с нашим игроком
			if (excludePlayer != 0)
			{
				var player:Object = game.rally.player0.collisions.getParams();
				var collisionPoint:Object = collisionWithPlayer(player, t);
				if(collisionPoint.exists)
				{										
					bounceOfPlayer(player);
					ball.setControlPoint([collisionPoint.x, collisionPoint.y, ball.r[2]], ball.v, ball.w, collisionPoint.t);
					//game.rally.middleLines.hit(0, collisionPoint.x);
					ball.viewShowPos();
					init(collisionPoint.t);
					excludePlayer = 0;
					excludeLine = -1;
					ball.messageSendHit(collisionPoint.t);
					ball.shiftTime(t);
					game.rally.referee.collision('player', 0);
				}
			}
			
			//столкновение с его игроком						
			if ((game.type!='network') && (excludePlayer != 1))
			{
				var player:Object = game.rally.player1.collisions.getParams();
				var collisionPoint:Object = collisionWithPlayer(player, t);
				if (collisionPoint.exists)
				{					
					bounceOfPlayer(player);
					ball.setControlPoint([collisionPoint.x, collisionPoint.y, ball.r[2]], ball.v, ball.w, collisionPoint.t);
					//game.rally.middleLines.hit(1, collisionPoint.x);
					ball.viewShowPos();
					init(collisionPoint.t);
					excludePlayer = 1;
					excludeLine = -1;
					ball.shiftTime(t);					
					game.rally.referee.collision('player', 1);
				}
			}
			
			init(t);
			game.rally.player0.collisions.init(t);
			game.rally.player1.collisions.init(t);
		}
		
		private function collisionWithLine(line: Array, t:int): Object
		{
			var i:Object = MathLib.linesIntersection(prevX, prevY, ball.r[0], ball.r[1], line[0], line[1], line[2], line[3]);
			if (i.intersect)
			{
				return { exists: true, x: i.x, y:i.y, t: prevT+(t-prevT)*i.k};
			}
			else
			{
				return { exists: false };
			}
		}
		
		private function collisionWithPlayer(player: Object, t: int): Object
		{				
			//положения мяча
			var ballR0:Array = [prevX, prevY];
			var ballR1:Array = [ball.r[0], ball.r[1]];
			//положения игрока
			var plR0:Array = player.prevXy;
			var plR1:Array = player.xy;
			//углы игрока
			var plDir0:Array = player.prevDir;
			var plDir1:Array = player.dir;
			
			//переходим в новую систему отсчета
			var ballR0_ = MathLib.vReturn(MathLib.vMinus(ballR0, plR0), plDir0);
			var ballR1_ = MathLib.vReturn(MathLib.vMinus(ballR1, plR1), plDir0);
			
			//сдвиг из-за поворота игрока
			var turnShiftCoeff:Number = MathLib.vReturn(plDir1, plDir0)[1];
			ballR1_[1] -= turnShiftCoeff * ballR1_[0];
			
			//сдвиг на радиус мяча
			if (ballR1_[1] - ballR0_[1] > 0)
			{
				ballR0_[1] += ball.R;
				ballR1_[1] += ball.R;
			}
			else
			{
				ballR0_[1] -= ball.R;
				ballR1_[1] -= ball.R;
			}	
			
			//находим точку пересечения				
			var k:Number = ballR0_[1] / (ballR0_[1] - ballR1_[1]);
			if (k > 0 && k <= 1)
			{
				var x:Number = ballR0_[0] + (ballR1_[0] - ballR0_[0]) * k;
				if (x >= -player.length && x <= player.length)
				{
					return { exists: true, x: prevX+(ball.r[0]-prevX)*k, y: prevY+(ball.r[1]-prevY)*k, t: prevT + (t - prevT) * k };
				}
				else return { exists: false };
			}
			else return { exists: false };		
		}
		
		private function bounceOfGround(): void
		{
			//
		}
		
		private function bounceOfLine(line: Array): void
		{
			var dir:Array = MathLib.getLineDirection(line[0], line[1], line[2], line[3]);
			var vtn:Array = MathLib.decomposeVector(ball.v[0], ball.v[1], dir[0], dir[1]);
			if (vtn[1] > 0) 
			{
				vtn[0] *= -1;
				vtn[1] *= -1;
				dir[0] *= -1;
				dir[1] *= -1;
				
			}
			var d:Array = MathLib.bounceOfRotatingBall(vtn[0], -vtn[1], ball.w[2], ball.R, 0.125, 2.5);
			vtn[0] += d[0];	
			ball.w[2] += d[1];
			vtn[1] *= -(1-0.1*(Math.abs(vtn[1]/0.1)));
			var v:Array = MathLib.composeVector(vtn[0], vtn[1], dir[0], dir[1]);
			ball.v[0] = v[0];
			ball.v[1] = v[1];
		}
		
		private function bounceOfPlayer(p: Object): void
		{						
			//направление ракетки игрока
			var dir:Array = p.dir;
			
			//разлагаем скорсть мяча по направлению ракетки (vtn)
			var vtn:Array = MathLib.decomposeVector(ball.v[0], ball.v[1], dir[0], dir[1]);
			//меняем "полярность", чтобы мяч (якобы) налетал на игрока "Vnorm<0"
			if (vtn[1] > 0)
			{
				vtn[0] *= -1;
				vtn[1] *= -1;
				dir[0] *= -1;
				dir[1] *= -1;			
			}
			
			//разлагаем скорость игрока по направлению ракетки (pvtn): Vnorm должно быть>0
			var pvtn:Array = MathLib.decomposeVector(p.v[0], p.v[1], dir[0], dir[1]);
			
			//хитрая формула для расчета "силы удара" (пересчет скорости игрока)
			pvtn[1] = (pvtn[1] / 0.14) * 0.012 + 0.25 * m;
			
			//расчет изменения Vnorm мяча по ЗСИ
			if (pvtn[1] < 0)
			{
				//упрощенные рассмотрение, если игрок набегает на мяч
				var newVn:Number = vtn[1] + 2 * pvtn[1] / (m + 1);
			}
			else
			{				
				//полноценный ЗСИ
				var newVn:Number = -vtn[1] + 2 * (vtn[1] * m + pvtn[1]) / (m + 1);
			}
			
			//расчет изменений [Vtang, вращения мяча] исходя из [dVn мяча, Vtang мяча и игрока]
			var d:Array = MathLib.bounceOfRotatingBall(vtn[0]-pvtn[0], (newVn-vtn[1])/2, ball.w[2], ball.R, 0.2, 2.5);
			vtn[0] += d[0];	
			ball.w[2] += d[1];
			vtn[1] = newVn;
			
			//пересчитываем скорость мяча из Norm-Tang разложения в X-Y
			var v:Array = MathLib.composeVector(vtn[0], vtn[1], dir[0], dir[1]);
			ball.v[0] = v[0];
			ball.v[1] = v[1];
		}
		
		public function hitWas(playerNumber: int): void
		{
			excludeLine = -1;
			excludePlayer = playerNumber;
		}
		
		public function reset(): void
		{
			excludePlayer = -1;
			excludeLine = -1;
		}
	}

}

