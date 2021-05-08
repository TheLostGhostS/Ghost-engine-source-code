package;

import lime.app.Promise;
import lime.app.Future;
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxTimer;
import flixel.ui.FlxBar;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;


import openfl.utils.Assets;
import lime.utils.Assets as LimeAssets;
import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;

import haxe.io.Path;

class LoadingState extends MusicBeatState
{
	inline static var MIN_TIME = 1.0;
	
	var target:FlxState;
	var stopMusic = false;
	var callbacks:MultiCallback;
	
	var logo:FlxSprite;
	var screen:FlxSprite;
	var bar1:FlxBar;
	var bar2:FlxBar;

	var progress:Int;
	var color:FlxColor;

	var way:FlxBarFillDirection = VERTICAL_INSIDE_OUT;
	
	
	function new(target:FlxState, stopMusic:Bool)
	{
		super();
		this.target = target;
		this.stopMusic = stopMusic;
	}
	
	override function create()
	{	
		

		logo = new FlxSprite(-100, 10);
		logo.frames = Paths.getSparrowAtlas('logoBumpin');
		logo.antialiasing = true;
		logo.animation.addByPrefix('bump', 'logo bumpin', 24);
		logo.animation.play('bump');
		logo.updateHitbox();
		logo.setGraphicSize(Std.int(logo.width * 0.8), Std.int(logo.height * 0.8));
		// logoBl.screenCenter();
		// logoBl.color = FlxColor.BLACK;

		progress = 0;

		if(FlxG.random.bool(25)){
			color = 0xFF1679B6;
		}else if(FlxG.random.bool(33)){
			color = 0xFF23B616;
		}else if(FlxG.random.bool(50)){
			color = 0xFF8B16B6;
		}else{
			color = 0xFFB61616;
		}

		

		bar1 = new FlxBar(0, 0, way, 20, FlxG.height, this, 'progress', 0, 100);
		bar1.scrollFactor.set();
		bar1.createFilledBar(0xFF2E2E2E, color);

		bar2 = new FlxBar(FlxG.width - 20, 0, way, 20, FlxG.height, this, 'progress', 0, 100);
		bar2.scrollFactor.set();
		bar2.createFilledBar(0xFF2E2E2E, color);


		screen = new FlxSprite(0, 0).loadGraphic(Paths.image('loadingScreen'));
		screen.updateHitbox();
		screen.screenCenter();
		

		
		add(screen);
		add(logo);
		add(bar1);
		add(bar2);

		initSongsManifest().onComplete
		(
			function (lib)
			{
				callbacks = new MultiCallback(onLoad);
				
				checkLoadSong(getSongPath());
				if (PlayState.SONG.needsVoices)
					checkLoadSong(getVocalPath());
				checkLibrary("shared");
				checkLibrary("characters");
				if (PlayState.storyWeek > 0){
					checkLibrary("week" + PlayState.storyWeek);
					trace("Library checked");
				}
				else
					checkLibrary("tutorial");
				var introComplete = callbacks.add("introComplete");

				var fadeTime = 0.5;
				FlxG.camera.fade(FlxG.camera.bgColor, fadeTime, true);
				new FlxTimer().start(fadeTime + MIN_TIME, function(_){ introComplete(); });

			}
		);
	}

	function finish(yep:Float){

		progress = Std.int(yep);
	}
	
	function checkLoadSong(path:String)
	{
		if (!Assets.cache.hasSound(path))
		{
			var library = Assets.getLibrary("songs");
			final symbolPath = path.split(":").pop();
			// @:privateAccess
			// library.types.set(symbolPath, SOUND);
			// @:privateAccess
			// library.pathGroups.set(symbolPath, [library.__cacheBreak(symbolPath)]);
			var callback = callbacks.add("song:" + path);
			Assets.loadSound(path).onComplete(function (_) { callback(); });
		}
	}
	
	function checkLibrary(library:String)
	{
		//trace(Assets.hasLibrary(library));
		//trace(Assets.getLibrary(library));
		if (Assets.getLibrary(library) == null)
		{
			@:privateAccess
			if (!LimeAssets.libraryPaths.exists(library))
				throw "Missing library: " + library;
			
			var callback = callbacks.add("library:" + library);
			trace(library);
			Assets.loadLibrary(library).onComplete(function (_) { callback(); });
		}
	}

	public static function characterLibrary(library:String){
		if (Assets.getLibrary(library) == null)
		{
			//if (!LimeAssets.libraryPaths.exists(library))
			//	throw "Missing library: " + library;
				
			Assets.loadLibrary(library);
		}


	}
	
