//
//  WordsViewController.m
//
//  Purpose: The definition of class WordViewController
//
//  Application: iLearnLetters
//
//  Team: Flying Moose - Group 1
//
//  Revision history:
//
//  Date            Author                      Description
//  ---------------------------------------------------------------------------
//  2013-10-12      R. Roshanravan              Original definition
//  2013-10-19      R. Roshanravan              Major UI improvements
//  2013-10-27      Anni Cao                    Added file headers and comments
//
//  Known bugs: N/A
//
//  Copyright (c) 2013 Rouzbeh Roshanravan. All rights reserved.
//


#import "WordsViewController.h"
#import "Google_TTS_BySham.h"
#import <stdlib.h>

@interface WordsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *randomWord;

@property (nonatomic, strong) NSMutableArray *arrayOfWords;
@property (nonatomic,strong)Google_TTS_BySham *google_TTS_BySham;
@end

@implementation WordsViewController

#define NUMBER_OF_WORDS 7
#define yCo 250
-(NSMutableArray *)arrayOfWords{
    if(!_arrayOfWords){
        _arrayOfWords = [[NSMutableArray alloc] init];
    }
    
    return _arrayOfWords;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self extractWordsFromFile];

    self.google_TTS_BySham = [[Google_TTS_BySham alloc] init];
    
	
}

-(void)extractWordsFromFile{
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"OWL" ofType:@"txt"];
    
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    
    NSArray *lineArray = [content componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    
    for (int i = 0; i < [lineArray count]; i++) {
        NSArray *tempArray = [[lineArray objectAtIndex:i] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        [self.arrayOfWords addObject:[tempArray objectAtIndex:0]];
        
         //NSLog(@"%@", [tempArray lastObject]);
    }

    
    /*for (int i = 0; i < [self.arrayOfWords count]; i++) {
       // NSLog(@"here");
        NSLog(@"%@", [self.arrayOfWords objectAtIndex:i]);
    }*/

    NSLog(@"we have %d words", [self.arrayOfWords count]);
}

-(NSString *)randomlyPickWord{
    int r = arc4random() % NUMBER_OF_WORDS;
    
    for (int i = 0; i < [[self.arrayOfWords objectAtIndex:r] length]; i++) {
        [self createButtonFront:i :[NSString stringWithFormat:@"%@", [[self.arrayOfWords objectAtIndex:r] substringWithRange:NSMakeRange(i, 1)]]];
    
    }
    
    return [self.arrayOfWords objectAtIndex:r];
}

- (IBAction)readTheWord:(id)sender {
    
    self.randomWord.text = [NSString stringWithFormat:@"%@", [self randomlyPickWord]];
    
    
    
    [self.google_TTS_BySham speak:[NSString stringWithFormat:@"%@", self.randomWord.text]];
    
}

-(void)createButtonFront:(int)whichLetter :(NSString *)letter{
    
    CGPoint pointToAddButton = CGPointMake((whichLetter + 5) * 70, yCo);
    
    UIButton *buttonToAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [buttonToAdd setBackgroundColor:[UIColor cyanColor]];
    
    [buttonToAdd setTitleColor:[UIColor redColor] forState:(UIControlState)UIControlStateNormal];
    
    buttonToAdd.frame = CGRectMake(pointToAddButton.x, pointToAddButton.y, 44.0f, 44.0f);
    
    [buttonToAdd addTarget:self action:@selector(readTheChar:)
          forControlEvents:(UIControlEvents)UIControlEventTouchUpInside];
    
    [buttonToAdd setTitle:letter forState:(UIControlState)UIControlStateNormal];
    
    [self.view addSubview:buttonToAdd];
    
    

}

-(IBAction)readTheChar:(id)sender{
   
    [self.google_TTS_BySham speak:[NSString stringWithFormat:@"%@", [sender titleLabel].text]];

}














@end
