//
//  CustomTextField.m
//  DogHub
//
//  Created by Emil Iliev on 2/7/16.
//  Copyright © 2016 Marina Georgieva. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [[NSBundle mainBundle]loadNibNamed:@"CustomTextField" owner:self options:nil];
        [self addSubview:self.view];
        [self addBorders];
    }
    
    return self;
}

-(void)addBorders{

    CALayer *upperBorder = [CALayer layer];
    upperBorder.backgroundColor = [[UIColor purpleColor] CGColor];
    upperBorder.frame = CGRectMake(0, 0, self.frame.size.width, 1.0f);
    [self.layer addSublayer:upperBorder];

    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.backgroundColor = [[UIColor purpleColor] CGColor];
    bottomBorder.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, 1.0f);
    [self.layer addSublayer:bottomBorder];
    
    CALayer *leftBorder = [CALayer layer];
    leftBorder.backgroundColor = [[UIColor purpleColor] CGColor];
    leftBorder.frame = CGRectMake(0, 0, 1.0f, self.frame.size.height);
    [self.layer addSublayer:leftBorder];
    
    CALayer *rightBorder = [CALayer layer];
    rightBorder.backgroundColor = [[UIColor purpleColor] CGColor];
    rightBorder.frame = CGRectMake(self.frame.size.width , 0, 1.0f, self.frame.size.height);
    [self.layer addSublayer:rightBorder];
}




@end
