//
//  protagonist.cpp
//  AvoidSquares
//
//  Created by Clay Ewing on 7/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#include "protagonist.h"

void Protagonist::display() {
    ofSetColor(r, g, b);
    switch (sides) {
        case HEALTHY:
            ofCircle(x, y, radius);
//            protags[0].draw(x, y);
            break;
        case WOUNDED:
            ofCircle(x, y, radius-1);
            ofRect(x - radius/2, y - radius/2, radius, radius);
//            protags[1].draw(x,y);
            break;
            
        case DISFIGURED:
            
            ofCircle(x, y, radius-1);
            ofRect(x - radius/2, y - radius/2, radius, radius);
            ofRect(x + radius/2, y + radius/2, radius, radius);
            
            //protags[2].draw(x,y);

            break;
            
        case MANGLED:
            
            ofCircle(x, y, radius-1);
            ofRect(x - radius/2, y - radius/2, radius, radius);
            ofRect(x + radius/2, y + radius/2, radius, radius);
            ofRect(x - radius/2, y + radius/2, radius, radius);
            
            //protags[3].draw(x,y);

            break;
        
        case DEAD:
            ofRect(x, y, radius*2, radius*2);
            
            break;
        
        default:
            break;
    }
}

void Protagonist::moveTo(int xPos, int yPos) {
//creep up on the spot
	x = (.05 * xPos) + (.95 * x); 
	y = (.05 * yPos) + (.95 * y); 

    
}


void Protagonist::create(int _x, int _y, int _radius) {
    r = 255;
    g = 255;
    b = 255;
    x = _x;
    y = _y;
    radius = _radius;
    sides = HEALTHY;
/*
    ofImage tmpImage;
    tmpImage.loadImage("circle.png");
    protags.push_back(tmpImage);

    tmpImage.loadImage("circle-mod1.png");
    protags.push_back(tmpImage);

    tmpImage.loadImage("circle-mod2.png");
    protags.push_back(tmpImage);

    tmpImage.loadImage("circle-mod3.png");
    protags.push_back(tmpImage);

    protoImages[0].loadImage("circle.png");
    protoImages[1].loadImage("circle-mod1.png");
    protoImages[2].loadImage("circle-mod2.png");
    protoImages[3].loadImage("circle-mod3.png");
*/
}

void Protagonist::change(int amount) {
    sides = sides + amount;
    if (sides < HEALTHY) {
        sides = HEALTHY;
    }
    if (sides > DEAD) {
        sides = DEAD;
    }
}

