#include "testApp.h"
#include "introController.h"

#define WAITING_TO_PLAY 0
#define TUTORIAL        1
#define PLAYING         2
#define GAME_OVER       3
#define NEW_GAME        4
#define CREDITS         5
#define GAME_CENTER     6
#define WON_TRACK       7

introController *intro;

//----------------------------------------------------------------
void testApp::setup(){
   // ofxiPhoneFlurryAnalytics(@"Z8Q3945CDT8VYXM2BSVP");
	// register touch events
	ofRegisterTouchEvents(this);
	
	// initialize the accelerometer
	//ofxAccelerometer.setup();
	
	//iPhoneAlerts will be sent to this.
	ofxiPhoneAlerts.addListener(this);
	
	//If you want a landscape oreintation 
	//iPhoneSetOrientation(OFXIPHONE_ORIENTATION_LANDSCAPE_RIGHT);
	ofEnableSmoothing();
    ofSetRectMode(OF_RECTMODE_CORNER);
    textBig.loadFont("cdb.ttf",30);
    textSmall.loadFont("cdb.ttf",11);
    textBig.setLetterSpacing(1);
    ofEnableTextureEdgeHack();
    ofEnableSmoothing();
    ofEnableAlphaBlending();
    
	userSettings = [NSUserDefaults standardUserDefaults];
    
    enemySound.loadSound("bad.caf");
    movementSound.loadSound("click.caf");
    collectableSound.loadSound("fiji.caf");
    movingSound.loadSound("click.caf");
    backgroundMusic.loadSound("trancebg.caf");
    backgroundMusic.setLoop(true);
    gameState = WAITING_TO_PLAY;
    currentPattern = 0;
    backgroundMusic.setVolume(1);
    
    intro = [[introController alloc] initWithNibName:@"introController" bundle:nil];
    [ofxiPhoneGetGLView() addSubview:intro.view];
    [Flurry startSession:@"Z8Q3945CDT8VYXM2BSVP"];
}

NSString * testApp::getLevelName(NSString * levelFile) {
    if (XML.loadFile(ofxNSStringToString(levelFile))) {
        
        return ofxStringToNSString(XML.getValue("name", "Level"));
    }
    return @"error";
}


//--------------------------------------------------------------
void testApp::loadLevel(string levelName) {
    [Flurry logEvent:ofxStringToNSString(levelName) timed:YES];
    protagonist.create(ofGetWidth()/2, ofGetHeight()/2, 25);

    patterns.clear();
    enemies.clear();
    collectables.clear();
    if (XML.loadFile(levelName)) {
        speed = XML.getValue("speed", -1);
        multiplier = XML.getValue("multiplier", 1.08);
        completionAmount = XML.getValue("complete", 10) * 4;
        for (int i = 0; i < XML.getNumTags("file"); i++) {
            string filename = XML.getValue("file", "error.xml", i);
            patterns.push_back(filename);
        }
    }
    else {
        NSLog(@"Unable to load level file");
    }
}

//--------------------------------------------------------------

void testApp::loadPattern(int pattern) {
    if( XML.loadFile(patterns[pattern]) ){
        
        NSLog(@"Loaded Pattern %s", patterns[pattern].c_str());
    }

    //load enemies
    speed *= multiplier;

    for (int i = 0; i < XML.getNumTags("enemy"); i++) {
        Enemy tmpEnemy;
        tmpEnemy.create(XML.getValue("enemy:x", 0, i), XML.getValue("enemy:y", 0, i), speed, XML.getValue("enemy:size", 0, i));
        enemies.push_back(tmpEnemy);
        
    }

    //load collectables
    for (int i = 0; i < XML.getNumTags("collectable"); i++) {
        Collectable tmpCollectable;
        tmpCollectable.create(XML.getValue("collectable:x", 0, i), XML.getValue("collectable:y", 0, i), speed, XML.getValue("collectable:size", 0, i));
        collectables.push_back(tmpCollectable);
        
    }
    
}

