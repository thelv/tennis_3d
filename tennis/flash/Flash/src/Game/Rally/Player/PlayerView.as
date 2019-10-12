package Game.Rally.Player 
{
	
	import flash.display.Bitmap;
		
	public class PlayerView extends View
	{
		private var player: Player;
		[Embed(source = "../../../../lib/player.png")]
		public var imageClass : Class;
		public var image:Bitmap=new imageClass();
		
		public function PlayerView(player: Player):void
		{
			this.player = player;
			image = new imageClass();
			super(image.width, image.height);
			addChild(image);			
		}		
	}
}