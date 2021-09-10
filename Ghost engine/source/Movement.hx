package;

import flixel.FlxSprite;
import flixel.tweens.motion.LinearPath;
import flixel.FlxBasic;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.FlxG;

using StringTools;

class SpriteEffect extends FlxSprite{

    public var time:Float;
    public var targetInt:Int;
    public var player:Bool;
    public var target:String;

    public static var duration:Float = 0;

    public function new(time:Float, targetInt:Int, player:Bool, target:String){
        super();

        this.time = time;
        this.targetInt = targetInt;
        this.player = player;
        this.target = target;

        loadGraphic(Paths.image('Circle_Sprites', 'preload'), true, 110, 100);
        
        animation.add('x', [0], 0, false);
        animation.add('y', [1], 0, false);
        animation.add('spriteRot', [2], 0, false);
        animation.add('incoming', [3], 0, false);
        animation.add('pivotRot', [4], 0, false);
        animation.add('radius', [5], 0, false);
        animation.add('alpha', [6], 0, false);
        animation.play(target);

        alpha = 0.7;
        /**
         var time:Float;
          var quantity:Float;
         var duration:Float;
          var target:String;
         var targetInt:Int;
          var way:String;
         var player:Bool;
          var set:Bool;
         var all:Bool;

        **/

    }

}


class Effect extends FlxBasic
{

    

