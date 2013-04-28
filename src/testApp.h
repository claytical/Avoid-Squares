#pragma once

#include "ofMain.h"
#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"
#include "enemy.h"
#include "protagonist.h"
#include "savior.h"

class testApp : public ofxiPhoneApp {
	
public:
	void setup();
	void update();
	void draw();
	void exit();
	
    void touchDown(ofTouchEventArgs & touch);
    void touchMoved(ofTouchEventArgs & touch);
    void touchUp(ofTouchEventArgs & touch);
    void touchDoubleTap(ofTouchEventArgs & touch);
    void touchCancelled(ofTouchEventArgs & touch);
    
    void lostFocus();
    void gotFocus();
    void gotMemoryWarning();
    void deviceOrientationChanged(int newOrientation);

    void moreEnemies();
    
    Protagonist protagonist;
    vector<Savior> saviors;
    vector<Enemy> enemies;
    int enemyCounter;
    int progressMarker;
    int healCounter;
    ofTrueTypeFont text;
    int gameState;
    NSUserDefaults *userSettings;
    bool achievedHighScore;
};


