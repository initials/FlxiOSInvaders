//
//  MenuState.m
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

#import "MenuState.h"

#import "PlayState.h"

//static NSString * RUN_MUSIC = @"run.mp3";
//static NSString * RUN_TITLE_MUSIC = @"run-title.mp3";
//static NSString * PANIC_MUSIC = @"daringescape.mp3";
//static NSString * PANIC_TITLE_MUSIC = @"daringescape-title.mp3";
//static NSString * TRACK3_MUSIC = @"machrunner.mp3";
//static NSString * TRACK3_TITLE_MUSIC = @"machrunner-title.mp3";

static NSString * MUSIC_SELECTION = @"CanabaltTrack";

enum {
	RUN_TRACK,
	PANIC_TRACK,
	TRACK3_TRACK,
};

static NSString * RUN_TITLE = @"RUN";
static NSString * PANIC_TITLE = @"DARING ESCAPE";
static NSString * TRACK3_TITLE = @"MACH RUNNER";


static NSString * ImgTitle = @"logoSmall.png";
static NSString * ImgStartGame = @"startGame.png";
static NSString * ImgHelp = @"help.png";
static NSString * ImgHighScore = @"highScores.png";

static CGFloat duration = 1.0;

enum {
	MENU,
	ABOUT,
	PLAY,
};

enum {
	LOCAL,
	DAILY,
	WEEKLY,
	MONTHLY,
	GLOBAL,
};

@interface MenuState ()
- (void) showMusic;
- (void) hideMusic;
- (void) move:(FlxObject *)obj toPoint:(CGPoint)pnt duration:(CGFloat)dur;
@end


@implementation MenuState

- (id) init
{
	if ((self = [super init])) {
		self.bgColor = 0xf4c9c6;
		moving = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void) create
{
	
	state = MENU;
	scoreState = LOCAL;
	
	
	title = [FlxSprite spriteWithGraphic:ImgTitle];
	title.x = FlxG.width/2;
	title.y = -200;
	title.offset= CGPointMake(title.width/2, title.height/2);
	title.scale = CGPointMake(2, 2);
	title.velocity = CGPointMake(0, 254);
	title.drag = CGPointMake(title.drag.x, 100);
	[self add:title];
	
	
	startGame = [[[FlxButton alloc] initWithX:FlxG.width/2-533-104
											y:FlxG.height/2
									 callback:[FlashFunction functionWithTarget:self
																		 action:@selector(onPlay)]] autorelease];
	[startGame loadGraphic:[FlxSprite spriteWithGraphic:ImgStartGame]];
	[startGame loadText:[FlxText textWithWidth:startGame.width
										  text:NSLocalizedString(@"", @"")
										  font:nil
										  size:16.0]];
	//startGame.scale.x = 2;
	startGame.velocity = CGPointMake(400, 0);
	startGame.drag = CGPointMake(150, 150);
	
	[self add:startGame];
	

	
}

- (void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[moving release];
	[super dealloc];
}


- (void) update
{
	//move the moving objects...
	//NSLog(@"%f", startGame.x);
	
	for (FlxObject * obj in [[[moving allKeys] copy] autorelease]) {
		NSMutableDictionary * md = [moving objectForKey:obj];
		float timer = [[md objectForKey:@"timer"] floatValue];
		float duration = [[md objectForKey:@"duration"] floatValue];
		CGPoint fromPoint = [[md objectForKey:@"fromPoint"] CGPointValue];
		CGPoint toPoint = [[md objectForKey:@"toPoint"] CGPointValue];
		timer += FlxG.elapsed;
		float delta = timer/duration - sin(timer/duration*2*M_PI)/(2*M_PI);
		if (delta < 1.0) {
			obj.x = delta * (toPoint.x-fromPoint.x) + fromPoint.x;
			obj.y = delta * (toPoint.y-fromPoint.y) + fromPoint.y;
			[md setObject:[NSNumber numberWithFloat:timer] forKey:@"timer"];
		} else {
			obj.x = toPoint.x;
			obj.y = toPoint.y;
			[moving removeObjectForKey:obj];
		}
	}
	
	[super update];
	
	
	
}


- (void) move:(FlxObject *)obj toPoint:(CGPoint)pnt duration:(CGFloat)dur
{
	[moving setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
					   [NSValue valueWithCGPoint:pnt], @"toPoint",
					   [NSValue valueWithCGPoint:CGPointMake(obj.x, obj.y)], @"fromPoint",
					   [NSNumber numberWithFloat:dur], @"duration",
					   [NSNumber numberWithFloat:0.0], @"timer",
					   nil]
			   forKey:obj];
}

- (void) onPlay
{
	if (state != MENU)
		return;
	
	state = PLAY;
	
	FlxG.state = [[[PlayState alloc] init] autorelease];
	
	//	NSNumber * musicSelection = [[NSUserDefaults standardUserDefaults] objectForKey:MUSIC_SELECTION];
	//	if (musicSelection == nil || [musicSelection intValue] == RUN_TRACK)
	//		[FlxG playMusic:RUN_MUSIC];
	//	else if ([musicSelection intValue] == PANIC_TRACK)
	//		[FlxG playMusic:PANIC_MUSIC];
	//	else
	//		[FlxG playMusic:TRACK3_MUSIC];
}

- (void) onHighScore
{
	
}

- (void) onHelp
{
	
}

- (void) hideMusic
{
	if (nowPlaying) {
		nowPlaying.visible = NO;
		danny.visible = NO;
	}
}

- (void) showMusicDelayed
{
	if (nowPlaying) {
		nowPlaying.visible = YES;
		danny.visible = YES;
	}
}

- (void) showMusic
{
	[self performSelector:@selector(showMusicDelayed)
			   withObject:nil
			   afterDelay:1.0];
}


@end

