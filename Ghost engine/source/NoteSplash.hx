package;


import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class NoteSplash extends FlxSprite
{

    public function new(daNote:Note){
        super();

        x = daNote.x - 80;
        y = daNote.y - 80;

        alpha = .8 * daNote.alpha;

        //trace(info);
        
        frames = Paths.getSparrowAtlas('noteSplashes');

        animation.addByPrefix('Purple'  ,   'note impact 2 purple', 24, false);
        animation.addByPrefix('Blue'    ,   'note impact 2 blue', 24, false);
        animation.addByPrefix('Green'   ,   'note impact 2 green', 24, false);
        animation.addByPrefix('Red'     ,   'note impact 2 red', 24, false);
        animation.addByPrefix('Fake'    ,   'note impact 2 fake', 24, false);
        animation.addByPrefix('Chain'   ,   'note impact 2 chain', 24, false);

        updateHitbox();

        antialiasing = true;

        switch(daNote.noteType){

            case 1:
                animation.play('Fake');
                
            case 2:
                animation.play('Chain');

            default:

                switch(daNote.noteData){

                    case 0:
                        animation.play('Purple');

                    case 1:
                        animation.play('Blue');

                    case 2:
                        animation.play('Green');

                    case 3:
                        animation.play('Red');

                }

        }

        


        


    }

    override function update(elapsed:Float){

        if(animation.finished){
            kill();
        }

        super.update(elapsed);

    }





}