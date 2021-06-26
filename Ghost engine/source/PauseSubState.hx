package;

import flixel.FlxBasic;
import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;

#if windows
import Discord.DiscordClient;
#end

/*
if (accepted)
		{
			var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);

			trace(poop);

			PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = curDifficulty;
			PlayState.storyWeek = songs[curSelected].week;
			trace('CUR WEEK' + PlayState.storyWeek);
			LoadingState.loadAndSwitchState(new PlayState());
		}
*/

class PauseSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;
	var difMenuShit:FlxTypedGroup<Alphabet>;
	var gendifMenuShit:FlxTypedGroup<Alphabet>;

	var mainmenuItems:Array<String> = ['Resume', 'Restart Song', 'Difficulty', 'General Difficulty','Practice mode', 'Exit level','Exit to menu'];
	var dificultymenuItems:Array<String> = ['Easy', 'Normal', 'Hard','Back'];
	var generaldificultymenuItems:Array<String> = ['Baby', 'Classic', 'Permissive', 'Geometry Dash','Back'];
	var menuItems:Array<String> = [];
	var curSelected:Int = 0;

	var pauseMusic:FlxSound;

	var practice:FlxText;

	public static var tweens:FlxTweenManager;

	public function new(x:Float, y:Float)
	{
		super();
		FlxTween.globalManager.active = false;
		//FlxTimer.globalManager.active = false;

		add(tweens = new FlxTweenManager());

		if(! PlayState.loadRep){
			mainmenuItems = ['Resume', 'Restart Song', 'Difficulty', 'General Difficulty','Practice mode', 'Exit level','Exit to menu'];
		}else{
			mainmenuItems = ['Resume', 'Restart Song', 'Exit level','Exit to menu'];

		}
		

		pauseMusic = new FlxSound().loadEmbedded(Paths.music('breakfast'), true, true);
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		var levelInfo:FlxText = new FlxText(20, 15, 0, "", 32);
		levelInfo.text += PlayState.SONG.song;
		levelInfo.scrollFactor.set();
		levelInfo.setFormat(Paths.font("vcr.ttf"), 32);
		levelInfo.updateHitbox();
		add(levelInfo);

		var levelDifficulty:FlxText = new FlxText(20, 15 + 32, 0, "", 32);
		levelDifficulty.text += CoolUtil.difficultyString();
		levelDifficulty.scrollFactor.set();
		levelDifficulty.setFormat(Paths.font('vcr.ttf'), 32);
		levelDifficulty.updateHitbox();
		add(levelDifficulty);

		var generalDifficulty:FlxText = new FlxText(20, 15 + 64, 0, "", 32);
		generalDifficulty.text += CoolUtil.generaldifficultyString();
		generalDifficulty.scrollFactor.set();
		generalDifficulty.setFormat(Paths.font('vcr.ttf'), 32);
		generalDifficulty.updateHitbox();
		add(generalDifficulty);

		practice = new FlxText(20, 15 + 96, 0, "", 32);
		practice.text = "Practice mode";
		practice.scrollFactor.set();
		practice.setFormat(Paths.font('vcr.ttf'), 32);
		practice.updateHitbox();
		add(practice);

		levelDifficulty.alpha = 0;
		levelInfo.alpha = 0;
		generalDifficulty.alpha = 0;
		practice.alpha = 0;

		levelInfo.x = FlxG.width - (levelInfo.width + 20);
		levelDifficulty.x = FlxG.width - (levelDifficulty.width + 20);
		generalDifficulty.x = FlxG.width - (generalDifficulty.width + 20);
		practice.x = FlxG.width - (practice.width + 20);

		

		tweens.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		tweens.tween(levelInfo, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		tweens.tween(levelDifficulty, {alpha: 1, y: levelDifficulty.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.5});
		tweens.tween(generalDifficulty, {alpha: 1, y: generalDifficulty.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.7});
		if(FlxG.save.data.practice){
			tweens.tween(practice, {alpha: 1, y: practice.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.9});
		}else{
			practice.y += 5;

		}

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		difMenuShit = new FlxTypedGroup<Alphabet>();

		gendifMenuShit = new FlxTypedGroup<Alphabet>();

		menuItems = dificultymenuItems;

		for (i in 0...menuItems.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			difMenuShit.add(songText);
		}

		menuItems = generaldificultymenuItems;

		for (i in 0...menuItems.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			gendifMenuShit.add(songText);
		}


		menuItems = mainmenuItems;

		for (i in 0...menuItems.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpMenuShit.add(songText);
		}

		

		

		changeSelection();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}



	override function update(elapsed:Float)
	{
		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.02 * elapsed;

		super.update(elapsed);

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (accepted)
		{
			
			var daSelected:String = menuItems[curSelected];

			FlxTween.globalManager.active = true;
			//FlxTimer.globalManager.active = true;
			
			

			switch (daSelected)
			{
				case "Resume":
					close();
				case "Restart Song":
					FlxG.resetState();
				case "Difficulty":

					
					remove(grpMenuShit);
					
					curSelected = 0;

					menuItems = dificultymenuItems;	

					add(difMenuShit);

					changeSelection();
				
				case "General Difficulty":

					remove(grpMenuShit);
					
					curSelected = 0;

					menuItems = generaldificultymenuItems;	

					add(gendifMenuShit);

					changeSelection();
				
				case "Practice mode":

					if(FlxG.save.data.practice ){
						FlxG.save.data.practice = false;
						practice.alpha = 0;
						
					}else{
						FlxG.save.data.practice = true;
						practice.alpha = 1;

					}
					FlxG.save.flush();
				case "Exit to menu":
					PlayState.loadRep = false;
					if (PlayState.offsetTesting)
					{
						PlayState.offsetTesting = false;
						FlxG.switchState(new OptionsMenu());
					}
					else
						FlxG.switchState(new MainMenuState());

				
				//difficulty options thingy idk

				case "Easy":
					
					changeDif(0);

				case "Normal":
					changeDif(1);

				case "Hard":
					changeDif(2);


				case "Back":

					remove(difMenuShit);
					remove(gendifMenuShit);

					curSelected = 0;

					menuItems = mainmenuItems;	

					add(grpMenuShit);

					changeSelection();

				//General difficulty options over hea idk

				case "Baby":
					changeGenDif(0);

				case "Classic":
					changeGenDif(1);

				case "Permissive":
					changeGenDif(2);

				case "Geometry Dash":
					changeGenDif(3);

				case 'Exit level':

					if(PlayState.isStoryMode){
						#if windows
							DiscordClient.changePresence("In the Menus", null);
						#end
				
						FlxG.switchState(new StoryMenuState());

					}else{

						#if desktop
							if(!PlayState.loadRep){
								trace('WENT BACK TO FREEPLAY??');
								#if windows
									DiscordClient.changePresence("In the Freeplay Menu", null);
								#end
								FlxG.switchState(new FreeplayState());
							}else{
								FlxG.switchState(new LoadReplayState());
							}
						#end

						#if !desktop
							FlxG.switchState(new FreeplayState());
						#end

					}
				

			}
		}

		

		if (FlxG.keys.justPressed.J)
		{
			// for reference later!
			// PlayerSettings.player1.controls.replaceBinding(Control.LEFT, Keys, FlxKey.J, null);
		}
	}

	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		if(menuItems == mainmenuItems){

			for (item in grpMenuShit.members)
			{
				item.targetY = bullShit - curSelected;
				bullShit++;

				item.alpha = 0.6;
				// item.setGraphicSize(Std.int(item.width * 0.8));

				if (item.targetY == 0)
				{
					item.alpha = 1;
					// item.setGraphicSize(Std.int(item.width));
				}
			}

		}else if(menuItems == dificultymenuItems){

			for (item in difMenuShit.members)
			{
				item.targetY = bullShit - curSelected;
				bullShit++;
	
				item.alpha = 0.6;
				// item.setGraphicSize(Std.int(item.width * 0.8));
	
				if (item.targetY == 0)
				{
					item.alpha = 1;
					// item.setGraphicSize(Std.int(item.width));
				}
			}	


		}else if(menuItems == generaldificultymenuItems){
			
			for (item in gendifMenuShit.members)
				{
					item.targetY = bullShit - curSelected;
					bullShit++;
		
					item.alpha = 0.6;
					// item.setGraphicSize(Std.int(item.width * 0.8));
		
					if (item.targetY == 0)
					{
						item.alpha = 1;
						// item.setGraphicSize(Std.int(item.width));
					}
				}	


		}



	}

	function changeDif(dif:Int){
		var poop:String = Highscore.formatSong(PlayState.SONG.song.toLowerCase(), dif);

			trace(poop);

			PlayState.SONG = Song.loadFromJson(poop, PlayState.SONG.song.toLowerCase());
			PlayState.storyDifficulty = dif;
			trace('CUR WEEK' + PlayState.storyWeek);
			LoadingState.loadAndSwitchState(new PlayState());


	}

	function changeGenDif(dif:Int){
		FlxG.save.data.dif = dif;

		FlxG.save.flush();

		FlxG.resetState();

	}

}
