package Game.Rally.Ball 
{
	
	import Game.Game;
	import Game.Rally.Ball.BallEval.BallEval;
	import Game.Rally.Ball.BallCollisions.BallCollisions;
	
	public class Ball 
	{
		//vars
			
			private var game: Game;			
			private var eval: BallEval;	
			public var collisions: BallCollisions;
			public var a: Number;
			public var R: int = 4;
			public var r: Array=[0, 0, 0], v: Array=[0, 0, 0], w: Array=[0, 0, 0];
			
			public var view: BallView; //view
			public var viewShadow: BallShadowView; //view
				
		//constructor
		
			public function Ball(game: Game): void
			{
				this.game = game;
				
				this.eval = new BallEval(this);
				this.a = 0;
				this.setControlPoint([0, 0, 50], [0, 0, 0], [0, 0, 0], 0);				
				this.collisions = new BallCollisions(game, this);
				
				//view
				view = new BallView(this);
				viewShadow = new BallShadowView(this);
				viewShowPos();				
			}

		//view methods
		
			public function viewShowPos(): void
			{					
				view.showPosition(this.r[0], this.r[1]+this.r[2], this.a);
				viewShadow.showPosition(this.r[0], this.r[1], this.a);
			}	
			
		//logic methods
			
			public function setControlPoint(r:Array, v:Array, w:Array, t:int): void
			{
				this.r = r.concat();
				this.v = v.concat();
				this.w = w.concat();
				eval.init(t);
			}
			
			public function shiftTime(t: int): void
			{								
				eval.eval(t);
				collisions.collise(t);
				viewShowPos(); //view
				
				//game.rally.middleLines.ballPos(x);
			}
			
			public function serve(start: Boolean, who: Boolean, t:int): void
			{								
				if (start)
				{
					setControlPoint([0, 0, 50], [0.25 * (who ? 1: -1), 0, 0], [0, 0, 0], t);
					collisions.init(t)
				}
				else
				{
					setControlPoint([0, 0, 50], [0, 0, 0], [0, 0, 0], game.rally.time.get());
					collisions.init(t)
				}
			}
			
			public function messageSendHit(t: int): void
			{					
				game.messageSend(
					{mt: 'bh', t: t, x: this.r[0], y: this.r[1], vx: this.v[0], vy: this.v[1], va: this.w[2]}
					,{firstConnection: 9, connectionsRange: 3, connectionsCount: 2, seriesName: 'bh'}
				);
				//"bh" == "ball hit"
			}		
			
			public function messageReceive(message: Object):void
			{
				switch(message.mt)
				{
					case 'bh':
						setControlPoint( [-message.x, -message.y, this.r[2]], [-message.vx, -message.vy, this.v[2]], [0, 0, message.va], message.t);
						game.rally.referee.collision('player', 1);
						collisions.hitWas(1);
						shiftTime(game.rally.time.get());
						break;
				}
			}
	}

}