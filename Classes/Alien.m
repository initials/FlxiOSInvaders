#import "Alien.h"

static NSString * ImgAlien = @"alien.png";

@implementation Alien

@synthesize originalX;
@synthesize originalY;

+ (id) alien
{
	return [[[self alloc] init] autorelease];
}

- (id) initWithOrigin:(CGPoint)Origin colorAnim:(int)colorAnim
{
	if ((self = [super initWithX:Origin.x y:Origin.y graphic:nil])) {
		
		[self loadGraphicWithParam1:ImgAlien param2:YES param3:NO param4:16 param5:16];
		
		//Time to create a simple animation!  alien.png has 3 frames of animation in it.
		//We want to play them in the order 1, 2, 3, 1 (but of course this stuff is 0-index).
		//To avoid a weird, annoying appearance the framerate is randomized a little bit
		// to a value between 6 and 10 (6+4) frames per second.
		// AS3 addAnimation("Default",[0,1,0,2],6+FlxU.random()*4);
		[self addAnimationWithParam1:@"DarkBlue" param2:[NSMutableArray intArrayWithSize:4 ints:0,1,0,2] param3:6+[FlxU random] *4];
		[self addAnimationWithParam1:@"LightBlue" param2:[NSMutableArray intArrayWithSize:4 ints:3,4,3,5] param3:6+[FlxU random] *4];
		[self addAnimationWithParam1:@"Green" param2:[NSMutableArray intArrayWithSize:4 ints:6,7,6,8] param3:6+[FlxU random] *4];
		[self addAnimationWithParam1:@"Yellow" param2:[NSMutableArray intArrayWithSize:4 ints:9,10,9,11] param3:6+[FlxU random] *4];
		[self addAnimationWithParam1:@"Red" param2:[NSMutableArray intArrayWithSize:4 ints:12,13,12,14] param3:6+[FlxU random] *4];
		
		//Now that the animation is set up, it's very easy to play it back!
		switch (colorAnim) {
			case 0:
				[self playWithParam1:@"DarkBlue" param2:YES];
				break;
			case 1:
				[self playWithParam1:@"LightBlue" param2:YES];
				break;
			case 2:
				[self playWithParam1:@"Green" param2:YES];
				break;
			case 3:
				[self playWithParam1:@"Yellow" param2:YES];
				break;
			case 4:
				[self playWithParam1:@"Red" param2:YES];
				break;
			default:
				break;
		}
		[self playWithParam1:@"Default" param2:YES];
		
		//Everybody move to the right!
		self.velocity = CGPointMake(10, 0);
		
		originalX = self.x;
		originalY = self.y;
		
		// not implemented? Instead using the Color attr to determine which animation to play
		// self.color = 0xff00ff00;
		
		
		
	}
	
	return self;
	
}

//- (id) init
//{
//	if ((self = [super initWithX:0 y:0 graphic:nil])) {
//		
//		[self loadGraphicWithParam1:ImgAlien param2:YES param3:NO param4:18 param5:16];
//		
//		self.x = FlxG.width/2-6;
//		self.y = FlxG.height-12;
//		
//	}
//	
//	return self;
//}



- (void) dealloc
{
	[super dealloc];
}


- (void) update
{   
	
	//If alien has moved too far to the left, reverse direction and increase speed!
	if(!dead) {
		if(x < originalX - 8)
		{
			x = originalX - 8;
			velocity.x = 10;
			velocity.y++;
		}
		if(x > originalX + 8) //If alien has moved too far to the right, reverse direction
		{
			x = originalX + 8;
			velocity.x = -10;
		}
		
		if (y >  originalY + FlxG.height/2) {
			velocity = CGPointMake(self.velocity.x, 0);
			y = originalY + FlxG.height/2;
		}
		
	}
	
	[super update];
	
}




@end
