#pragma once

#include "ofMain.h"
#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"
#include "enemy.h"
#include "protagonist.h"
#include "savior.h"
#include "collectable.h"
#include "ofxXmlSettings.h"
#include "ofxCenteredTrueTypeFont.h"
#include "ofxEasyRetina.h"
#include "ofxRetinaImage.h"
#include "ofxOpenALSoundPlayer.h"
#include "Flurry.h"


#define FASTEST_COLLECTABLE -2
#define SLOWEST_COLLECTABLE -1
#define OBJECT_OFFSET ofGetHeight()


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

    void loadLevel(string levelName);
    NSString * getLevelName(NSString *levelFile);
    vector<string>patterns;
    
    static bool consumed(Savior &savior);
    static bool collected(Collectable &collectable);
    static bool passedGateway(Enemy &enemy);

    
    void loadPattern(int pattern);
    
    ofxXmlSettings XML;
    ofxXmlSettings XMLLevel;
    Protagonist protagonist;
    vector<Savior> saviors;
    ofxOpenALSoundPlayer movementSound;
    ofxOpenALSoundPlayer movingSound;
    
    vector<Enemy> enemies;
    ofxRetinaImage enemyImage;
    ofxOpenALSoundPlayer enemySound;

    vector<Collectable> collectables;
    ofxOpenALSoundPlayer collectableSound;
    ofxOpenALSoundPlayer backgroundMusic;

    int progressMarker, completionAmount;
    float speed, multiplier;
    int healCounter;
    ofxCenteredTrueTypeFont textBig;
    ofxCenteredTrueTypeFont textSmall;
    ofxEasyRetina retina;

    int gameState;
    string selectedTrack;
    int currentPattern;
    NSUserDefaults *userSettings;
    bool achievedHighScore;
    
};


