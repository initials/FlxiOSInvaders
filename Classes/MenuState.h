

@interface MenuState : FlxState
{
	FlxSprite * title;
	FlxSprite * title2;
	
	FlxButton * startGame;
	FlxButton * help;
	FlxButton * highScore;
	
	
	int state;
	int scoreState;
	
	FlxButton * back;
	FlxSprite * bar;
	FlxText * aboutTitle;
	
	FlxText * aboutText;
	
	FlxText * thanksText;
	NSArray * peopleTexts;
	NSArray * reasonTexts;
	
	FlxText * nowPlaying;
	FlxText * danny;
	
	NSMutableDictionary * moving;
	
	BOOL touchBeganInMusic;
	BOOL touchEndedInMusic;
	
}

@end

