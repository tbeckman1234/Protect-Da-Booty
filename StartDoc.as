package 
{
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.media.Sound;
    import flash.media.SoundChannel; 
	import flash.net.*;
	import flash.display.SimpleButton;
	import flash.display.MovieClip;
	
	import ThomasMain
	
	public class StartDoc extends MovieClip
	{
		
		private var startSound:Sound;
		private var mySoundChannel:SoundChannel = new SoundChannel();
		private var menuChannel:SoundChannel;
		
		public function StartDoc()
		{
			//stage.scaleMode = StageScaleMode.NO_SCALE;
			
			createStartMenu();
			startSound = new Sound(new URLRequest("gameSounds/mainMenu.mp3"));
			menuChannel = startSound.play(25000, 1);
		}
		
		private function createStartMenu():void
		{
			var start:StartScreen = new StartScreen();
			
			addChild(start);
			
			start.coinButton.addEventListener(MouseEvent.CLICK, startGameHandler);
		}
		
		private function startGameHandler(evt:MouseEvent):void
		{
			removeChild(evt.currentTarget.parent);
			
			evt.currentTarget.removeEventListener(MouseEvent.CLICK, startGameHandler);
			
			createGame();
		}
		
		private function createGame():void
		{
			menuChannel.stop();
			menuChannel = null;
			var game:ThomasMain = new ThomasMain();
			
			addChild(game);
		}
	}
}