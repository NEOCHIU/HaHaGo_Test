//
//  GroupViewModel.h
//  HaHaGo_Test
//
//  Created by nerochiu on 2018/3/5.
//  Copyright © 2018年 ISCOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupViewModel : NSObject
/**
 *loadData
 */
@property (nonatomic, copy)NSArray *dataArray;

/**
 *SearchData
 */
@property(nonatomic, strong) NSMutableArray *muSearchArray;


/**
 *JoinMember
 */
@property(nonatomic, strong) NSMutableArray *muJoinArray;


@property (nonatomic, strong, readwrite)NSNumber *isFresh;


/**
*GetFirbaseAPI
*/
-(void)getDataFromFirebase;

@end
