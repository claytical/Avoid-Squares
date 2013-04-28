//
//  protagonist.h
//  AvoidSquares
//
//  Created by Clay Ewing on 7/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#pragma once
#include "ofMain.h"

#define HEALTHY     0
#define WOUNDED     1
#define DISFIGURED  2
#define MANGLED     3
#define DEAD        4

class Protagonist {
    
public:
	
	void display();
	void create(int x, int y, int radius);
    void change(int amount);
    void moveTo(int x, int y);
//    vector<ofImage> protags;
//    ofImage protoUnhealthy;
	int x, y;
    int r,g,b;
	int radius;
    int sides;
};
