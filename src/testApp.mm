#include "testApp.h"

#define WAITING_TO_PLAY 0
#define TUTORIAL        1
#define PLAYING         2
#define GAME_OVER       3
#define SECRET_SCREEN   4
#define GLANCING        5

bool hasNoStrength(Savior s){
	return (s.strength <= 0);
}
bool passedGateway(Enemy e){
	return (e.x <= -20);
}

void testApp::moreEnemies() {
    progressMarker--;
    if (progressMarker < 1) {
        progressMarker = 1; 
    }
}
//--------------------------------------------------------------
void testApp::setup(){	
	// register touch events
	ofRegisterTouchEvents(this);
	
	// initialize the accelerometer
	ofxAccelerometer.setup();
	
	//iPhoneAlerts will be sent to this.
	ofxiPhoneAlerts.addListener(this);
	
	//If you want a landscape oreintation 
	iPhoneSetOrientation(OFXIPHONE_ORIENTATION_LANDSCAPE_RIGHT);
	
    ofSetRectMode(OF_RECTMODE_CENTER);
    protagonist.create(ofGetWidth()/3, ofGetHeight()/2, 25);
    text.loadFont("mono.ttf",10);
    progressMarker = 60;
    enemyCounter = 1000;
    ofEnableSmoothing();
    ofEnableAlphaBlending();
    ofSetCircleResolution(200);
	userSettings = [NSUserDefaults standardUserDefaults];
    achievedHighScore = false;
    gameState = WAITING_TO_PLAY;
}

//--------------------------------------------------------------
void testApp::update(){
    switch (gameState) {
        case WAITING_TO_PLAY:
            break;
        case PLAYING:
            if (saviors.size() > 0) {
                
                protagonist.moveTo(saviors[saviors.size() - 1].x, saviors[saviors.size() - 1].y);
                if (ofDist(protagonist.x, protagonist.y, saviors[saviors.size() -1].x, saviors[saviors.size() - 1].y) <= saviors[saviors.size() - 1].strength) {
                    healCounter++;
                    
                    //recharge
                    if (healCounter % 90 == 0) {
                   //     protagonist.change(-1);
                    }
                    
                }
            }
            if (enemyCounter%progressMarker == 0) {
                Enemy tmpEnemy;
                int tmpSpeed = ofRandom(-1.5, int(enemyCounter * .001 * -1));
                NSLog(@"Temp Speed: %i", int(enemyCounter * .001 * -1));
                tmpEnemy.create(ofGetWidth() + ofRandom(50, 80), ofRandom(ofGetHeight(), 0), tmpSpeed, ofRandom(20,50));
                enemies.push_back(tmpEnemy);
            }
            saviors.erase( remove_if(saviors.begin(), saviors.end(), hasNoStrength), saviors.end() );	
            enemies.erase( remove_if(enemies.begin(), enemies.end(), passedGateway), enemies.end() );	
            
            if (enemyCounter%1000 == 0) {
                moreEnemies();
                NSLog(@"Progress Marker: %i", progressMarker);
            }

            break;
        case GAME_OVER:
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
	ofBackground(0,0,0);

    switch (gameState) {
        case WAITING_TO_PLAY:
            cout << "looping" <<endl;

            text.drawString("you are a well rounded individual.\nstay away from squares.\n\n\ntap to start.", 40, ofGetHeight()/2);
            break;
        case PLAYING:
            for (int i = 0; i < saviors.size(); i++) {
                saviors[i].display();
            }
            
            for (int i = 0; i < enemies.size(); i++) {
                if (ofDist(protagonist.x, protagonist.y, enemies[i].x, enemies[i].y) <= protagonist.radius*2 - GLANCING) {
                    enemies[i].x = -40;
                    protagonist.change(1);
                }
                //        ofSetColor(0, 255, 0);
                //        ofCircle(protagonist.x, protagonist.y, 1);
                enemies[i].display();
                //        ofSetColor(255, 0, 0);
                //        ofCircle(enemies[i].x + (enemies[i].width/2), enemies[i].y + (enemies[i].width/2),1 );
                //        ofSetColor(0, 0, 255);
                //        ofLine(protagonist.x, protagonist.y, enemies[i].x + (enemies[i].width/2) ,  enemies[i].y + (enemies[i].width/2));
                //      ofSetColor(255,255,255);
                //        text.drawString(ofToString(ofDist(protagonist.x, protagonist.y, enemies[i].x + (enemies[i].width/2), enemies[i].y + (enemies[i].width/2))), enemies[i].x + (enemies[i].width/2) ,  enemies[i].y + (enemies[i].width/2));
                
            }
            protagonist.display();
            
            enemyCounter++;
            if (protagonist.sides == DEAD) {
                gameState = GAME_OVER;
                if (int(enemyCounter * .01) - 10 > [[userSettings valueForKey:@"highest_score"] intValue]) {
                    NSLog(@"New High Score, writing...");
                    achievedHighScore = true;
                    [userSettings setValue:[NSString stringWithFormat:@"%i", int(enemyCounter * .01) - 10] forKey:@"highest_score"];
                    [userSettings synchronize];
                }
                
            }
            
            text.drawString(ofToString(int(enemyCounter * .01) - 10), 20, ofGetHeight() - 30); 
            break;
            
        case GAME_OVER:
            if (achievedHighScore) {
                text.drawString("it took you " + ofToString(int(enemyCounter * .01) - 10) + " seconds to became a square.\nthat's your longest time yet.\n\n\ngame over.", 40, ofGetHeight()/2);
            }
            else {
                text.drawString("it took you " + ofToString(int(enemyCounter * .01) - 10) + " seconds to became a square.\n\n\ngame over.", 40, ofGetHeight()/2);
                
            }
            
            protagonist.display();
            break;
        case SECRET_SCREEN:
            text.drawString("you are a well rounded individual,\navoid squares\n\nby clay ewing\n\n\nfind more fun stuff at claytical.com", 20, 20);
        default:
            break;
    }
}

//--------------------------------------------------------------
void testApp::exit(){

}

//--------------------------------------------------------------
void testApp::touchDown(ofTouchEventArgs &touch){
    switch (gameState) {
        case WAITING_TO_PLAY:
            if (touch.id == 2) {
                gameState = SECRET_SCREEN;
            }
            break;
        case PLAYING:
            Savior tmpSavior;
            tmpSavior.create(touch.x, touch.y);
            
            saviors.push_back(tmpSavior);

            break;
        case GAME_OVER:

            break;

        default:
            break;
    }
}

//--------------------------------------------------------------
void testApp::touchMoved(ofTouchEventArgs &touch){

}

//--------------------------------------------------------------
void testApp::touchUp(ofTouchEventArgs &touch){
    switch (gameState) {
        case WAITING_TO_PLAY:
            gameState = PLAYING; 

            break;
        case PLAYING:
            if (saviors.size() > 0) {
                for (int i = 0; i < saviors.size(); i++) {
                    saviors[i].charging = false;
                }
            }
            break;
        case GAME_OVER:
            gameState = WAITING_TO_PLAY; 
            progressMarker = 60;
            enemyCounter = 1000;
            protagonist.sides = HEALTHY;
            enemies.clear();
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

