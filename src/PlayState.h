//
//  PlayState.h
//  FlxInvaders
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
@class Ship;
@class Alien;

@interface PlayState : FlxState <UIAccelerometerDelegate>
{
	Ship * ship;
	Alien * alien;
	
	FlxGroup * _playerBullets; //refers to the bullets you shoot
	FlxGroup * _aliens; //refers to all the squid monsters
	FlxGroup * _alienBullets; //refers to all the bullets the enemies shoot at you
	FlxGroup * _shields; //refers to the box shields along the bottom of the game
	
	//Some meta-groups for speeding up overlap checks later
	FlxGroup * _vsShields;
	
	FlxSprite * playerBullet ;
	FlxSprite * alienBullet ;

	FlxSprite * shield ;
	
	FlxText * scoreText;


	
}

- (void)startAccelerometer;
- (void)stopAccelerometer;
- (void)resetAliens;

@end

