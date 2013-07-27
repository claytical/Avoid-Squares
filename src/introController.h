//
//  introController.h
//  WellRounded
//
//  Created by Clay Ewing on 7/23/13.
//
//

#import <UIKit/UIKit.h>
#include "testApp.h"
#define WAITING_TO_PLAY 0
#define TUTORIAL        1
#define PLAYING         2
#define GAME_OVER       3
#define NEW_GAME        4
#define CREDITS         5
#define GAME_CENTER     6
#define SECRET_SCREEN   7
@interface introController : UIViewController <UICollectionViewDelegate> {
    testApp *myApp;
    UICollectionView *levelSelection;
}

- (IBAction)leaderboardButton:(id)sender;

- (IBAction)creditsButton:(id)sender;

@property (nonatomic, strong) NSArray *levels;

@end