	override function beatHit()
	{
		super.beatHit();
		
		logo.animation.play('bump');
		
		
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		
		if(callbacks != null){
			progress = Std.int( FlxMath.lerp(progress, (callbacks.getFired().length + 1 / (callbacks.length) ) * 100, .15) ) ;
			//FlxTween.num(progress, 100, .4, {ease: FlxEase.linear, type:ONESHOT}, finish.bind() );
			trace(callbacks.getUnfired().length);

			if(callbacks.getUnfired().length == 0){
				FlxTween.num(progress, 100, .4, {ease: FlxEase.linear, type:ONESHOT}, finish.bind() );
			}
		}
		
		if (FlxG.keys.justPressed.SPACE)
			trace('fired: ' + callbacks.getFired() + " unfired:" + callbacks.getUnfired());
		
	}
	
	function onLoad()
	{
		if (stopMusic && FlxG.sound.music != null)
			FlxG.sound.music.stop();
		
		
		FlxG.switchState(target);
	}
	
	static function getSongPath()
	{
		return Paths.inst(PlayState.SONG.song);
	}
	
	static function getVocalPath()
	{
		return Paths.voices(PlayState.SONG.song);
	}
	
	inline static public function loadAndSwitchState(target:FlxState, stopMusic = false)
	{
		FlxG.switchState(getNextState(target, stopMusic));
	}
	
	static function getNextState(target:FlxState, stopMusic = false):FlxState
	{
		Paths.setCurrentLevel("week" + PlayState.storyWeek);
		#if NO_PRELOAD_ALL
		var loaded = isSoundLoaded(getSongPath())
			&& (!PlayState.SONG.needsVoices || isSoundLoaded(getVocalPath()))
			&& isLibraryLoaded("shared");
		
		if (!loaded)
			return new LoadingState(target, stopMusic);
		#end
		if (stopMusic && FlxG.sound.music != null)
			FlxG.sound.music.stop();
		
		return target;
	}
	
	#if NO_PRELOAD_ALL
	static function isSoundLoaded(path:String):Bool
	{
		return Assets.cache.hasSound(path);
	}
	#end

	static function isLibraryLoaded(library:String):Bool
	{
		return Assets.getLibrary(library) != null;
	}
	

	public static function unloadLibrary(library:String){ //Update: this function didnt work but still im not deleting it -Ghost

		if (isLibraryLoaded(library)){

			#if windows

				if(FlxG.save.data.unload){
					Assets.unloadLibrary(library);
				}

			#end

			#if linux

				if(FlxG.save.data.unload){
					Assets.unloadLibrary(library);
				}

			#end

		}

	}	
	
	override function destroy()
	{
		super.destroy();
		
		callbacks = null;
	}
	
	static function initSongsManifest()
	{
		var id = "songs";
		var promise = new Promise<AssetLibrary>();

		var library = LimeAssets.getLibrary(id);

		if (library != null)
		{
			return Future.withValue(library);
		}

		var path = id;
		var rootPath = null;

		@:privateAccess
		var libraryPaths = LimeAssets.libraryPaths;
		if (libraryPaths.exists(id))
		{
			path = libraryPaths[id];
			rootPath = Path.directory(path);
		}
		else
		{
			if (StringTools.endsWith(path, ".bundle"))
			{
				rootPath = path;
				path += "/library.json";
			}
			else
			{
				rootPath = Path.directory(path);
			}
			@:privateAccess
			path = LimeAssets.__cacheBreak(path);
		}

		AssetManifest.loadFromFile(path, rootPath).onComplete(function(manifest)
		{
			if (manifest == null)
			{
				promise.error("Cannot parse asset manifest for library \"" + id + "\"");
				return;
			}

			var library = AssetLibrary.fromManifest(manifest);

			if (library == null)
			{
				promise.error("Cannot open library \"" + id + "\"");
			}
			else
			{
				@:privateAccess
				LimeAssets.libraries.set(id, library);
				library.onChange.add(LimeAssets.onChange.dispatch);
				promise.completeWith(Future.withValue(library));
			}
		}).onError(function(_)
		{
			promise.error("There is no asset library with an ID of \"" + id + "\"");
		});

		return promise.future;
	}
}

class MultiCallback
{
	public var callback:Void->Void;
	public var logId:String = null;
	public var length(default, null) = 0;
	public var numRemaining(default, null) = 0;
	
	var unfired = new Map<String, Void->Void>();
	var fired = new Array<String>();
	
	public function new (callback:Void->Void, logId:String = null)
	{
		this.callback = callback;
		this.logId = logId;
	}
	
	public function add(id = "untitled")
	{
		id = '$length:$id';
		length++;
		numRemaining++;
		var func:Void->Void = null;
		func = function ()
		{
			if (unfired.exists(id))
			{
				unfired.remove(id);
				fired.push(id);
				numRemaining--;
				
				if (logId != null)
					log('fired $id, $numRemaining remaining');
				
				if (numRemaining == 0)
				{
					if (logId != null)
						log('all callbacks fired');
					callback();
					
				}
			}
			else
				log('already fired $id');
		}
		unfired[id] = func;
		return func;
	}
	
	inline function log(msg):Void
	{
		if (logId != null)
			trace('$logId: $msg');
	}
	
	public function getFired() return fired.copy();
	public function getUnfired() return [for (id in unfired.keys()) id];
}