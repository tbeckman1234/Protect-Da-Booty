package {

	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.geom.*;
	import flash.utils.Timer;
	import flash.utils.getQualifiedClassName;
	import flash.events.TimerEvent;
	import flash.text.*;
	import flash.media.*;
	import flash.net.*;
	import flash.display.*;

	import MapBound;
	import ammoSpawn;
	import Player;
	import Particle;
	import Pirate;
	import Treasure;
	import flash.text.engine.GraphicElement;
	import com.adobe.tvsdk.mediacore.TextFormat;

	public class ThomasMain extends MovieClip {

		private var player: Player;
		private var playerHealthBar: playerHealth = new playerHealth();
		private var background: Map = new Map();
		private var bullet: Bullet;
		private var bullets: Array;
		private var shotAngle: Number;

		private var healthText: TextField;
		private var health: uint;
		private var ammoText: TextField;
		private var ammoAmount: uint;
		private var scoreText: TextField;
		private var score: uint = 0;
		private var ammoIcon: Sprite = new ammoSymbol();
		private var insultText:TextField;
		private var timerText:TextField;
		private var time:uint = 0;

		private var ammoLayer: Sprite = new Sprite();
		private var topLeft: Point = new Point(365, 602);
		private var topRight: Point = new Point(6085, 622);
		private var bottomLeft: Point = new Point(365, 4062);
		private var bottomRight: Point = new Point(6085, 4062);
		private var ammoPoints: Array = new Array();
		private var ammoArray: Array = new Array();

		private var pirateMan: Pirate = new Pirate();
		private var treasure: Treasure = new Treasure();
		private var piratePad: Point = new Point();
		private var topPirate: Point = new Point(background.width / 2, 0);
		private var bottomPirate: Point = new Point(background.width / 2, background.height);
		private var rightPirate: Point = new Point(background.width, (background.height / 2 + 200));
		private var leftPirate: Point = new Point(0, (background.height / 2 + 200));
		private var piratePoints: Array = new Array();
		private var skeletonPoints:Array = new Array();
		private var pirates: Array = new Array();
		private var piratePOI: Number;
		private var pirateEscaped:Boolean = false;
		private var pirateHasTreasure:Boolean = false;
		private var playerGotHealth:Boolean = false;
		private var playerGotSpeed:Boolean = false;
		private var playerGotSpear:Boolean = false;
		private var skeletons: Array = new Array();

		private var globalTimer: Timer = new Timer(1000, 30);

		private var viewRect: Rectangle;
		
		private var resetBtn:resetButton;
		private var upgrades:upgradeUI;
		private var resume:Boolean = false;
		/*private var spearUp:spearUpgrade = new spearUpgrade();
		private var healthUp:healthUpgrade = new healthUpgrade();
		private var moveUp:moveUpgrade = new moveUpgrade();*/
		
		private var snd:Sound;
		private var soundStart:int = 2000;
		private var soundEffectChannel:SoundChannel;
		private var themeChannel:SoundChannel;
		private var endChannel:SoundChannel;
		private var skeletonSound:Sound;
		private var pirateDying:Sound;
		private var pirateSpawned:Sound;
		private var pirateGrabbedTreasure:Sound;
		private var playerGotHit:Sound;
		private var endMusic:Sound;
		private var ammoPickUp:Sound;
		private var transform1:SoundTransform=new SoundTransform();
		
		private var insults:Array = new Array("Lemme spell out the rules for ye, I win. YOU LOSE!", 
											"Yar thieving, work Shirking, rapscallion!", 
											"Ye grog faced gold stealin' stink on legs!", 
											"Yar salt crusted land lubber!", 
											"Hands off me booty ye cargo thieving freebooter!", 
											"Yarr mutinous, rotten rigged, bilge drinker!");
		

		public function ThomasMain() {
			
			transform1.volume=.7; // goes from 0 to 1
			
			snd = new Sound(new URLRequest("gameSounds/inGame.mp3"));
			themeChannel = snd.play(2000, 1, transform1);
			skeletonSound = new Sound(new URLRequest("gameSounds/skeleSound.mp3"));
			pirateDying = new Sound(new URLRequest("gameSounds/pirateDying.mp3"));
			pirateSpawned = new Sound(new URLRequest("gameSounds/PirateSpawn.mp3"));
			pirateGrabbedTreasure = new Sound(new URLRequest("gameSounds/PickedUpTreasure.mp3"));
			playerGotHit = new Sound(new URLRequest("gameSounds/playerBeingHit.mp3"));
			endMusic = new Sound(new URLRequest("gameSounds/endGameTheme.mp3"));
			ammoPickUp = new Sound(new URLRequest("gameSounds/ammoPickUp.mp3"));

			bullets = new Array();

			background.x = 0;
			background.y = 0;
			addChild(background);
		
			var UI: TextFormat = new TextFormat();
			UI.size = 100;
			UI.align = TextFormatAlign.RIGHT;
			
			var insultFormat: TextFormat = new TextFormat();
			insultFormat.size = 100;
			insultFormat.align = TextFormatAlign.CENTER;


			healthText = new TextField();
			healthText.defaultTextFormat = UI;
			healthText.width = 500;
			healthText.height = 400;
			addChild(healthText);
			
			scoreText = new TextField();
			scoreText.defaultTextFormat = UI;
			scoreText.width = 800;
			scoreText.height = 400;
			addChild(scoreText);
			
			timerText = new TextField();
			timerText.defaultTextFormat = UI;
			timerText.width = 800;
			timerText.height = 400;
			addChild(timerText);

			ammoText = new TextField();
			ammoText.defaultTextFormat = UI;
			ammoText.width = 500;
			ammoText.height = 400;
			addChild(ammoText);
			
			insultText = new TextField();
			insultText.defaultTextFormat = insultFormat;
			insultText.width = 5000;
			insultText.height = 300;


			player = new Player();
			player.x = background.width / 2;
			player.y = background.height / 2;
			background.addChild(player);


			addChild(playerHealthBar);
			addChild(ammoIcon);

			treasure.x = 3216;
			treasure.y = 2400;
			background.addChild(treasure);
			
			pushAmmoPoints();
			pushSkeletonPoints();
			trace(ammoPoints.length);

			piratePoints.push(topPirate, bottomPirate, leftPirate, rightPirate);

			addEventListener(Event.ADDED_TO_STAGE, addToStage);
			
			globalTimer.start();
		}
		
		private function addToStage(e:Event)
		{	
			removeEventListener(Event.ADDED_TO_STAGE, addToStage);
			addEventListener(Event.ENTER_FRAME, update);
			addEventListener(MouseEvent.MOUSE_DOWN, fireBullet);
			themeChannel.addEventListener(Event.SOUND_COMPLETE, loopSound);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			//stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseCoords);

			globalTimer.addEventListener(TimerEvent.TIMER, dankSpawnSystem);
			globalTimer.addEventListener(TimerEvent.TIMER_COMPLETE, resetTimer);
			
			viewRect = new Rectangle(stage.stageWidth / 2, stage.height / 2, stage.stageWidth, stage.stageHeight);

		}
		private function loopSound(e:Event):void {
			themeChannel = snd.play();
		}
		/*private function mouseCoords(e:MouseEvent):void {
			trace(mouseX, mouseY);
			trace(treasure.x, treasure.y);
		}*/
		
		private function removeFromStage():void
		{
			removeEventListener(Event.ENTER_FRAME, update);
			removeEventListener(MouseEvent.MOUSE_DOWN, fireBullet);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			stage.removeEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			removeEventListener(Event.SOUND_COMPLETE, loopSound);
			

			globalTimer.removeEventListener(TimerEvent.TIMER, dankSpawnSystem);
			globalTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, resetTimer);
		}
		
		private function pushAmmoPoints():void
		{
			for ( var i:int = 0; i < background.numChildren; i++)
			{
				if (background.getChildAt(i) is ammoSpawn)
				{
					ammoPoints.push(background.getChildAt(i));
				}
			}
		}
		
		private function pushSkeletonPoints():void
		{
			for ( var i:int = 0; i < background.numChildren; i++)
			{
				if (background.getChildAt(i) is skeletonSpawn)
				{
					skeletonPoints.push(background.getChildAt(i));
				}
			}
		}

		private function update(evt: Event): void {
			if(score == 100 || score == 200 || score == 300){
				getUpgrade();
			}
		
			//trace(skeletons.length);
			ammoIcon.x = player.x + 750;
			ammoIcon.y = player.y - 800;

			ammoText.x = player.x + 750;
			ammoText.y = player.y - 850;
			ammoAmount = player.ammo;
			ammoText.text = (ammoAmount.toString() + " / 25");
			
			scoreText.x = player.x + 450;
			scoreText.y = player.y -750;
			scoreText.text = ("score:            " + score.toString());
			
			timerText.x = player.x -1650;
			timerText.y = player.y -950;
			timerText.text = ("Time:  " +time.toString());

			playerHealthBar.x = player.x + 850;
			playerHealthBar.y = player.y - 900;

			healthText.x = player.x + 750;
			healthText.y = player.y - 960;
			health = player.life / 10;
			healthText.text = (health.toString() + " / 100");

			playerHealthBar.width = player.life;

			if (pirateMan.currentFrame == 1) {
				movePirateToTreasure(pirateMan);
			} else if (pirateMan.currentFrame == 2) {
				movePirateToPad(pirateMan);
			}
			if(contains(pirateMan)){
			didPirateHitTreasure(pirateMan);
			}
			
			if (pirateMan.life < 1 && pirateHasTreasure == false) {
					killPirate(pirateMan);
					pirateMan.life = 2;
					score += 10;
			}
			if(pirateMan.life < 1 && pirateHasTreasure == true){
				score += 10;
				killPirate(pirateMan);
				pirateMan.life = 2;
			}

			camera(player);
			player.update();

			shotAngle = Math.atan2(stage.mouseY - stage.stageHeight / 2, stage.mouseX - stage.stageWidth / 2);
			var playerAngle: Number = shotAngle * 180 / Math.PI;
			player.rotation = playerAngle;

			for each(var bullet: Particle in bullets) {
				bullet.update();

				if (bullet.life <= 0) {
					killBullet(bullet);
				} else if (bullet.interacts) {
					if (pirateMan.hitTestPoint(bullet.x, bullet.y)) {
						pirateMan.life -= 100;
						killBullet(bullet);
						break;
					}
					for each(var skele: Skeleton in skeletons) {
						if (skele.hitTestPoint(bullet.x, bullet.y)) {
							skele.health -= 100
							if (skele.health < 1) {
								//skeletons.removeAt(skeletons.indexOf(skele))
								skele.stopSkeleton();
								killBullet(bullet);
								if (skele.bulletsFired.length == 0)
								{
									background.removeChild(skele);
									skeletons.removeAt(skeletons.indexOf(skele))
								}
								soundEffectChannel = skeletonSound.play(500, 1);
								skele.health = 2;
								score += 10;
								
							}

						}
					}
				}
			}

			

			for each(var ammo: Ammo in ammoArray) {

				if (contains(ammo)) {


					if (player.hitTestPoint(ammo.x, ammo.y)) {
						background.removeChild(ammo);
						player.addAmmo();
						soundEffectChannel = ammoPickUp.play();
					}
				}
			}
			for each(var s: Skeleton in skeletons) {
				/*if (s.visible == false )
				{
					background.addChild(s);
				}*/
				if (s.contains(s) == true && s.visible == true) {
					s.update();
				}




				for each(var b: Particle in s.bulletsFired) {
					s.parent.addChild(b);
					if (b.hitTestObject(player)) 
					{
						player.life -= 100;
						s.bulletsFired.removeAt(s.bulletsFired.indexOf(b));
						s.parent.removeChild(b);
						soundEffectChannel = playerGotHit.play();
					}

					if (b.life < 1) {
						s.bulletsFired.removeAt(s.bulletsFired.indexOf(b));
						s.parent.removeChild(b);
					}
					b.update();
				}
			}

			pirateMan.lookAtIt();

			collision();
			
			endGame()
			
		}

		private function resetTimer(e: TimerEvent) {
			globalTimer.reset();
			globalTimer.start();
		}

		private function dankSpawnSystem(event: TimerEvent) {
			time++;
			if (event.target.currentCount == 1) {
				makeammoBoxes();
				
			} else if (event.target.currentCount % 7 == 0) {
				makeASkeleton();
			} else if (event.target.currentCount % 18 == 0) {
				if (pirateMan.isAlive == true) {
					addAPirate();
					pirateMan.speed += 1.5;
				}
			} else if (event.target.currentCount == 30) {
				removeAmmo();
			}
		}
		

		private function fireBullet(evt: MouseEvent): void {
			var shot: Particle;

			shot = new Bullet();

			shot.x = player.x;
			shot.y = player.y;

			shot.interacts = true;

			shot.xVel = Math.cos(shotAngle) * player.speed * 30;
			shot.yVel = Math.sin(shotAngle) * player.speed * 30;
			if (player.ammo > 0) {
				addChild(shot);
				bullets.push(shot);
				player.ammo -= 1;
			}
			/*trace(player.ammo);*/

		}

		private function makeammoBoxes(): void {

		for each(var ammoPack:ammoSpawn in ammoPoints)
		{
			var ammo: Ammo = new Ammo()
			ammo.x = ammoPack.x;
			ammo.y = ammoPack.y;
			ammoArray.push(ammo);
			background.addChild(ammo);
		}
			
			
			
			
			
			
			/*var i: Number;
			for (i = 0; i < ammoPoints.length; i++) {
				var point: ammoSpawn = ammoPoints[i];
				var ammo: Ammo = new Ammo();
				ammo.x = point.x;
				ammo.y = point.y;

				background.addChild(ammo);
				trace("added ammobox");
				ammoArray.push(ammo);
			}*/



		}

		private function removeAmmo(): void {
			for each(var ammo:Ammo in ammoArray){
				if (contains(ammo)) {
				for (var j: int = 0; j < ammoArray.length; j++) {
						if(ammoArray[j].name == ammo.name){
							background.removeChild(ammoArray[j]);
						}
					}
				}
			}
		}


		private function killBullet(bullet: Particle): void {
			try {
				var i: int;
				for (i = 0; i < bullets.length; i++) {
					if (bullets[i].name == bullet.name) {
						bullets.splice(i, 1);
						removeChild(bullet);
						i = bullets.length;
					}
				}
			} catch (e: Error) {
				trace("Failed to delete bullet!", e);
			}
		}

		private function keyDownHandler(evt: KeyboardEvent): void {
			//87=w 68=d 83=s 65=a
			if (evt.keyCode == 87) {
				player.yVel = -player.movingSpeed;
				player.movingVerticle = true;
			} else if (evt.keyCode == 83) {
				player.yVel = player.movingSpeed;
				player.movingVerticle = true;
			} else if (evt.keyCode == 68) {
				player.xVel = player.movingSpeed;
				player.movingVerticle = false;
			} else if (evt.keyCode == 65) {
				player.xVel = -player.movingSpeed;
				player.movingVerticle = false;
			}
		}

		private function keyUpHandler(evt: KeyboardEvent): void {
			//87=w 68=d 83=s 65=a
			if (evt.keyCode == 87 || evt.keyCode == 83) {
				player.yVel = 0;
			} else if (evt.keyCode == 68 || evt.keyCode == 65) {
				player.xVel = 0;
			}
		}

		private function makeASkeleton(): void {
			for (var i: uint = 0; i < 2; i++) {
				var skeletonTimed: Skeleton = new Skeleton();
				var spawnPoint: skeletonSpawn = skeletonPoints[i = Math.floor(Math.random() * ammoPoints.length)];
				skeletonTimed.x = spawnPoint.x;
				skeletonTimed.y = spawnPoint.y;
				skeletonTimed._target = player;
				background.addChild(skeletonTimed);
				skeletons.push(skeletonTimed);
			}
		}

		private function killPirate(pirate: Pirate): void {
			if (contains(pirateMan)) {
				if(pirateMan.currentFrame == 1) {
					background.removeChild(pirateMan);
					soundEffectChannel = pirateDying.play();
					pirateMan.isAlive == false;
					
				}
				if (pirateMan.currentFrame == 2) {
					treasure.x = 3216;
					treasure.y = 2400;
					background.addChild(treasure);
					pirateHasTreasure = false;
					background.removeChild(pirateMan);
					soundEffectChannel = pirateDying.play();
				}

			}
		}

		private function addAPirate(): void {
			pirateMan = new Pirate();
			/*trace("timer done");*/
			var i: Number;
			var point: Point = piratePoints[i = Math.floor(Math.random() * piratePoints.length)];
			pirateMan.x = point.x;
			pirateMan.y = point.y;
			/*trace(point);*/
			background.addChild(pirateMan);
			pirates.push(pirateMan);
			pirateMan.gotoAndStop(1);
			pirateMan.pointOfInterest = pirateMan.lookAtAnObject(treasure.x, treasure.y);
			soundEffectChannel = pirateSpawned.play();
			pirateMan.isAlive == true;
		}

		private function setPiratePad(): void {
			var i: Number;
			var point: Point = piratePoints[i = Math.floor(Math.random() * piratePoints.length)];
			/*trace(point);
			trace("setting pirate pad");*/

			piratePad.x = point.x;
			piratePad.y = point.y;
			pirateMan.pointOfInterest = pirateMan.lookAtAnObject(point.x, point.y);

		}

		private function movePirateToPad(pirate: Pirate): void {
			var speed: Number = pirate.speed;
			var dx: Number = pirate.x - piratePad.x;
			var dy: Number = pirate.y - piratePad.y;
			var angle = Math.atan2(dy, dx);
			pirate.x += Math.cos(angle) * speed;
			pirate.y += Math.sin(angle) * speed;
		}

		private function movePirateToTreasure(pirate: Pirate): void {
			var speed = pirate.speed;
			if (pirateMan != null) {
				var dx: Number = treasure.x - pirate.x;
				var dy: Number = treasure.y - pirate.y;
				var angle = Math.atan2(dy, dx);
				pirate.x += Math.cos(angle) * speed;
				pirate.y += Math.sin(angle) * speed;
			}
			/*if (pirate.x > treasure.x) {
		   pirate.x -= speed;
		
		   } else if (pirate.x < treasure.x) {
		   pirate.x += speed;
		   } else if (pirate.y > treasure.y) {
		   pirate.y -= speed;
		   } else if (pirate.y < treasure.y) {
		   pirate.y += speed;
		   }*/

		}

		private function didPirateHitTreasure(pirate: Pirate): void {
			if (contains(treasure)) {
				if (pirate.hitTestPoint(treasure.x, treasure.y) && pirate.status == "Alive") {
					background.removeChild(treasure);
					pirate.gotoAndStop(2);
					setPiratePad();
					pirateHasTreasure = true;
					soundEffectChannel = pirateGrabbedTreasure.play();
				}
			}
		}

		public function collision(): void {
			for (var i: int = 0; i < background.numChildren; i++) {
				if (background.getChildAt(i) is MapBound) {
					for each(var skele: Skeleton in skeletons) 
					{
						for each(var sb:SkeleBullet in skele.bulletsFired)
						{
							if (sb.hitTestObject(background.getChildAt(i)))
							{
								background.removeChild(sb)
								skele.bulletsFired.removeAt(skele.bulletsFired.indexOf(sb));
							}
						}
						skele.didHitObject(background.getChildAt(i));
					}

					if (player.hitTestObject(background.getChildAt(i))) {
						player.didHitObject(background.getChildAt(i));
					}

					if(pirateMan.hitTestObject(background.getChildAt(i)) && pirateHasTreasure == true){
						pirateEscaped = true;

					}
					for each (var b:Particle in bullets)
					{
						if (b.hitTestObject(background.getChildAt(i)))
						{
							killBullet(b);
						}

					}
				}
				if (background.getChildAt(i) is Pirate) {
					player.didHitEnemy(pirateMan);
				}
				if (background.getChildAt(i) is Skeleton) {
					for each(var skeletonI: Skeleton in skeletons) {
						if (skeletonI.alpha > 0){
							player.didHitEnemy(skeletonI);
						}
					}
				}


			}
			/*if(pirateMan.hitTestPoint(piratePad.x, piratePad.y)){
				pirateEscaped = true;
			}*/
		}
		
		private function camera(char: Sprite): void {
			viewRect.x = char.x - stage.stageWidth / 2;
			viewRect.y = char.y - stage.stageHeight / 2;
			root.scrollRect = viewRect;
			//new Rectangle(char.x - stage.stageWidth / 2, char.y - stage.height / 2, stage.stageWidth, stage.stageHeight);
		}
		private function getInsult():void {
			var i:int;
			var rude: String = insults[i = Math.floor(Math.random() * insults.length)];
			insultText.text = (rude);
			
		}
		
		private function getUpgrade():void {
			upgrades = new upgradeUI();
			upgrades.x = viewRect.x + viewRect.width /2 - upgrades.width/2;
			upgrades.y = viewRect.y + viewRect.height /2 - upgrades.height/2;
			background.addChild(upgrades);
			
			///*healthUpgrade = new healthUpgrade();*/
			//healthUp.x = viewRect.x + viewRect.width /2 - upgrades.width/2 - 200;
			//healthUp.y = viewRect.y + viewRect.height /2 - upgrades.height/2 + 400;
			//upgrades.addChild(healthUp);
			//
			///*moveUpgrade = new moveUpgrade();*/
			//moveUp.x = viewRect.x + viewRect.width /2 - upgrades.width/2;
			//moveUp.y = viewRect.y + viewRect.height /2 - upgrades.height/2 + 400;
			//upgrades.addChild(moveUp);
			//
			///*spearUpgrade = new spearUpgrade();*/
			//spearUp.x = viewRect.x + viewRect.width /2 - upgrades.width/2 + 200;
			//spearUp.y = viewRect.y + viewRect.height /2 - upgrades.height/2 + 400;
			//upgrades.addChild(spearUp);
			
			if (playerGotHealth == false) {
				player.life = 1000;
			}
			else if (playerGotHealth == true) {
				player.life = 1500;
			}
			
			pauseGame();				

			upgrades.healthUp.addEventListener(MouseEvent.MOUSE_DOWN, healthIncrease);
			upgrades.moveUp.addEventListener(MouseEvent.MOUSE_DOWN, moveSpeed);
			upgrades.spearUp.addEventListener(MouseEvent.MOUSE_DOWN, spearSpeed);
			/*if(resume == true){
				resumeGame();
				
				
			}*/
			//resumeGame();

		}
		private function spearSpeed(event:MouseEvent):void {
			if(playerGotSpear == false){
				upgrades.moveUp.enabled = false;
				player.speed += player.speed * .26;
				score +=10;
				resumeGame();
				background.removeChild(upgrades);
				playerGotSpear = true;
			}
				
		}
		private function moveSpeed(event:MouseEvent):void {
			if(playerGotSpeed == false){
				upgrades.spearUp.enabled = false;
				/*trace("hello");*/
				player.movingSpeed += player.movingSpeed * .3;
				score += 10;
				resumeGame();
				background.removeChild(upgrades);
				playerGotSpeed = true;
			}
			
		}
		private function healthIncrease(event:MouseEvent):void {
			if(playerGotHealth == false ){
				upgrades.healthUp.enabled = false;
				player.life += 500;
				resumeGame();
				score += 10;
				background.removeChild(upgrades);
				playerGotHealth = true;
			}
				/*trace("clicked the button");*/
			
			
			
		}
		
		
	
		private function resumeGame():void {
			/*trace("got to resumeGame");*/
			upgrades.healthUp.removeEventListener(MouseEvent.MOUSE_DOWN, healthIncrease);
			upgrades.moveUp.removeEventListener(MouseEvent.MOUSE_DOWN, moveSpeed);
			upgrades.spearUp.removeEventListener(MouseEvent.MOUSE_DOWN, spearSpeed);
			stage.removeEventListener(Event.REMOVED_FROM_STAGE, resumeGame);
			addEventListener(Event.ENTER_FRAME, update);
			addEventListener(MouseEvent.MOUSE_DOWN, fireBullet);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			
			globalTimer.start();
		}
		private function pauseGame():void {
			removeEventListener(Event.ENTER_FRAME, update);
			removeEventListener(MouseEvent.MOUSE_DOWN, fireBullet);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			stage.removeEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			
			globalTimer.stop();
		}
		
		private function endGame()
		{
			if (player.life < 1 /*|| pirateEscaped == true*/)
			{
				
				removeFromStage();
				resetBtn = new resetButton();
				addChild(resetBtn);
				resetBtn.x = viewRect.x + viewRect.width / 2 - resetBtn.width / 2;
				resetBtn.y = viewRect.y + viewRect.height / 2 - resetBtn.height / 2;
				resetBtn.addEventListener(MouseEvent.CLICK, resetGame);	

				themeChannel.stop();
				endChannel = endMusic.play(5000, 1);
				
				healthText.text = (0 + "/ 100");
				playerHealthBar.width = 0;
				
				getInsult();
				insultText.x = viewRect.x + viewRect.width / 2 - 2500;
				insultText.y = viewRect.y + viewRect.height / 2 - 200;
				background.addChild(insultText);
				//snd.close();
				
			}
			if (pirateHasTreasure == true && pirateEscaped == true)
			{
				
				removeFromStage();
				resetBtn = new resetButton();
				addChild(resetBtn);
				resetBtn.x = viewRect.x + viewRect.width / 2 - resetBtn.width / 2;
				resetBtn.y = viewRect.y + viewRect.height / 2 - resetBtn.height / 2;
				resetBtn.addEventListener(MouseEvent.CLICK, resetGame);	
				
				themeChannel.stop();
				endChannel = endMusic.play(5000, 1);
				
				/*healthText.text = (0 + "/ 100");
				playerHealthBar.width = 0;*/
				
				getInsult();
				insultText.x = viewRect.x + viewRect.width / 2 - 2500;
				insultText.y = viewRect.y + viewRect.height / 2 - 200;
				background.addChild(insultText);
			}
			
		}
		private function resetGame(e:Event):void 
		{
			/*trace("reset game");*/
			//removeChild(background);
			resetBtn.removeEventListener(MouseEvent.CLICK, resetGame);
			while (numChildren > 0)
			{
				removeChildAt(0);
			}
			//removeChild(resetBtn);
			var game:ThomasMain = new ThomasMain();
			endChannel.stop();
			addChild(game);
			
		}

	}

}