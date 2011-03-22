// FlxInvaders.
// A port of the Flash game FlxInvaders
// For more info go to www.adamatomic.com
// Written by Initials.
// For more info go to www.initialscommand.com
// or contact initials@initialscommand.com


@interface Alien : FlxManagedSprite
{
	CGFloat shotClock;
	CGFloat originalX;
	CGFloat originalY;

}

+ (id) alien;
//- (id) init;
- (id) initWithOrigin:(CGPoint)origin colorAnim:(int)colorAnim;
//- (id) initWithOrigin:(CGPoint)origin color:(int)color;


@property CGFloat originalX;
@property CGFloat originalY;

@end
