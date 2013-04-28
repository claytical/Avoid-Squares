//
//  savior.cpp
//  AvoidSquares
//
//  Created by Clay Ewing on 7/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#include "savior.h"

void Savior::display() {
    ofNoFill();
    ofSetColor(r, g, b, 200);
    for (int i = 0; i < strength; i = i + 4) {
        ofCircle(x, y, i);
    }
    ofFill();
    if (!charging) {
//        y++;
        strength--;
        if (strength < 0) {
            strength = 0;
        }
    }
    else {
        charge();
    }
}

void Savior::charge() {
    strength = strength + 2;
}

void Savior::create(int _x, int _y) {
    r = 127;
    g = 127;
    b = 127;
    x = _x;
    y = _y;
    strength = 5;
    charging = true;
}