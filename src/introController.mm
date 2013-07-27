//
//  introController.m
//  WellRounded
//
//  Created by Clay Ewing on 7/23/13.
//
//

#import "introController.h"
#include "ofxiPhoneExtras.h"

@implementation introController
@synthesize levels;

-(void)viewDidLoad {
    self.levels = [NSArray array];
    myApp = (testApp*)ofGetAppPtr();
    [levelSelection registerNib:[UINib nibWithNibName:@"levelCell" bundle:nil] forCellWithReuseIdentifier:@"track"];

    NSString *bundleRoot = [[NSBundle mainBundle] bundlePath];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *dirContents = [fm contentsOfDirectoryAtPath:bundleRoot error:nil];
    NSPredicate *fltr = [NSPredicate predicateWithFormat:@"self ENDSWITH '.level'"];
    levels = [[dirContents filteredArrayUsingPredicate:fltr] retain];
}


- (IBAction)leaderboardButton:(id)sender {
}

- (IBAction)creditsButton:(id)sender {
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [levels count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"track";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    UILabel *levelLabel = (UILabel *)[cell viewWithTag:100];
    ;
    [levelLabel setText:myApp->getLevelName([levels objectAtIndex:indexPath.row])];
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.view.hidden = YES;
    myApp->loadLevel(ofxNSStringToString([levels objectAtIndex:indexPath.row]));
    myApp->gameState = NEW_GAME;
//    myApp->selectedTrack = ofxNSStringToString([levels objectAtIndex:indexPath.row]);
}

- (void)dealloc {
    [levelSelection release];
    [super dealloc];
}
@end
