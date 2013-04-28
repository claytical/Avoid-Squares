//
//  savior.h
//  AvoidSquares
//
//  Created by Clay Ewing on 7/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#pragma once
#include "ofMain.h"

class Savior {
public:
	
	void display();
    void charge();
	void create(int x, int y);
	int x, y;
    int r,g,b;
	int width, height;
    int strength;
    bool charging;
};
