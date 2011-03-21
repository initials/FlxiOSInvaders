//
//  PlayState.m
//  Canabalt
//
//  Copyright Semi Secret Software 2009-2010. All rights reserved.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "PlayState.h"
#import "Ship.h"
#import "Alien.h"

static CGFloat tiltMultiplier = 550;
int _playerBulletIndex;
int _alienBulletIndex;

@implementation PlayState

- (id) init
{
  if ((self = [super init])) {
    self.bgColor = 0xff35353d;
	  _aliens = [[FlxGroup alloc] init];
	  _playerBullets = [[FlxGroup alloc] init];
	  _aliens = [[FlxGroup alloc] init];
	  _alienBullets = [[FlxGroup alloc] init];
	  _shields = [[FlxGroup alloc] init];
	  _vsShields = [[FlxGroup alloc] init];


  }
  return self;
}

- (void) create
{
	[self startAccelerometer];
	
	scoreText = [FlxText textWithWidth:FlxG.width
								  text:@"Welcome to FlxInvaders"
								  font:nil
								  size:16];
	scoreText.color = 0xffffffff;
	scoreText.alignment = @"center";
	scoreText.x = 2;
	scoreText.y = 12;
	[self add:scoreText];
	
	ship = [[Ship alloc] init];
	[self add:ship];
	
	//First we will instantiate the bullets you fire at your enemies.
	
	int i;
	for(i = 0; i < 12; i++)			//Create 8 bullets for the player to recycle
	{
		playerBullet = [FlxSprite spriteWithX:-100 y:-100 graphic:nil];
		[playerBullet createGraphicWithParam1:2 param2:8 param3:0xffffffff];
		
		playerBullet.exists = TRUE;
		[_playerBullets add:playerBullet];			//Add it to the group of player bullets
		[_vsShields add:playerBullet];
	}	
	
	[self add:_playerBullets];
	
	
	
	//...then we go through and make the invaders.  This looks all mathy but it's not that bad!
	//We're basically making 5 rows of 10 invaders, and each row is a different color.
	
	for(i = 0; i < 50; i++)
	{
		alien = [[Alien alloc] initWithOrigin:CGPointMake(8 + (i % 10) * 31,
														  24 + (i / 10) * 31)];

		[_aliens add:alien];
	}
	[self add:_aliens];
	
	//Then we kind of do the same thing for the enemy invaders; first we make their bullets...
	
	for(i = 0; i < 64; i++)
	{
		alienBullet = [FlxSprite spriteWithX:-100 y:-100 graphic:nil];
		[alienBullet createGraphicWithParam1:2 param2:8 param3:0xff0000];
		alienBullet.exists = TRUE;
		[_alienBullets add:alienBullet];			//Add it to the group of alien bullets
		[_vsShields add:alienBullet];

		
	}	
	
	[self add:_alienBullets];
	
	
	//Finally, we're going to make the little box shields at the bottom of the screen.
	//Each shield is made up of a bunch of little white 2x2 pixel blocks.
	//That way they look like they're getting chipped apart as they get shot.
	//This also looks kind of crazy and mathy (it sort of is), but we're just
	// telling the game where to put all the individual bits that make up each box.
	for(i = 0; i < 256; i++)
	{
		int posx = (int) 32 + 80 * (i / 64) + (i % 8) * 2;
		int posy = (int) FlxG.height - 32 + ((i % 64) / 8) * 2;
		shield = [FlxSprite spriteWithX:posx
									  y:posy - 20
									  graphic:nil];
		[shield createGraphicWithParam1:2 param2:2 param3:0xffffffff];
		//NSLog(@"%d", posy-20);
		shield.moves = false;
		[ _shields add:shield];
	}
	[self add:_shields];
}

-(void) accelerometer:(UIAccelerometer *)accelerometer 
		didAccelerate:(UIAcceleration *)acceleration
{
	
	// use the accelerometer to move ship
	
	ship.velocity = CGPointMake(acceleration.x*tiltMultiplier,
								0);
	
	
	// to use up and down motion, use this instead
	/*
	ship.velocity = CGPointMake(acceleration.x*tiltMultiplier,
								  (- acceleration.y*tiltMultiplier) - 150);
	*/
	
}

- (void)startAccelerometer {
	UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
	accelerometer.delegate = self;
	accelerometer.updateInterval = 0.05;
}

- (void)stopAccelerometer {
	UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
	accelerometer.delegate = nil;
}

