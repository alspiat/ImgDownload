//
//  CellView.m
//  ImgDownload
//
//  Created by Алексей on 31.05.2018.
//  Copyright © 2018 Алексей. All rights reserved.
//

#import "CellView.h"

@implementation CellView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    CGFloat cellHeight = frame.size.width / 4;
    CGFloat offset = 10;
    
    if (self) {
        _urlLabel = [[UILabel alloc] initWithFrame:CGRectMake(cellHeight + offset, self.bounds.size.height/2 - 30/2, self.bounds.size.width - cellHeight - 2*offset, 30)];
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(offset, offset, cellHeight - 2*offset, cellHeight - 2*offset)];
        
        CALayer *layer = self.layer;
        [layer setBorderWidth:0.4];
        layer.borderColor=[[UIColor lightGrayColor] CGColor];
        
        [self addSubview: self.urlLabel];
        [self addSubview: self.imageView];
        
        self.backgroundColor = UIColor.whiteColor;
    }
    return self;
}

-(void)dealloc{
    [_urlLabel release];
    [_imageView release];
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
