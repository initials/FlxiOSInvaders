// FlxInvaders.
// A port of the Flash game FlxInvaders
// For more info go to www.adamatomic.com
// Written by Initials.
// For more info go to www.initialscommand.com
// or contact initials@initialscommand.com


@interface Ship : FlxSprite
{
	CGFloat timer;
	int gunType;
	int gunPower;
	
}

+ (id) ship;
- (id) init;


@property CGFloat timer;
@property int gunType;
@property int gunPower;

@end
