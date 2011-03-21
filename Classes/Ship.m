#import "Ship.h"

static NSString * ImgShip = @"ship.png";

@implementation Ship


@synthesize timer;
@synthesize gunType;
@synthesize gunPower;



+ (id) ship
{
	return [[[self alloc] init] autorelease];
}

- (id) init
{
	if ((self = [super initWithX:0 y:0 graphic:nil])) {
		
		[self loadGraphicWithParam1:ImgShip param2:YES param3:NO param4:12 param5:8];
		
		self.x = FlxG.width/2-6;
		self.y = FlxG.height-12;

	}
	
	return self;
}



- (void) dealloc
{
	[super dealloc];
}


- (void) update
{   
	//Here we are stopping the player from moving off the screen,
	// with a little border or margin of 4 pixels.
	if(x > FlxG.width-width-4)
		x = FlxG.width-width-4; //Checking and setting the right side boundary
	if(x < 4)
		x = 4;					//Checking and setting the left side boundary
	
	


	
	
	
	[super update];
	
}




@end