- (void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[self stopAccelerometer];
	
	[_aliens release];
	[_playerBullets release];
	[_aliens release];
	[_alienBullets release];
	[_shields release];
	[_vsShields release];

	

	[super dealloc];
}


- (void) update
{
	//NSLog(@" %f %f ", ship.x, ship.y);
	
	//This used to be in Player.as
	//I can't figure out how to pass the bullets to it
	//Finally, we gotta shoot some bullets amirite?  First we check to see if the
	// screen was just pressed (no autofire in space invaders you guys)
  	//if (FlxG.touches.touchesBegan) {
	if (FlxG.touches.touching) { //just for debugging. saving my thumb
		//Screen was pressed!  FIRE A BULLET

		FlxSprite * b = [_playerBullets.members objectAtIndex:_playerBulletIndex];
		b.exists = TRUE;
		b.x = ship.x + ship.width / 2 - b.width;
		b.y = ship.y;
		b.velocity = CGPointMake(0, -240);
		_playerBulletIndex++;
		if (_playerBulletIndex>=_playerBullets.members.length) {
			_playerBulletIndex = 0;	
		}
	}
	
	//1 in 20 chance of an alien firing a bullet
	if ([FlxU random]* 20 < 1) {
		FlxSprite * ab = [_alienBullets.members objectAtIndex:_alienBulletIndex];
		FlxSprite * randomAlien = [_aliens.members objectAtIndex:[FlxU random]* 49 ];
		
		ab.x = randomAlien.x;
		ab.y = randomAlien.y;
		ab.velocity = CGPointMake(0, 240);

		_alienBulletIndex++;
		if (_alienBulletIndex>=_alienBullets.members.length) {
			_alienBulletIndex = 0;	
		}	
	}

	
	
	//This is how we do basic sprite collisions in flixel!
	//We compare one array of objects against another, and then if any of them overlap
	// flixel calls their 'kill' method, which by default sets the object to not exist (!exists)
	//FlxU.overlap(_shields,_vsShields,overlapped);
	//FlxU.overlap(_playerBullets,_aliens);
	//FlxU.overlap(_alienBullets,_player);
	
	
	//FlxU.overlap(_shields,_vsShields,overlapped);
	for (FlxSprite * sh in _shields.members) {
		for (FlxSprite	* vs in _vsShields.members) {
			if (vs.y < 442 && vs.y > 428 ) { // small trick to speed up collision detection
				if ([sh overlaps:vs]) {
					vs.x = -50;
					vs.y = -50;
					vs.dead = YES;
					sh.x = -50;
					sh.y = -50;
					sh.velocity = CGPointMake(0, 0);
					[super update];
					return;
				}			
			}
		}
	}
	
	//[FlxU overlapWithParam1:_shields param2:_vsShields];
	
	
	//FlxU.overlap(_playerBullets,_aliens);
	for (Alien * a in _aliens.members) {
		for (FlxSprite	* pb in _playerBullets.members) {	
			if ([a overlaps:pb]) {
				pb.x = -50;
				pb.y = -50;
				a.x = -50;
				a.y = -50;
				a.dead = YES;
				a.velocity = CGPointMake(0, 0);
				[super update];
				return;
			}
		}
	}
	
	//FlxU.overlap(_alienBullets,_player);
	for (FlxSprite * a in _alienBullets.members) {
		if ([a overlaps:ship]) {
			ship.dead = YES;
		}
	}
	
	
	[super update];

	//Now that everything has been updated, we are going to check and see if there
	// is a game over yet.  There are two ways to get a game over - player dies,
	// OR player kills all aliens.  First we check to see if the player is dead:
	if(ship.dead)
	{
		scoreText.text = @"You Lost";	//Player died, so set our label to YOU LOST
		
		//can't seem to reset PlayState;
		
		[self resetAliens];
		
		return;							//Anytime you call switchstate it is good to just return
	}
	if ([_aliens countLiving ] < 0)
	{
		scoreText.text = @"You won!" ;
		[self resetAliens];
		return;
	}
	
	
  
}

- (void) resetAliens

{
	for (Alien * a in _aliens.members) {
		a.x = a.originalX;
		a.y = a.originalY;
		a.dead = NO;
		a.velocity = CGPointMake(10, 0);
		ship.dead = NO;
		ship.x = FlxG.width/2-6;
		ship.y = FlxG.height-12;
	}	
}


@end

