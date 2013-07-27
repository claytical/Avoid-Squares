//
//  protagonist.cpp
//  AvoidSquares
//
//  Created by Clay Ewing on 7/9/11.

#include "protagonist.h"

int Protagonist::collectEdge() {
    for (int i = 0; i < 4; i++) {
        if (lineAnimation[i]) {
            switch (i) {
                case 0:
                    ofLine(edges[0].x, animatedLine[0], edges[1].x, animatedLine[0]);
                    animatedLine[0]+= LINE_ANIMATION_SPEED;
                    if (animatedLine[0] >= edges[0].y) {
                        lineAnimation[0] = false;
                        return 1;
                    }
                    break;
                case 1:
                    ofLine(animatedLine[1], edges[1].y, animatedLine[1], edges[2].y);
                    animatedLine[1]-= LINE_ANIMATION_SPEED;
                    if (animatedLine[1] <= edges[1].x) {
                        lineAnimation[1] = false;
                        return 1;
                    }
                    break;
                case 2:
                    ofLine(edges[2].x, animatedLine[2], edges[3].x, animatedLine[2]);
                    animatedLine[2]-= LINE_ANIMATION_SPEED;
                    if (animatedLine[2] <= edges[2].y) {
                        lineAnimation[2] = false;
                        return 1;
                    }
                    break;
                case 3:
                    ofLine(animatedLine[3], edges[3].y, animatedLine[3], edges[0].y);
                    animatedLine[3]+= LINE_ANIMATION_SPEED;
                    if (animatedLine[3] >= edges[3].x) {
                        lineAnimation[3] = false;
                        return 1;
                    }
                    break;
                default:
                    break;
            }
        }
    }
    return 0;
    
}

void Protagonist::display() {
    ofSetColor(r, g, b);
    ofNoFill();
    ofRectRounded(x, y, width, height, sides);

    ofFill();
    ofSetColor(127);
    //collectEdge();

}

void Protagonist::moveTo(int xPos, int yPos) {
//creep up on the spot
    x += (xPos - x) * .1;
    y += (yPos - y) * .1;

    edges[0].set(x, y);
    edges[1].set(x+width, y);
    edges[2].set(x+width, y+height);
    edges[3].set(x, y+height);
    
}


void Protagonist::create(int _x, int _y, int _size) {
    r = 255;
    g = 255;
    b = 255;
    x = _x;
    y = _y;
    for (int i = 0; i < 4; i++) {
        lineAnimation[i] = false;
    }
    width = _size;
    height = _size;
    sides = HEALTHY;

}


bool Protagonist::collide(Collectable c) {
    c.distanceToProtagonist = ofDist(c.x, c.y, x + width/2, y + height/2);
    if ((c.x >= x && c.x <= x + width) || (x <= c.x + c.width && c.x + c.width <= x + width)) {
        if((c.y <= y  && (y <= c.y + c.width)) || (y <= (c.y + c.width) && c.y + c.width <= y + height)) {
            animatedLine[0] = 0;
            animatedLine[1] = ofGetWidth();
            animatedLine[2] = ofGetHeight();
            animatedLine[3] = 0;
            for (int i = 0; i < 4; i++) {
                lineAnimation[i] = true;
            }
            return true;
        }
    }
    
    return false;
}

bool Protagonist::collide(Enemy e) {

    if (e.hit) {
        return false;
    }
    
    float distanceFromProtagonistX = abs(e.x - (x + width/2));
    float distanceFromProtagonistY = abs(e.y - (y + height/2));
    
    if (distanceFromProtagonistX > (width/2 + e.radius)) {
        return false;
    }
    
    if (distanceFromProtagonistY > (height/2 + e.radius)) {
        return false;
    }

    if (distanceFromProtagonistX <= width/2) {
        return true;
    }
    if (distanceFromProtagonistY <= height/2) {
        return true;
    }
    
    return false;
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