    public function new(quantity:Float, duration:Float, target:String, targetInt:Int, way:String, player:Bool = true, set:Bool = false, all:Bool){

        super();
        var prevStat:Float;
        var playerAdd:Int;
        var options:TweenOptions;
        var translation:Null<EaseFunction>;


        if(FlxG.save.data.downscroll && !all){

            if(set){

                if(target == 'y'){
                    quantity = 615 - quantity;
                    trace(quantity);
                }

                if(target == 'incoming' ){
                    quantity = 180 - quantity;
                }

                if(target == 'spriteRot' || target == 'pivotRot'){
                    quantity = 360 - quantity;
                }

                

            }else{

                if(target == 'incoming' || target == 'spriteRot' || target == 'pivotRot' || target == 'y'){
                    quantity *= -1;
                }

            }

            
            
        }

        if((target == 'incoming' || target == 'spriteRot' || target == 'pivotRot') && !all){



        }

        switch(way){
            case "quadIn": translation = FlxEase.quadIn;
            case "quadOut": translation = FlxEase.quadOut;
            case "quadInOut": translation = FlxEase.quadInOut;
            case "cubeIn": translation = FlxEase.cubeIn;
            case "cubeOut": translation = FlxEase.cubeOut;
            case "cubeInOut": translation = FlxEase.cubeInOut;
            case "quartIn": translation = FlxEase.quartIn;
            case "quartOut": translation = FlxEase.quartOut;
            case "quartInOut": translation = FlxEase.quartInOut;
            case "quintIn": translation = FlxEase.quintIn;
            case "quintOut": translation = FlxEase.quintOut;
            case "quintInOut": translation = FlxEase.quintInOut;
            case "sineIn": translation = FlxEase.sineIn;
            case "sineOut": translation = FlxEase.sineOut;
            case "sineInOut": translation = FlxEase.sineInOut;
            case "bounceIn": translation = FlxEase.bounceIn;
            case "bounceOut": translation = FlxEase.bounceOut;
            case "bounceInOut": translation = FlxEase.bounceInOut;
            case "circIn": translation = FlxEase.circIn;
            case "circOut": translation = FlxEase.circOut;
            case "circInOut": translation = FlxEase.circInOut;
            case "expoIn": translation = FlxEase.expoIn;
            case "expoOut": translation = FlxEase.expoOut;
            case "expoInOut": translation = FlxEase.expoInOut;
            case "backIn": translation = FlxEase.backIn;
            case "backOut": translation = FlxEase.backOut;
            case "backInOut": translation = FlxEase.backInOut;
            case "elasticIn": translation = FlxEase.elasticIn;
            case "elasticOut": translation = FlxEase.elasticOut;
            case "elasticInOut": translation = FlxEase.elasticInOut;
            case "smoothStepIn": translation = FlxEase.smoothStepIn;
            case "smoothStepOut": translation = FlxEase.smoothStepOut;
            case "smoothStepInOut": translation = FlxEase.smoothStepInOut;
            case "smootherStepIn": translation = FlxEase.smootherStepIn;
            case "smootherStepOut": translation = FlxEase.smootherStepOut;
            case "smootherStepInOut": translation = FlxEase.smootherStepInOut;
			default: translation = FlxEase.linear;
		}
        
       

        playerAdd = 0;

        if(player){
            playerAdd = 4;
        }

        prevStat = 0;

        options = {type: ONESHOT, ease: translation, onComplete: function(_){ destroy(); } };

        switch(target){

            case 'x':


                if(! all){
                    
                   
                    prevStat = 0;
                    if(duration > 0){

                        FlxTween.num(0, quantity - (set ? PlayState.currentPositionX[targetInt + playerAdd] : 0), duration, options, function(adding:Float){

                            PlayState.currentPositionX[targetInt + playerAdd] += (adding - prevStat);

                            prevStat = adding;
                        });
                    }else{
                        PlayState.currentPositionX[targetInt + playerAdd] += quantity - (set ? PlayState.currentPositionX[targetInt + playerAdd] : 0);

                    }

                }else{

                    for(newTarget in 0...4){

                        new Effect(quantity, duration, target, newTarget, way, player, set, false);

                    }

                }

                case 'y':

                    if(! all){
                    
                   
                        prevStat = 0;
                        if(duration > 0){
                            FlxTween.num(0, quantity - (set ? PlayState.currentPositionY[targetInt + playerAdd] : 0), duration, options, function(adding:Float){

                                PlayState.currentPositionY[targetInt + playerAdd] += (adding - prevStat);

                                prevStat = adding;
                            });
                        }else{
                            PlayState.currentPositionY[targetInt + playerAdd] += quantity - (set ? PlayState.currentPositionY[targetInt + playerAdd] : 0);
    
                        }
                    
                    }else{

                        for(newTarget in 0...4){

                            new Effect(quantity, duration, target, newTarget, way, player, set, false);

                        }

                    }

            case 'spriteRot':

                if(! all){
                    
                   
                    prevStat = 0;
                    if(duration > 0){
                        FlxTween.num(0, quantity - (set ? PlayState.angle[targetInt + playerAdd] : 0), duration, options, function(adding:Float){

                            PlayState.angle[targetInt + playerAdd] += (adding - prevStat);

                            prevStat = adding;

                            while(PlayState.angle[targetInt + playerAdd] > 360){
                                PlayState.angle[targetInt + playerAdd] -= 360;

                            }
                            while(PlayState.angle[targetInt + playerAdd] < 0){
                                PlayState.angle[targetInt + playerAdd] += 360;
                            }


                        });
                    }else{
                        PlayState.angle[targetInt + playerAdd] += quantity - (set ? PlayState.angle[targetInt + playerAdd] : 0);

                    }
                    

                }else{

                    for(newTarget in 0...4){

                        new Effect(quantity, duration, target, newTarget, way, player, set, false);

                    }

                }

            case 'incoming':

                if(! all){
                    
                   
                    prevStat = 0;
                    if(duration > 0){
                        FlxTween.num(0, quantity - (set ? PlayState.angleC[targetInt + playerAdd] : 0), duration, options, function(adding:Float){

                            PlayState.angleC[targetInt + playerAdd] += (adding - prevStat);

                            prevStat = adding;

                            while(PlayState.angleC[targetInt + playerAdd] > 360){
                                PlayState.angleC[targetInt + playerAdd] -= 360;

                            }
                            while(PlayState.angleC[targetInt + playerAdd] < 0){
                                PlayState.angleC[targetInt + playerAdd] += 360;
                            }


                        });
                    }else{
                        PlayState.angleC[targetInt + playerAdd] += quantity - (set ? PlayState.angleC[targetInt + playerAdd] : 0);

                    }

                }else{

                    for(newTarget in 0...4){

                        new Effect(quantity, duration, target, newTarget, way, player, set, false);

                    }

                }

            case 'pivotRot':

                    if(! all){
                        
                       
                        prevStat = 0;
                        if(duration > 0){
                            FlxTween.num(0, quantity - (set ? PlayState.angleD[targetInt + playerAdd] : 0), duration, options, function(adding:Float){
        
                                PlayState.angleD[targetInt + playerAdd] += (adding - prevStat);
        
                                prevStat = adding;
        
                                while(PlayState.angleD[targetInt + playerAdd] > 360){
                                    PlayState.angleD[targetInt + playerAdd] -= 360;
        
                                }
                                while(PlayState.angleD[targetInt + playerAdd] < 0){
                                    PlayState.angleD[targetInt + playerAdd] += 360;
                                }
        
        
                            });
                        }else{
                            PlayState.angleD[targetInt + playerAdd] += quantity - (set ? PlayState.angleD[targetInt + playerAdd] : 0);
    
                        }
                    }else{
    
                        for(newTarget in 0...4){
    
                            new Effect(quantity, duration, target, newTarget, way, player, set, false);
    
                        }
    
                    }

                case 'radius':

                        if(! all){
                            
                           
                            prevStat = 0;
                            if(duration > 0){
                                FlxTween.num(0, quantity - (set ? PlayState.orbit[targetInt + playerAdd] : 0), duration, options, function(adding:Float){
            
                                    PlayState.orbit[targetInt + playerAdd] += (adding - prevStat);
            
                                    prevStat = adding;
            
            
                                });
                            }else{
                                PlayState.orbit[targetInt + playerAdd] += quantity - (set ? PlayState.orbit[targetInt + playerAdd] : 0);
        
                            }
        
                        }else{
        
                            for(newTarget in 0...4){
        
                                new Effect(quantity, duration, target, newTarget, way, player, set, false);
        
                            }
        
                        }

                    case 'alpha':

                            if(! all){
                                
                               
                                prevStat = 0;
                                if(duration > 0){
                                    FlxTween.num(0, quantity - (set ? PlayState.alpha[targetInt + playerAdd] : 0), duration, options, function(adding:Float){
                
                                        PlayState.alpha[targetInt + playerAdd] += (adding - prevStat);
                
                                        prevStat = adding;

                                        if(PlayState.alpha[targetInt + playerAdd] > 1){
                                            PlayState.alpha[targetInt + playerAdd] = 1;
                
                                        }
                                        if(PlayState.alpha[targetInt + playerAdd] < 0){
                                            PlayState.alpha[targetInt + playerAdd] = 0;
                                        }
                
                
                                    });
                                }else{
                                    PlayState.alpha[targetInt + playerAdd] += quantity - (set ? PlayState.alpha[targetInt + playerAdd] : 0);
            
                                }
            
                            }else{
            
                                for(newTarget in 0...4){
            
                                    new Effect(quantity, duration, target, newTarget, way, player, set, false);
            
                                }
            
                            }    
                    
            default:

                            trace("No existing variable change for that");

        }

         



    }


}

typedef EffectParams = {

    var time:Float;
    var quantity:Float;
    var duration:Float;
    var target:String;
    var targetInt:Int;
    var way:String;
    var player:Bool;
    var set:Bool;
    var all:Bool;


}

enum Modify{

    x;
    y;

    spriteRot;
    incoming;
    pivotRot;

    radius;
    
    alpha;



}