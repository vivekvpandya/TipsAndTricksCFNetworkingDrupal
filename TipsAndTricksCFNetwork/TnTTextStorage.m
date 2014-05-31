//
//  TnTTextStorage.m
//  TipsAndTricksCFNetwork
//
//  Created by Vivek Pandya on 5/30/14.
//  Copyright (c) 2014 Vivek Pandya. All rights reserved.
//

#import "TnTTextStorage.h"

@implementation TnTTextStorage
{

    NSMutableAttributedString *_imp;
}

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        _imp = [NSMutableAttributedString new];
    }
    
    return self;
}

-(NSString *)string{
    return  _imp.string;

}
-(NSDictionary *)attributesAtIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range{

    return [_imp attributesAtIndex:location effectiveRange:range];

}

-(void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str{
    [_imp replaceCharactersInRange:range withString:str];
    [self edited:NSTextStorageEditedCharacters range:range changeInLength:(NSInteger)str.length - (NSInteger)range.length];
}
-(void)setAttributes:(NSDictionary *)attrs range:(NSRange)range{

    [_imp setAttributes:attrs range:range];
    [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
}

-(void)processEditing{

    static NSRegularExpression *htmlTagExpression;
    htmlTagExpression = htmlTagExpression ?: [NSRegularExpression regularExpressionWithPattern:@"<[/]?[\\p{Alphabetic}]+>" options:0 error:NULL];
    
    // Clear text color of edited range
    NSRange paragraphRange = [self.string paragraphRangeForRange:self.editedRange];
    [self removeAttribute:NSForegroundColorAttributeName range:paragraphRange];
    
    //Find all html tags in range
    
    [htmlTagExpression enumerateMatchesInString:self.string options:0 range:paragraphRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        [self addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:result.range];
        
    }];
    
    [super processEditing];
    


}

@end