//--------------------------------------------------------------
void testApp::update(){
    //this is our crazy control scheme that will be used everywhere
    if (saviors.size() > 0) {
        
        protagonist.moveTo(saviors[0].x, saviors[0].y);
        if (ofDist(protagonist.x, protagonist.y, saviors[0].x, saviors[0].y) <= 1) {
           // movingSound.play();
            saviors[0].consumed = true;
        }
    }
    ofRemove(saviors, consumed);
    //now we go for specific states
    switch (gameState) {
        case WAITING_TO_PLAY:
            break;
        case CREDITS:
            break;
        case GAME_CENTER:
            break;
        case NEW_GAME:
            NSLog(@"New game loading...");
            currentPattern = 0;
            speed = -1;
            progressMarker = 0;
            achievedHighScore = false;
            gameState = PLAYING;
            break;
        case PLAYING:
            ofRemove(collectables, collected);
            ofRemove(enemies, passedGateway);
            if (enemies.size() <= 0 && collectables.size() <= 0) {
                loadPattern(currentPattern%patterns.size());
                currentPattern++;
            }
            
            for (int i = 0; i < enemies.size(); i++) {
                enemies[i].distanceToProtagonist = ofDist(enemies[i].x, enemies[i].y, protagonist.x + protagonist.width/2, protagonist.y + protagonist.height/2);

                if (protagonist.collide(enemies[i])) {
                    protagonist.change(3);
                    enemies[i].hit = true;
                    enemySound.play();
                }
            }
            for (int i = 0; i < collectables.size(); i++) {
                collectables[i].distanceToProtagonist = ofDist(collectables[i].x + collectables[i].width/2, collectables[i].y + collectables[i].height/2, protagonist.x + protagonist.width/2, protagonist.y + protagonist.height/2);
                
                if (collectables[i].collected == false) {
                    if (protagonist.collide(collectables[i])) {
                        collectableSound.play();
                        collectables[i].collected = true;
                    }
                }
            }
            
            
            if (protagonist.sides == DEAD) {
                gameState = GAME_OVER;
              /*  if (score > [[userSettings valueForKey:@"highest_score"] intValue]) {
                    NSLog(@"New High Score, writing...");
                    achievedHighScore = true;
                    [userSettings setValue:[NSString stringWithFormat:@"%i", score] forKey:@"highest_score"];
                    [userSettings synchronize];
                }
                */
            }
            
            if (progressMarker >= completionAmount) {
                gameState = WON_TRACK;
            }

            
            
            break;
        case WON_TRACK:
            enemies.clear();
            collectables.clear();
            gameState = WAITING_TO_PLAY;
            intro.view.hidden = false;
            break;
            
        case GAME_OVER:
            enemies.clear();
            collectables.clear();
            
            if (achievedHighScore) {
                protagonist.moveTo(ofGetWidth()/3 + 55, ofGetHeight()/2 + 80);
            }
            else {
                protagonist.moveTo(ofGetWidth()/3 + 55, ofGetHeight()/2 + 60);
                
            }
                break;
            
        default:
            break;
    }
}

//--------------------------------------------------------------
void testApp::draw(){
	retina.setupScreenOrtho();
	ofBackground(0,0,0);
    protagonist.display();
    progressMarker += protagonist.collectEdge();
    for (int i = 0; i < saviors.size(); i++) {
        saviors[i].display();
    }
//    int edge = ofMap(score, 0, 100, 0, ofGetWidth() - textSmall.stringWidth("EDGE:") - 30);

    switch (gameState) {
        case WAITING_TO_PLAY:
            break;
        case CREDITS:

            break;
        case GAME_CENTER:
            break;
        case PLAYING:
            
            for (int i = 0; i < enemies.size(); i++) {
                enemies[i].display();
            }
            for (int i = 0; i < collectables.size(); i++) {
                  collectables[i].display();
            }
            
            ofSetColor(0, 0, 0);
            ofFill();
            ofRect(0, ofGetHeight() - 40, ofGetWidth(), 40);
            ofSetColor(255, 255, 255);
            textSmall.drawString("EDGES " + ofToString(progressMarker) + " / " + ofToString(completionAmount), 20, ofGetHeight() - 30);
            break;
            
        case GAME_OVER:
/*
            if (achievedHighScore) {
                textSmall.drawString("you associated with " + ofToString(score) + " other squares before losing\nyour edge.\nthat's your most impressive run yet.\n\n\ngame over.", 40, ofGetHeight()/2);
            }
            else {
                textSmall.drawString("you associated with " + ofToString(score) + " other squares before losing\nyour edge.\n\n\ngame over.", 40, ofGetHeight()/2);
                
            }
  */
            break;
        case SECRET_SCREEN:
            textSmall.drawString("you are a well rounded individual,\navoid squares\n\nby clay ewing\n\n\nfind more fun stuff at claytical.com", 20, 20);
        default:
            break;
    }


}

//--------------------------------------------------------------
void testApp::exit(){

}

//--------------------------------------------------------------
void testApp::touchDown(ofTouchEventArgs &touch){
    //our crazy control scheme. create spots that we move the protagonist to... everywhere.
    if (touch.y <= ofGetHeight() - 60) {
        Savior tmpSavior;
        tmpSavior.create(touch.x, touch.y);
        
        saviors.push_back(tmpSavior);
        movementSound.play();
    }
}

//--------------------------------------------------------------
void testApp::touchMoved(ofTouchEventArgs &touch){

}

//--------------------------------------------------------------
void testApp::touchUp(ofTouchEventArgs &touch){
    switch (gameState) {
        case WAITING_TO_PLAY:
            //gameState = PLAYING;

            break;
        case PLAYING:
            break;
        case GAME_OVER:
            gameState = WAITING_TO_PLAY; 
            protagonist.sides = HEALTHY;
            enemies.clear();
            collectables.clear();
            saviors.clear();

            break;
            
        default:
            break;
    }
    
}

//--------------------------------------------------------------
void testApp::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void testApp::touchDoubleTap(ofTouchEventArgs &touch){

}

//--------------------------------------------------------------
void testApp::lostFocus(){

}

//--------------------------------------------------------------
void testApp::gotFocus(){

}

//--------------------------------------------------------------
void testApp::gotMemoryWarning(){

}

//--------------------------------------------------------------
void testApp::deviceOrientationChanged(int newOrientation){

}

bool testApp::consumed(Savior &savior){
	return (savior.consumed);
}

bool testApp::passedGateway(Enemy &enemy){
	return (enemy.y >= ofGetHeight() + enemy.radius);
}

bool testApp::collected(Collectable &collectable) {
    return (collectable.y > ofGetHeight() + collectable.height);

 }


