//
//  enemy.cpp
//  AvoidSquares
//
//  Created by Clay Ewing on 7/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#include "enemy.h"

void Enemy::create(int _x, int _y, int _speed, int _width) {
    x = _x;
    y = _y;
    width = _width;
    speed = _speed;
    if (speed < 0) {
        r = ofRandom(0,127);
        g = ofRandom(127, 255);
        b = ofRandom(127, 255);
    }

    if (speed < -5) {
        r = 255;
        g = ofRandom(0, 255);
        b = ofRandom(0, 255);
    }
    if (speed < -10) {
        r = ofRandom(0, 255);
        g = 255;
        b = ofRandom(0, 255);
        
    }
    
    if (speed < -15) {
        r = ofRandom(0, 255);
        g = ofRandom(0, 255);
        b = 255;
    }
    
    if (speed < -20) {
        r = 255;
        g = 255;
        b = ofRandom(0, 255);

    }

    if (speed < -25) {
        r = 255;
        g = ofRandom(0, 255);
        b = 255;
        
    }

    if (speed < -30) {
        r = ofRandom(0, 255);
        g = 255;
        b = 255;
        
    }

    if (speed < -35) {
        r = ofRandom(127, 255);
        g = 255;
        b = 255;
        
    }

    if (speed < -40) {
        r = ofRandom(200, 255);
        g = 255;
        b = 255;
        
    }

}

void Enemy::display() {
    ofSetColor(r, g, b);
    ofNoFill();
    ofRect(x, y, width, width);
    ofFill();
    x = x + speed;
    
}

bool Enemy::hit() {
    return false;
}

